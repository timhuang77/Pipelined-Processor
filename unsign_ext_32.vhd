library IEEE;
use IEEE.std_logic_1164.all;

use work.eecs361_gates.all;

entity unsign_ext_32 is
	port (
		x	: in std_logic_vector(15 downto 0);
		z	: out std_logic_vector(31 downto 0)
	);
end entity unsign_ext_32;

architecture structural of unsign_ext_32 is

begin
	lower_half : for i in 0 to 15 generate
		z(i) <= x(i);	--Pass-thru of existing bits
	end generate;
	
	upper_half : for i in 16 to 31 generate
		z(i) <= '0';
	end generate;
	
end architecture structural;
