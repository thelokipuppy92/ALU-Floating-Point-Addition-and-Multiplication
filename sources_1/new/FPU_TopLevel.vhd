library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FPU_TopLevel is
    Port (
        address_a : in STD_LOGIC_VECTOR(7 downto 0);  
        address_b : in STD_LOGIC_VECTOR(7 downto 0);  
        op_select : in STD_LOGIC;                     
        result : out STD_LOGIC_VECTOR(31 downto 0);   
        overflow : out STD_LOGIC;                     
        underflow : out STD_LOGIC                     
    );
end FPU_TopLevel;

architecture Structural of FPU_TopLevel is

    -- Internal Signals
    signal a, b : STD_LOGIC_VECTOR(31 downto 0);       
    signal rom_data_a, rom_data_b : STD_LOGIC_VECTOR(31 downto 0);  
    signal product : STD_LOGIC_VECTOR(31 downto 0);    
    signal sum : STD_LOGIC_VECTOR(31 downto 0);        
    signal overflow_flag, underflow_flag : STD_LOGIC;  

    -- Component Declarations for ROM and operations
    component ROM is
        Port (
            address : in STD_LOGIC_VECTOR(7 downto 0);  
            data_out : out STD_LOGIC_VECTOR(31 downto 0) 
        );
    end component;

    component FloatingPointMultiplier32 is
        Port (
            a : in STD_LOGIC_VECTOR(31 downto 0);       
            b : in STD_LOGIC_VECTOR(31 downto 0);       
            product : out STD_LOGIC_VECTOR(31 downto 0);
            overflow : out STD_LOGIC;                   
            underflow : out STD_LOGIC                   
        );
    end component;

    component FloatingPointAdder32 is
        Port (
            a, b : in STD_LOGIC_VECTOR(31 downto 0);    
            c : out STD_LOGIC_VECTOR(31 downto 0)       
        );
    end component;

begin

    ROM_A : entity work.ROM
        port map (
            address => address_a,  
            data_out => rom_data_a  
        );

    ROM_B : entity work.ROM
        port map (
            address => address_b,  
            data_out => rom_data_b  
        );

    
    process(op_select, rom_data_a, rom_data_b)
    begin
        a <= rom_data_a;
        b <= rom_data_b;
    end process;

    FP_Multiplier : entity work.FloatingPointMultiplier32
        port map (
            a => a,
            b => b,
            product => product,
            overflow => overflow_flag,
            underflow => underflow_flag
        );

    FP_Adder : entity work.FloatingPointAdder32
        port map (
            a => a,
            b => b,
            c => sum
        );

    -- Select result based on operation
    process(op_select, product, sum)
    begin
        if op_select = '1' then
            result <= product;
            overflow <= overflow_flag;
            underflow <= underflow_flag;
        else
            result <= sum;
            overflow <= '0';  
            underflow <= '0';  
        end if;
    end process;

end Structural;
