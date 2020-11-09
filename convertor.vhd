library IEEE;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

entity conversion is
	port(
	x : in integer;
	y : out std_logic_vector(3 downto 0)); 
end conversion;

architecture c of conversion is	
begin
	y <= std_logic_vector( to_unsigned ( x, 4)); 
end c;