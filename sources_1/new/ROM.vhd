library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;  

entity ROM is
    Port (
        address : in STD_LOGIC_VECTOR(7 downto 0);  -- 8-bit address input, allows up to 256 entries
        data_out : out STD_LOGIC_VECTOR(31 downto 0)  -- 32-bit data output
    );
end ROM;

architecture Behavioral of ROM is
    -- Declare the ROM as an array of 32-bit values
    type rom_array is array (0 to 255) of STD_LOGIC_VECTOR(31 downto 0);
    
    -- ROM initialization 
    constant ROM_INIT : rom_array := (
        0 => x"3F800000",  -- 1.0 
        1 => x"40000000",  -- 2.0 
        2 => x"40400000",  -- 3.0 
        3 => x"3F000000",  -- 0.5 
        4 => x"41000000",  -- 8
        5 => x"40100000",   --2.25
        6 => x"40F00000",  --7.5
        7 => x"404CCCCD",  --3.2
        8 => x"7F7FFFFF", --maximum normal value (~3.4028235E38)
        9 => x"42260000", --41.5
        10 => x"41BD5C29", --23.67
        11 => x"42296666", --42.35
        12 => x"7f800000", -- plus infinit
        13 => x"44FE5000", --2034.5
        14 => x"43E1199A", --450.2
        15 => x"45AF299A", --5605.2
        16 => x"4557A8CD", --3450.55
        17 => x"00000001", --sub normal
        18 => x"00000000", --0
        19 => x"00000002", --sub normal
        20 => x"4557C6E1", --3452,43
        21 => x"45AAD266", --5466.3
        22 => x"4780615A", --65730.70
        23 => x"47AE79BB", --89331.461
        24 => x"C36A8000", --234.5
        25 => x"C28C0000", --70
        others => (others => '0')  
    );
    
begin
    process(address)
    begin
        data_out <= ROM_INIT(to_integer(unsigned(address)));
    end process;
end Behavioral;
