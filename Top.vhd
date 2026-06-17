library ieee;
use ieee.std_logic_1164.all;
use work.Operation_Types.all;

entity Top is
    port (
        clk     : in std_logic;
        reset   : in std_logic
    );
end entity;

architecture Top_architecture of Top is
    
    component PC is
        port (
            clk        : in std_logic;
            reset      : in std_logic;
            pc_next    : in std_logic_vector(63 downto 0);
            pc_value   : out std_logic_vector(63 downto 0)
        );
    end component PC;
    
    component Instruction_Memory is
        port(
            address    : in std_logic_vector(63 downto 0);
            instr      : out std_logic_vector(31 downto 0)
        );
    end component Instruction_Memory;

    component Control_Unit is
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
    end component Control_Unit;
    
    component Register_File is
        port (
            clk        : in std_logic;
            wr_en      : in std_logic;
            rs1        : in std_logic_vector(4 downto 0);
            rs2        : in std_logic_vector(4 downto 0);
            rd         : in std_logic_vector(4 downto 0);
            wr_data    : in std_logic_vector(63 downto 0);
            data_1     : out std_logic_vector(63 downto 0);
            data_2     : out std_logic_vector(63 downto 0)
        );
    end component Register_File;
    
    component ALU is
        port(
            x, y        : in  std_logic_vector(63 downto 0);  
            result      : out std_logic_vector(63 downto 0);
            operation   : in  alu_operation;
            branch_taken : out std_logic 
        );
    end component ALU;

    component Data_Memory is
        port (
            clk      : in std_logic;
            wr_en    : in std_logic;
            byte_en  : in std_logic_vector(2 downto 0); 
            address  : in std_logic_vector(63 downto 0);
            wr_data  : in std_logic_vector(63 downto 0);
            re_data  : out std_logic_vector(63 downto 0)
        );
    end component Data_Memory;

    component ADDER is
        port (
            A    : in std_logic_vector(63 downto 0);
            B    : in std_logic_vector(63 downto 0);
            Z    : out std_logic_vector(63 downto 0)
        );
    end component ADDER;

    component MUX is
        port (
            IN0    : in std_logic_vector(63 downto 0);
            IN1    : in std_logic_vector(63 downto 0);
            sel    : in std_logic;
            Z      : out std_logic_vector(63 downto 0)
        );
    end component MUX;
    
    constant pc_4 : std_logic_vector(63 downto 0) := X"0000000000000004";
    
    -- Control Unit signals
    signal instruction_sig  : std_logic_vector(31 downto 0);
    signal rs1_addr_sig     : std_logic_vector(4 downto 0);
    signal rs2_addr_sig     : std_logic_vector(4 downto 0);
    signal rd_addr_sig      : std_logic_vector(4 downto 0);
    signal immediate_sig    : std_logic_vector(63 downto 0);
    signal alu_op_sig       : ALU_Operation;
    signal alu_src_sig      : std_logic;
    signal reg_write_sig    : std_logic;
    signal mem_write_sig    : std_logic;
    signal mem_to_reg_sig   : std_logic;
    signal branch_sig       : std_logic;
    signal byte_en_sig      : std_logic_vector(2 downto 0);
    
    -- PC signals
    signal pc_next_sig      : std_logic_vector(63 downto 0);
    signal pc_value_sig     : std_logic_vector(63 downto 0);
    
    -- Register File signals
    signal reg_data1_sig    : std_logic_vector(63 downto 0);
    signal reg_data2_sig    : std_logic_vector(63 downto 0);
    signal reg_wr_data_sig  : std_logic_vector(63 downto 0);
    
    -- ALU signals
    signal alu_result_sig   : std_logic_vector(63 downto 0);
    signal alu_branch_taken : std_logic;
    signal alu_mux_out_sig  : std_logic_vector(63 downto 0);
    
    -- Data Memory signals
    signal mem_read_data_sig : std_logic_vector(63 downto 0);
    
    -- Adder signals
    signal pc_plus_4_sig    : std_logic_vector(63 downto 0);
    signal pc_plus_imm_sig  : std_logic_vector(63 downto 0);
    
    -- Branch control
    signal branch_control   : std_logic;
    
begin

   
    branch_control <= branch_sig and alu_branch_taken;
    
    
    PC_Mapping: PC 
        port map(
            clk => clk,
            reset => reset,
            pc_next => pc_next_sig,
            pc_value => pc_value_sig
        );
        
    Instruction_Memory_Mapping: Instruction_Memory 
        port map(
            address => pc_value_sig,
            instr => instruction_sig
        );
        
    Control_Unit_Mapping: Control_Unit 
        port map(
            instruction => instruction_sig,
            rs1_addr => rs1_addr_sig,
            rs2_addr => rs2_addr_sig,
            rd_addr => rd_addr_sig,
            immediate => immediate_sig,
            alu_op => alu_op_sig,
            alu_src => alu_src_sig,
            reg_write => reg_write_sig,
            mem_write => mem_write_sig,
            mem_to_reg => mem_to_reg_sig,
            branch => branch_sig,
            byte_en => byte_en_sig
        );
        
    Register_File_Mapping: Register_File 
        port map(
            clk => clk,
            wr_en => reg_write_sig,
            rs1 => rs1_addr_sig,
            rs2 => rs2_addr_sig,
            rd => rd_addr_sig,
            wr_data => reg_wr_data_sig,
            data_1 => reg_data1_sig,
            data_2 => reg_data2_sig
        );
        
    ALU_Mapping: ALU 
        port map(
            x => reg_data1_sig,
            y => alu_mux_out_sig,
            result => alu_result_sig,
            operation => alu_op_sig,
            branch_taken => alu_branch_taken
        );
        
    Data_Memory_Mapping: Data_Memory 
        port map(
            clk => clk,
            wr_en => mem_write_sig,
            byte_en => byte_en_sig,
            address => alu_result_sig,
            wr_data => reg_data2_sig,
            re_data => mem_read_data_sig
        );
        
    PC_Adder_Mapping: ADDER 
        port map(
            A => pc_value_sig,
            B => pc_4,
            Z => pc_plus_4_sig
        );
        
    Branch_Adder_Mapping: ADDER 
        port map(
            A => pc_value_sig,
            B => immediate_sig,
            Z => pc_plus_imm_sig
        );
        
    PC_MUX_Mapping: MUX 
        port map(
            IN0 => pc_plus_4_sig,
            IN1 => pc_plus_imm_sig,
            sel => branch_control,
            Z => pc_next_sig
        );
        
    ALU_MUX_Mapping: MUX 
        port map(
            IN0 => reg_data2_sig,
            IN1 => immediate_sig,
            sel => alu_src_sig,
            Z => alu_mux_out_sig
        );
        
    Memory_MUX_Mapping: MUX 
        port map(
            IN0 => alu_result_sig,
            IN1 => mem_read_data_sig,
            sel => mem_to_reg_sig,
            Z => reg_wr_data_sig
        );
      end architecture;
