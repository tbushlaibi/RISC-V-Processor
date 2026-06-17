library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Operation_Types.all;

entity Control_Unit is
    port (
        instruction : in std_logic_vector(31 downto 0);
        rs1_addr    : out std_logic_vector(4 downto 0);
        rs2_addr    : out std_logic_vector(4 downto 0);
        rd_addr     : out std_logic_vector(4 downto 0);
        immediate   : out std_logic_vector(63 downto 0);
        alu_op      : out ALU_Operation;
        alu_src     : out std_logic;
        reg_write   : out std_logic;
        mem_write   : out std_logic;
        mem_to_reg  : out std_logic;
        branch      : out std_logic;
        byte_en     : out std_logic_vector(2 downto 0)
    );
end entity;

architecture Control_Unit_architecture of Control_Unit is
    signal opcode    : std_logic_vector(6 downto 0);
    signal funct3    : std_logic_vector(2 downto 0);
    signal funct7    : std_logic_vector(6 downto 0);
    
begin
    opcode <= instruction(6 downto 0);
    funct3 <= instruction(14 downto 12);
    funct7 <= instruction(31 downto 25);
    rs1_addr <= instruction(19 downto 15);
    rs2_addr <= instruction(24 downto 20);
    rd_addr <= instruction(11 downto 7);
    
    process(instruction)
    begin
        case opcode is
            when "0010011" | "0000011" => -- I-type 
                if instruction(31) = '1' then
                    immediate <= X"FFFFFFFFFFFFF" & instruction(31 downto 20);
                else
                    immediate <= X"0000000000000" & instruction(31 downto 20);
                end if;
                
            when "0100011" => -- S-type 
                if instruction(31) = '1' then
                    immediate <= X"FFFFFFFFFFFFF" & instruction(31 downto 25) & instruction(11 downto 7);
                else
                    immediate <= X"0000000000000" & instruction(31 downto 25) & instruction(11 downto 7);
                end if;
                
            when "1100011" => -- SB-type 
                if instruction(31) = '1' then
                    immediate <= X"FFFFFFFFFFFFF" & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
                else
                    immediate <= X"0000000000000" & instruction(7) & instruction(30 downto 25) & instruction(11 downto 8) & '0';
                end if;
                
            when others =>
                immediate <= (others => '0');
        end case;
    end process;
    
    process(opcode, funct3, funct7)
    begin
        alu_op <= ALU_ADD;
        alu_src <= '0';
        reg_write <= '0';
        mem_write <= '0';
        mem_to_reg <= '0';
        branch <= '0';
        byte_en <= MEM_ACCESS_DOUBLEWORD;  
        
        case opcode is
            when "0110011" => -- R-type instructions
                reg_write <= '1';
                alu_src <= '0';
                case funct3 is
                    when "000" => 
                        if funct7 = "0000000" then
                            alu_op <= ALU_ADD; 			-- add
                        else
                            alu_op <= ALU_SUB;  		-- sub
                        end if;
                    when "100" => alu_op <= ALU_XOR;  -- xor
                    when "110" => alu_op <= ALU_OR;  	-- or
                    when "111" => alu_op <= ALU_AND;  -- and
                    when others => reg_write <= '0';
                end case;
                
            when "0010011" => -- I-type arithmetic
                reg_write <= '1';
                alu_src <= '1';
                case funct3 is
                    when "000" => alu_op <= ALU_ADD;  -- addi
                    when "100" => alu_op <= ALU_XOR;  -- xori
                    when "110" => alu_op <= ALU_OR;   -- ori
                    when "111" => alu_op <= ALU_AND;  -- andi
                    when others => reg_write <= '0';
                end case;
                
            when "0000011" => -- Load instructions
                reg_write <= '1';
                alu_src <= '1';
                alu_op <= ALU_ADD; 
                mem_to_reg <= '1';
                case funct3 is
                    when "000" => byte_en <= MEM_ACCESS_BYTE;       -- lb
                    when "001" => byte_en <= MEM_ACCESS_HALFWORD;   -- lh
                    when "010" => byte_en <= MEM_ACCESS_WORD;       -- lw
                    when "011" => byte_en <= MEM_ACCESS_DOUBLEWORD; -- ld
                    when others => reg_write <= '0';
                end case;
                
            when "0100011" => -- Store instructions
                mem_write <= '1';
                alu_src <= '1';
                alu_op <= ALU_ADD;  
                case funct3 is
                    when "000" => byte_en <= MEM_ACCESS_BYTE;       -- sb
                    when "001" => byte_en <= MEM_ACCESS_HALFWORD;   -- sh
                    when "010" => byte_en <= MEM_ACCESS_WORD;       -- sw
                    when "011" => byte_en <= MEM_ACCESS_DOUBLEWORD; -- sd
                    when others => mem_write <= '0';
                end case;
                
            when "1100011" => -- Branch instructions
                branch <= '1';
                alu_src <= '0';
                case funct3 is
                    when "000" => alu_op <= ALU_BEQ;   -- beq
                    when "001" => alu_op <= ALU_BNE;   -- bne
                    when "100" => alu_op <= ALU_BLT;   -- blt
                    when "101" => alu_op <= ALU_BGE;   -- bge
                    when "110" => alu_op <= ALU_BLTU;  -- bltu
                    when "111" => alu_op <= ALU_BGEU;  -- bgeu
                    when others => branch <= '0';
                end case;
                
            when others =>
                null;
        end case;
    end process;
    
end architecture;
