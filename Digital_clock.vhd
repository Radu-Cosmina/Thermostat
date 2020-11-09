library IEEE;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 


entity Digital_clock is
	port(
	
	clk : in std_logic; -- 100MHz clk
	rst : in std_logic; -- reset activ pe 0; aduce ceasul la 00:00
	
	H1_IN : in std_logic_vector( 3 downto 0); -- cea mai semnificativa cifra a orei 
	                                   -- valori posibile: 0-2
	
	H2_IN : in std_logic_vector( 3 downto 0); -- cea mai putin semnificativa cifra a orei
	                                   -- valori posibile: 0-9
	
    M1_IN : in std_logic_vector( 3 downto 0); -- cea mai semnificativa cifra a minutului
									   -- valori posibile: 0-5
									   
	M2_IN : in std_logic_vector( 3 downto 0); -- cea mai putin semnificativa cifra a minutului
	                                   -- valori posibile: 0-9
									   
	H1_OUT : out std_logic_vector ( 3 downto 0);  -- cea mai semnificativa cifra a orei 
	                                       -- valori posibile: 0-2 ( in hexa pentru BCD 7 SEG)
										   
    H2_OUT : out std_logic_vector ( 3 downto 0);  -- cea mai putin semnificativa cifra a orei
										   -- valori posibile: 0-9 ( in hexa pentru BCD 7 SEG)  
										   
    M1_OUT : out std_logic_vector ( 3 downto 0);  -- cea mai semnificativa cifra a minutului
										   -- valori posibile: 0-5 ( in hexa pentru BCD 7 SEG)
										   
	M2_OUT : out std_logic_vector ( 3 downto 0)  -- cea mai putin semnificativa cifra a minutului
										   -- valori posibile: 0-9 ( in hexa pentru BCD 7 SEG)
);
end Digital_clock;


architecture Behavioral of Digital_clock is

component clk_div 
	port(
	in_clk : in std_logic;
	clr : in std_logic;
	out_clk : out std_logic);
end component;

component conversion 
	port(
	x : in integer;
	y : out std_logic_vector(3 downto 0)); 
end component;

signal clk_1s : std_logic; -- clock-ul cu perioada de 1 secunda	 
signal clr : std_logic:='0';
signal count_h1, count_h2, count_m1, count_m2, count_s : INTEGER :=0; -- counter pentru ore, minute, secunde
signal H1_out_bin : std_logic_vector ( 3 downto 0); -- m.s.b. pentru ora
signal H2_out_bin : std_logic_vector ( 3 downto 0); -- l.s.b. pentru ora
signal M1_out_bin : std_logic_vector ( 3 downto 0); -- m.s.b. pentru minut
signal M2_out_bin : std_logic_vector ( 3 downto 0); -- l.s.b. pentru minut	

begin

create_1s_clk: clk_div port map ( in_clk => clk, clr => clr, out_clk => clk_1s);	-- create 1 second clock 

process ( clk, rst)
begin
	if ( rst = '0' ) then
		count_h1 <= to_integer ( unsigned(H1_IN));
		count_h2 <= to_integer ( unsigned(H2_IN));
		count_m1 <= to_integer ( unsigned(M1_IN));
		count_m2 <= to_integer ( unsigned(M2_IN));
		count_s <= 0;
	elsif rising_edge(clk) then
	count_s <= count_s + 1;
	
	if ( count_s >= 59 ) then
		count_s <= 0;
		count_m2 <= count_m2 + 1;
			
			
	if ( count_m2 >= 9 ) then
		count_m2 <= 0; 		  
		count_m1 <= count_m1 + 1;
		
	if ( count_m1 >= 5 ) then
		count_m1 <= 0;
		count_h2 <= count_h2 + 1;
		
	if ( count_h2 >= 3 ) and (count_h1 = 2) then
		count_h1 <= 0;
		count_h2 <= 0;
	
	elsif ( count_h2 >= 9 ) and ( count_h1 <= 2) then
		count_h2 <= 0;
		count_h1 <= count_h1 + 1;
		
	
		
	
	end if;
	end if;
	end if;
	end if;
	end if;
	

end process	;

-- convertim timpul;

conversie1: conversion port map ( count_h1, H1_OUT );
conversie2: conversion port map ( count_h2, H2_OUT );
conversie3: conversion port map ( count_m1, M1_OUT );
conversie4: conversion port map ( count_m2, M2_OUT );


end Behavioral;