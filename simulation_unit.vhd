library IEEE;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity simulation_unit is
	port(
	clk : in std_logic;
	en_simulation : in std_logic; -- active high
	heat : in std_logic;
	temp : out std_logic_vector( 7 downto 0 ));
	
end simulation_unit;

architecture Behavioral of simulation_unit is

signal counter : std_logic_vector(28 downto 0) :="00000000000000000000000000000";

signal reg_temp : std_logic_vector( 7 downto 0 ) := x"00"; -- iesirea temp; starea interioara a registrului de temperaturi

signal modify_temp : std_logic; -- semnalul de modificare a temperaturii( o data la 3 sec.)

signal add_res : std_logic_vector( 7 downto 0 ) := "00000000";  --  rezultatul adunarii
signal add_res_bounded : std_logic_vector ( 7 downto 0 );

signal delta_t : std_logic_vector ( 7 downto 0 );  -- cu cat se modifica temperatura 

--signal t0, t1, t2 : std_logic_vector( 3 downto 0 );

component binary_to_decimal
	port(	 
	num : in STD_LOGIC_VECTOR (7 downto 0);
    digit_hundrends : out STD_LOGIC_VECTOR (3 downto 0);
    digit_tens : out STD_LOGIC_VECTOR (3 downto 0);
    digit_units : out STD_LOGIC_VECTOR (3 downto 0));
end component;

begin
	
	-- modificare registru de temperatura
	process (clk)
	begin
		if rising_edge(clk) then
			if en_simulation = '1' and modify_temp = '1' then
				reg_temp <= add_res_bounded;
			end if;
		end if;
	end process; 
	
	-- timer de 3 secunde ( intervalul la care temperatura creste sau scade cu un grad )
	process (clk)
	begin
		if rising_edge(clk) then
			if counter = "10001111000011010001100000000" then
				counter <= (others => '0');
			else
				counter <= counter + '1';
			end if;
		end if;
	end process;
	
	modify_temp <= '1' when counter = (counter'range => '0') else '0';
	
	add_res <= reg_temp + delta_t;   -- temperatura dupa crestere sau scadere
	
	--setare minim si maxim
	process ( add_res )
	begin
		if add_res > x"32" then 
			add_res_bounded <= x"32";
		elsif add_res < x"01" then
			add_res_bounded <= x"00";
		else
			add_res_bounded <= add_res;
		end if;
	end process;
	
	-- delta_temp = 1 cand heat = 1
	-- delta_temp = -1 cand heat = 0
	delta_t <= x"01" when heat = '1' else x"FF";
		
	temp <= reg_temp;
		
	--conversion: binary_to_decimal port map ( reg_temp, t0, t1, t2);
	--temp_tens <= t1;
	--temp_units <= t2;

end Behavioral;
	
	
	
	

	