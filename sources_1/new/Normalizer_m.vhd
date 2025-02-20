library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity normalizer_2 is
    port (
        intermediate_product : in STD_LOGIC_VECTOR(47 downto 0);  
        intermediate_exponent : in STD_LOGIC_VECTOR(8 downto 0);  
        normalized_mantissa : out STD_LOGIC_VECTOR(22 downto 0);  
        normalized_exponent : out STD_LOGIC_VECTOR(7 downto 0)    
    );
end entity;

architecture rtl of normalizer_2 is
begin
    process(intermediate_product, intermediate_exponent)
    variable temp_exponent : unsigned(8 downto 0);  -- Temporary variable for exponent manipulation
begin
    -- Check for underflow: Exponent is less than 0
    if signed(intermediate_exponent) < 0 then
        -- Too small to represent even as subnormal
        normalized_mantissa <= (others => '0');  -- Zero mantissa
        normalized_exponent <= (others => '0');  -- Zero exponent
    else
        if intermediate_product(47) = '1' then
            -- Leading 1 is at bit 47, shift right and increment exponent
            normalized_mantissa <= intermediate_product(46 downto 24);  -- Select bits 46 to 24
            
            -- Increment exponent and convert back to std_logic_vector, then slice it to 8 bits
            temp_exponent := unsigned(intermediate_exponent) + 1;
            normalized_exponent <= std_logic_vector(temp_exponent(7 downto 0));  -- Take only the lower 8 bits of the incremented exponent
        else
            -- Leading 1 is at bit 46, no shift needed
            normalized_mantissa <= intermediate_product(45 downto 23);  -- Select bits 45 to 23
            normalized_exponent <= intermediate_exponent(7 downto 0);  -- No change to exponent
        end if;
    end if;
end process;
end architecture;

