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
		ForwardA, ForwardB : out std_logic_vector(1 downto 0);
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
    --ForwardA = 00: First ALU operand comes from register file
    --ForwardA = 10: First ALU operand forwarded from prior result
    --ForwardA = 01: First ALU operand forwarded from data_mem or earlier result
    --ForwardB = 00 : Second ALU operand comes from register file
    --ForwardB = 10 : Second ALU operand comes from prior result
    --ForwardB = 01 : Second ALU operand forwarded from data_mem or earlier result

	signal EX_MEM_Rd_is_0, EX_MEM_Rd_isnot_0 : std_logic;
	
	--ForwardA
	signal EX_MEM_RdRs_Equal_flag, EX_MEM_RdRs_IsNotEqual_flag, and_temp_0 : std_logic;
	signal MEMWBRd_IDEXRs_Equal_flag : std_logic;
	--ForwardB
	signal EX_MEM_RdRt_Equal_flag, EX_MEM_RdRt_IsNotEqual_flag, and_temp_1 : std_logic;
  

	signal MEM_WB_Rd_is_0, MEM_WB_Rd_isnot_0, and_temp_2 : std_logic;
	
begin
--EX Hazard--
  	EX_MEM_Rd_iszero : compare_5 port map(x => EX_MEM_Rd, y => "00000", z => EX_MEM_Rd_is_0);
	not_0 : not_gate port map(EX_MEM_Rd_is_0, EX_MEM_Rd_isnot_0);

	--ForwardA(1)
	compare_EXMEMRd_IDEXRs_ : compare_5 port map (x => EX_MEM_Rd, y => ID_EX_Rs, z => EX_MEM_RdRs_Equal_flag);
	and_0 : and_gate port map(EX_MEM_RdRs_Equal_flag, EX_MEM_Rd_isnot_0, and_temp_0);
	and_1 : and_gate port map(EX_MEM_RegWr, and_temp_0, ForwardA(1));
	--ForwardB(1)
	compare_EXMEMRd_IDEXRt_ : compare_5 port map(x => EX_MEM_Rd, y => ID_EX_Rt, z => EX_MEM_RdRt_Equal_flag);
	and_2 : and_gate port map(EX_MEM_RdRt_Equal_flag, EX_MEM_Rd_isnot_0, and_temp_1);
	and_3 : and_gate port map(EX_MEM_RegWr, and_temp_1, ForwardB(1));	
	
--MEM Hazard--
	MEM_WB_Rd_iszero : compare_5 port map(x => MEM_WB_Rd, y => "00000", z => MEM_WB_Rd_is_0);
	not_1 : not_gate port map(MEM_WB_Rd_is_0, MEM_WB_Rd_isnot_0);
	EX_MEM_RegWr_and_EX_MEM_Rd_check : and_gate 
		port map(EX_MEM_RegWr, EX_MEM_Rd_isnot_0, and_temp_2);
	
	--ForwardA(0)
	not_2 : not_gate port map(EX_MEM_RdRs_Equal_flag, EX_MEM_RdRs_IsNotEqual_flag);
	and_4 : and_gate port map(and_temp_2, EX_MEM_RdRs_IsNotEqual_flag, and_temp_3);
	not_3 : not_gate port map(and_temp_3, not_temp_0);
	compare_MEMWBRd_IDEXRs : compare_5 
		port map(x => MEM_WB_Rd, y => ID_EX_Rs, z => MEMWBRd_IDEXRs_Equal_flag);
	and_5 : and_gate port map(MEM_WB_RegWr, MEM_WB_Rd_isnot_0, and_temp_4);
	and_6 : and_gate port map(not_temp_0, MEMWBRd_IDEXRs_Equal_flag, and_temp_5);
	and_7 : and_gate port map (and_temp_4, and_temp_5, ForwardA(0));
	
	
	--ForwardB(0)
	not_4 : not_gate port map(EX_MEM_RdRt_Equal_flag, EX_MEM_RdRt_IsNotEqual_flag);
	and_8 : and_gate port map(and_temp_2, EX_MEM_RdRt_IsNotEqual_flag, and_temp_6);
	not_5 : not_gate port map(and_temp_6, not_temp_1);
	compare_MEMWBRd_IDEXRt : compare_5 
		port map(x => MEM_WB_Rd, y => ID_EX_Rt, z => MEMWBRd_IDEXRt_Equal_flag);
	-- and_9 : and_gate port map(MEM_WB_RegWr, MEM_WB_Rd_isnot_0, and_temp_4);
	and_9 : and_gate port map(not_temp_1, MEMWBRd_IDEXRt_Equal_flag, and_temp_7);
	and_10 : and_gate port map(and_temp_4, and_temp_7, ForwardB(0));

end architecture











