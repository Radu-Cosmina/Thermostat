library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;

entity binary_to_decimal is
    Port ( num : in STD_LOGIC_VECTOR (7 downto 0);
           digit_hundrends : out STD_LOGIC_VECTOR (3 downto 0);
           digit_tens : out STD_LOGIC_VECTOR (3 downto 0);
           digit_units : out STD_LOGIC_VECTOR (3 downto 0));
end binary_to_decimal;

architecture Behavioral of binary_to_decimal is

signal num_unsigned : STD_LOGIC_VECTOR(7 downto 0);

begin

    num_unsigned <= num when num(7) = '0' else ( not num ) + 1;
    
    
    process(num_unsigned)
    variable temp : STD_LOGIC_VECTOR (11 downto 0);
    variable bcd : UNSIGNED (15 downto 0) := (others => '0');
      
    begin
        bcd := (others => '0');
        temp(11 downto 0) := "0000" & num_unsigned;

        for i in 0 to 11 loop
        
            if bcd(3 downto 0) > 4 then 
                bcd(3 downto 0) := bcd(3 downto 0) + 3;
            end if;
          
            if bcd(7 downto 4) > 4 then 
                bcd(7 downto 4) := bcd(7 downto 4) + 3;
            end if;
        
            if bcd(11 downto 8) > 4 then  
              bcd(11 downto 8) := bcd(11 downto 8) + 3;
            end if;

            bcd := bcd(14 downto 0) & temp(11);
        
            temp := temp(10 downto 0) & '0';
        
        end loop;

        digit_units <= STD_LOGIC_VECTOR(bcd(3 downto 0));
        digit_tens <= STD_LOGIC_VECTOR(bcd(7 downto 4));
        digit_hundrends <= STD_LOGIC_VECTOR(bcd(11 downto 8));
      
    end process;   

end Behavioral;