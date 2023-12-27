library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;

entity uarttx_cmd_96b is
  Port ( 
    clk 			:  in  STD_LOGIC;
    tx_cmd_96b      :  in STD_LOGIC_VECTOR (95 downto 0);
    UART_TXD 	    :  out  STD_LOGIC;
    tx_send_start   :  in std_logic;
    reset_n         :  in  STD_LOGIC
    );
end uarttx_cmd_96b;

architecture Behavioral of uarttx_cmd_96b is

signal uart_rx_data, uart_tx_data : std_logic_vector(7 downto 0) := (others=>'0');
signal uartRX_read, uart_rx_96b_valid, uart_rx_96b_resetn, uart_tx_ready, uart_tx_send : std_logic;

signal rst : std_logic;
signal tx_send_start_prev : std_logic;

begin
rst <= not reset_n;

Inst_UART_TX_CTRL: entity work.UART_TX_CTRL port map(
		
		DATA =>uart_tx_data,
		CLK => clk,
		SEND => uart_tx_send,
		READY => uart_tx_ready,
		UART_TX => UART_TXD 
	);
	
process(clk,reset_n)
variable  state_index : integer :=0;
begin
 if(reset_n = '0') then        --reset system
    state_index:= 0;
    uart_tx_send<='0';
elsif(clk'EVENT AND clk = '1') then
    tx_send_start_prev <= tx_send_start;
    if (tx_send_start = '1') then
        state_index := 1;        
    end if;
    case state_index is
	---IDLE
		when 0 =>
			uart_tx_send <= '0';
			if (tx_send_start = '1') then
				state_index := 1;        
			end if;
	---start Tx    96bit = 12byte   高字节优先
		when 1 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(95 downto 88);
				state_index := state_index + 1;
			else
				uart_tx_send <= '0';
			end if;
			
		when 2 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(87 downto 80);
				state_index := state_index+1;
			end if;
			
		when 3 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(79 downto 72);
				state_index := state_index + 1;
			end if;
          
       when 4 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(71 downto 64);          
				state_index := state_index+1;
			end if; 
			
       when 5 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(63 downto 56);          
				state_index := state_index + 1;
			end if; 
			
       when 6 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(55 downto 48);          
				state_index := state_index+1;
			end if; 
			
       when 7 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(47 downto 40);          
				state_index := state_index+1;
			end if; 
      
       when 8 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <='1';
				uart_tx_data <= tx_cmd_96b(39 downto 32);          
				state_index := state_index + 1;
			end if; 
			
       when 9 =>
			if(uart_tx_ready ='1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(31 downto 24);          
				state_index := state_index + 1;
			end if; 
			
       when 10 =>
			if(uart_tx_ready = '1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(23 downto 16);          
				state_index := state_index + 1;
			end if; 
			
       when 11 =>
			if(uart_tx_ready ='1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(15 downto 8);          
				state_index := state_index + 1;
			end if; 
      
	   when 12 =>
			if(uart_tx_ready ='1') then
				uart_tx_send <= '1';
				uart_tx_data <= tx_cmd_96b(7 downto 0);
				state_index := state_index + 1;
			end if;
			
       when 13 =>
			uart_tx_send <= '0';
			uart_tx_data <= (others => '0');
			state_index := 0;
			
       when others =>
			uart_tx_send <='0';
			uart_tx_data <= (others => '0');
			state_index := 0;
    end case;
end if;
end process;

end Behavioral;
