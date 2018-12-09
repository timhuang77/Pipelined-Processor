library ieee;
use ieee.std_logic_1164.all;
use work.eecs361_gates.all;

package old_components is

	component mux_1_4 is
		port (
			sel 							: in std_logic_vector (1 downto 0);
			src0, src1, src2, src3	: in std_logic;
			z								: out std_logic
		);
	end component mux_1_4;

	component mux_n_4 is
		generic (
			n : integer
		);
		port (
			sel 							: in std_logic_vector (1 downto 0);
			src0, src1, src2, src3	: in std_logic_vector (n - 1 downto 0);
			z								: out std_logic (n - 1 downto 0)
		);
	end component mux_n_4;
	
	component mux_32_to_1 is
		port (
			sel   : in  std_logic_vector (5 downto 0);
			src0, src1, src2, src3, src4, src5, src6, src7 : in std_logic_vector(31 downto 0);
			z	   : out std_logic_vector(31 downto 0)
		);
	end mux_32_to_1;

	component mux_8_to_1 is
		port (
			sel   : in  std_logic_vector (5 downto 0);
			src0, src1, src2, src3, src4, src5, src6, src7  : in  std_logic;
			z	   : out std_logic
		);
	end component mux_8_to_1;

	component add is
		port(
				a, b, carryin 			: in std_logic;
				z, overflow, carryout : out std_logic
			);
	end component add;
	
	component add32 is
		port(
				a, b 						: in std_logic_vector (31 downto 0);
				carry_in 				: in std_logic;
				z 							: out std_logic_vector (31 downto 0);
				overflow, carry_out 	: out std_logic
			);
	end component add32;

	component sub is
		port(
				a, b, carryin				: in std_logic;
				z, overflow, carryout 	: out std_logic
			);
	end component sub;
	
	component sub32 is
		port(
				a, b 						: in std_logic_vector (31 downto 0);
				z 							: out std_logic_vector (31 downto 0);
				overflow, carryout 	: out std_logic
			);
	end component sub32;

	component sll32 is
		port (
			x, y   	: in  std_logic_vector(31 downto 0);
			z   		: out std_logic_vector(31 downto 0)
		);
	end component sll32;
	
	component slt32 is
		port (
			x, y   	: in  std_logic_vector(31 downto 0);
			z   		: out std_logic_vector(31 downto 0);
			overflow, carryout : out std_logic
		);
	end slt32;

	component sltu32 is
	  port (
		x, y   	: in  std_logic_vector(31 downto 0);
		z   		: out std_logic_vector(31 downto 0);
		 overflow, carryout : out std_logic
	  );
	end sltu32;
	
	component slt_1bit is
		port (
				x, y   						: in  std_logic;
				z, overflow, carryout  : out std_logic
			);
	end component slt_1bit;
		
	component sltu_1bit is
			port (
				x, y   						: in  std_logic;
				z, overflow, carryout	: out std_logic
			);
	end component sltu_1bit;
	
	component or_self is
		port (
			x   : in  std_logic_vector (31 downto 0);
			z   : out std_logic
		);
	end or_self;

--------------------------------------------------------
-- new componenets

	component and_n is
		generic (
			n : integer
		);
		port (
			x : in std_logic_vector(n - 1 downto 0);
			z : out std_logic
		);
	end component and_n;

	component or_n is
		generic (
			n : integer
		);
		port (
			x : in std_logic_vector (n - 1 downto 0);
			z : out std_logic
		);
	end component or_n;

	component extender is 
		generic (
			n	: integer;
			m 	: integer
		);
		port (
			A	: in std_logic_vector(n - 1 downto 0);
			R	: out std_logic_vector(m - 1 downto 0)
		);
	end component extender;

	component register_32bit is
		port (
			clk : in std_logic;
			rst : in std_logic;
			we : in std_logicl
			d : in std_logic_vector(31 downto 0);
			z : out std_logic_vector(31 downto 0)
		);
	end register_32bit;

	component register_file is
		port (
			clk : in std_logic;
			rst : in std_logic;
			we : in std_logic;
			wd : in std_logic_vector(31 downto 0);
			read_A	: in std_logic_vector(4 down to 0);
			read_B	: in std_logic_vector(4 down to 0);
			write_index	: in std_logic_vector(4 down to 0);
			read_op_A	: out std_logic_vector(31 downto 0);
			read_op_B	: out std_logic_vector(31 downto 0)
		);
	end component register_file;

	component decoder is
		port (
			x : in std_logic_vector (4 downto 0);
			z : out std_logic_vector (31 downto 0)
		);
	end component decoder;

end package old_components;