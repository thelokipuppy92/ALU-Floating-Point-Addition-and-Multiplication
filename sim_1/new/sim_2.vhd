library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FloatingPointMultiplier32_tb is
end FloatingPointMultiplier32_tb;

architecture behavior of FloatingPointMultiplier32_tb is

    component FloatingPointMultiplier32 is
        Port (
            a : in STD_LOGIC_VECTOR(31 downto 0);      
            b : in STD_LOGIC_VECTOR(31 downto 0);      
            product : out STD_LOGIC_VECTOR(31 downto 0); 
            overflow : out STD_LOGIC;                  
            underflow : out STD_LOGIC                  
        );
    end component;

    signal a, b : STD_LOGIC_VECTOR(31 downto 0);
    signal product : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow, underflow : STD_LOGIC;

begin

    -- Instantiate the Unit Under Test (UUT)
    uut: FloatingPointMultiplier32
        Port map (
            a => a,
            b => b,
            product => product,
            overflow => overflow,
            underflow => underflow
        );

    
    stimulus: process
    begin
    
        -- Test Case: Smallest normal number multiplied by a small subnormal
a <= x"00800000";  -- Smallest normal number (2^-126)
b <= x"00000001";  -- Smallest subnormal number
wait for 10 ns;
    
        -- Test Case 1: Multiplying 1.0 * 1.0 (Should be 1.0)
        a <= x"3F800000";  -- IEEE-754 representation of 1.0
        b <= x"3F800000";  -- IEEE-754 representation of 1.0
        wait for 10 ns;
        
        

        -- Test Case 2: Multiplying 2.5 * 3.1 (Should be 8) 4100000
        a <= x"40200000";  -- IEEE-754 representation of 2.5
        b <= x"404CCCCD";  -- IEEE-754 representation of 3.2
        wait for 10 ns;

        -- Test Case 5: Multiplying 2.0 * 3.0 (Should be 6) 40c00000
        a <= x"40000000";  -- IEEE-754 representation of 2.0
        b <= x"40400000";  -- IEEE-754 representation of 3.0
        wait for 10 ns;
        
        -- Test Case 5: Multiplying 7.5 * 3.0 (Should be 33.75) 42070000
        a <= x"40F00000";  -- IEEE-754 representation of 7.5
        b <= x"40900000";  -- IEEE-754 representation of 4.5
        wait for 10 ns;
        
        -- Overflow Test Case
        --a <= x"7F7FFFFF";  -- Maximum normal value (~3.4028235E38)
        --b <= x"40000000";  -- 2.0
        --wait for 10 ns;

       -- Test Case: Smallest subnormal number multiplied by 0 (should underflow to zero)
        a <= x"00000001";  -- Smallest subnormal number
        b <= x"00000000";  -- Zero
        wait for 10 ns;



-- Test Case: Two small subnormal numbers multiplied together
a <= x"00000001";  -- Smallest subnormal number
b <= x"00000002";  -- Second smallest subnormal number
wait for 10 ns;

        --a <= x"00800000";
        --b <= x"00000001";  -- Smallest subnormal
        --wait for 10 ns;
      
        -- End simulation
        wait;
    end process;

end behavior;
