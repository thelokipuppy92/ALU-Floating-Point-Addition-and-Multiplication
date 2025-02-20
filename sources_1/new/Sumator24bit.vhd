library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Sumator24bit is
    Port (
        a : in std_logic_vector(23 downto 0);
        b : in std_logic_vector(23 downto 0);
        r : out std_logic_vector(24 downto 0)
    );
end Sumator24bit;

architecture Behavioral of Sumator24bit is
    signal c : std_logic_vector(24 downto 0);  -- Carry signal
begin

    -- Initial carry is '0'
    c(0) <= '0';

    -- Generate sum and carry using a loop for 24 bits
    gen_sum : for i in 0 to 23 generate
        r(i) <= a(i) xor b(i) xor c(i);  -- Sum 

        -- Carry computation: 
        c(i+1) <= (a(i) and b(i)) or (a(i) and c(i)) or (b(i) and c(i)); 
    end generate;

    -- Final carry out
    r(24) <= c(24);  -- Last carry bit

end Behavioral;
