library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ExponentComparator is
    Port (
        exponent_a, exponent_b : in STD_LOGIC_VECTOR(7 downto 0);
        larger_exponent, smaller_exponent : out STD_LOGIC_VECTOR(7 downto 0);
        exponent_diff : out INTEGER;
        shift_mantissa_a : out BOOLEAN;  -- Output signal indicating which mantissa to shift
        shift_mantissa_b : out BOOLEAN   
    );
end ExponentComparator;

architecture Behavioral of ExponentComparator is
begin
    process(exponent_a, exponent_b)
    begin
        if unsigned(exponent_a) > unsigned(exponent_b) then
            larger_exponent <= exponent_a;
            smaller_exponent <= exponent_b;
            exponent_diff <= to_integer(unsigned(exponent_a) - unsigned(exponent_b));
            shift_mantissa_a <= false;  
            shift_mantissa_b <= true;  
        else
            larger_exponent <= exponent_b;
            smaller_exponent <= exponent_a;
            exponent_diff <= to_integer(unsigned(exponent_b) - unsigned(exponent_a));
            shift_mantissa_a <= true;   
            shift_mantissa_b <= false;  
        end if;
    end process;
end Behavioral;
