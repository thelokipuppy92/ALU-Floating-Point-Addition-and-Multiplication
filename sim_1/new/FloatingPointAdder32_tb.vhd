library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.STD_LOGIC_ARITH.ALL;
use IEEE.STD_LOGIC_UNSIGNED.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FloatingPointAdder32_tb is
end FloatingPointAdder32_tb;

architecture Behavioral of FloatingPointAdder32_tb is

    signal a, b : STD_LOGIC_VECTOR(31 downto 0); 
    signal c : STD_LOGIC_VECTOR(31 downto 0);   

    component FloatingPointAdder32
        Port (
            a : in STD_LOGIC_VECTOR(31 downto 0);
            b : in STD_LOGIC_VECTOR(31 downto 0);
            c : out STD_LOGIC_VECTOR(31 downto 0)
        );
    end component;

begin

    uut: FloatingPointAdder32
        Port Map (
            a => a,
            b => b,
            c => c
        );

    process
    begin
      
       -- Test Case 0: 2.75 + 3.25 (Expected output: 6.0=40c00000)
        a <= X"40300000";  
        b <= X"40500000";  
        wait for 10 ns;
        
         -- Test Case 1: 1.0 + 1.0 (Expected output: 2.0=4000000)
        a <= X"3F800000";  -- 1 
        b <= X"3F800000";  -- 1
        wait for 10 ns;

        -- Test Case 5: 1.5 + 2.5 (Expected output: 4.0=40800000)
        a <= X"3FC00000";  -- 1.5 
        b <= X"40200000";  -- 2.5 
        wait for 10 ns;
    
        -- Test Case 6: 10.0 + 5.0 (Expected output: 15.0=4170000)
        a <= X"41200000";  -- 10.0 
        b <= X"40A00000";  -- 5.0 
        wait for 10 ns;
    
        -- Test Case 7: 0.75 + 0.5 (Expected output: 1.25=3fa00000)
        a <= X"3F400000";  -- 0.75 
        b <= X"3F000000";  -- 0.5 
        wait for 10 ns;
        
        -- Test Case 7: 0.75 + 0.5 (Expected output: 1.25=3fa00000)
        a <= X"7F800000";  -- 0.75 
        b <= X"7F800000";  -- 0.5 
        wait for 10 ns;
        
        -- Test Case 7: 0.75 + 0.5 (Expected output: 1.25=3fa00000)
        a <= X"7f7fffff";  -- 0.75 
        b <= X"7f7fffff";  -- 0.5 
        wait for 10 ns;
        
        -- Test Case 7: 0.75 + 0.5 (Expected output: 2.484.7=451B4B33)
        a <= X"44FE5000";  -- 2034.5 
        b <= X"43E1199A";  -- 450.2
        wait for 10 ns;
        
        
       
        wait;
    end process;

end Behavioral;
