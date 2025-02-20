library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FPU_TopLevel_tb is
end FPU_TopLevel_tb;

architecture Behavioral of FPU_TopLevel_tb is

    -- Signals for FPU_TopLevel I/O
    signal address_a : STD_LOGIC_VECTOR(7 downto 0);
    signal address_b : STD_LOGIC_VECTOR(7 downto 0);
    signal op_select : STD_LOGIC;
    signal result : STD_LOGIC_VECTOR(31 downto 0);
    signal overflow : STD_LOGIC;
    signal underflow : STD_LOGIC;

begin
    -- Instantiate FPU_TopLevel
    DUT: entity work.FPU_TopLevel
        port map (
            address_a => address_a,
            address_b => address_b,
            op_select => op_select,
            result => result,
            overflow => overflow,
            underflow => underflow
        );

    -- Test Process
    stim_proc: process
    begin
    -- Test Case 14: Mul (op_select = '1') result:460b5aeb
        address_a <= "00010100";  -- Address 20 in ROM number: 3452.43
        address_b <= "00010101";  -- Address 21 in ROM number: subnormal 5466.3
        op_select <= '0';         -- Select mul
        wait for 10 ns;
        
         -- Test Case 14: Mul (op_select = '1') result:4b8ffb68
        address_a <= "00010100";  -- Address 20 in ROM number: 3452.43
        address_b <= "00010101";  -- Address 21 in ROM number: subnormal 5466.3
        op_select <= '1';         -- Select mul
        wait for 10 ns;
    
    
        -- Test Case 1: Addition (op_select = '0') result: 3: 40400000
        address_a <= "00000000";  -- Address 0 in ROM number:1
        address_b <= "00000001";  -- Address 1 in ROM number: 2
        op_select <= '0';         -- Select addition
        wait for 10 ns;
        
        
        -- Test Case 2: Addition (op_select = '0') result: 10,7: 412B3333
        address_a <= "00000110";  -- Address 6 in ROM number:7.5
        address_b <= "00000111";  -- Address 7 in ROM number: 3.2
        op_select <= '0';         -- Select addition
        wait for 10 ns;
        
        
        
          -- Test Case 3: Multiplication (op_select = '1') result: 24 41C00000
        address_a <= "00000110";  -- Address 6 in ROM number:7.5
        address_b <= "00000111";  -- Address 7 in ROM number: 3.2
        op_select <= '1';         -- Select mul
        wait for 10 ns;
        
        -- Test Case 12: Mul (op_select = '1') result: 0000000
        --address_a <= "00010001";  -- Address 17 in ROM number:subnormal
        --address_b <= "00010010";  -- Address 18 in ROM number: 0
        --op_select <= '1';         -- Select mul
        --wait for 10 ns;
        
         -- Test Case 4: Addition (op_select = '0') result: 2.75 40300000
        address_a <= "00000011";  -- Address 3 in ROM number:0.5
        address_b <= "00000101";  -- Address 5 in ROM number: 2.25
        op_select <= '0';         -- Select addition
        wait for 10 ns;

        -- Test Case 5: Multiplication (op_select = '1') result: 1,125 3F900000
        address_a <= "00000011";  -- Address 3 in ROM number:0.5
        address_b <= "00000101";  -- Address 5 in ROM number: 2.25
        op_select <= '1';         -- Select mul
        wait for 10 ns;
        
         -- Test Case 6: Multiplication (op_select = '1') result: overflow, 7f80000
        address_a <= "00000001";  -- Address 1 in ROM number:2
        address_b <= "00001000";  -- Address 8 in ROM number: max value
        op_select <= '1';         -- Select mul
        wait for 10 ns; 
        
         -- Test Case 7: Multiplication (op_select = '1') result: 44759385 982.305
        address_a <= "00001001";  -- Address 9 in ROM number:41.5
        address_b <= "00001010";  -- Address 10 in ROM number: 23.67
        op_select <= '1';         -- Select mul
        wait for 10 ns;
        
        -- Test Case 8: Multiplication (op_select = '1') result: 447A9B2A 1002,4245
        address_a <= "00001011";  -- Address 9 in ROM number:42,35
        address_b <= "00001010";  -- Address 10 in ROM number: 23.67
        op_select <= '1';         -- Select mul
        wait for 10 ns;
        
       
        -- Test Case 9: Addition (op_select = '0') result: 7f80000
        address_a <= "00001100";  -- Address 6 in ROM number:7f80000
        address_b <= "00001100";  -- Address 7 in ROM number: 7f80000
        op_select <= '0';         -- Select addition
        wait for 10 ns;
        
        -- Test Case 10: Addition (op_select = '0') result: 2.484.7=451B4B33
        address_a <= "00001101";  -- Address 6 in ROM number:2034.5
        address_b <= "00001110";  -- Address 7 in ROM number: 450.2
        op_select <= '0';         -- Select addition
        wait for 10 ns; 
        
        -- Test Case 11: Addition (op_select = '0') result: 9055.75==460D7F00
        address_a <= "00001111";  -- Address 15 in ROM number:5605.2
        address_b <= "00010000";  -- Address 16 in ROM number: 3450.55
        op_select <= '0';         -- Select addition
        wait for 10 ns; 
        
         
        -- Test Case 12: Mul (op_select = '1') result:000000 underflow
        address_a <= "00010001";  -- Address 17 in ROM number:subnormal
        address_b <= "00010011";  -- Address 19 in ROM number: subnormal 2
        op_select <= '1';         -- Select mul
        wait for 10 ns;
        
        -- Test Case 13: Mul (op_select = '1') result: 4AD63CE0
        address_a <= "00001101";  -- Address 13 in ROM number: 2034.5
        address_b <= "00010000";  -- Address 16 in ROM number: subnormal 3450.55
        op_select <= '1';         -- Select mul
        wait for 10 ns;
        
        -- Test Case 17: Mul (op_select = '0') 155062.16 result: 48176D8A 
        address_a <= "00010111";  -- Address 23 in ROM number: 89331.461
        address_b <= "00010110";  -- Address 22 in ROM number: 65730.70
        op_select <= '0';         -- Select mul
        wait for 10 ns;
        
        -- Test Case 17: Mul (op_select = '1') result: 4FAEFE6D
        address_a <= "00010111";  -- Address 23 in ROM number: 89331.461
        address_b <= "00010110";  -- Address 22 in ROM number: 65730.70
        op_select <= '1';         -- Select mul
        wait for 10 ns;
        
        -- Test Case 17: Mul (op_select = '0') result: C3984000
        address_a <= "00011000";  -- Address 24 in ROM number: -234.5
        address_b <= "00011001";  -- Address 25 in ROM number: -70
        op_select <= '0';         -- Select mul
        wait for 10 ns;
        
        -- Test Case 17: Mul (op_select = '1') result: 46803E00
        address_a <= "00011000";  -- Address 24 in ROM number: -234.5
        address_b <= "00011001";  -- Address 25 in ROM number: -70
        op_select <= '1';         -- Select mul
        wait for 10 ns;
        
        
        -- Add more test cases if necessary...

        -- Finish simulation
        wait;
    end process;

end Behavioral;
