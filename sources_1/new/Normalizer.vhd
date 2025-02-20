library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Normalizer is
    Port (
        sum_mantissa : in STD_LOGIC_VECTOR(24 downto 0);   
        larger_exponent : in STD_LOGIC_VECTOR(7 downto 0); 
        normalized_mantissa : out STD_LOGIC_VECTOR(23 downto 0); 
        normalized_exponent : out STD_LOGIC_VECTOR(7 downto 0); 
        -- Special case flags
        a_is_nan : in STD_LOGIC;
        b_is_nan : in STD_LOGIC;
        a_is_infinity : in STD_LOGIC;
        b_is_infinity : in STD_LOGIC;
        a_is_zero : in STD_LOGIC;
        b_is_zero : in STD_LOGIC
    );
end Normalizer;

architecture Behavioral of Normalizer is
begin
    process(sum_mantissa, larger_exponent, a_is_nan, b_is_nan, a_is_infinity, b_is_infinity, a_is_zero, b_is_zero)
    begin
        -- Check for NaN first
        if a_is_nan = '1' or b_is_nan = '1' then
            normalized_mantissa <= (others => '1');  -- Set to NaN
            normalized_exponent <= "11111111";  -- Exponent for NaN is all ones
        -- Check for infinity
        elsif a_is_infinity = '1' or b_is_infinity = '1' then
            normalized_mantissa <= (others => '0');  -- Mantissa for infinity is all zeros
            normalized_exponent <= "11111111";  -- Exponent for infinity is all ones
        -- Check for zero
        elsif a_is_zero = '1' or b_is_zero = '1' then
            normalized_mantissa <= (others => '0');  -- Zero mantissa is all zeros
            normalized_exponent <= "00000000";  -- Exponent for zero is all zeros
        else
            -- Normalization logic
            if sum_mantissa(24) = '1' then
                -- Shift right by 1 bit (drop the 25th bit) and increment the exponent
                normalized_mantissa <= sum_mantissa(24 downto 1);  -- Right shift mantissa
                normalized_exponent <= std_logic_vector(unsigned(larger_exponent) + 1);  -- Increment exponent (biased)
            else
                -- No shift needed, just truncate the extra bit
                normalized_mantissa <= sum_mantissa(23 downto 0);
                normalized_exponent <= larger_exponent;  -- Exponent stays the same
            end if;
        end if;
    end process;
end Behavioral;