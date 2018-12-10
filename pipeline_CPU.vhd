library IEEE;
use IEEE.std_logic_1164.all;
use work.eecs361_gates.all;
use work.eecs361.all;

entity pipeline_CPU is
	generic (
		--loads Data Memory
		mem_file : string
		);
	port (
		clk 	: in std_logic;
		arst	: in std_logic
	);
end entity pipeline_CPU;
  
architecture structural of pipeline_CPU is
--types
--components
  	--components
	component alu is
		port(
				A 			: in std_logic_vector(31 downto 0);
				B 			: in std_logic_vector(31 downto 0);
				sel 		: in std_logic_vector(5 downto 0);
				result 		: out std_logic_vector(31 downto 0);
				cout, overflow, zero : out std_logic
			);
	end component alu;
  
 	component ALU_control is
		port (
			ALUop	: in std_logic_vector(1 downto 0);
			funct	: in std_logic_vector(5 downto 0);
			ALUctrl	: out std_logic_vector(5 downto 0)
		);
	end component ALU_control;

	component register_32 is
		port (
			clk : in std_logic;
			arst, aload, RegWr			: in std_logic;
			Ra, Rb, Rw					: in std_logic_vector(4 downto 0);
			busW						: in std_logic_vector(31 downto 0);
			busA, busB					: out std_logic_vector(31 downto 0)
		);
	end component register_32;
  
	component IFU_multicycle is
		generic (mem_file: string);
		port(
			clk, rst	: in std_logic;

			pc_in		: in std_logic_vector(31 downto 0);


			pc_out		: out std_logic_vector(31 downto 0);
			instr_out	: out std_logic_vector(31 downto 0)
		);
	end component IFU_multicycle;
	
	component IF_ID_Reg is
		port (
			--Inputs
			clk : in std_logic;
			arst, aload : in std_logic;
				--async reset will initialize register with 0
			instr_in : in std_logic_vector(31 downto 0);
			pc_in : in std_logic_vector(31 downto 0);
			
			--Outputs
			instr_out : out std_logic_vector(31 downto 0); 
			pc_out : out std_logic_vector(31 downto 0)
		);
	end component IF_ID_Reg;
	
	component ID_EX_Reg is 
		port ( 
			-- inputs
			clk			: in std_logic;
			arst, aload	: in std_logic;
			
			control_wb	: in std_logic_vector(1 downto 0);
			control_mem	: in std_logic_vector(4 downto 0);
			control_ex	: in std_logic_vector(3 downto 0);
			
			pc_in		: in std_logic_vector(31 downto 0);
			
			read_data1	: in std_logic_vector(31 downto 0);
			read_data2	: in std_logic_vector(31 downto 0);
			
			sign_ext	: in std_logic_vector(31 downto 0);
			
			instruct_1	: in std_logic_vector(4 downto 0);
			instruct_2	: in std_logic_vector(4 downto 0);
			
			--outputs
			control_wb_out	: out std_logic_vector(1 downto 0);
			control_mem_out	: out std_logic_vector(4 downto 0);
			ALUSrc			: out std_logic;
			ALUOp			: out std_logic_vector(1 downto 0);
			RegDst			: out std_logic;
			
			pc_out 			: out std_logic_vector(31 downto 0);
			bus_a			: out std_logic_vector(31 downto 0);
			bus_b			: out std_logic_vector(31 downto 0);
			out_sign_ext	: out std_logic_vector(31 downto 0);
			
			out_instruct1	: out std_logic_vector(4 downto 0);
			out_instruct2	: out std_logic_vector(4 downto 0)
		);
	end component ID_EX_Reg;
  
    component EX_MEM_Reg is 
        port(
            clk, arst, aload, enable	: in std_logic; 

            wb_in_sig 	 	: in std_logic_vector (1 downto 0);
            control_mem_in	: in std_logic_vector (4 downto 0); 
                --control_mem(0): beq
                --control_mem(1): bneq
                --control_mem(2): bgtz
                --control_mem(3): MemRead
                --control_mem(4): MemWrite
            pc_in_sig		: in std_logic_vector (31 downto 0);
            alu_zero_in		: in std_logic;
            alu_result_in   : in std_logic_vector (31 downto 0);
            bus_b_in		: in std_logic_vector (31 downto 0);
            write_reg_in 	: in std_logic_vector (4 downto 0);

            wb_out_sig	 	  : out std_logic_vector (1 downto 0);

            --control_mem signals
            beq_flag, bneq_flag, bgtz_flag, MemRead, MemWrite : out std_logic;
            pc_out_sig		  : out std_logic_vector (31 downto 0); 
            alu_zero_out	  : out std_logic;
            alu_result_out    : out std_logic_vector (31 downto 0);	
            bus_b_out		  : out std_logic_vector (31 downto 0);
            write_reg_out 	  : out std_logic_vector (4 downto 0)
        );
    end component;
  
  	component MEM_WB is 
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
	end component MEM_WB;
  
    component sign_ext_32 is
        port (
            x	: in std_logic_vector(15 downto 0);
            z	: out std_logic_vector(31 downto 0)
        );
    end component sign_ext_32;
  
    component adder_32 is
    port (
            a, b : in std_logic_vector(31 downto 0);
            z : out std_logic_vector(31 downto 0)
            );
    end component adder_32;
  
    component shift_left_2 is
    port (
            x: in std_logic_vector(31 downto 0);
            z : out std_logic_vector(31 downto 0)
            );
    end component shift_left_2;

   component unsign_ext_32 is
        port (
            x	: in std_logic_vector(15 downto 0);
            z	: out std_logic_vector(31 downto 0)
        );
    end component unsign_ext_32;
--signals
	--IF stage
	signal pc_Src_signal : std_logic;
	signal pc_plus_4, pc_plus_4_plus_imm16, pc_in, IF_instr_out : std_logic_vector(31 downto 0);
	
	--ID stage
	signal RegWr_signal : std_logic;
	signal ID_instr, ID_pc, read_data1, read_data2, busw_signal, sign_extended_imm16, extended_shamt: std_logic_vector(31 downto 0);

	--EX stage
	signal EX_bus_a_in,  EX_bus_b_in, EX_ALU_in : std_logic_vector(31 downto 0);
    signal is_zero, ALU_zero: std_logic;
    signal imm16_sll_2, shamt_32, ALU_result : std_logic_vector(31 downto 0);
    signal ALUctrl : std_logic_vector(5 downto 0);
    signal instruct_rw : std_logic_vector(4 downto 0);

begin
	--IF Stage
		--Before IFU
		pcSrc_Mux : mux_32 port map(sel => pc_Src_signal, src0 => pc_plus_4, src1 => pc_plus_4_plus_imm16, z => pc_in);
	
  	-- Controls  
        control : main_control port map(
        	opcode => ID_instr(31 downto 26),
          	ALUSrc => ID_control_ex(0),
            ALUop => ID_control_ex(2 downto 1),
          	RegDst => ID_control_ex(3),
          	MemtoReg => ID_control_wb(0),
          	RegWrite => ID_control_wb(1),
          	beq => ID_control_mem(0);
          	bneq => ID_control_mem(1);
          	bgtz => ID_control_mem(2);
          	MemRead => ID_control_mem(3);
          	MemWrite => ID_control_mem(4)
          	--ExtOp not connected
        );
          
	--IFU
		IFU : IFU_multicycle port map(
			clk => clk,
			pc_in => pc_in,
			pc_out => pc_plus_4,
			instr_out => IF_instr_out
		);
	
	--IF/ID
		IF_ID_register : IF_ID_Reg port map(
			clk => clk,
			arst => arst,
			aload => '0', --loads 0 on async reset
			instr_in => IF_instr_out,
			pc_in => pc_plus_4,
			instr_out => ID_instr,
			pc_out => ID_pc
		);
		
	--ID Stage
		register_file : register_32 port map(
			clk => clk,
			arst => arst,
			aload => '0',
			RegWr => RegWr_signal
			Ra => ID_instr(25 downto 21),
			Rb => ID_instr(20 downto 16),
			Rw => Rw_signal,
			busW => busw_signal,
			busA => read_data1,
			busB => read_data2
		);
          
        sign_extend_imm16 : sign_ext_32 port map(x => IF_instr_out(15 downto 0), z => sign_extended_imm16);
        extend_shamt : unsign_ext_32 port map(x => IF_instr_out(10 downto 6), z = > extended_shamt);
	
	--ID/EX
		ID_EX_register : ID_EX_Reg port map(
			clk	=> clk,
			arst => arst,
			aload => aload, 
			control_wb => ID_control_wb,
			control_mem => ID_control_mem,
			control_ex => ID_control_ex,
			pc_in => ID_pc,
			read_data1 => read_data1,
			read_data2 => read_data2,
			sign_ext => sign_extended_imm16,
			instruct_1 => ID_instr(20 downto 16),
			instruct_2 => ID_instr(15 downto 11),
			--outputs
			control_wb_out => EX_control_wb,
			control_mem_out => EX_control_mem,
			ALUSrc => ALUSrc,
			ALUOp => ALUOp,
			RegDst => RegDst,
			pc_out => EX_pc_in,
			bus_a => EX_bus_a_in,
			bus_b => EX_bus_b_in,
			out_sign_ext => EX_sign_extend,
			out_instruct1 => EX_instruct_1,
			out_instruct2 => EX_instruct_2
        );
          
	--EX Stage
        imm16_shifter 	: shift_left_2 port map (x => EX_sign_extend, z => imm16_sll_2);
        pc_add_imm16 	: adder_32 port map (a => EX_pc_in, b => imm16_sll_2, z => EX_pc_out); 
       
        sll_detector 	: zero_detect_6 port map (x => ALUctrl, z => is_zero);
        sll_alu_mux 	: mux_32 port map (sel => is_zero, src0 => EX_sign_extend, src1 => shamt_32, z => EX_ALU_in1);
        alu_mux 		: mux_32 port map (sel => ALUSrc, src0 => EX_bus_b_in, src1 => EX_ALU_in1, z => EX_ALU_in2);
        alu_map			: alu port map (A => EX_bus_a_in, B => EX_ALU_in2, sel => ALUctrl, result => ALU_result, zero => ALU_zero);
        
        alu_control_map	: ALU_control port map (ALUop => ALUOp, funct => EX_sign_extend(5 downto 0), ALUctrl => ALUctrl);
        
        RegDst_mux 	: mux_n generic map(n => 5) port map (sel => RegDst, src0 => EX_instruct_1, src1 => EX_instruct_2, z => instruct_rw);
                                                        
    --EX/MEM                                    
        EX_Mem_register : EX_MEM_Reg port map(
          clk => clk,
          arst => arst,
          aload => aload,
          control_wb_in => EX_control_wb,
          control_mem_in => EX_control_mem,
          
          pc_in => EX_pc_out,
          zero_flag_in => ALU_zero,
          alu_result_in => ALU_result,
          bus_b_in => Ex_bus_b_in,
          rw_in => instruct_rw,
          
          control_wb_out => MEM_control_wb,
          beq_flag => MEM_beq_flag,
          bneq_flag => MEM_bneq_flag, 
          bgtz_flag => MEM_bgtz_flag, 
          MemRead => MemRead, 
          MemWrite => MemWrite,
          
          zero_flag_out => MEM_zero_flag_in,
          pc_out => MEM_pc_in,
          alu_result_out => MEM_ALU_result_in,
          bus_b_out => MEM_bus_b_in,
          rw_out => MEM_rw_in
        );
          
    --FOR REFERENCE
entity EX_MEM_Reg is 
	port(
		clk, rst, aload	: in std_logic; 
 
		control_wb_in 	 	: in std_logic_vector (1 downto 0);
			--control_wb(0) : MemToReg
			--control_wb(1) : RegWrite
		control_mem_in	: in std_logic_vector (4 downto 0); 
      		--control_mem(0): beq
      		--control_mem(1): bneq
      		--control_mem(2): bgtz
      		--control_mem(3): MemRead
      		--control_mem(4): MemWrite
		pc_in			: in std_logic_vector (31 downto 0);
		zero_flag_in	: in std_logic;
		alu_result_in   : in std_logic_vector (31 downto 0);
		bus_b_in		: in std_logic_vector (31 downto 0);
		rw_in 			: in std_logic_vector (4 downto 0);
		
		control_wb_out	: out std_logic_vector (1 downto 0);
      	
      	--control_mem signals
		beq_flag, bneq_flag, bgtz_flag, MemRead, MemWrite, zero_flag_out : out std_logic;

		pc_out		: out std_logic_vector (31 downto 0); 
		alu_result_out  : out std_logic_vector (31 downto 0);	
		bus_b_out		: out std_logic_vector (31 downto 0);
		rw_out 	  		: out std_logic_vector (4 downto 0)
	);
end EX_MEM_Reg;
                                                
    --MEM Stage
        --Data Memory component
        DataMemory : sram 
            generic map(mem_file => mem_file)
            port map(cs => '1',
                     oe => MemRead,
                     we => MemWrite,
                     addr => MEM_ALU_result_in,
                     din => MEM_bus_b_in,
                     dout => MEM_dout);
                --OE currently 1, but could be modified to output based on control logic
          
        gtz_detect : gtz_detector port map (x => MEM_ALU_result_in, z => MEM_gtz_flag);
        branch_detect : branch_detector port map(
            beq_flag => MEM_beq_flag, bneq_flag => MEM_bneq_flag, bgtz_flag => MEM_bgtz_flag,
            zero_flag => MEM_zero_flag, gtz_flag => MEM_gtz_flag, PC_Src_out => pc_Src_signal);

    --MEM/WB                                    
	MEM_WB_MAP : MEM_WB_Reg port map(
		clk => clk,
		arst => arst,
		aload => aload,
		data_mem_in => MEM_dout,
		control_wb_in => MEM_control_wb,
		alu_result_in => MEM_ALU_result_in,
		rw_in => MEM_rw_in,
		data_mem_out => WB_data_mem_in,
		control_wb_out(0) => MemToReg,
      	control_wb_out(1) => RegWrite,
		alu_result_out => WB_alu_result_in,
		rw_out => Rw_signal
	);                             
                                                
    --WB Stage
    wb_mux : mux_32 port map (sel => MemtoReg, src0 => WB_alu_result_in, src1 => WB_data_mem_in, z => busw_signal);		

end architecture structural;
  