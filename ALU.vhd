library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Operation_Types.all;

entity ALU is
    port(
        x, y      : in  std_logic_vector(63 downto 0);  
        result    : out std_logic_vector(63 downto 0);
        operation : in  alu_operation;
        branch_taken : out std_logic 
    );
end entity;

architecture ALU_architecture of ALU is
begin
    process(operation, x, y)
    begin
        result <= (others => '0');
        branch_taken <= '0';
        
        case operation is
            when ALU_AND =>
                result <= x and y;
            when ALU_OR =>
                result <= x or y;
            when ALU_XOR =>
                result <= x xor y;
            when ALU_ADD =>
                result <= std_logic_vector(unsigned(x) + unsigned(y));
            when ALU_SUB =>
                result <= std_logic_vector(unsigned(x) - unsigned(y));
            when ALU_BEQ =>
                if x = y then
                    branch_taken <= '1';
                else
                    branch_taken <= '0';
                end if;
            when ALU_BNE =>
                if x /= y then
                    branch_taken <= '1';
                else
                    branch_taken <= '0';
                end if;
            when ALU_BLT =>
                if signed(x) < signed(y) then
                    branch_taken <= '1';
                else
                    branch_taken <= '0';
                end if;
            when ALU_BGE =>
                if signed(x) >= signed(y) then
                    branch_taken <= '1';
                else
                    branch_taken <= '0';
                end if;
            when ALU_BLTU =>
                if unsigned(x) < unsigned(y) then
                    branch_taken <= '1';
                else
                    branch_taken <= '0';
                end if;
            when ALU_BGEU =>
                if unsigned(x) >= unsigned(y) then
                    branch_taken <= '1';
                else
                    branch_taken <= '0';
                end if;
            when ALU_PASS =>
                result <= x;  
        end case;
    end process;
end architecture;
