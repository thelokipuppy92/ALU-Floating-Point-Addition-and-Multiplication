library ieee;
use ieee.std_logic_1164.all;

entity CarrySaveAdder is
    port (
        A      : in std_logic_vector(23 downto 0);  -- First operand
        B      : in std_logic_vector(23 downto 0);  -- Second operand
        Cin    : in std_logic_vector(23 downto 0);  -- Carry input from previous stage
        Sum    : out std_logic_vector(23 downto 0); -- Sum output
        Cout   : out std_logic_vector(23 downto 0)  -- Carry output
    );
end entity;

architecture rtl of CarrySaveAdder is
begin
    process(A, B, Cin)
    begin
        for i in 0 to 23 loop
            Sum(i) <= A(i) xor B(i) xor Cin(i);
            Cout(i) <= (A(i) and B(i)) or (Cin(i) and (A(i) xor B(i)));
        end loop;
    end process;
end architecture;
