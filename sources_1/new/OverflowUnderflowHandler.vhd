library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity OverflowUnderflowHandler is
    Port (
        normalized_exponent : in STD_LOGIC_VECTOR(7 downto 0);  
        result_sign         : in STD_LOGIC;                      
        normalized_mantissa : in STD_LOGIC_VECTOR(22 downto 0);   
        product             : out STD_LOGIC_VECTOR(31 downto 0);  
        overflow            : out STD_LOGIC;                      
        underflow           : out STD_LOGIC                      
    );
end OverflowUnderflowHandler;

architecture Behavioral of OverflowUnderflowHandler is
begin
    process(normalized_exponent, normalized_mantissa, result_sign)
    begin
        -- Default values
        overflow <= '0';
        underflow <= '0';
        product <= (others => '0');  -- Default to 0 for product

        -- Case for overflow (exponent = 255, which represents infinity)
        if (normalized_exponent = "11111111") then
            overflow <= '1';  
            product(31) <= result_sign;  -- Set the sign bit in the product
            product(30 downto 23) <= "11111111";  -- Set exponent to 255 for infinity
            product(22 downto 0) <= (others => '0');  -- Mantissa is zero for infinity

        -- Case for underflow (exponent = 0 and non-zero mantissa, indicating a denormalized number)
        elsif (normalized_exponent = "00000000") then
            -- subnormal
            if (normalized_mantissa /= "00000000000000000000000") then
                underflow <= '1';  
                product(31) <= result_sign;  -- Set the sign bit in the product
                product(30 downto 23) <= "00000000";  -- Set exponent to 0 for subnormal
                product(22 downto 0) <= normalized_mantissa;  -- Keep the mantissa unchanged (subnormal)
            else
                -- Zero case (exponent = 0 and mantissa = 0)
                product(31) <= result_sign;  -- Set the sign bit for zero
                product(30 downto 23) <= "00000000";  -- Set exponent to 0 for zero
                product(22 downto 0) <= "00000000000000000000000";  -- Mantissa is 0
            end if;

        -- Normal case (valid exponent between 1 and 254)
        else
            if (normalized_exponent > "11111110") then
                overflow <= '1';  
                product(31) <= result_sign;  
                product(30 downto 23) <= "11111111";  -- Set exponent to 255 for infinity
                product(22 downto 0) <= (others => '0');  -- Mantissa is zero for infinity
            elsif (normalized_exponent < "00000001") then
                underflow <= '1';  
                product(31) <= result_sign;  
                product(30 downto 23) <= "00000000";  -- Set exponent to 0 for zero or subnormal
                product(22 downto 0) <= normalized_mantissa;  -- Keep the mantissa unchanged (for subnormal)
            else
                -- Normal case, set the product with the exponent and mantissa
                product(31) <= result_sign;  
                product(30 downto 23) <= normalized_exponent;  
                product(22 downto 0) <= normalized_mantissa;  
            end if;
        end if;
        
        -- Final underflow condition for zero result
        if (normalized_exponent = "00000000" and normalized_mantissa = "00000000000000000000000") then
            underflow <= '1';
        end if;
    end process;
end Behavioral;