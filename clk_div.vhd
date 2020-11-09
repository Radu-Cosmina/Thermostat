library IEEE;
use ieee.std_logic_1164.all;

entity clk_div is
	port(
	
	in_clk  : in std_logic;	   -- semnal de ceas (de la placuta)
	clr 	: in std_logic;    -- semnal reset
	out_clk : out std_logic);  -- semnal de ceas divizat ( 1 secunda )
end clk_div;


architecture Behavioral of clk_div is  

signal clk_1_sec : std_logic := '0';
signal count     : integer range 0 to 450_000_000 := 0;  -- valoare limita de numarare ( nexys 3 are frecv. 100MHz )

begin			
	process ( in_clk )
	begin
		if ( clr = '0' ) then  -- clr - activ pe 0 => resetam 
			clk_1_sec <= '0';
			count <= 0; 
		elsif ( in_clk = '1' and in_clk' event ) then  
			if ( count = 100_000_000) then			  -- daca au trecut 100-000-000 oscilatii => avem o secunda
				clk_1_sec <= not ( clk_1_sec);
				count <= 0;
			else						-- altfel continuam sa numaram
				count <= count + 1;
			end if;
		end if;
	end process;
	
	out_clk <= clk_1_sec;
end Behavioral;		 
	