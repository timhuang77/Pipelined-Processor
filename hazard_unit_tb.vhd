library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;
use work.pipeline_reg_package.all;

entity hazard_unit_tb is
end entity hazard_unit_tb;

architecture behavioral of hazard_unit_tb is

	component hazard_unit is 
	port (
			clk : in std_logic; 
			if_id_Rs, if_id_Rt, id_ex_Rt : in std_logic_vector(4 downto 0); 
			id_ex_MemRd : in std_logic;
			PCWrite, if_id_write, mux_select : out std_logic
			);
	end component hazard_unit;

	signal clk, id_ex_MemRd, PCWrite, if_id_write, mux_select : std_logic;
	signal if_id_Rs, if_id_Rt, id_ex_Rt : std_logic_vector(4 downto 0);

begin

  	hazard_unit_map : hazard_unit port map(clk, if_id_Rs, if_id_Rt, id_ex_Rt, id_ex_MemRd, PCWrite, if_id_write, mux_select);
	
	hazard_test : process is 
	begin 
		if_id_Rs <= "01010";
		if_id_Rt <= "01010";
		id_ex_Rt <= "01010";
		id_ex_MemRd <= '1'; 
		wait for 5 ns; 
		
		if_id_Rs <= "01010";
		if_id_Rt <= "11111";
		id_ex_Rt <= "01010";
		id_ex_MemRd <= '1'; 
		wait for 5 ns;
		
		if_id_Rs <= "11111";
		if_id_Rt <= "01010";
		id_ex_Rt <= "01010";
		id_ex_MemRd <= '1'; 
		wait for 5 ns;
		
		if_id_Rs <= "11111";
		if_id_Rt <= "11111";
		id_ex_Rt <= "01010";
		id_ex_MemRd <= '1'; 
		wait for 5 ns;
		
		if_id_Rs <= "01010";
		if_id_Rt <= "01010";
		id_ex_Rt <= "01010";
		id_ex_MemRd <= '0'; 
		wait for 5 ns;
		
		wait;
		
	end process;
end architecture;
