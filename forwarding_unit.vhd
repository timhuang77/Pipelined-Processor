library IEEE;
use IEEE.std_logic_1164.all;
use IEEE.std_logic_unsigned.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity forwarding_unit is
	port(
		--inputs
        ID_EX_Rs, ID_EX_Rt, EX_MEM_Rd, MEM_WB_Rd : in std_logic_vector(4 downto 0);
		EX_MEM_RegWr, MEM_WB_RegWr : in std_logic;
		--outputs
		forwardA, forwardB : out std_logic_vector(1 downto 0)
	);
  
end entity forwarding_unit;
  
architecture structural of forwarding_unit is
    component compare_5 is
      port (
        x   : in std_logic_vector (4 downto 0);
        y	: in std_logic_vector (4 downto 0);
        z   : out std_logic
      );
    end component compare_5;
	
	component and3_gate is
		port(
			x1, x2, x3 	: in std_logic;
			z 			: out std_logic
		);
	end component and3_gate;
    --forwardA = 00: First ALU operand comes from register file
    --forwardA = 10: First ALU operand forwarded from prior result
    --forwardA = 01: First ALU operand forwarded from data_mem or earlier result
    --forwardB = 00 : Second ALU operand comes from register file
    --forwardB = 10 : Second ALU operand comes from prior result
    --forwardB = 01 : Second ALU operand forwarded from data_mem or earlier result

	signal EX_MEM_Rd_is_0, EX_MEM_Rd_isnot_0 : std_logic;
	signal EXMEMRd_IDEXRs_Equal_flag, EXMEMRd_IDEXRs_NotEqual_flag : std_logic;
	signal EXMEMRd_IDEXRt_Equal_flag, EXMEMRd_IDEXRt_NotEqual_flag : std_logic;
	signal MEMWBRd_IDEXRs_Equal_flag, MEMWBRd_IDEXRt_Equal_flag : std_logic;
	signal MEM_WB_Rd_is_0, MEM_WB_Rd_isnot_0 : std_logic;
	signal and_temp_0, and_temp_1, and_temp_2, and_temp_3 : std_logic; 
	signal and_temp_4, and3_temp_1, and3_temp_2 : std_logic;
	signal not_temp_0, not_temp_1 : std_logic;
begin
--EX Hazard--
  	EX_MEM_Rd_iszero : compare_5 port map(x => EX_MEM_Rd, y => "00000", z => EX_MEM_Rd_is_0);
	not_0 : not_gate port map(EX_MEM_Rd_is_0, EX_MEM_Rd_isnot_0);

	--forwardA(1)
	compare_EXMEMRd_IDEXRs : compare_5 port map (x => EX_MEM_Rd, y => ID_EX_Rs, z => EXMEMRd_IDEXRs_Equal_flag);
	and_0 : and_gate port map(EXMEMRd_IDEXRs_Equal_flag, EX_MEM_Rd_isnot_0, and_temp_0);
	and_1 : and_gate port map(EX_MEM_RegWr, and_temp_0, forwardA(1));
	--forwardB(1)
	compare_EXMEMRd_IDEXRt : compare_5 port map(x => EX_MEM_Rd, y => ID_EX_Rt, z => EXMEMRd_IDEXRt_Equal_flag);
	and_2 : and_gate port map(EXMEMRd_IDEXRt_Equal_flag, EX_MEM_Rd_isnot_0, and_temp_1);
	and_3 : and_gate port map(EX_MEM_RegWr, and_temp_1, forwardB(1));	
	
--MEM Hazard--
	MEM_WB_Rd_iszero : compare_5 port map(x => MEM_WB_Rd, y => "00000", z => MEM_WB_Rd_is_0);
	not_1 : not_gate port map(MEM_WB_Rd_is_0, MEM_WB_Rd_isnot_0);
	EX_MEM_RegWr_and_EX_MEM_Rd_check : and_gate 
		port map(MEM_WB_RegWr, MEM_WB_Rd_isnot_0, and_temp_2);
	
	--forwardA(0)
	not_2 : not_gate port map(EXMEMRd_IDEXRs_Equal_flag, EXMEMRd_IDEXRs_NotEqual_flag);
	and3_1 : and3_gate port map(
		x1 => EX_MEM_RegWr, 
		x2 => EX_MEM_Rd_isnot_0,
		x3 => EXMEMRd_IDEXRs_NotEqual_flag,
		z => and3_temp_1
		);
	not_3 : not_gate port map(and3_temp_1, not_temp_0);
	compare_MEMWBRd_IDEXRs_1 : compare_5 
		port map(x => MEM_WB_Rd, y => ID_EX_Rs, z => MEMWBRd_IDEXRs_Equal_flag);
	and_4 : and_gate port map(not_temp_0, MEMWBRd_IDEXRs_Equal_flag, and_temp_3);
	final_and_A : and_gate port map(and_temp_2, and_temp_3, forwardA(0));
	
	--forwardB(0)
	not_4 : not_gate port map(EXMEMRd_IDEXRt_Equal_flag, EXMEMRd_IDEXRt_NotEqual_flag);
	and3_2 : and3_gate port map(
		x1 => EX_MEM_RegWr, 
		x2 => EX_MEM_Rd_isnot_0,
		x3 => EXMEMRd_IDEXRt_NotEqual_flag,
		z => and3_temp_2
		);
	not_5 : not_gate port map(and3_temp_2, not_temp_1);
	compare_MEMWBRd_IDEXRs_2 : compare_5 
		port map(x => MEM_WB_Rd, y => ID_EX_Rt, z => MEMWBRd_IDEXRt_Equal_flag);
	and_5 : and_gate port map(not_temp_1, MEMWBRd_IDEXRt_Equal_flag, and_temp_4);
	final_and_B : and_gate port map(and_temp_2, and_temp_4, forwardB(0));


end architecture;