library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ADDER is
    port (
        A    : in std_logic_vector(63 downto 0);
        B    : in std_logic_vector(63 downto 0);
        Z    : out std_logic_vector(63 downto 0)
        );
end entity;

architecture ADDER_architecture of ADDER is
begin
    Z <= std_logic_vector(unsigned(A) + unsigned(B));
end architecture;
