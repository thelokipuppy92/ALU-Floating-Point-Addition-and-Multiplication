library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MantissaAdder is
    Port (
        aligned_mantissa_a : in STD_LOGIC_VECTOR(23 downto 0); -- 24-bit aligned mantissa 
        aligned_mantissa_b : in STD_LOGIC_VECTOR(23 downto 0); -- 24-bit aligned mantissa 
        sum_mantissa : out STD_LOGIC_VECTOR(24 downto 0)      -- 25-bit sum mantissa
    );
end MantissaAdder;

architecture Behavioral of MantissaAdder is

    component FullAdder is
        Port (
            A     : in STD_LOGIC;
            B     : in STD_LOGIC;
            Cin   : in STD_LOGIC;
            Sum   : out STD_LOGIC;
            Cout  : out STD_LOGIC
        );
    end component;

    signal carry : STD_LOGIC_VECTOR(23 downto 0);  
    signal sum : STD_LOGIC_VECTOR(24 downto 0);    

begin

    -- First bit addition (least significant bit)
    FullAdder_inst_0 : FullAdder
        Port map (
            A     => aligned_mantissa_a(0),
            B     => aligned_mantissa_b(0),
            Cin   => '0', -- No initial carry-in
            Sum   => sum(0),
            Cout  => carry(0)
        );

    -- Ripple Carry Adder for the sum of mantissas (for bits 1 to 22)
    gen_rca : for i in 1 to 22 generate
        FullAdder_inst : FullAdder
            Port map (
                A     => aligned_mantissa_a(i),
                B     => aligned_mantissa_b(i),
                Cin   => carry(i-1),  -- Carry-in from previous adder
                Sum   => sum(i),
                Cout  => carry(i)
            );
    end generate;

    -- Final bit addition for the 23rd bit (most significant bit)
    FullAdder_inst_23 : FullAdder
        Port map (
            A     => aligned_mantissa_a(23),  -- Last bit of A
            B     => aligned_mantissa_b(23),  -- Last bit of B
            Cin   => carry(22),  -- Carry-in from previous adder
            Sum   => sum(23),    -- Last bit of the sum
            Cout  => sum(24)     -- Final carry-out, indicating overflow
        );

    sum_mantissa <= sum;  -- 25-bit result

end Behavioral;