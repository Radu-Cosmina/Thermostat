library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity prog_unit is
	port(
	clk : in std_logic;
	set_minmax : in std_logic;  -- buton pentru mod setare minmax
	ok : in std_logic;  -- buton pentru preluare date
	set_hour : in std_logic;	 -- buton pentru setare ora
	din : in std_logic; -- 0 - h1, min / 1 - h2, max
	inc : in std_logic;		 
	dec : in std_logic;
	prog_h1 : out std_logic_vector( 3 downto 0 );
	prog_h2 : out std_logic_vector( 3 downto 0 );
	prog_min : out std_logic_vector( 7 downto 0 );
	prog_max : out std_logic_vector( 7 downto 0 );
	display : out std_logic_vector( 7 downto 0));
end prog_unit;


architecture Behavioral of prog_unit is

signal reg_h1 : std_logic_vector( 7 downto 0 );
signal reg_h2 : std_logic_vector( 7 downto 0 );
signal reg_min : std_logic_vector( 7 downto 0 );
signal reg_max : std_logic_vector( 7 downto 0 );
signal counter : std_logic_vector( 7 downto 0 ):="00000000";


begin
	
process( clk )
begin
	if rising_edge(clk) then
		if set_minmax = '1' and set_hour= '1' and din = '0' and ok = '1' then
			reg_h1 <= counter;
			
		end if;
	end if;
end process;
																		-- setare ora
process( clk )
begin
	if rising_edge(clk) then
		if set_minmax = '1' and set_hour = '1' and din = '1' and ok = '1' then
			reg_h2 <= counter;
		end if;
	end if;
end process; 


process( clk )	  -- setare minim
begin
	if rising_edge(clk) then
		if set_minmax = '1' and set_hour = '0' and din = '0' and ok = '1' then
			reg_min <= counter;	
		end if;
	end if;
end process;

process( clk )	  -- setare maxim
begin
	if rising_edge(clk) then
		if set_minmax = '1' and set_hour = '0' and din = '1' and ok = '1' then
			reg_max <= counter;	
		end if;
	end if;
end process; 


process( clk )
begin
	if rising_edge(clk) then 
		if set_minmax = '1' then
			if set_hour = '1' and din = '0'  and counter >= x"02" then
			counter <= x"00";
			elsif set_hour = '1' and din = '1' and reg_h1 = x"02" and counter >= x"03" then
			counter <= x"00";
			elsif set_hour = '1' and din = '1' and reg_h1 = x"01" and counter >=x"09" then
			counter <= x"00";
			elsif set_hour = '1' and din = '1' and reg_h1 = x"00" and counter >=x"09" then
			counter <= x"00";
			elsif inc = '1' then
			counter <= counter + 1;
			elsif dec = '1' then
			counter <= counter - 1;
			end if;
		end if;
	end if;
end process;

display <= counter;
prog_h1 <= reg_h1( 3 downto 0 );
prog_h2 <= reg_h2( 3 downto 0 );
prog_min <= reg_min;
prog_max <= reg_max;

end Behavioral;

		
			
			


	