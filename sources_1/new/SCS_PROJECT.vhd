library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity FloatingPointAdder32 is
    Port (
        a, b : in STD_LOGIC_VECTOR(31 downto 0); 
        c : out STD_LOGIC_VECTOR(31 downto 0)   
    );
end FloatingPointAdder32;

architecture Behavioral of FloatingPointAdder32 is

    component InputExtractor
        Port (
            a : in STD_LOGIC_VECTOR(31 downto 0);
            b : in STD_LOGIC_VECTOR(31 downto 0);
            sign_a : out STD_LOGIC;
            sign_b : out STD_LOGIC;
            exponent_a : out STD_LOGIC_VECTOR(7 downto 0);
            exponent_b : out STD_LOGIC_VECTOR(7 downto 0);
            mantissa_a : out STD_LOGIC_VECTOR(23 downto 0);
            mantissa_b : out STD_LOGIC_VECTOR(23 downto 0)
        );
    end component;

    component ExponentComparator
        Port (
            exponent_a : in STD_LOGIC_VECTOR(7 downto 0);
            exponent_b : in STD_LOGIC_VECTOR(7 downto 0);
            larger_exponent : out STD_LOGIC_VECTOR(7 downto 0);
            smaller_exponent : out STD_LOGIC_VECTOR(7 downto 0);
            exponent_diff : out INTEGER;
            shift_mantissa_a : out BOOLEAN;  
            shift_mantissa_b : out BOOLEAN 
        );
    end component;

    component MantissaAligner
        Port (
            mantissa_a : in STD_LOGIC_VECTOR(23 downto 0);
            mantissa_b : in STD_LOGIC_VECTOR(23 downto 0);
            exponent_diff : in INTEGER;
            shift_mantissa_a : in BOOLEAN;                          
            shift_mantissa_b : in BOOLEAN;
            aligned_mantissa_a : out STD_LOGIC_VECTOR(23 downto 0);
            aligned_mantissa_b : out STD_LOGIC_VECTOR(23 downto 0)
        );
    end component;

        component SignChooser is
    Port (
        sign_a : in STD_LOGIC;
        sign_b : in STD_LOGIC;
        aligned_mantissa_a : in STD_LOGIC_VECTOR(23 downto 0);
        aligned_mantissa_b : in STD_LOGIC_VECTOR(23 downto 0);
        result_sign : out STD_LOGIC
    );
end component;

    component MantissaAdder
        Port (
            aligned_mantissa_a : in STD_LOGIC_VECTOR(23 downto 0);
            aligned_mantissa_b : in STD_LOGIC_VECTOR(23 downto 0);
            sum_mantissa : out STD_LOGIC_VECTOR(24 downto 0)
        );
    end component;

    component Normalizer
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
    end component;

    component OutputPacker
        Port (
            result_sign : in STD_LOGIC;
            normalized_exponent : in STD_LOGIC_VECTOR(7 downto 0);
            normalized_mantissa : in STD_LOGIC_VECTOR(23 downto 0); 
            c : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

    signal sign_a, sign_b, result_sign : STD_LOGIC;
    signal exponent_a, exponent_b : STD_LOGIC_VECTOR(7 downto 0);
    signal mantissa_a, mantissa_b : STD_LOGIC_VECTOR(23 downto 0);
    signal larger_exponent, smaller_exponent : STD_LOGIC_VECTOR(7 downto 0);
    signal exponent_diff : INTEGER;
    signal aligned_mantissa_a, aligned_mantissa_b : STD_LOGIC_VECTOR(23 downto 0);
    signal sum_mantissa : STD_LOGIC_VECTOR(24 downto 0);
    signal normalized_mantissa : STD_LOGIC_VECTOR(23 downto 0);
    signal normalized_exponent : STD_LOGIC_VECTOR(7 downto 0);
    signal shift_mantissa_a :  BOOLEAN;                          
    signal shift_mantissa_b :  BOOLEAN;
    
    -- Internal signals for NaN, infinity, and zero detection
    signal a_is_nan, b_is_nan : STD_LOGIC;
    signal a_is_infinity, b_is_infinity : STD_LOGIC;
    signal a_is_zero, b_is_zero : STD_LOGIC;

begin

    InputInst : entity work.InputExtractor
        port map (
            a => a,
            b => b,
            sign_a => sign_a,
            sign_b => sign_b,
            exponent_a => exponent_a,
            exponent_b => exponent_b,
            mantissa_a => mantissa_a,
            mantissa_b => mantissa_b
        );
        
        -- Special case detection logic
    a_is_nan <= '1' when (exponent_a = "11111111" and mantissa_a(22 downto 0) /= "00000000000000000000000") else '0';
    b_is_nan <= '1' when (exponent_b = "11111111" and mantissa_b(22 downto 0) /= "00000000000000000000000") else '0';

    a_is_infinity <= '1' when (exponent_a = "11111111" and mantissa_a(22 downto 0) = "00000000000000000000000") else '0';
    b_is_infinity <= '1' when (exponent_b = "11111111" and mantissa_b(22 downto 0) = "00000000000000000000000") else '0';

    a_is_zero <= '1' when (exponent_a = "00000000" and mantissa_a(22 downto 0) = "00000000000000000000000") else '0';
    b_is_zero <= '1' when (exponent_b = "00000000" and mantissa_b(22 downto 0) = "00000000000000000000000") else '0';


    ExponentCompInst : entity work.ExponentComparator
        port map (
            exponent_a => exponent_a,
            exponent_b => exponent_b,
            larger_exponent => larger_exponent,
            smaller_exponent => smaller_exponent,
            exponent_diff => exponent_diff,
            shift_mantissa_a => shift_mantissa_a,
            shift_mantissa_b => shift_mantissa_b
        );

    MantissaAlignInst : entity work.MantissaAligner
        port map (
            mantissa_a => mantissa_a,
            mantissa_b => mantissa_b,
            exponent_diff => exponent_diff,
            shift_mantissa_a => shift_mantissa_a,                           
            shift_mantissa_b => shift_mantissa_b,
            aligned_mantissa_a => aligned_mantissa_a,
            aligned_mantissa_b => aligned_mantissa_b
        );
        
    SignChooserInst : entity work.SignChooser
        port map (
            sign_a => sign_a,
            sign_b => sign_b,
            aligned_mantissa_a => aligned_mantissa_a,
            aligned_mantissa_b => aligned_mantissa_b,
            result_sign => result_sign
        );

    MantissaAddInst : entity work.MantissaAdder
        port map (
            aligned_mantissa_a => aligned_mantissa_a,
            aligned_mantissa_b => aligned_mantissa_b,
            sum_mantissa => sum_mantissa
        );

    NormalizerInst : entity work.Normalizer
        port map (
            sum_mantissa => sum_mantissa,
            larger_exponent => larger_exponent,
            normalized_mantissa => normalized_mantissa,
            normalized_exponent => normalized_exponent,
            a_is_nan => a_is_nan,
            b_is_nan =>b_is_nan,
            a_is_infinity =>a_is_infinity,
            b_is_infinity =>b_is_infinity,
            a_is_zero =>a_is_zero,
            b_is_zero =>b_is_zero
        );

    OutputPackerInst : entity work.OutputPacker
        port map (
            result_sign => result_sign,
            normalized_exponent => normalized_exponent,
            normalized_mantissa => normalized_mantissa,
            c => c
        );

end Behavioral;