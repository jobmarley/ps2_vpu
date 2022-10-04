library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use work.vpu_utils.all;

entity vpu_decode is
	port (
		resetn : in std_logic;
		clock : in std_logic;
		enable : in std_logic;
	
		instruction_data : in std_logic_vector(63 downto 0);
		instruction_data_valid : in std_logic;
		instruction_data_ready : out std_logic;
	
		upper_operand_address1 : out std_logic_vector(4 downto 0);
		upper_operand_address2 : out std_logic_vector(4 downto 0);
		--upper_operand_address2_valid : out std_logic;
		upper_use_i : out std_logic;
		upper_write_i : out std_logic;
		upper_write_i_data : out std_logic_vector(31 downto 0);
		upper_destination_address : out std_logic_vector(4 downto 0);
		upper_destination_strobe : out std_logic_vector(3 downto 0);
	
		upper_operation : out std_logic_vector(4 downto 0);
		upper_operation_valid : out std_logic;
	
		-- LOWER
		lower_operand_address1 : out std_logic_vector(3 downto 0);
		lower_operand_address2 : out std_logic_vector(3 downto 0);
		lower_immediate : out std_logic_vector(15 downto 0);
		lower_immediate_valid : out std_logic;
		lower_destination_address : out std_logic_vector(5 downto 0);
		lower_operation : out std_logic_vector(7 downto 0);
		lower_operation_valid : out std_logic;
	
		error : out std_logic
	);
end vpu_decode;

architecture vpu_decode_behavioral of vpu_decode is
	type instruction_upper_t is record
		bc : std_logic_vector(1 downto 0);
		opcode : std_logic_vector(3 downto 0);
		fd : std_logic_vector(4 downto 0);
		fs : std_logic_vector(4 downto 0);
		ft : std_logic_vector(4 downto 0);
		dest : std_logic_vector(3 downto 0);
		unknown : std_logic_vector(1 downto 0);
		flags : std_logic_vector(4 downto 0);
	end record;
	type instruction_lower_t is record
		bc : std_logic_vector(1 downto 0);
		special : std_logic_vector(3 downto 0);
		rd : std_logic_vector(4 downto 0);
		rs : std_logic_vector(4 downto 0);
		rt : std_logic_vector(4 downto 0);
		dest : std_logic_vector(3 downto 0);
		opcode : std_logic_vector(6 downto 0);
	end record;
	constant UPPER_FLAG_T : NATURAL := 0;
	constant UPPER_FLAG_D : NATURAL := 1;
	constant UPPER_FLAG_M : NATURAL := 2;
	constant UPPER_FLAG_E : NATURAL := 3;
	constant UPPER_FLAG_I : NATURAL := 4;
	
	function slv32_to_instruction_upper(data : std_logic_vector(31 downto 0)) return instruction_upper_t is
		variable vinst : instruction_upper_t;
	begin
		vinst.bc := data(1 downto 0);
		vinst.opcode := data(5 downto 2);
		vinst.fd := data(10 downto 6);
		vinst.fs := data(15 downto 11);
		vinst.ft := data(20 downto 16);
		vinst.dest := data(24 downto 21);
		vinst.unknown := data(26 downto 25);
		vinst.flags := data(31 downto 27);
		return vinst;
	end function;
	function slv32_to_instruction_lower(data : std_logic_vector(31 downto 0)) return instruction_lower_t is
		variable vinst : instruction_lower_t;
	begin
		vinst.bc := data(1 downto 0);
		vinst.special := data(5 downto 2);
		vinst.rd := data(10 downto 6);
		vinst.rs := data(15 downto 11);
		vinst.rt := data(20 downto 16);
		vinst.dest := data(24 downto 21);
		vinst.opcode := data(31 downto 25);
		return vinst;
	end function;
	
	constant UPPER_OPCODE_ADD : std_logic_vector(3 downto 0) := "1010";
	constant UPPER_OPCODE_SUB : std_logic_vector(3 downto 0) := "1011";
	constant UPPER_OPCODE_SPECIAL : std_logic_vector(3 downto 0) := "1111";
	constant UPPER_OPCODE_ABS_FD : std_logic_vector(4 downto 0) := "00111";
	constant UPPER_OPCODE_ABS_BC : std_logic_vector(1 downto 0) := "01";
	constant UPPER_OPCODE_NOP_FD : std_logic_vector(4 downto 0) := "01011";
	constant UPPER_OPCODE_NOP_BC : std_logic_vector(1 downto 0) := "11";
	
	
	constant LOWER_OPCODE_IADDI : std_logic_vector(6 downto 0) := "1000000";
	constant LOWER_OPCODE_IADDI_BC : std_logic_vector(1 downto 0) := "10";
	constant LOWER_OPCODE_IADDI_SPECIAL : std_logic_vector(3 downto 0) := "1100";
	constant LOWER_OPCODE_LQ : std_logic_vector(6 downto 0) := "0000000";
	
	signal upper_operand_address1_reg : std_logic_vector(4 downto 0);
	signal upper_operand_address1_reg_next : std_logic_vector(4 downto 0);
	signal upper_operand_address2_reg : std_logic_vector(4 downto 0);
	signal upper_operand_address2_reg_next : std_logic_vector(4 downto 0);
	signal upper_use_i_reg : std_logic;
	signal upper_use_i_reg_next : std_logic;
	signal upper_destination_address_reg : std_logic_vector(4 downto 0);
	signal upper_destination_address_reg_next : std_logic_vector(4 downto 0);
	signal upper_destination_strobe_reg : std_logic_vector(3 downto 0);
	signal upper_destination_strobe_reg_next : std_logic_vector(3 downto 0);
	
	signal upper_operation_reg : std_logic_vector(4 downto 0);
	signal upper_operation_reg_next : std_logic_vector(4 downto 0);
	signal upper_operation_valid_reg : std_logic;
	signal upper_operation_valid_reg_next : std_logic;
	
	
	
	signal lower_operand_address1_reg : std_logic_vector(4 downto 0);
	signal lower_operand_address1_reg_next : std_logic_vector(4 downto 0);
	signal lower_operand_address2_reg : std_logic_vector(4 downto 0);
	signal lower_operand_address2_reg_next : std_logic_vector(4 downto 0);
	signal lower_destination_address_reg : std_logic_vector(5 downto 0);
	signal lower_destination_address_reg_next : std_logic_vector(5 downto 0);
	signal lower_immediate_reg : std_logic_vector(15 downto 0);
	signal lower_immediate_reg_next : std_logic_vector(15 downto 0);
	signal lower_immediate_valid_reg : std_logic;
	signal lower_immediate_valid_reg_next : std_logic;
	signal lower_operation_reg : std_logic_vector(7 downto 0);
	signal lower_operation_reg_next : std_logic_vector(7 downto 0);
	signal lower_operation_valid_reg : std_logic;
	signal lower_operation_valid_reg_next : std_logic;
begin

	upper_operand_address1 <= upper_operand_address1_reg;
	upper_operand_address2 <= upper_operand_address2_reg;
	upper_destination_address <= upper_destination_address_reg;
	upper_destination_strobe <= upper_destination_strobe_reg;
	
	upper_operation <= upper_operation_reg;
	upper_operation_valid <= upper_operation_valid_reg;
	
	upper_use_i <= upper_use_i_reg;
	upper_write_i <= '0';
	upper_write_i_data <= (others => '0');
	
	lower_operand_address1 <= lower_operand_address1_reg(3 downto 0);
	lower_operand_address2 <= lower_operand_address2_reg(3 downto 0);
	lower_immediate <= lower_immediate_reg;
	lower_immediate_valid <= lower_immediate_valid_reg;
	lower_destination_address <= lower_destination_address_reg(5 downto 0);
	lower_operation <= lower_operation_reg;
	lower_operation_valid <= lower_operation_valid_reg;
	
	process(clock)
	begin
		if rising_edge(clock) then
			upper_operand_address1_reg <= upper_operand_address1_reg_next;
			upper_operand_address2_reg <= upper_operand_address2_reg_next;
			upper_use_i_reg <= upper_use_i_reg_next;
			upper_destination_address_reg <= upper_destination_address_reg_next;
			upper_destination_strobe_reg <= upper_destination_strobe_reg_next;
			upper_operation_reg <= upper_operation_reg_next;
			upper_operation_valid_reg <= upper_operation_valid_reg_next;
			
			lower_operand_address1_reg <= lower_operand_address1_reg_next;
			lower_operand_address2_reg <= lower_operand_address2_reg_next;
			lower_destination_address_reg <= lower_destination_address_reg_next;
			lower_immediate_reg <= lower_immediate_reg_next;
			lower_immediate_valid_reg <= lower_immediate_valid_reg_next;
			lower_operation_reg <= lower_operation_reg_next;
			lower_operation_valid_reg <= lower_operation_valid_reg_next;
		end if;
	end process;

	process(
		resetn,
		enable,
		
		instruction_data,
		instruction_data_valid,
		
		upper_operand_address1_reg,
		upper_operand_address2_reg,
		upper_use_i_reg,
		upper_destination_address_reg,
		
		lower_operand_address1_reg,
		lower_operand_address2_reg,
		lower_destination_address_reg,
		lower_immediate_reg,
		lower_operation_reg
		)
		variable vinst_upper : instruction_upper_t;
		variable vinst_lower : instruction_lower_t;
	begin
		upper_operand_address1_reg_next <= upper_operand_address1_reg;
		upper_operand_address2_reg_next <= upper_operand_address2_reg;
		upper_use_i_reg_next <= upper_use_i_reg;
		upper_destination_address_reg_next <= upper_destination_address_reg;
		upper_destination_strobe_reg_next <= (others => '0');
		
		upper_operation_reg_next <= (others => '0');
		upper_operation_valid_reg_next <= '0';
		upper_use_i_reg_next <= '0';
		
		error <= '0';
		instruction_data_ready <= '0';
		
		
		lower_operand_address1_reg_next <= lower_operand_address1_reg;
		lower_operand_address2_reg_next <= lower_operand_address2_reg;
		lower_destination_address_reg_next <= lower_destination_address_reg;
		lower_immediate_valid_reg_next <= '0';
		lower_immediate_reg_next <= lower_immediate_reg;
		lower_operation_reg_next <= lower_operation_reg;
		lower_operation_valid_reg_next <= '0';
		
		if resetn = '0' then
			upper_operand_address1_reg_next <= (others => '0');
			upper_operand_address2_reg_next <= (others => '0');
			upper_use_i_reg_next <= '0';
			upper_destination_address_reg_next <= (others => '0');
			upper_destination_strobe_reg_next <= (others => '0');
			upper_operation_reg_next <= (others => '0');
			upper_operation_valid_reg_next <= '0';
			
			lower_operand_address1_reg_next <= (others => '0');
			lower_operand_address2_reg_next <= (others => '0');
			lower_destination_address_reg_next <= (others => '0');
			lower_immediate_reg_next <= (others => '0');
			lower_immediate_valid_reg_next <= '0';
			lower_operation_reg_next <= (others => '0');
			lower_operation_valid_reg_next <= '0';
		else
			if enable = '1' then
				vinst_upper := slv32_to_instruction_upper(instruction_data(63 downto 32));
				vinst_lower := slv32_to_instruction_lower(instruction_data(31 downto 0));
			
				instruction_data_ready <= '1';
			
				-------------------------------------------------------------
				-- UPPER INSTRUCTION DECODE
				-------------------------------------------------------------
				if vinst_upper.flags(UPPER_FLAG_I) = '1' then
				
				end if;
			
				case (vinst_upper.opcode) is
					when UPPER_OPCODE_ADD =>
						if vinst_upper.bc = "00" then
							upper_operand_address1_reg_next <= vinst_upper.fs;
							upper_operand_address2_reg_next <= vinst_upper.ft;
							upper_use_i_reg_next <= '0';
			
							upper_operation_reg_next <= "00001";
							upper_operation_valid_reg_next <= instruction_data_valid;
							upper_destination_address_reg_next <= vinst_upper.fd;
							upper_destination_strobe_reg_next <= vinst_upper.dest;
						else
							-- invalid instruction
							error <= instruction_data_valid;
						end if;
					when UPPER_OPCODE_SUB =>
						if vinst_upper.bc = "00" then
							upper_operand_address1_reg_next <= vinst_upper.fs;
							upper_operand_address2_reg_next <= vinst_upper.ft;
							upper_use_i_reg_next <= '0';
			
							upper_operation_reg_next <= "00010";
							upper_operation_valid_reg_next <= instruction_data_valid;
							upper_destination_address_reg_next <= vinst_upper.fd;
							upper_destination_strobe_reg_next <= vinst_upper.dest;
						else
							-- invalid instruction
							error <= '1';
						end if;
					when UPPER_OPCODE_SPECIAL =>
						if vinst_upper.bc = UPPER_OPCODE_ABS_BC and vinst_upper.fd = UPPER_OPCODE_ABS_FD then
							upper_operand_address1_reg_next <= vinst_upper.ft;
							upper_operand_address2_reg_next <= (others => '0');
							upper_use_i_reg_next <= '1';
			
							upper_operation_reg_next <= "00100";
							upper_operation_valid_reg_next <= instruction_data_valid;
							upper_destination_address_reg_next <= vinst_upper.fs;
							upper_destination_strobe_reg_next <= vinst_upper.dest;
						elsif vinst_upper.bc = UPPER_OPCODE_NOP_BC and vinst_upper.fd = UPPER_OPCODE_NOP_FD then
						else
							-- invalid instruction
							error <= instruction_data_valid;
						end if;
					when others =>
						error <= instruction_data_valid;
				end case;
			
				-------------------------------------------------------------
				-- LOWER INSTRUCTION DECODE
				-------------------------------------------------------------
				case vinst_lower.opcode is
					when LOWER_OPCODE_IADDI =>
						if vinst_lower.bc = LOWER_OPCODE_IADDI_BC and vinst_lower.special = LOWER_OPCODE_IADDI_SPECIAL then
							lower_operand_address1_reg_next <= vinst_lower.rs;
							lower_destination_address_reg_next <= '0' & vinst_lower.rt;
							lower_immediate_valid_reg_next <= '1';
							lower_immediate_reg_next <= sign_extend(vinst_lower.rd, 16);
							lower_operation_reg_next <= "00000001";
							lower_operation_valid_reg_next <= instruction_data_valid;
						else
							error <= instruction_data_valid;
						end if;
					when LOWER_OPCODE_LQ =>
						lower_operand_address1_reg_next <= vinst_lower.rs;
						lower_destination_address_reg_next <= '1' & vinst_lower.rt;
						lower_immediate_valid_reg_next <= '1';
						lower_immediate_reg_next <= sign_extend(vinst_lower.rd & vinst_lower.special & vinst_lower.bc, 16);
						lower_operation_reg_next <= "10000001";
						lower_operation_valid_reg_next <= instruction_data_valid;
					when others =>
						error <= instruction_data_valid;
				end case;
			end if;
		end if;
	end process;
	
end vpu_decode_behavioral;
