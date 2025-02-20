library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity ExponentAddition is
    Port (
        exponent_a, exponent_b : in STD_LOGIC_VECTOR(7 downto 0);  
        Sum       : out STD_LOGIC_VECTOR(8 downto 0)  
    );
end ExponentAddition;

architecture rtl of ExponentAddition is
    signal carry : STD_LOGIC_VECTOR(7 downto 0);  
begin
    HA0: entity work.HalfAdder
        port map (
            A => exponent_a(0),   
            B => exponent_b(0),   
            Sum => Sum(0),      
            Cout => carry(0)      
        );

    FA1: entity work.FullAdder
        port map (
            A => exponent_a(1),   
            B => exponent_b(1),   
            Cin => carry(0),      
            Sum => Sum(1),        
            Cout => carry(1)      
        );

    FA2: entity work.FullAdder
        port map (
            A => exponent_a(2),   
            B => exponent_b(2),   
            Cin => carry(1),      
            Sum => Sum(2),        
            Cout => carry(2)      
        );

    FA3: entity work.FullAdder
        port map (
            A => exponent_a(3),   
            B => exponent_b(3),   
            Cin => carry(2),      
            Sum => Sum(3),        
            Cout => carry(3)      
        );

    FA4: entity work.FullAdder
        port map (
            A => exponent_a(4),   
            B => exponent_b(4),   
            Cin => carry(3),      
            Sum => Sum(4),        
            Cout => carry(4)      
        );

    FA5: entity work.FullAdder
        port map (
            A => exponent_a(5),   
            B => exponent_b(5),   
            Cin => carry(4),      
            Sum => Sum(5),        
            Cout => carry(5)      
        );

    FA6: entity work.FullAdder
        port map (
            A => exponent_a(6),   
            B => exponent_b(6),   
            Cin => carry(5),      
            Sum => Sum(6),        
            Cout => carry(6)      
        );

    FA7: entity work.FullAdder
        port map (
            A => exponent_a(7),   
            B => exponent_b(7),   
            Cin => carry(6),      
            Sum => Sum(7),        
            Cout => Sum(8)        
        );

end architecture;
