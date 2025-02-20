library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ExponentCalculator is
    Port (
        a : in STD_LOGIC_VECTOR(31 downto 0);
        b : in STD_LOGIC_VECTOR(31 downto 0);
        intermediate_exponent : out STD_LOGIC_VECTOR(8 downto 0) -- 9-bit for bias adjustment
    );
end ExponentCalculator;

architecture Behavioral of ExponentCalculator is
    signal exponent_a, exponent_b : STD_LOGIC_VECTOR(8 downto 0);
begin
    exponent_a <= "0" & a(30 downto 23); -- Extend to 9 bits for bias adjustment
    exponent_b <= "0" & b(30 downto 23);
    
    intermediate_exponent <= std_logic_vector(unsigned(exponent_a) + unsigned(exponent_b) - 127); -- E1 + E2 - Bias
end Behavioral;
