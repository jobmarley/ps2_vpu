
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity vpu_read_register is
	port (
		resetn : in std_logic;
		clock : in std_logic;
		enable : in std_logic;
		
		decode_upper_operand_address1 : in std_logic_vector(4 downto 0);
		decode_upper_operand_address2 : in std_logic_vector(4 downto 0);
		--decode_upper_operand_address2_valid : in std_logic;
		decode_upper_use_i : in std_logic;
		--decode_upper_update_i : in std_logic;
		--decode_upper_i_data : in std_logic_vector(31 downto 0);
	
		decode_upper_destination_address : in std_logic_vector(4 downto 0);
		decode_upper_destination_strobe : in std_logic_vector(3 downto 0);
	
		decode_upper_alu_operation : in std_logic_vector(4 downto 0);
		decode_upper_alu_operation_valid : in std_logic;
	
	
		registers_port_vfa_address : out std_logic_vector(4 downto 0);
		registers_port_vfa_data : in std_logic_vector(127 downto 0);
		registers_port_vfa_pending : in std_logic;
	
		registers_port_vfb_address : out std_logic_vector(4 downto 0);
		registers_port_vfb_data : in std_logic_vector(127 downto 0);
		registers_port_vfb_pending : in std_logic;
	
		registers_port_vfd_address : out std_logic_vector(4 downto 0);
		registers_port_vfd_pending : in std_logic;
		registers_port_vfd_write : out std_logic;
		registers_port_vfd_write_pending : out std_logic;
	
		registers_port_vfe_address : out std_logic_vector(4 downto 0);
		registers_port_vfe_pending : in std_logic;
		registers_port_vfe_write : out std_logic;
		registers_port_vfe_write_pending : out std_logic;
	
		--registers_i_data : out std_logic_vector(31 downto 0); 
		--registers_i_write : in std_logic;
		--registers_i_write_data : in std_logic_vector(31 downto 0);
	
	    alu_add_in_tvalid : out std_logic;
	    alu_add_in_tdata : out std_logic_vector(255 downto 0);
	    alu_add_in_tuser : out std_logic_vector(8 downto 0);
	
		alu_sub_in_tvalid : out std_logic;
		alu_sub_in_tdata : out std_logic_vector(255 downto 0);
		alu_sub_in_tuser : out std_logic_vector(8 downto 0);
	
		alu_abs_in_tvalid : out std_logic;
		alu_abs_in_tdata : out std_logic_vector(127 downto 0);
		alu_abs_in_tuser : out std_logic_vector(8 downto 0);
	
	    alu_add_int16_in_tvalid : out std_logic;
	    alu_add_int16_in_tdata : out std_logic_vector(31 downto 0);
	    alu_add_int16_in_tuser : out std_logic_vector(8 downto 0);
	
	    alu_sub_int16_in_tvalid : out std_logic;
	    alu_sub_int16_in_tdata : out std_logic_vector(31 downto 0);
	    alu_sub_int16_in_tuser : out std_logic_vector(8 downto 0);
	
		-- LOWER
		decode_lower_operand_address1 : in std_logic_vector(3 downto 0);
		decode_lower_operand_address2 : in std_logic_vector(3 downto 0);
		decode_lower_immediate : in std_logic_vector(15 downto 0);
		decode_lower_immediate_valid : in std_logic;
		decode_lower_destination_address : in std_logic_vector(5 downto 0);
		decode_lower_operation : in std_logic_vector(7 downto 0);
		decode_lower_operation_valid : in std_logic;

	
		registers_port_via_address : out std_logic_vector(3 downto 0);
		registers_port_via_data : in std_logic_vector(15 downto 0);
		registers_port_via_pending : in std_logic;
	
		registers_port_vib_address : out std_logic_vector(3 downto 0);
		registers_port_vib_data : in std_logic_vector(15 downto 0);
		registers_port_vib_pending : in std_logic;
	
		registers_port_vic_address : out std_logic_vector(3 downto 0);
		registers_port_vic_pending : in std_logic;
		registers_port_vic_write : out std_logic;
		registers_port_vic_write_pending : out std_logic;
	
		stall : out std_logic
	 );
end vpu_read_register;

architecture vpu_read_register_behavioral of vpu_read_register is
	signal decode_upper_operand_address1_reg : std_logic_vector(4 downto 0);
	signal decode_upper_operand_address1_reg_next : std_logic_vector(4 downto 0);
	signal decode_upper_operand_address2_reg : std_logic_vector(4 downto 0);
	signal decode_upper_operand_address2_reg_next : std_logic_vector(4 downto 0);
	signal decode_upper_destination_address_reg : std_logic_vector(4 downto 0);
	signal decode_upper_destination_address_reg_next : std_logic_vector(4 downto 0);
	signal decode_upper_destination_strobe_reg : std_logic_vector(3 downto 0);
	signal decode_upper_destination_strobe_reg_next : std_logic_vector(3 downto 0);
	
	signal decode_upper_alu_operation_reg : std_logic_vector(4 downto 0);
	signal decode_upper_alu_operation_reg_next : std_logic_vector(4 downto 0);
	signal decode_upper_alu_operation_valid_reg : std_logic;
	signal decode_upper_alu_operation_valid_reg_next : std_logic;
	
	signal decode_upper_use_i_reg : std_logic;
	signal decode_upper_use_i_reg_next : std_logic;
	--signal decode_upper_update_i_reg : std_logic;
	--signal decode_upper_update_i_reg_next : std_logic;
	--signal decode_upper_i_data_reg : std_logic_vector(31 downto 0);
	--signal decode_upper_i_data_reg_next : std_logic_vector(31 downto 0);
	
	signal alu_in_tuser_reg : std_logic_vector(8 downto 0);
	signal alu_in_tuser_reg_next : std_logic_vector(8 downto 0);
	
	
	signal decode_lower_operand_address1_reg : std_logic_vector(3 downto 0);
	signal decode_lower_operand_address1_reg_next : std_logic_vector(3 downto 0);
	signal decode_lower_operand_address2_reg : std_logic_vector(3 downto 0);
	signal decode_lower_operand_address2_reg_next : std_logic_vector(3 downto 0);
	signal decode_lower_destination_address_reg : std_logic_vector(5 downto 0);
	signal decode_lower_destination_address_reg_next : std_logic_vector(5 downto 0);
	signal decode_lower_operation_reg : std_logic_vector(7 downto 0);
	signal decode_lower_operation_reg_next : std_logic_vector(7 downto 0);
	signal decode_lower_operation_valid_reg : std_logic;
	signal decode_lower_operation_valid_reg_next : std_logic;
	signal decode_lower_immediate_reg : std_logic_vector(15 downto 0);
	signal decode_lower_immediate_reg_next : std_logic_vector(15 downto 0);
	signal decode_lower_immediate_valid_reg : std_logic;
	signal decode_lower_immediate_valid_reg_next : std_logic;
	
	signal alu_int16_tuser_reg : std_logic_vector(8 downto 0);
	signal alu_int16_tuser_reg_next : std_logic_vector(8 downto 0);
begin
	alu_add_in_tdata <= (registers_port_vfb_data & registers_port_vfa_data);-- when decode_upper_use_i_reg = '0' else (registers_i_data & registers_i_data & registers_i_data & registers_i_data & registers_port_vfa_data);
	alu_add_in_tuser <= alu_in_tuser_reg;
	alu_sub_in_tdata <= registers_port_vfb_data & registers_port_vfa_data;
	alu_sub_in_tuser <= alu_in_tuser_reg;
	alu_abs_in_tdata <= registers_port_vfa_data;
	alu_abs_in_tuser <= alu_in_tuser_reg;
	
	alu_add_int16_in_tdata <= (registers_port_vib_data & registers_port_via_data) when decode_lower_immediate_valid_reg = '0' else (decode_lower_immediate_reg & registers_port_via_data);
	alu_add_int16_in_tuser <= alu_int16_tuser_reg;
	alu_sub_int16_in_tdata <= (registers_port_vib_data & registers_port_via_data) when decode_lower_immediate_valid_reg = '0' else (decode_lower_immediate_reg & registers_port_via_data);
	alu_sub_int16_in_tuser <= alu_int16_tuser_reg;
	
	process(clock)
	begin
		if rising_edge(clock) then
			decode_upper_operand_address1_reg <= decode_upper_operand_address1_reg_next;
			decode_upper_operand_address2_reg <= decode_upper_operand_address2_reg_next;
			decode_upper_destination_address_reg <= decode_upper_destination_address_reg_next;
			decode_upper_destination_strobe_reg <= decode_upper_destination_strobe_reg_next;
			decode_upper_alu_operation_reg <= decode_upper_alu_operation_reg_next;
			decode_upper_alu_operation_valid_reg <= decode_upper_alu_operation_valid_reg_next;
			alu_in_tuser_reg <= alu_in_tuser_reg_next;
			decode_upper_use_i_reg <= decode_upper_use_i_reg_next;
			--decode_upper_update_i_reg <= decode_upper_update_i_reg_next;
			--decode_upper_i_data_reg <= decode_upper_i_data_reg_next;
			
			decode_lower_operand_address1_reg <= decode_lower_operand_address1_reg_next;
			decode_lower_operand_address2_reg <= decode_lower_operand_address2_reg_next;
			decode_lower_destination_address_reg <= decode_lower_destination_address_reg_next;
			decode_lower_operation_reg <= decode_lower_operation_reg_next;
			decode_lower_operation_valid_reg <= decode_lower_operation_valid_reg_next;
			alu_int16_tuser_reg <= alu_int16_tuser_reg_next;
			decode_lower_immediate_reg <= decode_lower_immediate_reg_next;
			decode_lower_immediate_valid_reg <= decode_lower_immediate_valid_reg_next;
		end if;
	end process;
	
	process(
		resetn,
		enable,
		
		decode_upper_operand_address1,
		decode_upper_operand_address2,
		decode_upper_use_i,
		--decode_upper_update_i,
		--decode_upper_i_data,
		decode_upper_destination_address,
		decode_upper_destination_strobe,
		decode_upper_alu_operation,
		decode_upper_alu_operation_valid,
		
		
		decode_upper_operand_address1_reg,
		decode_upper_operand_address2_reg,
		decode_upper_destination_address_reg,
		decode_upper_destination_strobe_reg,
		decode_upper_alu_operation_reg,
		decode_upper_alu_operation_valid_reg,
		decode_upper_use_i_reg,
		
		registers_port_vfa_data,
		registers_port_vfa_pending,
		registers_port_vfb_data,
		registers_port_vfb_pending,
		registers_port_vfd_pending,
		
		alu_in_tuser_reg,
		
		decode_lower_operand_address1,
		decode_lower_operand_address2,
		decode_lower_destination_address,
		decode_lower_operation,
		decode_lower_operation_valid,
		decode_lower_immediate,
		decode_lower_immediate_valid,
		registers_port_via_pending,
		registers_port_vib_pending,
		registers_port_vic_pending,
		decode_lower_operand_address1_reg,
		decode_lower_operand_address2_reg,
		decode_lower_destination_address_reg,
		decode_lower_operation_reg,
		decode_lower_operation_valid_reg,
		decode_lower_immediate_valid_reg,
		alu_int16_tuser_reg
		)
	begin
		
		stall <= '0';
		-- upper
		registers_port_vfa_address <= decode_upper_operand_address1;
		registers_port_vfb_address <= decode_upper_operand_address2;
		registers_port_vfd_address <= decode_upper_destination_address;
		registers_port_vfe_address <= decode_lower_destination_address(4 downto 0);
		
		decode_upper_operand_address1_reg_next <= decode_upper_operand_address1;
		decode_upper_operand_address2_reg_next <= decode_upper_operand_address2;
		decode_upper_destination_address_reg_next <= decode_upper_destination_address;
		decode_upper_destination_strobe_reg_next <= decode_upper_destination_strobe;
		decode_upper_alu_operation_reg_next <= decode_upper_alu_operation;
		decode_upper_alu_operation_valid_reg_next <= decode_upper_alu_operation_valid;
		alu_in_tuser_reg_next <= decode_upper_destination_strobe & decode_upper_destination_address;
		decode_upper_use_i_reg_next <= decode_upper_use_i;
		--decode_upper_update_i_reg_next <= decode_upper_update_i;
		--decode_upper_i_data_reg_next <= decode_upper_i_data;
		
		registers_port_vfd_write_pending <= '1';
		registers_port_vfd_write <= '0';
		registers_port_vfe_write_pending <= '1';
		registers_port_vfe_write <= '0';
		
		alu_add_in_tvalid <= '0';
		alu_sub_in_tvalid <= '0';
		alu_abs_in_tvalid <= '0';
		
		-- lower
		registers_port_via_address <= decode_lower_operand_address1;
		registers_port_vib_address <= decode_lower_operand_address2;
		registers_port_vic_address <= decode_lower_destination_address(3 downto 0);
		
		decode_lower_operand_address1_reg_next <= decode_lower_operand_address1;
		decode_lower_operand_address2_reg_next <= decode_lower_operand_address2;
		decode_lower_destination_address_reg_next <= decode_lower_destination_address;
		decode_lower_operation_reg_next <= decode_lower_operation;
		decode_lower_operation_valid_reg_next <= decode_lower_operation_valid;		
		decode_lower_immediate_reg_next <= decode_lower_immediate;
		decode_lower_immediate_valid_reg_next <= decode_lower_immediate_valid;
		
		registers_port_vic_write <= '0';
		registers_port_vic_write_pending <= '1';
		
		alu_add_int16_in_tvalid <= '0';
		alu_sub_int16_in_tvalid <= '0';
		
		alu_int16_tuser_reg_next <= "00" & decode_lower_operation(7) & decode_lower_destination_address;
		
		if resetn = '0' then
			decode_upper_operand_address1_reg_next <= (others => '0');
			decode_upper_operand_address2_reg_next <= (others => '0');
			decode_upper_destination_address_reg_next <= (others => '0');
			decode_upper_destination_strobe_reg_next <= (others => '0');
			decode_upper_alu_operation_reg_next <= (others => '0');
			decode_upper_alu_operation_valid_reg_next <= '0';
			decode_upper_use_i_reg_next <= '0';
			alu_in_tuser_reg_next <= (others => '0');
			decode_lower_operand_address1_reg_next <= (others => '0');
			decode_lower_operand_address2_reg_next <= (others => '0');
			decode_lower_destination_address_reg_next <= (others => '0');
			decode_lower_operation_reg_next <= (others => '0');
			decode_lower_operation_valid_reg_next <= '0';
			decode_lower_immediate_reg_next <= (others => '0');
			decode_lower_immediate_valid_reg_next <= '0';
			alu_int16_tuser_reg_next <= (others => '0');
		else
			if enable = '1' then
				-- upper
				if registers_port_vfa_pending = '1' or (decode_upper_use_i = '0' and registers_port_vfb_pending = '1') or registers_port_vfd_pending = '1' then
					-- stall the decode and fetch
					-- keep the same register addresses
					-- save decode output
					stall <= '1';
					registers_port_vfa_address <= decode_upper_operand_address1_reg;
					registers_port_vfb_address <= decode_upper_operand_address2_reg;
					registers_port_vfd_address <= decode_upper_destination_address_reg;
				
					decode_upper_operand_address1_reg_next <= decode_upper_operand_address1_reg;
					decode_upper_operand_address2_reg_next <= decode_upper_operand_address2_reg;
					decode_upper_destination_address_reg_next <= decode_upper_destination_address_reg;
					decode_upper_destination_strobe_reg_next <= decode_upper_destination_strobe_reg;
					decode_upper_alu_operation_reg_next <= decode_upper_alu_operation_reg;
					decode_upper_alu_operation_valid_reg_next <= decode_upper_alu_operation_valid_reg;
					alu_in_tuser_reg_next <= alu_in_tuser_reg;
					decode_upper_use_i_reg_next <= decode_upper_use_i_reg;
					--decode_upper_update_i_reg_next <= decode_upper_update_i_reg
					--decode_upper_i_data_reg_next <= decode_upper_i_data_reg;
				else
					alu_add_in_tvalid <= decode_upper_alu_operation_reg(0) and decode_upper_alu_operation_valid_reg;
					alu_sub_in_tvalid <= decode_upper_alu_operation_reg(1) and decode_upper_alu_operation_valid_reg;
					alu_abs_in_tvalid <= decode_upper_alu_operation_reg(2) and decode_upper_alu_operation_valid_reg;
					registers_port_vfd_write <= '1' and decode_upper_alu_operation_valid_reg;
				end if;
			
				-- lower
				if registers_port_via_pending = '1' or (decode_lower_immediate_valid_reg = '0' and registers_port_vib_pending = '1') or registers_port_vic_pending = '1' then
					registers_port_via_address <= decode_lower_operand_address1_reg;
					registers_port_vib_address <= decode_lower_operand_address2_reg;
					registers_port_vic_address <= decode_lower_destination_address_reg(3 downto 0);
					registers_port_vfe_address <= decode_lower_destination_address_reg(4 downto 0);
					
					decode_lower_operand_address1_reg_next <= decode_lower_operand_address1_reg;
					decode_lower_operand_address2_reg_next <= decode_lower_operand_address2_reg;
					decode_lower_destination_address_reg_next <= decode_lower_destination_address_reg;
					decode_lower_operation_reg_next <= decode_lower_operation_reg;
					decode_lower_operation_valid_reg_next <= decode_lower_operation_valid_reg;
					alu_int16_tuser_reg_next <= alu_int16_tuser_reg;
				else
					alu_add_int16_in_tvalid <= decode_lower_operation_reg(0) and decode_lower_operation_valid_reg;
					alu_sub_int16_in_tvalid <= decode_lower_operation_reg(1) and decode_lower_operation_valid_reg;
					registers_port_vic_write <= decode_lower_operation_valid_reg and not decode_lower_destination_address(5);
					registers_port_vfe_write <= decode_lower_operation_valid_reg and decode_lower_destination_address(5); 
				end if;
			end if;
		end if;
	end process;
end vpu_read_register_behavioral;
