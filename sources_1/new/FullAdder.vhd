 library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FullAdder is
        Port (
            A     : in STD_LOGIC;
            B     : in STD_LOGIC;
            Cin   : in STD_LOGIC;
            Sum   : out STD_LOGIC;
            Cout  : out STD_LOGIC
        );
    end FullAdder;

architecture FullAdder_Behavioral of FullAdder is
begin
    process(A, B, Cin)
    begin
        Sum  <= A XOR B XOR Cin;
        Cout <= (A AND B) OR (Cin AND (A XOR B));
    end process;
end FullAdder_Behavioral;