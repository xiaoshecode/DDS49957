library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity parallel_test_new is
	port(
		rstn_i : in std_logic;
		pdclk_i : in std_logic;
		en_i : in std_logic;
		F_o : out std_logic_vector(1 downto 0);
		D_o : out std_logic_vector(15 downto 0);
		en_o : out std_logic;
		state_i : in std_logic_vector(2 downto 0)
	);
end entity;

architecture behave of parallel_test_new is


signal count : std_logic_vector(21 downto 0);

type test_state is (idle, step_one, step_two, step_three, step_four, step_five);
signal mech_state : test_state;

begin
	process(pdclk_i) begin
        if(pdclk_i'event and pdclk_i = '0') then
			case mech_state is
				when idle=>
						F_o <= "10";
						D_o <= x"0000";
						en_o <= '1';
					if(en_i = '1' and state_i = "100") then
						mech_state <= step_one;
					else 
						mech_state <= idle;
					end if;
					
				when step_one =>				-----200ns 200MHz
					if(en_i = '1' and state_i = "100") then
						en_o <= '1';
						F_o <= "10";
						D_o <= x"3333";
						if(count < 50) then
							count <= count + 1;
							mech_state <= step_one;
						else
							count <= (others => '0');
							mech_state <= step_two;
						end if;
					else
						mech_state <= idle;
					end if;
					
				when step_two => 
					if(en_i = '1' and state_i = "100") then
						F_o <= "10";
						D_o <= x"0000";
						en_o <= '1';
						if(count < 2500000) then      ----10ms close
							count <= count + 1;
							mech_state <= step_two;
						else
							count <= (others => '0');
							mech_state <= step_three;
						end if;
					else
						mech_state <= idle;
					end if;
	
				when step_three => 				---1us 200MHz
					if(en_i = '1' and state_i = "100") then
						F_o <= "10";
						D_o <= x"3333";
						en_o <= '1';
						if(count < 250) then
						
							count <= count + 1;
							mech_state <= step_three;
						else
							count <= (others => '0');
							mech_state <= step_four;
						end if;	
					else
						mech_state <= idle;
					end if;
					
				when step_four => 				---1us 300MHz
					if(en_i = '1' and state_i = "100") then
						F_o <= "10";
						D_o <= x"4c33";
						en_o <= '1';
						if(count < 250) then
							count <= count + 1;
							mech_state <= step_four;
						else
							count <= (others => '0');
							mech_state <= step_five;
						end if;	
					else
						mech_state <= idle;
					end if;
					
				when step_five =>				-----close
					if(en_i = '1' and state_i = "100") then
						F_o <= "10";
						D_o <= x"0000";
						en_o <= '1';
						if(count < 4000000) then
							count <= count + 1;
							mech_state <= step_five;
						else
							count <= (others => '0');
							mech_state <= step_one;
						end if;
					else
						mech_state <= idle;
					end if;
				
				end case;
		end if;
	end process;

end behave;

