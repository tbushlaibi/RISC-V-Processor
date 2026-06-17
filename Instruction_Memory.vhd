library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Instruction_Memory is
    port(
        address    : in std_logic_vector(63 downto 0);
        instr      : out std_logic_vector(31 downto 0)
        );
end entity;

architecture Instruction_Memory_architecture of Instruction_Memory is
    type ROM1024x32 is array (1023 downto 0) of std_logic_vector(31 downto 0);
    

    signal instr_mem : ROM1024x32 := (

        -- BASE INSTRUCTIONS
        0 => X"00038783",  -- ld x15, 0(x7)     
        1 => X"00F33423",  -- sd x15, 8(x6)      
        2 => X"004181B3",  -- add x3, x3, x4     
        3 => X"40418233",  -- sub x4, x3, x4     
        4 => X"0041F3B3",  -- and x7, x3, x4     
        5 => X"0041E2B3",  -- or x5, x3, x4     
        6 => X"02728863",  -- beq x5, x7, +16   
        

        -- OTHER INSTRUCTIONS 
        7 => X"00034603",  -- lb x12, 0(x6)
        8 => X"00036683",  -- lh x13, 0(x6)
        9 => X"00037703",  -- lw x14, 0(x6)
        10 => X"00C30023", -- sb x12, 0(x6)
        11 => X"00D31023", -- sh x13, 0(x6)
        12 => X"00E32023", -- sw x14, 0(x6)
        13 => X"0041C333", -- xor x6, x3, x4
        14 => X"01400193", -- addi x3, x0, 20
        15 => X"00108093", -- addi x1, x1, 1
        16 => X"00A36313", -- ori x6, x6, 10
        17 => X"00B37393", -- andi x7, x6, 11
        18 => X"00C34313", -- xori x6, x6, 12
        19 => X"02729663", -- bne x5, x7, +12
        20 => X"00724463", -- blt x4, x7, +8
        21 => X"00725663", -- bge x4, x7, +12
        22 => X"0272C863", -- bltu x5, x7, +16
        23 => X"0272D663", -- bgeu x5, x7, +12
        
        others => X"00000013"
    );
        
begin
process(address)
begin
    instr <= instr_mem(to_integer(unsigned(address(11 downto 2))));
end process;
end architecture;
