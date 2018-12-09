library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity IF_ID_Reg is
	port (
		--Inputs
		clk : in std_logic;
		arst, aload : in std_logic;
			--async reset will initialize register with 0
		instr_in : in std_logic_vector(31 downto 0);
		pc_in : in std_logic_vector(31 downto 0);
		
		--Outputs
		instr_out : out std_logic_vector(31 downto 0); 
		pc_out : out std_logic_vector(31 downto 0);
	);
end entity IF_ID_Reg;


architecture structural of IF_ID_Reg is
--types
--components
--signals
	-- pc_reg : std_logic_vector(31 downto 0);
	-- instr_reg : std_logic_vector(31 downto 0);
	
begin
	gen_pc_reg : for i in 0 to 31 generate
		dff_pc : dffr_a port map (
			clk	=> clk,
			arst => arst,
			aload => aload,
			adata => '0', --reset will initialize register with 0
			d => pc_in,
			enable => '1',
			q => pc_out
	end generate;
	
	gen_instr_reg : for i in 0 to 31 generate
		dff_instr : dffr_a port map (
			clk	=> clk,
			arst => arst,
			aload => aload,
			adata => '0', --reset will initialize register with 0
			d => instr_in,
			enable => '1',
			q => instr_out
	end generate;
	


end architecture structural;