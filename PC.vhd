library ieee;
use ieee.std_logic_1164.all;

entity PC is
    port (
  			      clk        : in std_logic;
  			      reset        : in std_logic;
       			 pc_next    : in std_logic_vector(63 downto 0);
       			 pc_value    : out std_logic_vector(63 downto 0)
  		      );
end entity;

architecture PC_architecture of PC is
    signal pc_reg : std_logic_vector(63 downto 0) := (others => '0');
begin
    process(clk)
    begin
        if rising_edge(clk) then
            if (reset='1') then
                pc_reg <= (others => '0');
            else
                pc_reg <= pc_next;
            end if;
        end if;
    end process;
    
    pc_value <= pc_reg;
end architecture;
