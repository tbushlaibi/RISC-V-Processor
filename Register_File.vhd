library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Register_File is
    port (
        clk    : in std_logic;
        wr_en    : in std_logic;
        rs1    : in std_logic_vector(4 downto 0);
        rs2    : in std_logic_vector(4 downto 0);
        rd        : in std_logic_vector(4 downto 0);
        wr_data    : in std_logic_vector(63 downto 0);
        data_1    : out std_logic_vector(63 downto 0);
        data_2    : out std_logic_vector(63 downto 0)
        );
end entity;

architecture Register_File_architecture of Register_File is

    type regfile_32x64 is array(0 to 31) of std_logic_vector(63 downto 0);
    signal registers : regfile_32x64 := (
    0  => x"0000000000000000",  -- x0 
    1  => x"0000000000000001",  -- x1
    2  => x"0000000000000002",  -- x2
    3  => x"0000000000000003",  -- x3
    4  => x"0000000000000004",  -- x4
    5  => x"0000000000000005",  -- x5
    6  => x"0000000000001000",  -- x6 
    7  => x"0000000000002000",  -- x7 
    8  => x"0000000000000008",  -- x8
    9  => x"0000000000000009",  -- x9
    10 => x"000000000000000A",  -- x10
    11 => x"000000000000000B",  -- x11
    12 => x"00000000000000C0",  -- x12 
    13 => x"0000000000000D00",  -- x13 
    14 => x"000000000000E000",  -- x14 
    15 => x"00000000000000F0",  -- x15 

    others => (others => '0')
);

    
begin

    data_1 <= registers(to_integer(unsigned(rs1)));
    data_2 <= registers(to_integer(unsigned(rs2)));
    
    process(clk, wr_en)
    begin
        if rising_edge(clk) then
            if (wr_en='1' AND rd/="00000") then
                registers(to_integer(unsigned(rd))) <= wr_data;
            end if;
        end if;
    end process;
end architecture;
