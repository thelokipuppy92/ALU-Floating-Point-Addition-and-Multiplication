library ieee;
use ieee.std_logic_1164.all;

entity ZeroSubtractor is
    port (
        A       : in std_logic;          
        Bin     : in std_logic;          -- Borrow in from previous stage
        Diff    : out std_logic;         
        Bout    : out std_logic          -- Borrow out to next stage
    );
end entity;

architecture rtl of ZeroSubtractor is
begin
    Diff <= A xor Bin;
    Bout <= (not A and Bin);
end architecture;
