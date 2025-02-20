library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;

entity CarrySaveAdder2 is
    Port ( 
        A    : in  STD_LOGIC_VECTOR(23 downto 0); -- First input (24 bits)
        B    : in  STD_LOGIC_VECTOR(23 downto 0); -- Second input (24 bits)
        Cin  : in  STD_LOGIC_VECTOR(23 downto 0); -- Third input (24 bits)
        Sum  : out STD_LOGIC_VECTOR(23 downto 0); -- Sum output (24 bits)
        Cout : out STD_LOGIC_VECTOR(23 downto 0)  -- Carry output (24 bits)
    );
end CarrySaveAdder2;
architecture Behavioral of CarrySaveAdder2 is
begin
    process (A, B, Cin)
    variable sum_temp : STD_LOGIC_VECTOR(23 downto 0);
    variable carry_temp : STD_LOGIC_VECTOR(23 downto 0);
    begin
        sum_temp := (others => '0');
        carry_temp := (others => '0');

        -- Perform carry-save addition
        for i in 0 to 23 loop
            sum_temp(i) := A(i) xor B(i) xor Cin(i);      -- Sum bit: XOR of the three inputs
            carry_temp(i) := (A(i) and B(i)) or (B(i) and Cin(i)) or (Cin(i) and A(i)); -- Carry bit
        end loop;

        -- Output the sum and carry
        Sum  <= sum_temp;
        Cout <= carry_temp;
    end process;
end Behavioral;
