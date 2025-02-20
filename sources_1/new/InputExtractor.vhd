library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity InputExtractor is
    Port (
        a, b : in STD_LOGIC_VECTOR(31 downto 0);
        sign_a, sign_b : out STD_LOGIC;
        exponent_a, exponent_b : out STD_LOGIC_VECTOR(7 downto 0);
        mantissa_a, mantissa_b : out STD_LOGIC_VECTOR(23 downto 0)
    );
end InputExtractor;

architecture Behavioral of InputExtractor is
begin
    process(a, b)
    begin
        sign_a <= a(31);
        exponent_a <= a(30 downto 23);
        mantissa_a <= "1" & a(22 downto 0);  -- Implicit leading 1
        sign_b <= b(31);
        exponent_b <= b(30 downto 23);
        mantissa_b <= "1" & b(22 downto 0);  -- Implicit leading 1
    end process;
end Behavioral;