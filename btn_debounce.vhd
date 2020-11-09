library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity btn_debounce is
	port(
	clk : in std_logic;
	btn : in std_logic;
	btn_after : out std_logic);
end btn_debounce;


architecture Behavioral of btn_debounce is

signal q0, q1, q2, q3, q4, q5 : std_logic;

component DFF 
	port(
	clk : in std_logic;
	enable : in std_logic;
	d : in std_logic;
	rst : in std_logic;
	q : out std_logic);
end component;

begin 
	DFF1: DFF port map ( clk, '1', btn, '1', q0);	
	DFF2: DFF port map ( clk, '1', q0, '1', q1);
	DFF3: DFF port map ( clk, '1', q1, '1', q2); 
	DFF4: DFF port map ( clk, '1', q2, '1', q3);
	DFF5: DFF port map ( clk, '1', q3, '1', q4);
	DFF6: DFF port map ( clk, '1', q4, '1', q5);
	
	btn_after <= q0 and q1 and q2 and q3 and q4 and q5; 
	
end Behavioral;
	
	

	
	
	
