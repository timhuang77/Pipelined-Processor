library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity IFU_multicycle is
	generic (mem_file: string);
	port(
		clk, rst	: in std_logic;

		pc_in		: in std_logic_vector(31 downto 0);

		
		pc_out		: out std_logic_vector(31 downto 0);
		instr_out	: out std_logic_vector(31 downto 0)
	);
end entity IFU_multicycle;

architecture structural of IFU_multicycle is
	component pc_32 is
		port(clk : in std_logic; 
				d   : in std_logic_vector(31 downto 0); 
				q   : out std_logic_vector(31 downto 0)
			  );
	end component pc_32;
  
	component adder_32 is
		port(x,y : in std_logic_vector(31 downto 0); 
			  sum : out std_logic_vector(31 downto 0)
			  );
	end component;
	
	component sign_ext is
		port (
			x	: in std_logic_vector(15 downto 0);
			z	: out std_logic_vector(31 downto 0)
		);
	end component sign_ext; 
	
constant start_PC_addr : std_logic_vector(31 downto 0) := "00000000010000000000000000100000";
constant const_four : std_logic_vector(31 downto 0) := "00000000000000000000000000000100";

signal pc_signal : std_logic_vector(31 downto 0);

begin
	--PC component
	pc_map  : pc_32 port map(clk, pc_in, pc_signal);
	
	--Adder 32-bit in IFU
	add_4 : adder_32 port map(pc_signal, const_four, pc_out);
	
	--Instruction Memory
	instr_memory : sram
		generic map(mem_file => mem_file) 
		port map(
			cs => '1', --always select
			oe => '1', --read only memory
			we => '0', --read only memory
			addr => pc_signal, 
			din => "00000000000000000000000000000000", --doesn't matter, does not read
			dout => instr_out
		);
		
		
end architecture structural;
