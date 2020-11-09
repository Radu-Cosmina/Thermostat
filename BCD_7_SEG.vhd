library IEEE;
use ieee.std_logic_1164.all;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL; 

entity BCD_7_SEG is
	port(
	clk : in std_logic;
	digit0 : in std_logic_vector( 3 downto 0 );
	digit1 : in std_logic_vector( 3 downto 0 );
	digit2 : in std_logic_vector( 3 downto 0 );
	digit3 : in std_logic_vector( 3 downto 0 );	
	anod : out std_logic_vector( 3 downto 0 );
	catod : out std_logic_vector( 6 downto 0 ));
end BCD_7_SEG;

architecture Behavioral of BCD_7_SEG is	

signal counter : std_logic_vector(15 downto 0);
signal digit : std_logic_vector(3 downto 0);

begin
	counter <= counter + 1 when rising_edge(clk);
	
	process(counter)
	begin
		case counter ( 15 downto 14 ) is
			when "00" => digit <= digit0; anod <= "1110";
			when "01" => digit <= digit1; anod <= "1101";
			when "10" => digit <= digit2; anod <= "1011";
			when others => digit <= digit3; anod <= "0111"; 
		end case;
	end process;
	
	with digit select
     catod<= "1111001" when "0001",   --1
             "0100100" when "0010",   --2
             "0110000" when "0011",   --3
             "0011001" when "0100",   --4
             "0010010" when "0101",   --5
             "0000010" when "0110",   --6
             "1111000" when "0111",   --7
             "0000000" when "1000",   --8
             "0010000" when "1001",   --9
             "1000000" when others;   --0
end Behavioral;
	

