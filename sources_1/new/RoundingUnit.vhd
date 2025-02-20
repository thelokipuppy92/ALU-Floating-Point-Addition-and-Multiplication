library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity RoundingUnit is
    Port (
        normalized_mantissa : in STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit mantissa
        rounded_mantissa : out STD_LOGIC_VECTOR(22 downto 0);    -- 23-bit rounded mantissa
        rounding_overflow : out STD_LOGIC                        -- Overflow after rounding
    );
end RoundingUnit;

architecture Behavioral of RoundingUnit is
    signal incremented_mantissa : STD_LOGIC_VECTOR(24 downto 0);
begin
    process(normalized_mantissa)
    begin
        -- Round up if necessary (based on LSBs)
        if normalized_mantissa(0) = '1' then
            incremented_mantissa <= std_logic_vector(unsigned("0" & normalized_mantissa) + 1);
        else
            incremented_mantissa <= "0" & normalized_mantissa;
        end if;

        -- Set outputs
        rounded_mantissa <= incremented_mantissa(23 downto 1); -- Drop MSB after rounding
        rounding_overflow <= incremented_mantissa(24);         -- Detect overflow in rounding
    end process;
end Behavioral;
