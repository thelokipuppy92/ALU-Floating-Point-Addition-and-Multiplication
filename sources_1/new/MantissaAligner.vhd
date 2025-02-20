library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MantissaAligner is
    Port (
        mantissa_a : in STD_LOGIC_VECTOR(23 downto 0);          
        mantissa_b : in STD_LOGIC_VECTOR(23 downto 0);          
        exponent_diff : in INTEGER;                            
        shift_mantissa_a : in BOOLEAN;                          
        shift_mantissa_b : in BOOLEAN;                          
        aligned_mantissa_a : out STD_LOGIC_VECTOR(23 downto 0); -- Aligned mantissa A (24 bits)
        aligned_mantissa_b : out STD_LOGIC_VECTOR(23 downto 0)  -- Aligned mantissa B (24 bits)
    );
end MantissaAligner;

architecture Behavioral of MantissaAligner is
begin
    process(mantissa_a, mantissa_b, exponent_diff, shift_mantissa_a, shift_mantissa_b)
        variable temp_mantissa_a : STD_LOGIC_VECTOR(23 downto 0);
        variable temp_mantissa_b : STD_LOGIC_VECTOR(23 downto 0);
        variable abs_exponent_diff : INTEGER;
    begin
        abs_exponent_diff := abs(exponent_diff);

        -- temporary mantissas
        temp_mantissa_a := mantissa_a;
        temp_mantissa_b := mantissa_b;

        if shift_mantissa_a = true then
            -- Shift mantissa_a to the right by exponent_diff using shift_right function
            -- Convert mantissa_a to unsigned, perform shift, and convert back to std_logic_vector
            temp_mantissa_a := std_logic_vector(shift_right(unsigned(mantissa_a), abs_exponent_diff));
            aligned_mantissa_a <= temp_mantissa_a;
            aligned_mantissa_b <= mantissa_b;

        elsif shift_mantissa_b = true then
            temp_mantissa_b := std_logic_vector(shift_right(unsigned(mantissa_b), abs_exponent_diff));
            aligned_mantissa_a <= mantissa_a;
            aligned_mantissa_b <= temp_mantissa_b;

        else
            -- No shift needed if exponents are equal
            aligned_mantissa_a <= mantissa_a;
            aligned_mantissa_b <= mantissa_b;
        end if;
    end process;
end Behavioral;
