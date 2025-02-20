library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity SignChooser is
    Port (
        sign_a : in STD_LOGIC;
        sign_b : in STD_LOGIC;
        aligned_mantissa_a : in STD_LOGIC_VECTOR(23 downto 0);
        aligned_mantissa_b : in STD_LOGIC_VECTOR(23 downto 0);
        result_sign : out STD_LOGIC
    );
end SignChooser;

architecture Behavioral of SignChooser is
begin
    process(sign_a, sign_b, aligned_mantissa_a, aligned_mantissa_b)
    begin
        if sign_a = sign_b then
            result_sign <= sign_a;
        else
            -- If signs differ, choose the sign of the larger aligned mantissa
            if aligned_mantissa_a > aligned_mantissa_b then
                result_sign <= sign_a;
            else
                result_sign <= sign_b;
            end if;
        end if;
    end process;
end Behavioral;
