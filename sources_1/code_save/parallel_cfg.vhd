library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;

entity parallel_cfg is
	port(
		rstn_i : in std_logic;
		pdclk_i : in std_logic;
		en_i : in std_logic;
		F_o : out std_logic_vector(1 downto 0);
		D_o : out std_logic_vector(15 downto 0);
		F_i : in std_logic_vector(1 downto 0);
		D_i : in std_logic_vector(15 downto 0);
		Tx_enable_o : out std_logic;
		state_o : out std_logic_vector(2 downto 0)
	);
end entity;

architecture behavioral of parallel_cfg is
type parrallel_state is (idle, init_phase, init_freq, init_amp, run, finish);

signal mech_state : parrallel_state;

begin
	process (pdclk_i)
		begin
		if (pdclk_i'event and pdclk_i = '0') then
				case mech_state is 
					when idle =>
					    state_o <= "000";
						if(en_i = '1') then 
							mech_state <= init_phase;
							F_o <= (others => '0');
							D_o <= x"0000";
							Tx_enable_o <= '1';
						else
							mech_state <= idle;
						end if;
					when init_phase =>
						state_o <= "001";
						if(en_i = '1') then
							Tx_enable_o <= '1';
							F_o <= "01";
							D_o <= x"0000";
							mech_state <= init_freq;
						else 
							mech_state <= finish;
							end if;
					when init_freq =>
					 state_o <= "010";
						if(en_i = '1') then
							Tx_enable_o <= '1';
							F_o <= "10";
							D_o <= x"3333";
							mech_state <= init_amp;
						else 
							mech_state <= finish;
							end if;
					when init_amp =>
						state_o <= "011";
						if(en_i = '1') then
							Tx_enable_o <= '1';
							F_o <= "00";
							D_o <= x"3FFF";
							mech_state <= run;
						else
							mech_state <= finish;
							end if;
					when run =>
						state_o <= "100";
						if(en_i = '1') then
							Tx_enable_o <= '1';
							F_o <= F_i;
							D_o <= D_i;
							mech_state <= run;
						else 
							mech_state <= finish;
						end if;
					when finish =>
							state_o <= "101";
							Tx_enable_o <= '1';
							F_o <= "00";
							D_o <= x"3fff";
							mech_state <= idle;
					when others=> --should never be reached
						mech_state <= idle;
					end case;
			end if;
		end process;

end behavioral;