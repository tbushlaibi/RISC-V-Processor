library ieee;
use ieee.std_logic_1164.all;

entity MUX is
    port (
            IN0    : in std_logic_vector(63 downto 0);
            IN1    : in std_logic_vector(63 downto 0);
            sel    : in std_logic;
            Z    : out std_logic_vector(63 downto 0)
        );
end entity;

architecture MUX_architecture of MUX is
begin
    with sel select
        Z <= 
            IN0 when '0',
            IN1 when '1',
            (others => 'X') when others;
end architecture;
