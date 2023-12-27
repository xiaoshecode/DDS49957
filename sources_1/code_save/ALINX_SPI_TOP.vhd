library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use IEEE.std_logic_unsigned.all;

entity ALINX_SPI_TOP is
  GENERIC(
    spi_chn_num  : INTEGER := 4;  --number of spi slaves
    spi_datawidth : INTEGER := 24); --data bus width
    Port (
			rstn_i : in std_logic;
	---AD9910三线SPI
           ad9910_mosi        : out std_logic_vector(spi_chn_num-1 downto 0);
           ad9910_ssn         : buffer std_logic_vector(spi_chn_num-1 downto 0);
           ad9910_sclk        : buffer std_logic_vector(spi_chn_num-1 downto 0);
           sync_clk           : in std_logic_vector(3 downto 0);
		   
	----profile pin
           ad9910_ch0_profile : out std_logic_vector(2 downto 0);
           ad9910_ch1_profile : out std_logic_vector(2 downto 0);
           ad9910_ch2_profile : out std_logic_vector(2 downto 0);
           ad9910_ch3_profile : out std_logic_vector(2 downto 0);
           
		   ad9910_ioupdate    : out std_logic_vector(spi_chn_num - 1 downto 0);	   
		   
    ---AD9910控制信号       
           ad9910_masterrst : out std_logic_vector(spi_chn_num - 1 downto 0);
    
	---上位机UART串口
           UART_TXD 	  : out  STD_LOGIC;
           UART_RXD 	  : in  STD_LOGIC;  
		   
    ---差分时钟       
           sys_clk    : in  STD_LOGIC;
    ---pll config
            pll_sdi : out STD_LOGIC;
            pll_sclk : out std_logic;
            pll_cs : out std_logic;
            pll_stat : in std_logic;
            
            pll_lock_led : out  std_logic;
            pll_sync_in : out std_logic;
            
            ref_clk_sel : out std_logic
		   );
end ALINX_SPI_TOP;

architecture Behavioral of ALINX_SPI_TOP is

signal pd_clk_buf : std_logic;
signal sync_clk_buf : std_logic_vector(3 downto 0);




-- to align external ttl at same posedge of clk 100M
signal ext_prof_ch0_100M, ext_prof_ch1_100M, ext_prof_ch2_100M, ext_prof_ch3_100M : std_logic_vector(2 downto 0);
signal ext_prof_ch0_100M_buf1, ext_prof_ch1_100M_buf1, ext_prof_ch2_100M_buf1, ext_prof_ch3_100M_buf1 : std_logic_vector(2 downto 0);
signal ext_prof_ch0_100M_buf2, ext_prof_ch1_100M_buf2, ext_prof_ch2_100M_buf2, ext_prof_ch3_100M_buf2 : std_logic_vector(2 downto 0);
--------signal ext_prof_ch0_100M_buf3, ext_prof_ch1_100M_buf3, ext_prof_ch2_100M_buf3, ext_prof_ch3_100M_buf3 : std_logic_vector(2 downto 0);
signal s_ad9910_ioupdate :  std_logic_vector(spi_chn_num - 1 downto 0);



----------------------FIFO-------------
-- after a fifo, the sync signal should be aligned at the posedge of syncclk
signal ext_prof_ch0_sync, ext_prof_ch1_sync, ext_prof_ch2_sync, ext_prof_ch3_sync : std_logic_vector(2 downto 0);
signal ext_profile_ch0_buffer_full, ext_profile_ch0_buffer_empty, ext_profile_ch0_buffer_wren, ext_profile_ch0_buffer_rden : std_logic;
signal ext_profile_ch1_buffer_full, ext_profile_ch1_buffer_empty, ext_profile_ch1_buffer_wren, ext_profile_ch1_buffer_rden : std_logic;
signal ext_profile_ch2_buffer_full, ext_profile_ch2_buffer_empty, ext_profile_ch2_buffer_wren, ext_profile_ch2_buffer_rden : std_logic;
signal ext_profile_ch3_buffer_full, ext_profile_ch3_buffer_empty, ext_profile_ch3_buffer_wren, ext_profile_ch3_buffer_rden : std_logic;

-- the internal profile signals are original @100M, just use a fifo to sync with sync_clk
signal int_prof_ch0_sync, int_prof_ch1_sync, int_prof_ch2_sync, int_prof_ch3_sync : std_logic_vector(2 downto 0);
signal int_profile_ch0_buffer_full, int_profile_ch0_buffer_empty, int_profile_ch0_buffer_wren, int_profile_ch0_buffer_rden : std_logic;
signal int_profile_ch1_buffer_full, int_profile_ch1_buffer_empty, int_profile_ch1_buffer_wren, int_profile_ch1_buffer_rden : std_logic;
signal int_profile_ch2_buffer_full, int_profile_ch2_buffer_empty, int_profile_ch2_buffer_wren, int_profile_ch2_buffer_rden : std_logic;
signal int_profile_ch3_buffer_full, int_profile_ch3_buffer_empty, int_profile_ch3_buffer_wren, int_profile_ch3_buffer_rden : std_logic;


signal reset_n,enable,cpol,cpha,cont,busy :std_logic;
signal tx_data,rx_data : std_logic_vector(23 downto 0);

signal ss_n : std_logic_vector(0 downto 0);

signal clk_100M, clk_10M, clk_20M, clk_50M, pll_locked : std_logic;
signal sync_clk_100M_0, sync_pll_locked_0 : std_logic;
signal sync_clk_100M_1, sync_pll_locked_1 : std_logic;
signal sync_clk_100M_2, sync_pll_locked_2 : std_logic;
signal sync_clk_100M_3, sync_pll_locked_3 : std_logic;

signal full_cmd, uart_rx_96b_data, uart_tx_96b_data : std_logic_vector(95 downto 0)  := (others=>'0');
signal spi_cmd0, spi_cmd1, spi_cmd2 : std_logic_vector(23 downto 0)  := (others=>'0');
signal uart_rx_data, uart_tx_data : std_logic_vector(7 downto 0) := (others=>'0');
signal uartRX_read, uart_rx_96b_valid, uart_rx_96b_resetn, uart_tx_ready, uart_tx_send, uart_tx_96b_resetn, spi_resetn: std_logic;

signal spi_fifo_rst, spi_fifo_wr_en, spi_fifo_rd_en, spi_fifo_full, spi_fifo_empty : std_logic :='0';
signal spi_fifo_din, spi_fifo_dout : std_logic_vector(95 downto 0);

--type spi_chn_array is array (spi_chn_num-1 downto 0) of std_logic_vector(spi_datawidth-1 downto 0);
--signal spi_tx_data, spi_rx_data : spi_chn_array;


type spi_chn_array_72b is array (spi_chn_num-1 downto 0) of std_logic_vector(71 downto 0);
signal spi_tx_data_72b, spi_rx_data_72b : spi_chn_array_72b;

type spi_chn_array_40b is array (spi_chn_num-1 downto 0) of std_logic_vector(39 downto 0);
signal spi_tx_data_40b, spi_rx_data_40b : spi_chn_array_40b;

signal spi_busy, spi_wr_en, miso_reg, mosi_reg, sclk_reg,ss_n_reg : std_logic_vector(spi_datawidth-1 downto 0) := (others=>'0');
signal spi_busy_72b, spi_wren_72b,  spi_busy_40b, spi_wren_40b : std_logic_vector(spi_datawidth-1 downto 0) := (others=>'0');
signal spi_9910_masterrst, spi_9910_72b_wren, spi_9910_40b_wren, spi_9910_72b_miso, spi_9910_72b_mosi , spi_9910_72b_busy, spi_9910_72b_sclk, spi_9910_72b_ssn, spi_9910_40b_miso, spi_9910_40b_mosi , spi_9910_40b_busy, spi_9910_40b_sclk, spi_9910_40b_ssn : std_logic_vector(spi_chn_num-1 downto 0) := (others=>'0');

signal ATT_Gain : std_logic_vector(5 downto 0);
signal ATT_EN, ATT_LE_reg, ATT_CLK_reg,ATT_DATA_reg, ATT_RSTn_reg, RF_SWITCH_CTRL_reg : std_logic;

signal profile_switch : std_logic;

type profile_array is array (spi_chn_num - 1 downto 0) of std_logic_vector(2 downto 0); 
signal profile_internal : profile_array;

signal s_ad9910_ch0_profile : std_logic_vector(2 downto 0);
signal s_ad9910_ch1_profile : std_logic_vector(2 downto 0);
signal s_ad9910_ch2_profile : std_logic_vector(2 downto 0);
signal s_ad9910_ch3_profile : std_logic_vector(2 downto 0);

signal uart_ad9910_ch0_profile : std_logic_vector(2 downto 0);
signal uart_ad9910_ch1_profile : std_logic_vector(2 downto 0);
signal uart_ad9910_ch2_profile : std_logic_vector(2 downto 0);
signal uart_ad9910_ch3_profile : std_logic_vector(2 downto 0);

signal s_ch0_F : std_logic_vector(1 downto 0);
signal s_ch0_D : std_logic_vector(15 downto 0);
signal s_state_ch0 : std_logic_vector(2 downto 0);
signal s_parrallel_cfg_en_ch0 : std_logic;
signal s_parrallel_test_en_ch0_i : std_logic;

signal ch0_profile_sync_i : std_logic_vector(2 downto 0);
signal ch1_profile_sync_i : std_logic_vector(2 downto 0);
signal ch2_profile_sync_i : std_logic_vector(2 downto 0);
signal ch3_profile_sync_i : std_logic_vector(2 downto 0);
signal uart_att : std_logic_vector(5 downto 0);

signal pll_config_cs : std_logic_vector(0 downto 0);
signal pll_config_sdo : std_logic;
signal pll_config_data : std_logic_vector(15 downto 0);
signal pll_config_clk : std_logic;
signal pll_config_busy : std_logic;
signal pll_config_en : std_logic;
signal pll_config_sdi: std_logic;

component IBUFG
port(I: in STD_LOGIC; O: out STD_LOGIC);
end component;

component profile_sync port(
    profile_switch : in std_logic;
    ch0_profile : out std_logic_vector(2 downto 0);
    ch1_profile : out std_logic_vector(2 downto 0);
    ch2_profile : out std_logic_vector(2 downto 0);
    ch3_profile : out std_logic_vector(2 downto 0);
      
    ch0_profile_ext : in std_logic_vector(2 downto 0);
    ch1_profile_ext : in std_logic_vector(2 downto 0);
    ch2_profile_ext : in std_logic_vector(2 downto 0);
    ch3_profile_ext : in std_logic_vector(2 downto 0);
       
    sync_clk    : in std_logic_vector(3 downto 0)
    );
end component;

component spi_pll_16b port(
    clock   : IN     STD_LOGIC;                             --system clock
    reset_n : IN     STD_LOGIC;                             --asynchronous reset
    enable  : IN     STD_LOGIC;                             --initiate transaction
    cpol    : IN     STD_LOGIC;                             --spi clock polarity
    cpha    : IN     STD_LOGIC;                             --spi clock phase
    cont    : IN     STD_LOGIC;                             --continuous mode command
    clk_div : IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
    addr    : IN     INTEGER;                               --address of slave
    tx_data : IN     STD_LOGIC_VECTOR(15 DOWNTO 0);  --data to transmit
    miso    : IN     STD_LOGIC;                             --master in, slave out
    sclk    : BUFFER STD_LOGIC;                             --spi clock
    ss_n    : BUFFER STD_LOGIC_VECTOR(0 DOWNTO 0);   --slave select
    mosi    : OUT    STD_LOGIC;                             --master out, slave in
    busy    : OUT    STD_LOGIC;                             --busy / data ready signal
    rx_data : OUT    STD_LOGIC_VECTOR(15 DOWNTO 0)); --data received
end component;



begin    



profile_sync_inst:  profile_sync port map(
    profile_switch => profile_switch,
    
    ch0_profile => s_ad9910_ch0_profile,
    ch1_profile => s_ad9910_ch1_profile,
    ch2_profile => s_ad9910_ch2_profile,
    ch3_profile => s_ad9910_ch3_profile,
    -- ch0_profile => ad9910_ch0_profile,
    -- ch1_profile => ad9910_ch1_profile,
    -- ch2_profile => ad9910_ch2_profile,
    -- ch3_profile => ad9910_ch3_profile,
	
    ch0_profile_ext => ch0_profile_sync_i,
	ch1_profile_ext => ch1_profile_sync_i,
	ch2_profile_ext => ch2_profile_sync_i,
	ch3_profile_ext => ch3_profile_sync_i,
	
    -- ch0_profile_ext => ext_prof_ch0_sync,
    -- ch1_profile_ext => ext_prof_ch1_sync,
    -- ch2_profile_ext => ext_prof_ch2_sync,
    -- ch3_profile_ext => ext_prof_ch3_sync,
    
    sync_clk  => sync_clk_buf    
    );

sync_clk_wiz_inst_0 : entity work.sync_clk_wiz
port map
(
    clk_in1   => sync_clk_buf(0),
    clk_out1  => sync_clk_100M_0,
    reset     => '0',
    locked    => sync_pll_locked_0
);
sync_clk_wiz_inst_1 : entity work.sync_clk_wiz
port map
(
    clk_in1   => sync_clk_buf(1),
    clk_out1  => sync_clk_100M_1,
    reset     => '0',
    locked    => sync_pll_locked_1
);
sync_clk_wiz_inst_2 : entity work.sync_clk_wiz
port map
(
    clk_in1  => sync_clk_buf(2),
    clk_out1 => sync_clk_100M_2,
    reset    => '0',
    locked   => sync_pll_locked_2
);
sync_clk_wiz_inst_3 : entity work.sync_clk_wiz
port map
(
    clk_in1  => sync_clk_buf(3),
    clk_out1 => sync_clk_100M_3,
    reset    => '0',
    locked   => sync_pll_locked_3
);

-------uart decode
	inst_96bit_uart_rx: entity work.uartrx_cmd_96b port map
	   ( 
		clk 	      => clk_100M,
		cmdout_96b    => uart_rx_96b_data,
		UART_RXD 	  => UART_RXD,--   : in  STD_LOGIC;
		dataout_flag  => uart_rx_96b_valid,--  : out std_logic;
		reset_n       => uart_rx_96b_resetn--        : in  STD_LOGIC
		);

-------backhaul
	inst_96bit_uart_tx : entity work.uarttx_cmd_96b
	  Port map( 
		clk           => clk_100M, --			: in  STD_LOGIC;
		tx_cmd_96b    => uart_tx_96b_data, --   :  in STD_LOGIC_VECTOR (31 downto 0);
		UART_TXD 	  =>     UART_TXD,--: out  STD_LOGIC;
		tx_send_start => uart_tx_send,---   : in std_logic;
		reset_n       => uart_tx_96b_resetn--       : in  STD_LOGIC
		);

	clk_inst : entity work.clk_wiz_50M
	  port map(
		clk_in1 => sys_clk,
		clk_out1  => clk_100M,
		clk_out2  => clk_20M,
		clk_out3  => clk_10M,
		clk_out4  => clk_50M,    
		reset     => '0',
		locked    => pll_locked
	);
	
	
spi_chn_inst: for i in 0 to spi_chn_num-1 generate
	sync_clk_inst: IBUFG port map 
	(I => sync_clk(i), 
	 O => sync_clk_buf(i)); 

--与AD9910   SPI协议
	spi_72b_inst : entity work.spi_9910_72b port map
	(
	   clock    => clk_20M,--: IN     STD_LOGIC;                             --system clock
	   reset_n  => '1',-- : IN     STD_LOGIC;                             --asynchronous reset
	   enable   =>  spi_wren_72b(i),--  IN     STD_LOGIC;                             --initiate transaction
	   cpol     =>  '0',-- IN     STD_LOGIC;                             --spi clock polarity
	   cpha     =>  '0', --IN     STD_LOGIC;                             --spi clock phase
	   cont     =>  '0', --IN     STD_LOGIC;                             --continuous mode command
	   clk_div  =>  0, --IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
	   addr     =>  0, --IN     INTEGER;                               --address of slave
	   tx_data  => spi_tx_data_72b(i), --IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
	   miso     => spi_9910_72b_miso(i) , --IN     STD_LOGIC;                             --master in, slave out
	   sclk     => spi_9910_72b_sclk(i), --BUFFER STD_LOGIC;                             --spi clock
	   ss_n     => spi_9910_72b_ssn(i downto i) , --BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
	   mosi     => spi_9910_72b_mosi(i),--mosi , --OUT    STD_LOGIC;                             --master out, slave in
	   busy     => spi_9910_72b_busy(i), --OUT    STD_LOGIC;                             --busy / data ready signal
	   rx_data  => spi_rx_data_72b(i)  --OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
	);

	spi40b_inst : entity work.spi_9910_40b port map
	(
	   clock    => clk_20M,--: IN     STD_LOGIC;                             --system clock
	   reset_n  =>  '1',-- : IN     STD_LOGIC;                             --asynchronous reset
	   enable   =>  spi_wren_40b(i),--  IN     STD_LOGIC;                             --initiate transaction
	   cpol     =>  '0',-- IN     STD_LOGIC;                             --spi clock polarity
	   cpha     =>  '0', --IN     STD_LOGIC;                             --spi clock phase
	   cont     =>  '0', --IN     STD_LOGIC;                             --continuous mode command
	   clk_div  =>  0, --IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
	   addr     =>  0, --IN     INTEGER;                               --address of slave
	   tx_data  => spi_tx_data_40b(i), --IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
	   miso     => spi_9910_40b_miso(i) , --IN     STD_LOGIC;                             --master in, slave out
	   sclk     => spi_9910_40b_sclk(i), --BUFFER STD_LOGIC;                             --spi clock
	   ss_n     => spi_9910_40b_ssn(i downto i) , --BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
	   mosi     => spi_9910_40b_mosi(i),--mosi , --OUT    STD_LOGIC;                             --master out, slave in
	   busy     => spi_9910_40b_busy(i), --OUT    STD_LOGIC;                             --busy / data ready signal
	   rx_data  => spi_rx_data_40b(i)  --OUT    STD_LOGIC_VECTOR(d_width-1 DOWNTO 0)); --data received
	);

end generate;

	spi_16b : spi_pll_16b port map
	(
	   clock    => clk_20M,--: IN     STD_LOGIC;                             --system clock
	   reset_n  => '1',-- : IN     STD_LOGIC;                             --asynchronous reset
	   enable   =>  pll_config_en,--  IN     STD_LOGIC;                             --initiate transaction
	   cpol     =>  '0',-- IN     STD_LOGIC;                             --spi clock polarity
	   cpha     =>  '0', --IN     STD_LOGIC;                             --spi clock phase
	   cont     =>  '0', --IN     STD_LOGIC;                             --continuous mode command
	   clk_div  =>  0, --IN     INTEGER;                               --system clock cycles per 1/2 period of sclk
	   addr     =>  0, --IN     INTEGER;                               --address of slave
	   tx_data  => pll_config_data, --IN     STD_LOGIC_VECTOR(d_width-1 DOWNTO 0);  --data to transmit
	   miso     => '0',
	   sclk     => pll_config_clk, --BUFFER STD_LOGIC;                             --spi clock
	   ss_n     => pll_config_cs , --BUFFER STD_LOGIC_VECTOR(slaves-1 DOWNTO 0);   --slave select
	   mosi     => pll_config_sdi,--mosi , --OUT    STD_LOGIC;                             --master out, slave in
	   busy     => pll_config_busy --OUT    STD_LOGIC;                             --busy / data ready signal
	);
	
----uart decode -> fifo -> spi_AD9910
fifo_inst : entity work.fifo_generator_0 port map
(
    rst => spi_fifo_rst, --: IN STD_LOGIC;
    wr_clk => clk_100M,-- : IN STD_LOGIC;
    rd_clk => clk_20M,-- : IN STD_LOGIC;
    din =>  spi_fifo_din,-- : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
    wr_en => spi_fifo_wr_en,--: IN STD_LOGIC;
    rd_en => spi_fifo_rd_en,--: IN STD_LOGIC;
    dout  => spi_fifo_dout,--: OUT STD_LOGIC_VECTOR(95 DOWNTO 0);
    full => spi_fifo_full,--: OUT STD_LOGIC;
    empty => spi_fifo_empty --: OUT STD_LOGIC
);


-- this fifo is used to transfer external profile signal @ 100M to syncclk @250M
fifo_ext_profile_ch0_inst : entity work.fifo_profile_ext port map
(
    rst => '0', --: IN STD_LOGIC;
    wr_clk => sync_clk_100M_0,-- : IN STD_LOGIC;
    rd_clk => sync_clk_buf(0),-- : IN STD_LOGIC;
    din =>  ext_prof_ch0_100M,-- : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en => ext_profile_ch0_buffer_wren,--: IN STD_LOGIC;
    rd_en => ext_profile_ch0_buffer_rden,--: IN STD_LOGIC;
    dout  => ext_prof_ch0_sync,--: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full => ext_profile_ch0_buffer_full,--: OUT STD_LOGIC;
    empty => ext_profile_ch0_buffer_empty --: OUT STD_LOGIC
);



fifo_ext_profile_ch1_inst : entity work.fifo_profile_ext port map
(
    rst => '0', --: IN STD_LOGIC;
    wr_clk => sync_clk_100M_1,-- : IN STD_LOGIC;
    rd_clk => sync_clk_buf(1),-- : IN STD_LOGIC;
    din =>  ext_prof_ch1_100M,-- : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en => ext_profile_ch1_buffer_wren,--: IN STD_LOGIC;
    rd_en => ext_profile_ch1_buffer_rden,--: IN STD_LOGIC;
    dout  => ext_prof_ch1_sync,--: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full => ext_profile_ch1_buffer_full,--: OUT STD_LOGIC;
    empty => ext_profile_ch1_buffer_empty --: OUT STD_LOGIC
);

fifo_ext_profile_ch2_inst : entity work.fifo_profile_ext port map
(
    rst => '0', --: IN STD_LOGIC;
    wr_clk => sync_clk_100M_2,-- : IN STD_LOGIC;
    rd_clk => sync_clk_buf(2),-- : IN STD_LOGIC;
    din =>  ext_prof_ch2_100M,-- : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en => ext_profile_ch2_buffer_wren,--: IN STD_LOGIC;
    rd_en => ext_profile_ch2_buffer_rden,--: IN STD_LOGIC;
    dout  => ext_prof_ch2_sync,--: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full => ext_profile_ch2_buffer_full,--: OUT STD_LOGIC;
    empty => ext_profile_ch2_buffer_empty --: OUT STD_LOGIC
);

fifo_ext_profile_ch3_inst : entity work.fifo_profile_ext port map
(
    rst => '0', --: IN STD_LOGIC;
    wr_clk => sync_clk_100M_3,-- : IN STD_LOGIC;
    rd_clk => sync_clk_buf(3),-- : IN STD_LOGIC;
    din =>  ext_prof_ch3_100M,-- : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en => ext_profile_ch3_buffer_wren,--: IN STD_LOGIC;
    rd_en => ext_profile_ch3_buffer_rden,--: IN STD_LOGIC;
    dout  => ext_prof_ch3_sync,--: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full => ext_profile_ch3_buffer_full,--: OUT STD_LOGIC;
    empty => ext_profile_ch3_buffer_empty --: OUT STD_LOGIC
);



-- this fifo is used to transfer internal profile signal @ 20M to syncclk @250M
fifo_int_profile_ch0_inst : entity work.fifo_profile_int port map
(
    rst => '0', --: IN STD_LOGIC;
    wr_clk => clk_20M,-- : IN STD_LOGIC;
    rd_clk => sync_clk_buf(0),-- : IN STD_LOGIC;
    din =>  profile_internal(0),-- : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en => int_profile_ch0_buffer_wren,--: IN STD_LOGIC;
    rd_en => int_profile_ch0_buffer_rden,--: IN STD_LOGIC;
    dout  => int_prof_ch0_sync,--: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full => int_profile_ch0_buffer_full,--: OUT STD_LOGIC;
    empty => int_profile_ch0_buffer_empty --: OUT STD_LOGIC
);

fifo_int_profile_ch1_inst : entity work.fifo_profile_int port map
(
    rst => '0', --: IN STD_LOGIC;
    wr_clk => clk_20M,-- : IN STD_LOGIC;
    rd_clk => sync_clk_buf(1),-- : IN STD_LOGIC;
    din =>  profile_internal(1),-- : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en => int_profile_ch1_buffer_wren,--: IN STD_LOGIC;
    rd_en => int_profile_ch1_buffer_rden,--: IN STD_LOGIC;
    dout  => int_prof_ch1_sync,--: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full => int_profile_ch1_buffer_full,--: OUT STD_LOGIC;
    empty => int_profile_ch1_buffer_empty --: OUT STD_LOGIC
);


fifo_int_profile_ch2_inst : entity work.fifo_profile_int port map
(
    rst => '0', --: IN STD_LOGIC;
    wr_clk => clk_20M,-- : IN STD_LOGIC;
    rd_clk => sync_clk_buf(2),-- : IN STD_LOGIC;
    din =>  profile_internal(2),-- : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en => int_profile_ch2_buffer_wren,--: IN STD_LOGIC;
    rd_en => int_profile_ch2_buffer_rden,--: IN STD_LOGIC;
    dout  => int_prof_ch2_sync,--: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full => int_profile_ch2_buffer_full,--: OUT STD_LOGIC;
    empty => int_profile_ch2_buffer_empty --: OUT STD_LOGIC
);


fifo_int_profile_ch3_inst : entity work.fifo_profile_int port map
(
    rst => '0', --: IN STD_LOGIC;
    wr_clk => clk_20M,-- : IN STD_LOGIC;
    rd_clk => sync_clk_buf(3),-- : IN STD_LOGIC;
    din =>  profile_internal(3),-- : IN STD_LOGIC_VECTOR(2 DOWNTO 0);
    wr_en => int_profile_ch3_buffer_wren,--: IN STD_LOGIC;
    rd_en => int_profile_ch3_buffer_rden,--: IN STD_LOGIC;
    dout  => int_prof_ch3_sync,--: OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
    full => int_profile_ch3_buffer_full,--: OUT STD_LOGIC;
    empty => int_profile_ch3_buffer_empty --: OUT STD_LOGIC
);


process(clk_20M)
variable  tx_trigger_ext, ctrl_state_index : integer :=0;
begin
  if(clk_20M'EVENT AND clk_20M = '1') then
            
        spi_fifo_rd_en <= not spi_fifo_empty;    ----read fifo until fifo is empty
        spi_wren_72b <= (others => '0');
        spi_wren_40b <= (others => '0');
        s_ad9910_ioupdate <= (others => '0');
        spi_9910_masterrst <= (others => '0');
        pll_config_en <= '0';
        
        if (spi_fifo_rd_en ='1') then
            if (spi_fifo_dout(95 downto 88) = x"E0" ) then				-----chip select
					if (spi_fifo_dout(87 downto 80) = x"01" ) then
						spi_wren_72b(0) <= '1';             
						spi_tx_data_72b(0) <= spi_fifo_dout(71 downto 0); 
					elsif (spi_fifo_dout(87 downto 80) = x"02" ) then
						spi_wren_40b(0) <= '1';             
						spi_tx_data_40b(0) <= spi_fifo_dout(39 downto 0);
					elsif (spi_fifo_dout(87 downto 80) = x"ff" ) then
						s_ad9910_ioupdate(0) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fe" ) then
						spi_9910_masterrst(0) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fd" ) then
						uart_ad9910_ch0_profile <= spi_fifo_dout(2 downto 0); 
						s_ad9910_ioupdate(0) <= '1';  
					elsif (spi_fifo_dout(87 downto 80) = x"fc" ) then
						uart_ad9910_ch0_profile <= spi_fifo_dout(2 downto 0);
--						uart_ad9910_ch1_profile <= spi_fifo_dout(5 downto 3);
--						uart_ad9910_ch2_profile <= spi_fifo_dout(8 downto 6);
--						uart_ad9910_ch3_profile <= spi_fifo_dout(11 downto 9);
						s_ad9910_ioupdate(0) <= '1';						
					elsif (spi_fifo_dout(87 downto 80) = x"fb" ) then
						s_parrallel_test_en_ch0_i <= spi_fifo_dout(0);					
					end if;
					
            elsif (spi_fifo_dout(95 downto 88) = x"E1" ) then
					if (spi_fifo_dout(87 downto 80) = x"01" ) then
						spi_wren_72b(1) <= '1';             
						spi_tx_data_72b(1)<=spi_fifo_dout(71 downto 0); 
					elsif (spi_fifo_dout(87 downto 80) = x"02" ) then
						spi_wren_40b(1) <= '1';             
						spi_tx_data_40b(1) <= spi_fifo_dout(39 downto 0);
					elsif (spi_fifo_dout(87 downto 80) = x"ff" ) then
						s_ad9910_ioupdate(1) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fe" ) then
						spi_9910_masterrst(1) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fd" ) then
						uart_ad9910_ch1_profile <= spi_fifo_dout(2 downto 0); 
						s_ad9910_ioupdate(1) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fc" ) then
--						uart_ad9910_ch0_profile <= spi_fifo_dout(2 downto 0);
						uart_ad9910_ch1_profile <= spi_fifo_dout(2 downto 0);
--						uart_ad9910_ch2_profile <= spi_fifo_dout(8 downto 6);
--						uart_ad9910_ch3_profile <= spi_fifo_dout(11 downto 9);
                        s_ad9910_ioupdate(1) <= '1';
					end if;  
            elsif (spi_fifo_dout(95 downto 88) = x"E2" ) then
					if (spi_fifo_dout(87 downto 80) = x"01" ) then
						spi_wren_72b(2) <= '1';             
						spi_tx_data_72b(2) <= spi_fifo_dout(71 downto 0); 
					elsif (spi_fifo_dout(87 downto 80) = x"02" ) then
						spi_wren_40b(2) <= '1';             
						spi_tx_data_40b(2) <= spi_fifo_dout(39 downto 0);
					elsif (spi_fifo_dout(87 downto 80) = x"ff" ) then
						s_ad9910_ioupdate(2) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fe" ) then
						spi_9910_masterrst(2) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fd" ) then
						uart_ad9910_ch2_profile <= spi_fifo_dout(2 downto 0); 
						s_ad9910_ioupdate(2) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fc" ) then
--						uart_ad9910_ch0_profile <= spi_fifo_dout(2 downto 0);
--						uart_ad9910_ch1_profile <= spi_fifo_dout(5 downto 3);
						uart_ad9910_ch2_profile <= spi_fifo_dout(2 downto 0);
--						uart_ad9910_ch3_profile <= spi_fifo_dout(11 downto 9);
                        s_ad9910_ioupdate(2) <= '1';
					end if;
            elsif (spi_fifo_dout(95 downto 88) = x"E3" ) then
					if (spi_fifo_dout(87 downto 80) = x"01" ) then
						spi_wren_72b(3) <= '1';             
						spi_tx_data_72b(3) <= spi_fifo_dout(71 downto 0); 
					elsif (spi_fifo_dout(87 downto 80) = x"02" ) then
						spi_wren_40b(3) <= '1';             
						spi_tx_data_40b(3) <= spi_fifo_dout(39 downto 0);
					elsif (spi_fifo_dout(87 downto 80) = x"ff" ) then
						s_ad9910_ioupdate(3) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fe" ) then
						spi_9910_masterrst(3) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fd" ) then
						uart_ad9910_ch3_profile <= spi_fifo_dout(2 downto 0); 
						s_ad9910_ioupdate(3) <= '1';
					elsif (spi_fifo_dout(87 downto 80) = x"fc" ) then
--						uart_ad9910_ch0_profile <= spi_fifo_dout(2 downto 0);
--						uart_ad9910_ch1_profile <= spi_fifo_dout(5 downto 3);
--						uart_ad9910_ch2_profile <= spi_fifo_dout(8 downto 6);
						uart_ad9910_ch3_profile <= spi_fifo_dout(2 downto 0);	
						s_ad9910_ioupdate(3) <= '1';					
					end if;    
		    elsif (spi_fifo_dout(95 downto 88) = x"D0" ) then
					if (spi_fifo_dout(87 downto 80) = x"01" ) then
					profile_switch <= spi_fifo_dout(0); 
					s_ad9910_ioupdate <= "1111";
					elsif (spi_fifo_dout(87 downto 80) = x"fc" ) then
						uart_ad9910_ch0_profile <= spi_fifo_dout(2 downto 0);
						uart_ad9910_ch1_profile <= spi_fifo_dout(2 downto 0);
						uart_ad9910_ch2_profile <= spi_fifo_dout(2 downto 0);
						uart_ad9910_ch3_profile <= spi_fifo_dout(2 downto 0);
						s_ad9910_ioupdate <= "1111";
						elsif(spi_fifo_dout(87 downto 80) = x"fd" ) then
						 uart_Att <= spi_fifo_dout(5 downto 0);
					end if;
		     elsif (spi_fifo_dout(95 downto 88) = x"D1" ) then
						pll_config_en <= '1';             
						pll_config_data <= spi_fifo_dout(15 downto 0);
             end if;    
        end if;
       end if;

end process;

---应答状�?�机
process(clk_100M)
variable  tx_trigger_ext, ctrl_state_index : integer :=0;
begin
  if(clk_100M'EVENT AND clk_100M = '1') then
    case ctrl_state_index is
		when 0 =>
			if (uart_rx_96b_valid = '1' and uart_rx_96b_data = x"F1F2F3F4F1F2F3F4F1F2F3F4") then
				uart_tx_send <= '1';
				uart_tx_96b_data <= x"0a0b0c0d0a0b0c0d0a0b0c0d";
			end if;   
			if uart_tx_send = '1' then
				tx_trigger_ext := tx_trigger_ext + 1;
				if(tx_trigger_ext = 10) then
					uart_tx_send <= '0';
					tx_trigger_ext := 0;
					ctrl_state_index := 1;   
				end if;
			end if;
			
		when 1 =>
			spi_fifo_wr_en <= '0';
			if (uart_rx_96b_valid = '1' and uart_rx_96b_data /= x"F1F2F3F4F1F2F3F4F1F2F3F4") then
				spi_fifo_din <= uart_rx_96b_data;
				spi_fifo_wr_en <= '1';
				uart_tx_send <= '1';
				uart_tx_96b_data <= uart_rx_96b_data;
			end if;
			
			if (uart_rx_96b_valid = '1' and uart_rx_96b_data = x"F1F2F3F4F1F2F3F4F1F2F3F4") then
				uart_tx_send <='1';
				uart_tx_96b_data <= x"0a0b0c0d0a0b0c0d0a0b0c0d";
			end if;   
			
			if uart_tx_send = '1' then
				tx_trigger_ext := tx_trigger_ext+1;
				if(tx_trigger_ext = 10) then
					uart_tx_send <= '0';
					tx_trigger_ext := 0;
					ctrl_state_index := 1;
				end if;
			end if;
			 
		when others =>
			spi_fifo_wr_en <= '0';
			uart_tx_send <= '0';
			ctrl_state_index := 0;
		end case;
    
  end if;  
end process;
process(sync_clk_buf(0))
begin
    if(sync_clk_buf(0)'EVENT AND sync_clk_buf(0) = '0') then
            ad9910_ioupdate(0) <= s_ad9910_ioupdate(0);
    end if;  
end process;

process(sync_clk_buf(1))
begin
    if(sync_clk_buf(1)'EVENT AND sync_clk_buf(1) = '0') then
            ad9910_ioupdate(1) <= s_ad9910_ioupdate(1);
    end if;  
end process;

process(sync_clk_buf(2))
begin
    if(sync_clk_buf(2)'EVENT AND sync_clk_buf(2) = '0') then
            ad9910_ioupdate(2) <= s_ad9910_ioupdate(2);
    end if;  
end process;

process(sync_clk_buf(3))
begin
    if(sync_clk_buf(3)'EVENT AND sync_clk_buf(3) = '0') then
            ad9910_ioupdate(3) <= s_ad9910_ioupdate(3);
    end if;  
end process;

	spi_resetn <= '1';
	uart_rx_96b_resetn <= '1';
	uart_tx_96b_resetn <= '1';
	
	ad9910_masterrst<=spi_9910_masterrst;    

	
	ad9910_mosi(0) <= spi_9910_40b_mosi(0) when spi_9910_72b_busy(0) = '0' else spi_9910_72b_mosi(0);
	ad9910_ssn(0)  <= spi_9910_40b_ssn(0)  when spi_9910_72b_busy(0) = '0' else spi_9910_72b_ssn(0);
	ad9910_sclk(0) <= spi_9910_40b_sclk(0) when spi_9910_72b_busy(0) = '0' else spi_9910_72b_sclk(0);

	ad9910_mosi(1) <= spi_9910_40b_mosi(1) when spi_9910_72b_busy(1) = '0' else spi_9910_72b_mosi(1);
	ad9910_ssn(1)  <= spi_9910_40b_ssn(1)  when spi_9910_72b_busy(1) = '0' else spi_9910_72b_ssn(1);
	ad9910_sclk(1) <= spi_9910_40b_sclk(1) when spi_9910_72b_busy(1) = '0' else spi_9910_72b_sclk(1);


	ad9910_mosi(2) <= spi_9910_40b_mosi(2) when spi_9910_72b_busy(2) = '0' else spi_9910_72b_mosi(2);
	ad9910_ssn(2)  <= spi_9910_40b_ssn(2)  when spi_9910_72b_busy(2) = '0' else spi_9910_72b_ssn(2);
	ad9910_sclk(2) <= spi_9910_40b_sclk(2) when spi_9910_72b_busy(2) = '0' else spi_9910_72b_sclk(2);

	ad9910_mosi(3) <= spi_9910_40b_mosi(3) when spi_9910_72b_busy(3) = '0' else spi_9910_72b_mosi(3);
	ad9910_ssn(3)  <= spi_9910_40b_ssn(3)  when spi_9910_72b_busy(3) = '0' else spi_9910_72b_ssn(3);
	ad9910_sclk(3) <= spi_9910_40b_sclk(3) when spi_9910_72b_busy(3) = '0' else spi_9910_72b_sclk(3);
	
	int_profile_ch0_buffer_wren <= not int_profile_ch0_buffer_full;
	int_profile_ch0_buffer_rden <= not int_profile_ch0_buffer_empty;
	int_profile_ch1_buffer_wren <= not int_profile_ch1_buffer_full;
	int_profile_ch1_buffer_rden <= not int_profile_ch1_buffer_empty;
	int_profile_ch2_buffer_wren <= not int_profile_ch2_buffer_full;
	int_profile_ch2_buffer_rden <= not int_profile_ch2_buffer_empty;
	int_profile_ch3_buffer_wren <= not int_profile_ch3_buffer_full;
	int_profile_ch3_buffer_rden <= not int_profile_ch3_buffer_empty;
	
	
	ext_profile_ch0_buffer_wren <= not ext_profile_ch0_buffer_full;
	ext_profile_ch0_buffer_rden <= not ext_profile_ch0_buffer_empty;
	ext_profile_ch1_buffer_wren <= not ext_profile_ch1_buffer_full;
	ext_profile_ch1_buffer_rden <= not ext_profile_ch1_buffer_empty;
	ext_profile_ch2_buffer_wren <= not ext_profile_ch2_buffer_full;
	ext_profile_ch2_buffer_rden <= not ext_profile_ch2_buffer_empty;
	ext_profile_ch3_buffer_wren <= not ext_profile_ch3_buffer_full;
	ext_profile_ch3_buffer_rden <= not ext_profile_ch3_buffer_empty;
	
	ad9910_ch0_profile <= s_ad9910_ch0_profile;
	ad9910_ch1_profile <= s_ad9910_ch1_profile;
	ad9910_ch2_profile <= s_ad9910_ch2_profile;
	ad9910_ch3_profile <= s_ad9910_ch3_profile;
	
	ch0_profile_sync_i <= uart_ad9910_ch0_profile;
	ch1_profile_sync_i <= uart_ad9910_ch1_profile;
	ch2_profile_sync_i <= uart_ad9910_ch2_profile;
	ch3_profile_sync_i <= uart_ad9910_ch3_profile;
	
	pll_sdi <= pll_config_sdi;
	pll_sclk <= pll_config_clk;
    pll_cs <= pll_config_cs(0);
    pll_sync_in <= '0';
    
    pll_lock_led <= pll_stat;
    ref_clk_sel <= '0';
end Behavioral;
