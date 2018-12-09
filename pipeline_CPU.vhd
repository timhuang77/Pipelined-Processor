library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity pipeline_CPU is
	generic (
		--loads Data Memory
		mem_file : string
		);
	port (
		clk 	: in std_logic;
		arst	: in std_logic
	);
end entity pipeline_CPU;
  
architecture structural of pipeline_CPU is
--types
--components
  	--components
	component alu is
		port(
				A 			: in std_logic_vector(31 downto 0);
				B 			: in std_logic_vector(31 downto 0);
				sel 		: in std_logic_vector(5 downto 0);
				result 	: out std_logic_vector(31 downto 0);
				cout, overflow, zero : out std_logic
			);
	end component alu;

	component register_32 is
		port (
			clk : in std_logic;
			arst, aload, RegWr			: in std_logic;
			Ra, Rb, Rw					: in std_logic_vector(4 downto 0);
			busW						: in std_logic_vector(31 downto 0);
			busA, busB					: out std_logic_vector(31 downto 0)
		);
	end component register_32;
  
	component IFU_multicycle is
		generic (mem_file: string);
		port(
			clk, rst	: in std_logic;

			pc_in		: in std_logic_vector(31 downto 0);


			pc_out		: out std_logic_vector(31 downto 0);
			instr_out	: out std_logic_vector(31 downto 0)
		);
  end component IFU_multicycle;
--signals
	signal PC_Src_signal : std_logic;
	signal PC_plus_4 : std_logic_vector(31 downto 0);
	signal PC_plus_4_plus_imm16 : std_logic_vector(31 downto 0);
	signal PC_in : std_logic_vector(31 downto 0);
  
begin
	--IF stage
		--Before IFU
		PCSrc_Mux : mux_32 port map(sel => PC_Src_signal, src0 => PC_plus_4, src1 => PC_plus_4_plus_imm16, z => PC_in);
	
		--IFU
		IFU : IFU_multicycle port map(
			clk =>
			pc_in =>
			pc_out =>
			instr_out =>
		);
	
  
end architecture structural;