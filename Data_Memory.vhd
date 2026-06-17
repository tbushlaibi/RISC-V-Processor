library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
use work.Operation_Types.all;

entity Data_Memory is
    port (
        clk      : in std_logic;
        wr_en    : in std_logic;
        byte_en  : in std_logic_vector(2 downto 0); 
        address  : in std_logic_vector(63 downto 0);
        wr_data  : in std_logic_vector(63 downto 0);
        re_data  : out std_logic_vector(63 downto 0)
    );
end entity;

architecture Data_Memory_architecture of Data_Memory is

    type RAM_64x8 is array (63 downto 0) of std_logic_vector(7 downto 0);
    signal data_mem : RAM_64x8 := (
    0  => x"11",
    1  => x"22",
    2  => x"33",
    3  => x"44",
    4  => x"AA",
    5  => x"BB",
    6  => x"CC",
    7  => x"DD",

    others => (others => '0')
	);


    signal byte_addr : unsigned(5 downto 0);

    signal loaded_byte       : std_logic_vector(7 downto 0);
    signal loaded_halfword   : std_logic_vector(15 downto 0);
    signal loaded_word       : std_logic_vector(31 downto 0);
    signal loaded_doubleword : std_logic_vector(63 downto 0);

begin

    byte_addr <= unsigned(address(5 downto 0));

    loaded_byte <= data_mem(to_integer(byte_addr));

    loaded_halfword <=
        (others => '0') when (byte_addr > 62) else 
        data_mem(to_integer(byte_addr)+1) &
        data_mem(to_integer(byte_addr));

    loaded_word <=
        (others => '0') when (byte_addr > 60) else
        data_mem(to_integer(byte_addr)+3) &
        data_mem(to_integer(byte_addr)+2) &
        data_mem(to_integer(byte_addr)+1) &
        data_mem(to_integer(byte_addr));

    loaded_doubleword <=
        (others => '0') when (byte_addr > 56) else
        data_mem(to_integer(byte_addr)+7) &
        data_mem(to_integer(byte_addr)+6) &
        data_mem(to_integer(byte_addr)+5) &
        data_mem(to_integer(byte_addr)+4) &
        data_mem(to_integer(byte_addr)+3) &
        data_mem(to_integer(byte_addr)+2) &
        data_mem(to_integer(byte_addr)+1) &
        data_mem(to_integer(byte_addr));

    process(byte_en, loaded_byte, loaded_halfword, loaded_word, loaded_doubleword)
    begin
        case byte_en is

            when MEM_ACCESS_DOUBLEWORD =>
                re_data <= loaded_doubleword;

            when MEM_ACCESS_WORD =>
                if loaded_word(31) = '1' then
                    re_data <= X"FFFFFFFF" & loaded_word;
                else
                    re_data <= X"00000000" & loaded_word;
                end if;

            when MEM_ACCESS_HALFWORD =>
                if loaded_halfword(15) = '1' then
                    re_data <= X"FFFFFFFFFFFF" & loaded_halfword;
                else
                    re_data <= X"000000000000" & loaded_halfword;
                end if;

            when MEM_ACCESS_BYTE =>
                if loaded_byte(7) = '1' then
                    re_data <= X"FFFFFFFFFFFFFF" & loaded_byte;
                else
                    re_data <= X"00000000000000" & loaded_byte;
                end if;

            when others =>
                re_data <= (others => 'X');
        end case;
    end process;

    process(clk)
    begin
        if rising_edge(clk) then
            if wr_en = '1' then
                case byte_en is

                    when MEM_ACCESS_DOUBLEWORD =>
                        if byte_addr <= 56 then
                            data_mem(to_integer(byte_addr)+0) <= wr_data(7 downto 0);
                            data_mem(to_integer(byte_addr)+1) <= wr_data(15 downto 8);
                            data_mem(to_integer(byte_addr)+2) <= wr_data(23 downto 16);
                            data_mem(to_integer(byte_addr)+3) <= wr_data(31 downto 24);
                            data_mem(to_integer(byte_addr)+4) <= wr_data(39 downto 32);
                            data_mem(to_integer(byte_addr)+5) <= wr_data(47 downto 40);
                            data_mem(to_integer(byte_addr)+6) <= wr_data(55 downto 48);
                            data_mem(to_integer(byte_addr)+7) <= wr_data(63 downto 56);
                        end if;

                    when MEM_ACCESS_WORD =>
                        if byte_addr <= 60 then
                            data_mem(to_integer(byte_addr)+0) <= wr_data(7 downto 0);
                            data_mem(to_integer(byte_addr)+1) <= wr_data(15 downto 8);
                            data_mem(to_integer(byte_addr)+2) <= wr_data(23 downto 16);
                            data_mem(to_integer(byte_addr)+3) <= wr_data(31 downto 24);
                        end if;

                    when MEM_ACCESS_HALFWORD =>
                        if byte_addr <= 62 then
                            data_mem(to_integer(byte_addr)+0) <= wr_data(7 downto 0);
                            data_mem(to_integer(byte_addr)+1) <= wr_data(15 downto 8);
                        end if;

                    when MEM_ACCESS_BYTE =>
                        data_mem(to_integer(byte_addr)) <= wr_data(7 downto 0);

                    when others =>
                        null;
                end case;
            end if;
        end if;
    end process;
end architecture;
