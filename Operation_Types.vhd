library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

package Operation_Types is
    type ALU_Operation is (
            ALU_AND,    -- AND operation
            ALU_OR,     -- OR operation  
            ALU_XOR,    -- XOR operation
            ALU_ADD,    -- ADD operation
            ALU_SUB,    -- SUB operation
            ALU_BEQ,    -- Branch Equal
            ALU_BNE,    -- Branch Not Equal
            ALU_BLT,    -- Branch Less Than (signed)
            ALU_BGE,    -- Branch Greater/Equal (signed)
            ALU_BLTU,   -- Branch Less Than (unsigned)
            ALU_BGEU,   -- Branch Greater/Equal (unsigned)
            ALU_PASS    -- For load & store
    );
     
        constant MEM_ACCESS_BYTE       : std_logic_vector(2 downto 0) := "000";
        constant MEM_ACCESS_HALFWORD   : std_logic_vector(2 downto 0) := "001";
        constant MEM_ACCESS_WORD       : std_logic_vector(2 downto 0) := "010";
        constant MEM_ACCESS_DOUBLEWORD : std_logic_vector(2 downto 0) := "100";
     
end package;
