library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignCalculator is
    Port (
        sign_a : in STD_LOGIC;
        sign_b : in STD_LOGIC;
        result_sign : out STD_LOGIC
    );
end SignCalculator;

architecture Behavioral of SignCalculator is
begin
    result_sign <= sign_a XOR sign_b;
end Behavioral;
