library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OutputPacker is
    Port (
        result_sign : in STD_LOGIC;                    
        normalized_exponent : in STD_LOGIC_VECTOR(7 downto 0); 
        normalized_mantissa : in STD_LOGIC_VECTOR(23 downto 0); 
        c : out STD_LOGIC_VECTOR(31 downto 0)          
    );
end OutputPacker;

architecture Behavioral of OutputPacker is
begin
    process(result_sign, normalized_exponent, normalized_mantissa)
    begin
        -- Assemble Sign | Exponent | Mantissa[22 downto 0]
        c <= result_sign & normalized_exponent & normalized_mantissa(22 downto 0);
    end process;
end Behavioral;
