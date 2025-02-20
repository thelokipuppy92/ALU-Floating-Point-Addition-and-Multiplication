library ieee;
use ieee.std_logic_1164.all;

entity OneSubtractor is
    port (
        A       : in std_logic;          
        Bin     : in std_logic;          -- Borrow in from previous stage
        Diff    : out std_logic;         
        Bout    : out std_logic          -- Borrow out to next stage
    );
end entity;

architecture rtl of OneSubtractor is
begin
    Diff <= A xor '1' xor Bin;
    Bout <= (not A and '1') or (Bin and (not A or '1'));
end architecture;
