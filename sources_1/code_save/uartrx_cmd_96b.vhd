library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity uartrx_cmd_96b is
  Port ( 
    clk 			: in  STD_LOGIC;
    cmdout_96b      : out STD_LOGIC_VECTOR (95 downto 0);
    UART_RXD 	    : in  STD_LOGIC;
    dataout_flag    : out std_logic;
    reset_n         : in  STD_LOGIC
    );
end uartrx_cmd_96b;

architecture Behavioral of uartrx_cmd_96b is

signal uart_rx_data, uart_tx_data : std_logic_vector(7 downto 0) := (others=>'0');
signal uart_rx_96b_valid, uart_rx_96b_resetn, uart_tx_ready, uart_tx_send : std_logic;
signal rst : std_logic;
signal uartRX_read : std_logic_vector(1 downto 0);

begin

Inst_UART_RX_CTRL: entity work.UART_RX port map(
		
		rx_data_out => uart_rx_data,
		CLK => clk,
		rst => rst,
		rx_in => UART_RXD, 
		rx_valid_out => uartRX_read
	);
	
rst <= not reset_n;

process(clk,reset_n)
variable  state_index : integer :=0;
begin
 if(reset_n = '0') then        --reset system
    state_index := 0;
    cmdout_96b <= (others => '0');
    dataout_flag <= '0';
elsif(clk'EVENT AND clk = '1') then
    dataout_flag <= '0';
    case state_index is
    when 0 =>
        if(uartRX_read = "01") then
            cmdout_96b(95 downto 88) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(95 downto 88) <= x"00";
			state_index := state_index + 1;
        end if;

    when 1 =>
        if(uartRX_read = "01") then
            cmdout_96b(87 downto 80) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(87 downto 80) <= x"00";
			state_index := state_index + 1;
        end if;
		
    when 2 =>
        if(uartRX_read ="01") then
            cmdout_96b(79 downto 72) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(79 downto 72) <= x"00";
			state_index := state_index + 1;
        end if;
		
    when 3 =>
        if(uartRX_read ="01") then
            cmdout_96b(71 downto 64) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(71 downto 64) <= x"00";
			state_index := state_index + 1;
        end if;
        
    when 4 =>
        if(uartRX_read = "01") then
            cmdout_96b(63 downto 56) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(63 downto 56) <= x"00";
			state_index := state_index + 1;	
        end if;
		
    when 5 =>
        if(uartRX_read = "01") then
            cmdout_96b(55 downto 48) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(55 downto 48) <= x"00";
			state_index := state_index + 1;
        end if;
		
    when 6 =>
        if(uartRX_read = "01") then
            cmdout_96b(47 downto 40) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(47 downto 40) <= x"00";
			state_index := state_index + 1;
        end if;
		
    when 7 =>
        if(uartRX_read = "01") then
            cmdout_96b(39 downto 32) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(39 downto 32) <= x"00";
			state_index := state_index + 1;
        end if;
        
    when 8 =>
        if(uartRX_read = "01") then
            cmdout_96b(31 downto 24) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(31 downto 24) <= x"00";
			state_index := state_index + 1;
        end if;
		
    when 9 =>
        if(uartRX_read = "01") then
            cmdout_96b(23 downto 16) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(23 downto 16) <= x"00";
			state_index := state_index + 1;
        end if;
		
    when 10 =>
        if(uartRX_read = "01") then
            cmdout_96b(15 downto 8) <= uart_rx_data;
            state_index := state_index + 1;
		elsif(uartRX_read = "10") then
			cmdout_96b(15 downto 8) <= x"00";
			state_index := state_index + 1;
        end if;
		
    when 11 =>
        if(uartRX_read = "01") then
            cmdout_96b(7 downto 0) <= uart_rx_data;
            state_index := state_index + 1;
            dataout_flag <= '1';
		elsif(uartRX_read = "10") then
			cmdout_96b(7 downto 0) <= x"00";
			state_index := state_index + 1;
			dataout_flag <= '1';
        end if;
		
	when 12 =>
			state_index := 0;
			cmdout_96b <= (others => '0');
			dataout_flag <= '0';  
			
	when others =>
			state_index := 0;
			cmdout_96b <= (others => '0');
			dataout_flag <= '0';
		end case;
end if;
end process;

end Behavioral;
