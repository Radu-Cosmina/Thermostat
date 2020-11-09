library IEEE;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 

entity test is
	port(
	clk : in STD_LOGIC;
    sw : in STD_LOGIC_VECTOR (15 downto 0);
    btn : in STD_LOGIC_VECTOR (4 downto 0);
    led : out STD_LOGIC_VECTOR (15 downto 0);
    anod : out STD_LOGIC_VECTOR (3 downto 0);
    catod : out STD_LOGIC_VECTOR (6 downto 0));	
end test;

architecture Behavioral of test is

component Digital_clock 
	port(
	clk : in std_logic; 
	rst : in std_logic; 
	H1_IN : in std_logic_vector( 3 downto 0); 
	H2_IN : in std_logic_vector( 3 downto 0); 
    M1_IN : in std_logic_vector( 3 downto 0); 
	M2_IN : in std_logic_vector( 3 downto 0); 
	H1_OUT : out std_logic_vector ( 3 downto 0);  
    H2_OUT : out std_logic_vector ( 3 downto 0);  
    M1_OUT : out std_logic_vector ( 3 downto 0); 
	M2_OUT : out std_logic_vector ( 3 downto 0));
end component;

component Term2 
	port (
	clk : in std_logic;
	temp : in std_logic_vector(7 downto 0);
	hour1 : in std_logic_vector( 3 downto 0);
	hour2 : in std_logic_vector(3 downto 0);
	prog_h1 : in std_logic_vector( 3 downto 0);
	prog_h2 : in std_logic_vector( 3 downto 0);
	prog_min : in std_logic_vector( 7 downto 0);
	prog_max : in std_logic_vector( 7 downto 0);
	ok : in std_logic;
	heat: out std_logic); 
end component; 

component binary_to_decimal 
    Port ( num : in STD_LOGIC_VECTOR (7 downto 0);
           digit_hundrends : out STD_LOGIC_VECTOR (3 downto 0);
           digit_tens : out STD_LOGIC_VECTOR (3 downto 0);
           digit_units : out STD_LOGIC_VECTOR (3 downto 0));
end component;

component prog_unit 
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
end component; 

component set_clock 
	port(
	clk : in std_logic;
	set_digital_clk : in std_logic;  
	ok : in std_logic;  
	set_hour : in std_logic;	 
	set_min : in std_logic;	
	din : in std_logic; 
	inc : in std_logic;		 
	dec : in std_logic;
	prog_time_h1 : out std_logic_vector( 3 downto 0 );
	prog_time_h2 : out std_logic_vector( 3 downto 0 );
	prog_time_m1 : out std_logic_vector( 3 downto 0 );
	prog_time_m2 : out std_logic_vector( 3 downto 0 );
	display : out std_logic_vector( 7 downto 0));
end component; 	

component BCD_7_SEG 
	port(
	clk : in std_logic;
	digit0 : in std_logic_vector( 3 downto 0 );
	digit1 : in std_logic_vector( 3 downto 0 );
	digit2 : in std_logic_vector( 3 downto 0 );
	digit3 : in std_logic_vector( 3 downto 0 );	
	anod : out std_logic_vector( 3 downto 0 );
	catod : out std_logic_vector( 6 downto 0 ));
end component;	

component btn_debounce 
	port(
	clk : in std_logic;
	btn : in std_logic;
	btn_after : out std_logic );
end component; 

component simulation_unit 
	port(
	clk : in std_logic;
	en_simulation : in std_logic; -- active high
	heat : in std_logic;
	temp : out std_logic_vector( 7 downto 0 ));
end component; 

signal btn_after : STD_LOGIC_VECTOR(4 downto 0);
signal prog_min, prog_max, sim_temp, prog_display1, prog_display2, display_bin : STD_LOGIC_VECTOR(7 downto 0);
signal prog_time, current_time : STD_LOGIC_VECTOR(4 downto 0);
signal sim_en, prog_en, prog, settime_en, heat, sign : STD_LOGIC;
signal digit3, digit2, digit1, digit0 : STD_LOGIC_VECTOR(3 downto 0);
signal d1, d2, d3 : STD_LOGIC_VECTOR(3 downto 0);

signal h1, h2, m1, m2 : std_logic_vector(3 downto 0);
signal prog_time_h1, prog_time_h2, prog_time_m1, prog_time_m2 : std_logic_vector (3 downto 0);
signal prog_h1, prog_h2 : std_logic_vector(3 downto 0);

begin	
	
	led(15 downto 1) <= (others => '0');
    led(0) <= heat;
	
	debouncer0: btn_debounce port map (clk, btn(0), btn_after(0));	 
	debouncer1: btn_debounce port map (clk, btn(1), btn_after(1));
	debouncer2: btn_debounce port map (clk, btn(2), btn_after(2));
	debouncer3: btn_debounce port map (clk, btn(3), btn_after(3));
	debouncer4: btn_debounce port map (clk, btn(4), btn_after(4));
    afisaj: BCD_7_SEG port map (clk, digit0, digit1, digit2, digit3, anod, catod); 
	unitate_simulare: simulation_unit port map (clk, sim_en, heat, sim_temp);
	termostat: Term2 port map (clk, sim_temp, h1, h2, prog_h1, prog_h2, prog_min, prog_max, btn_after(0), heat); 
	setare_ceas: set_clock port map (clk, sw(15), btn_after(0), sw(13), sw(12), sw(0), btn_after(3), btn_after(1), prog_time_h1, prog_time_h2, prog_time_m1, prog_time_m2, prog_display1);
	setare_minmax: prog_unit port map (clk, sw(14), btn_after(0), sw(13), sw(0), sw(3), sw(1), prog_h1, prog_h2, prog_min, prog_max, prog_display2);
	ceas_digital: Digital_clock port map ( clk, btn_after(4), prog_time_h1, prog_time_h2, prog_time_m1, prog_time_m2, h1, h2, m1, m2);
	bin_2_dec: binary_to_decimal port map (display_bin, digit1, digit2, digit3);
	
	sim_en <= sw(2);
	
	process (sw)
    begin
        if sw(1) = '0' and sw(2) = '0' then
            digit0 <= h2;
			digit1 <= h1;
			digit2 <= m1;
			digit3 <= m2;
        elsif sw(1) = '1' and sw(2) = '0' then 
			digit0 <= "0000";
			display_bin <= sim_temp;
        elsif sw(1) = '0' and sw(2) = '1' then 
            display_bin <= prog_display1;
		elsif sw(1) = '1' and sw(2) = '1' then 
			display_bin <= prog_display2;	
        end if;
    end process;
	
end Behavioral; 











