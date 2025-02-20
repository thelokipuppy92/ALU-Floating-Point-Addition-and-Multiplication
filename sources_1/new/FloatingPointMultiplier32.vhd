library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FloatingPointMultiplier32 is
    Port (
        a : in STD_LOGIC_VECTOR(31 downto 0);      
        b : in STD_LOGIC_VECTOR(31 downto 0);      
        product : out STD_LOGIC_VECTOR(31 downto 0); 
        overflow : out STD_LOGIC;                  
        underflow : out STD_LOGIC                  
    );
end FloatingPointMultiplier32;

architecture Structural of FloatingPointMultiplier32 is

    component InputExtractor is
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
    
    component SignCalculator is
        Port (
            sign_a : in STD_LOGIC;
            sign_b : in STD_LOGIC;
            result_sign : out STD_LOGIC
        );
    end component;

    component ExponentAddition is
        Port (
            exponent_a, exponent_b      : in STD_LOGIC_VECTOR(7 downto 0);
            Sum       : out STD_LOGIC_VECTOR(8 downto 0)  -- 9-bit result
        );
    end component;

    component BiasSubtraction is
        Port (
            A          : in STD_LOGIC_VECTOR(8 downto 0);  
            Difference : out STD_LOGIC_VECTOR(8 downto 0)  
        );
    end component;

    component Mantissa_Multiplier is
    Port (
        a,b:in std_logic_vector(23 downto 0);
        r: out std_logic_vector(47 downto 0)
    );
end component;
    

    component normalizer_2 is
        Port (
            intermediate_product : in STD_LOGIC_VECTOR(47 downto 0);
            intermediate_exponent : in STD_LOGIC_VECTOR(8 downto 0);
            normalized_mantissa : out STD_LOGIC_VECTOR(22 downto 0);
            normalized_exponent : out STD_LOGIC_VECTOR(7 downto 0)
        );
    end component;

    component OverflowUnderflowHandler is
        Port (
            normalized_exponent : in STD_LOGIC_VECTOR(7 downto 0);
            result_sign : in STD_LOGIC;
            normalized_mantissa : in STD_LOGIC_VECTOR(22 downto 0); 
            product : out STD_LOGIC_VECTOR(31 downto 0); 
            overflow : out STD_LOGIC;  
            underflow : out STD_LOGIC  
        );
    end component;

    --Signals
    signal sign_a, sign_b : STD_LOGIC;
    signal exponent_a, exponent_b : STD_LOGIC_VECTOR(7 downto 0);
    signal mantissa_a, mantissa_b : STD_LOGIC_VECTOR(23 downto 0);
    signal result_sign : STD_LOGIC;
    signal intermediate_exponent : STD_LOGIC_VECTOR(8 downto 0);
    signal intermediate_sum : STD_LOGIC_VECTOR(8 downto 0);
    signal intermediate_product : STD_LOGIC_VECTOR(47 downto 0);
    signal normalized_mantissa : STD_LOGIC_VECTOR(22 downto 0);
    signal normalized_exponent : STD_LOGIC_VECTOR(7 downto 0);
    signal overflow_flag, underflow_flag : STD_LOGIC;

begin
    InputExtractor1: entity work.InputExtractor
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

   
    SignCalculator1: entity work.SignCalculator
        port map (
            sign_a => sign_a,
            sign_b => sign_b,
            result_sign => result_sign
        );

    ExponentAddition1: entity work.ExponentAddition
        port map (
            exponent_a => exponent_a, 
            exponent_b => exponent_b, 
            Sum => intermediate_sum
        );

    BiasSubtraction1: entity work.BiasSubtraction
        port map (
            A => intermediate_sum,
            Difference => intermediate_exponent
        );

   MantissaM: entity work.Mantissa_Multiplier
    port map(
        a=> mantissa_a,
        b=>mantissa_b,
        r=>intermediate_product
        );

    Normalizer1: entity work.normalizer_2
        port map (
            intermediate_product => intermediate_product,
            intermediate_exponent => intermediate_exponent,
            normalized_mantissa => normalized_mantissa,
            normalized_exponent => normalized_exponent
        );

    OverflowUnderflowHandler1: entity work.OverflowUnderflowHandler
        port map (
            normalized_exponent => normalized_exponent,
            result_sign => result_sign,
            normalized_mantissa => normalized_mantissa,
            product => product,
            overflow => overflow_flag,
            underflow => underflow_flag
        );

    overflow <= overflow_flag;
    underflow <= underflow_flag;

end Structural;