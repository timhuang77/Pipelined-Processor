library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.pipeline_reg_package.all;

entity hazard_unit is 
port (
		clk : in std_logic; 
		if_id_Rs, if_id_Rt, id_ex_Rt : in std_logic_vector(4 downto 0); 
		id_ex_MemRd : in std_logic;
		
		PCWrite, if_id_write, mux_select : out std_logic
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
  
  entity compare_5 is
    port (
        x   : in std_logic_vector (4 downto 0);
        y	: in std_logic_vector (4 downto 0);
        z   : out std_logic
    );
  end component;
  
-- 6 bits for zero detect --   
signal if_id_Rs_temp, if_id_Rt_temp, id_ex_Rt_temp : std_logic_vector(4 downto 0);
signal same1, same2, result, stall, neg_stall : std_logic;
  
begin
	
  	if_id_Rs_temp <= if_id_Rs;
    if_id_Rt_temp <= if_id_Rt;
    id_ex_Rt_temp <= id_ex_Rt;

	compare_5_map1 : compare_5 port map(id_ex_Rt_temp, if_id_Rs_temp, same1);
	compare_5_map2 : compare_5 port map(id_ex_Rt_temp, if_id_Rt_temp, same2);
    or_resuts : or_1bit port map(same1, same2, result);
    and_results : and_1bit port map(result, id_ex_MemRd, stall);
    not_results : not_gamte port map(stall, neg_stall);
    
    PCWrite <= neg_stall;
    if_id_write <= neg_stall;
  	mux_select <= stall; 
  
end architecture struct;
