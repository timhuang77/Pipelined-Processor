library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.pipeline_reg_package.all;

entity hazard_unit is 
port (
		--clk : in std_logic; 
		--lw 
		if_id_Rs, if_id_Rt, id_ex_Rt : in std_logic_vector(4 downto 0); 
		id_ex_MemRd : in std_logic;
  		--branch
		MEM_beq_flag, MEM_bneq_flag, MEM_bgtz_flag : in std_logic;
  	
		PC_write, IF_ID_write, IF_ID_zeros_flag, ID_EX_stall_flag, EX_MEM_stall_flag : out std_logic
  		--mux_select : out std_logic now called ID_EX_control_enable
  		
		);
end hazard_unit;
  
architecture struct of hazard_unit is 

  component and_1bit is
    port (
        x : in std_logic;
        y : in std_logic;
        z : out std_logic
    );
  end component;

  component or_1bit is
    port (
        x : in std_logic;
        y : in std_logic;
        z : out std_logic
    );
  end component;

  component not_gate is
    port (
        x   : in  std_logic;
        z   : out std_logic
    );
  end component;
  
  component compare_5 is
    port (
        x   : in std_logic_vector (4 downto 0);
        y	: in std_logic_vector (4 downto 0);
        z   : out std_logic
    );
  end component;

  component or3_gate is
      port(
          a : in std_logic;
          b : in std_logic;
          c : in std_logic;
          or3_out : out std_logic
      );
  end component or3_gate;
  
  component mux_3_to_1_5bits is
      port (
          sel	: in std_logic_vector(1 downto 0);
          src00, src01, src10	: in std_logic_vector(4 downto 0);
          z	: out std_logic_vector(4 downto 0)
      );
  end component mux_3_to_1_5bits;

--PC Write
--IF/ID Write
--IF/ID Empty
--ID/EX Ctrl
--EX/MEM Ctrl
  
constant lw_control_const : std_logic_vector(4 downto 0) := "00010"; --Disable write to PC, IF/ID. Enable stall in ID/EX
constant br_control_const : std_logic_vector(4 downto 0) := "11111"; --Stall IDEX Ctrl, EXMEM Ctrl. Enable PC write, IF/ID write, IF/ID Write 0's
constant else_control_const : std_logic_vector(4 downto 0) := "11000"; -- Continue instructions normally

-- 6 bits for zero detect --   
signal if_id_Rs_temp, if_id_Rt_temp, id_ex_Rt_temp : std_logic_vector(4 downto 0);
signal same1, same2, result, stall_lw, neg_stall : std_logic;
signal mux_sel_3to1 : std_logic_vector(1 downto 0);

signal control_output : std_logic_vector(4 downto 0);
begin

--LW detect
  	if_id_Rs_temp <= if_id_Rs;
    if_id_Rt_temp <= if_id_Rt;
    id_ex_Rt_temp <= id_ex_Rt;
	compare_5_map1 : compare_5 port map(id_ex_Rt_temp, if_id_Rs_temp, same1);
	compare_5_map2 : compare_5 port map(id_ex_Rt_temp, if_id_Rt_temp, same2);
    or_resuts : or_1bit port map(same1, same2, result);
    and_results : and_1bit port map(result, id_ex_MemRd, mux_sel_3to1(0));
--BR detect   
	or3_branch : or3_gate port map (a => MEM_beq_flag, b =>MEM_bneq_flag, c =>MEM_bgtz_flag, or3_out => mux_sel_3to1(1));
--MUX Select


-- choosing either lw, branch, or else
	hazard_select : mux_3_to_1_5bits port map (sel => mux_sel_3to1, src00 => lw_control_const, src01 => br_control_const, src10 => else_control_const, z => control_output);
      
  	PC_write <= control_output(0);
    IF_ID_write <= control_output(1);
  	IF_ID_zeros_flag <= control_output(2);
    ID_EX_stall_flag <= control_output(3);
    EX_MEM_stall_flag <= control_output(4);

end architecture struct;