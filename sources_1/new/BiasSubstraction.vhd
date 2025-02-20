library ieee;
use ieee.std_logic_1164.all;

entity BiasSubtraction is
    port (
        A          : in std_logic_vector(8 downto 0);  
        Difference : out std_logic_vector(8 downto 0)  
    );
end entity;

architecture rtl of BiasSubtraction is
    signal borrow : std_logic_vector(7 downto 0);  -- Intermediate borrow signals
begin
    -- Instantiate One Subtractors (OS) for bits 0 to 6
    OS0: entity work.OneSubtractor
        port map (A => A(0), Bin => '0', Diff => Difference(0), Bout => borrow(0));
        
    OS1: entity work.OneSubtractor
        port map (A => A(1), Bin => borrow(0), Diff => Difference(1), Bout => borrow(1));
        
    OS2: entity work.OneSubtractor
        port map (A => A(2), Bin => borrow(1), Diff => Difference(2), Bout => borrow(2));
        
    OS3: entity work.OneSubtractor
        port map (A => A(3), Bin => borrow(2), Diff => Difference(3), Bout => borrow(3));
        
    OS4: entity work.OneSubtractor
        port map (A => A(4), Bin => borrow(3), Diff => Difference(4), Bout => borrow(4));
        
    OS5: entity work.OneSubtractor
        port map (A => A(5), Bin => borrow(4), Diff => Difference(5), Bout => borrow(5));
        
    OS6: entity work.OneSubtractor
        port map (A => A(6), Bin => borrow(5), Diff => Difference(6), Bout => borrow(6));

    -- Instantiate Zero Subtractors (ZS) for bits 7 and 8
    ZS7: entity work.ZeroSubtractor
        port map (A => A(7), Bin => borrow(6), Diff => Difference(7), Bout => borrow(7));
        
    ZS8: entity work.ZeroSubtractor
        port map (A => A(8), Bin => borrow(7), Diff => Difference(8), Bout => open);  -- Final borrow out not needed
end architecture;


