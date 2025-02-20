library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MantissaMultiplier is
    Port (
        a : in STD_LOGIC_VECTOR(31 downto 0);
        b : in STD_LOGIC_VECTOR(31 downto 0);
        intermediate_product : out STD_LOGIC_VECTOR(47 downto 0) -- 48-bit product of mantissas
    );
end MantissaMultiplier;

architecture Behavioral of MantissaMultiplier is
    signal mantissa_a, mantissa_b : STD_LOGIC_VECTOR(23 downto 0);
begin
    mantissa_a <= "1" & a(22 downto 0); -- Include implicit leading 1
    mantissa_b <= "1" & b(22 downto 0);
    
    intermediate_product <= std_logic_vector(unsigned(mantissa_a) * unsigned(mantissa_b));
end Behavioral;
