library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity MEM_WB is 
	port(
		clk 	: in std_logic;
		rst		: in std_logic;
		load	: in std_logic;
		enable	: in std_logic; 
 
		data_mem_in  : in std_logic_vector (31 downto 0); 
		wb_in_sig 	 : in std_logic_vector (1 downto 0);
		alu_result_in: in std_logic_vector (31 downto 0);
		write_reg_in : in std_logic_vector (4 downto 0);
		
		data_mem_out  : out std_logic_vector (31 downto 0); 
		wb_out_sig1   : out std_logic;
		wb_out_sig2   : out std_logic; 
		alu_result_out: out std_logic_vector (31 downto 0);
		write_reg_out : out std_logic_vector (4 downto 0)
	);
end MEM_WB;

architecture structural of MEM_WB is 

	component dffr_a is
	  port (
		clk	   : in  std_logic;
		arst   : in  std_logic;
		aload  : in  std_logic;
		adata  : in  std_logic;
		d	   : in  std_logic;
		enable : in  std_logic;
		q	   : out std_logic
	  );
	end component;
	
	component dffr_a_32bit is
      port (
	    clk	   : in  std_logic;
        arst   : in  std_logic;
        aload  : in  std_logic;
        adata  : in  std_logic_vector(31 downto 0);
	    d	   : in  std_logic_vector(31 downto 0);
        enable : in  std_logic;
	    q	   : out std_logic_vector(31 downto 0)
      );
    end component;

	signal wb_out_sig_temp : std_logic_vector (1 downto 0);
	signal write_reg_temp  : std_logic_vector (4 downto 0);
	
begin
	wb_out_sig1 <= wb_out_sig_temp(0);
	wb_out_sig2 <= wb_out_sig_temp(1);
	write_reg_out <= write_reg_temp;
	
	generate_wb : for i in 0 to 1 generate 
		wb_out_sigs : dffr_a port map 
			(clk, rst, load, '0', wb_in_sig(i), enable, wb_out_sig_temp(i));
	end generate;
	
	generate_wr : for i in 0 to 4 generate 
		write_reg_sigs : dffr_a port map 
			(clk, rst, load, '0', write_reg_in(i), enable, write_reg_temp(i));
	end generate;
	
	dffr_a_32bit_1 : dffr_a_32bit port map
		(clk, rst, load, "00000000000000000000000000000000", data_mem_in, enable, data_mem_out);
    dffr_a_32bit_2 : dffr_a_32bit port map
		(clk, rst, load, "00000000000000000000000000000000", alu_result_in, enable, alu_result_out);
	
end structural;
