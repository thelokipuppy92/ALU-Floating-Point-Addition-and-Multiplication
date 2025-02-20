library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MantissaMultiplier is
    Port (
        mantissa_a : in STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit input A
        mantissa_b : in STD_LOGIC_VECTOR(23 downto 0);  -- 24-bit input B
        product    : out STD_LOGIC_VECTOR(47 downto 0)  -- 48-bit output product
    );
end entity;

architecture rtl of MantissaMultiplier is
    -- Signals to hold the partial products for each row of the matrix
    type partial_product_array is array (0 to 23) of STD_LOGIC_VECTOR(47 downto 0);
    signal partial_products : partial_product_array;

    -- Intermediate signals for sum and carry vectors in CSA stages
    signal sum_stage, carry_stage : partial_product_array;

    -- Final sum and carry signals (48-bit wide)
    signal final_sum, final_carry : STD_LOGIC_VECTOR(47 downto 0);

    -- Carry-save adder component declaration for 24-bit inputs and outputs
    component CarrySaveAdder
        Port (
            A    : in STD_LOGIC_VECTOR(23 downto 0);
            B    : in STD_LOGIC_VECTOR(23 downto 0);
            Cin  : in STD_LOGIC_VECTOR(23 downto 0);
            Sum  : out STD_LOGIC_VECTOR(23 downto 0);
            Cout : out STD_LOGIC_VECTOR(23 downto 0)
        );
    end component;

    -- Intermediate signals for partial addition results (each 24-bits wide)
    signal sum_24bit, carry_24bit : STD_LOGIC_VECTOR(23 downto 0);

begin
    -- Generate partial products using AND operation between mantissa_a and mantissa_b
    process(mantissa_a, mantissa_b)
    begin
        -- Initialize all partial products to zero
        for i in 0 to 23 loop
            partial_products(i) <= (others => '0');
        end loop;

        -- Generate the partial products
        for i in 0 to 23 loop
            for j in 0 to 23 loop
                -- Shift the AND result to the correct position
                partial_products(i)(i + j) <= mantissa_a(i) and mantissa_b(j);
            end loop;
        end loop;
    end process;

    -- Use Carry-Save Adders to sum the partial products
    CSA_1: CarrySaveAdder
        port map (
            A    => partial_products(0)(23 downto 0),
            B    => partial_products(1)(23 downto 0),
            Cin  => partial_products(2)(23 downto 0),
            Sum  => sum_24bit,
            Cout => carry_24bit
        );

    -- The sum and carry are then combined to form the final 48-bit product
    product <= sum_24bit & carry_24bit;

end architecture;

