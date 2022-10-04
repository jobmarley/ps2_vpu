
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity vpu_core is
	port (
		resetn : in std_logic;
		clock : in std_logic;
	
		m_axi_mem_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_axi_mem_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
		m_axi_mem_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_axi_mem_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
		m_axi_mem_arlock : out STD_LOGIC;
		m_axi_mem_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_axi_mem_arready : in STD_LOGIC;
		m_axi_mem_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_axi_mem_arvalid : out STD_LOGIC;
		m_axi_mem_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_axi_mem_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
		m_axi_mem_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_axi_mem_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
		m_axi_mem_awlock : out STD_LOGIC;
		m_axi_mem_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_axi_mem_awready : in STD_LOGIC;
		m_axi_mem_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_axi_mem_awvalid : out STD_LOGIC;
		m_axi_mem_bready : out STD_LOGIC;
		m_axi_mem_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_axi_mem_bvalid : in STD_LOGIC;
		m_axi_mem_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
		m_axi_mem_rlast : in STD_LOGIC;
		m_axi_mem_rready : out STD_LOGIC;
		m_axi_mem_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_axi_mem_rvalid : in STD_LOGIC;
		m_axi_mem_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
		m_axi_mem_wlast : out STD_LOGIC;
		m_axi_mem_wready : in STD_LOGIC;
		m_axi_mem_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_axi_mem_wvalid : out STD_LOGIC;
	
	
		m_axi_mem2_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_axi_mem2_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
		m_axi_mem2_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_axi_mem2_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
		m_axi_mem2_arlock : out STD_LOGIC;
		m_axi_mem2_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_axi_mem2_arready : in STD_LOGIC;
		m_axi_mem2_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_axi_mem2_arvalid : out STD_LOGIC;
		m_axi_mem2_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
		m_axi_mem2_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
		m_axi_mem2_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_axi_mem2_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
		m_axi_mem2_awlock : out STD_LOGIC;
		m_axi_mem2_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_axi_mem2_awready : in STD_LOGIC;
		m_axi_mem2_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
		m_axi_mem2_awvalid : out STD_LOGIC;
		m_axi_mem2_bready : out STD_LOGIC;
		m_axi_mem2_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_axi_mem2_bvalid : in STD_LOGIC;
		m_axi_mem2_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
		m_axi_mem2_rlast : in STD_LOGIC;
		m_axi_mem2_rready : out STD_LOGIC;
		m_axi_mem2_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
		m_axi_mem2_rvalid : in STD_LOGIC;
		m_axi_mem2_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
		m_axi_mem2_wlast : out STD_LOGIC;
		m_axi_mem2_wready : in STD_LOGIC;
		m_axi_mem2_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
		m_axi_mem2_wvalid : out STD_LOGIC;
	
		debug : out std_logic_vector(7 downto 0)
	 );
end vpu_core;

architecture vpu_core_behavioral of vpu_core is
	component vpu_alu is
		port (
			resetn : in std_logic;
			clock : in std_logic;
			enable : in std_logic;
	
			add_in_tvalid : in std_logic;
			add_in_tdata : in std_logic_vector(255 downto 0);
			add_in_tuser : in std_logic_vector(8 downto 0);
			add_out_tvalid : out std_logic;
			add_out_tdata : out std_logic_vector(127 downto 0);
			add_out_tuser : out std_logic_vector(8 downto 0);
	
			sub_in_tvalid : in std_logic;
			sub_in_tdata : in std_logic_vector(255 downto 0);
			sub_in_tuser : in std_logic_vector(8 downto 0);
			sub_out_tvalid : out std_logic;
			sub_out_tdata : out std_logic_vector(127 downto 0);
			sub_out_tuser : out std_logic_vector(8 downto 0);
	
			abs_in_tvalid : in std_logic;
			abs_in_tdata : in std_logic_vector(127 downto 0);
			abs_in_tuser : in std_logic_vector(8 downto 0);
			abs_out_tvalid : out std_logic;
			abs_out_tdata : out std_logic_vector(127 downto 0);
			abs_out_tuser : out std_logic_vector(8 downto 0);
	
			-- INTEGERS
			add_int16_in_tvalid : in std_logic;
			add_int16_in_tdata : in std_logic_vector(31 downto 0);
			add_int16_in_tuser : in std_logic_vector(8 downto 0);
			add_int16_out_tvalid : out std_logic;
			add_int16_out_tdata : out std_logic_vector(15 downto 0);
			add_int16_out_tuser : out std_logic_vector(8 downto 0);
	
			sub_int16_in_tvalid : in std_logic;
			sub_int16_in_tdata : in std_logic_vector(31 downto 0);
			sub_int16_in_tuser : in std_logic_vector(8 downto 0);
			sub_int16_out_tvalid : out std_logic;
			sub_int16_out_tdata : out std_logic_vector(15 downto 0);
			sub_int16_out_tuser : out std_logic_vector(8 downto 0)
		);
	end component;
	
	component vpu_decode is
		port (
			resetn : in std_logic;
			clock : in std_logic;
			enable : in std_logic;
	
			instruction_data : in std_logic_vector(63 downto 0);
			instruction_data_valid : in std_logic;
			instruction_data_ready : out std_logic;
	
			upper_operand_address1 : out std_logic_vector(4 downto 0);
			upper_operand_address2 : out std_logic_vector(4 downto 0);
			--operand_address2_valid : out std_logic;
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
	end component;
	
	component vpu_registers is
		port (
			resetn : in std_logic;
			clock : in std_logic;
	
			-- FLOATING PORTS
			port_vfa_address : in std_logic_vector(4 downto 0);
			port_vfa_data : out std_logic_vector(127 downto 0);
			port_vfa_pending : out std_logic;
	
			port_vfb_address : in std_logic_vector(4 downto 0);
			port_vfb_data : out std_logic_vector(127 downto 0);
			port_vfb_pending : out std_logic;
	
			port_vfc_address : in std_logic_vector(4 downto 0);
			port_vfc_write_data : in std_logic_vector(127 downto 0);
			port_vfc_write : in std_logic;
			port_vfc_write_strobe : in std_logic_vector(3 downto 0);
	
			port_vfd_address : in std_logic_vector(4 downto 0);
			port_vfd_pending : out std_logic;
			port_vfd_write : in std_logic;
			port_vfd_write_pending : in std_logic;
	
			port_vfe_address : in std_logic_vector(4 downto 0);
			port_vfe_data : out std_logic_vector(127 downto 0);
			port_vfe_pending : out std_logic;

			port_vff_address : in std_logic_vector(4 downto 0);
			port_vff_write_data : in std_logic_vector(127 downto 0);
			port_vff_write : in std_logic;
			port_vff_write_strobe : in std_logic_vector(3 downto 0);
	
			port_vfg_address : in std_logic_vector(4 downto 0);
			port_vfg_pending : out std_logic;
			port_vfg_write : in std_logic;
			port_vfg_write_pending : in std_logic;
	
				-- INTEGER PORTS
			port_via_address : in std_logic_vector(3 downto 0);
			port_via_data : out std_logic_vector(15 downto 0);
			port_via_pending : out std_logic;
	
			port_vib_address : in std_logic_vector(3 downto 0);
			port_vib_data : out std_logic_vector(15 downto 0);
			port_vib_pending : out std_logic;
	
			port_vic_address : in std_logic_vector(3 downto 0);
			port_vic_pending : out std_logic;
			port_vic_write : in std_logic;
			port_vic_write_pending : in std_logic;
	
			port_vid_address : in std_logic_vector(3 downto 0);
			port_vid_write_data : in std_logic_vector(15 downto 0);
			port_vid_write : in std_logic;
			--port_vid_write_strobe : in std_logic_vector(3 downto 0);
	
			port_vie_address : in std_logic_vector(3 downto 0);
			port_vie_write_data : in std_logic_vector(15 downto 0);
			port_vie_write : in std_logic
			--port_vie_write_strobe : in std_logic_vector(3 downto 0)
		);
	end component;

	component vpu_writeback is
		port (
			resetn : in std_logic;
			clock : in std_logic;
	
			-- register floating
			port_vfa_address : out std_logic_vector(4 downto 0);
			port_vfa_write_data : out std_logic_vector(127 downto 0);
			port_vfa_write : out std_logic;
			port_vfa_write_strobe : out std_logic_vector(3 downto 0);
			
			port_vfb_address : out std_logic_vector(4 downto 0);
			port_vfb_write_data : out std_logic_vector(127 downto 0);
			port_vfb_write : out std_logic;
			port_vfb_write_strobe : out std_logic_vector(3 downto 0);
	
			-- register integer
			port_via_address : out std_logic_vector(3 downto 0);
			port_via_write_data : out std_logic_vector(15 downto 0);
			port_via_write : out std_logic;
	
			port_vib_address : out std_logic_vector(3 downto 0);
			port_vib_write_data : out std_logic_vector(15 downto 0);
			port_vib_write : out std_logic;
	
			-- alu floating
			add_out_tvalid : in std_logic;
			add_out_tdata : in std_logic_vector(127 downto 0);
			add_out_tuser : in std_logic_vector(8 downto 0);
	
			-- alu integer
			alu_add_int16_out_tvalid : in std_logic;
			alu_add_int16_out_tdata : in std_logic_vector(15 downto 0);
			alu_add_int16_out_tuser : in std_logic_vector(8 downto 0);
	
			alu_sub_int16_out_tvalid : in std_logic;
			alu_sub_int16_out_tdata : in std_logic_vector(15 downto 0);
			alu_sub_int16_out_tuser : in std_logic_vector(8 downto 0);
	
			-- memory read
			read_data : in std_logic_vector(127 downto 0);
			read_data_register : in std_logic_vector(5 downto 0);
			read_data_valid : in std_logic;
			read_data_ready : out std_logic
		);
	end component;
	
	component vpu_read_register is
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
	end component;
	
	component vpu_instruction_reader is
		port(
			resetn : in std_logic;
			clock : in std_logic;
	
			m_axi_mem_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
			m_axi_mem_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
			m_axi_mem_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
			m_axi_mem_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
			m_axi_mem_arlock : out STD_LOGIC;
			m_axi_mem_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
			m_axi_mem_arready : in STD_LOGIC;
			m_axi_mem_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
			m_axi_mem_arvalid : out STD_LOGIC;
			m_axi_mem_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
			m_axi_mem_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
			m_axi_mem_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
			m_axi_mem_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
			m_axi_mem_awlock : out STD_LOGIC;
			m_axi_mem_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
			m_axi_mem_awready : in STD_LOGIC;
			m_axi_mem_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
			m_axi_mem_awvalid : out STD_LOGIC;
			m_axi_mem_bready : out STD_LOGIC;
			m_axi_mem_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
			m_axi_mem_bvalid : in STD_LOGIC;
			m_axi_mem_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
			m_axi_mem_rlast : in STD_LOGIC;
			m_axi_mem_rready : out STD_LOGIC;
			m_axi_mem_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
			m_axi_mem_rvalid : in STD_LOGIC;
			m_axi_mem_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
			m_axi_mem_wlast : out STD_LOGIC;
			m_axi_mem_wready : in STD_LOGIC;
			m_axi_mem_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
			m_axi_mem_wvalid : out STD_LOGIC;
	
			instruction_data : out std_logic_vector(63 downto 0);
			instruction_data_valid : out std_logic;
			instruction_data_ready : in std_logic;
		
			error : out std_logic
		);
	end component;
	
	component vpu_readmem is
		port(
			resetn : in std_logic;
			clock : in std_logic;
	
			read_address : in std_logic_vector(31 downto 0);
			read_address_valid : in std_logic;
			read_address_ready : out std_logic;
			read_address_register : in std_logic_vector(5 downto 0);
			read_data : out std_logic_vector(127 downto 0);
			read_data_register : out std_logic_vector(5 downto 0);
			read_data_valid : out std_logic;
			read_data_ready : in std_logic;
	
			m_axi_mem_araddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
			m_axi_mem_arburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
			m_axi_mem_arcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
			m_axi_mem_arlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
			m_axi_mem_arlock : out STD_LOGIC;
			m_axi_mem_arprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
			m_axi_mem_arready : in STD_LOGIC;
			m_axi_mem_arsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
			m_axi_mem_arvalid : out STD_LOGIC;
			m_axi_mem_awaddr : out STD_LOGIC_VECTOR ( 31 downto 0 );
			m_axi_mem_awburst : out STD_LOGIC_VECTOR ( 1 downto 0 );
			m_axi_mem_awcache : out STD_LOGIC_VECTOR ( 3 downto 0 );
			m_axi_mem_awlen : out STD_LOGIC_VECTOR ( 7 downto 0 );
			m_axi_mem_awlock : out STD_LOGIC;
			m_axi_mem_awprot : out STD_LOGIC_VECTOR ( 2 downto 0 );
			m_axi_mem_awready : in STD_LOGIC;
			m_axi_mem_awsize : out STD_LOGIC_VECTOR ( 2 downto 0 );
			m_axi_mem_awvalid : out STD_LOGIC;
			m_axi_mem_bready : out STD_LOGIC;
			m_axi_mem_bresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
			m_axi_mem_bvalid : in STD_LOGIC;
			m_axi_mem_rdata : in STD_LOGIC_VECTOR ( 63 downto 0 );
			m_axi_mem_rlast : in STD_LOGIC;
			m_axi_mem_rready : out STD_LOGIC;
			m_axi_mem_rresp : in STD_LOGIC_VECTOR ( 1 downto 0 );
			m_axi_mem_rvalid : in STD_LOGIC;
			m_axi_mem_wdata : out STD_LOGIC_VECTOR ( 63 downto 0 );
			m_axi_mem_wlast : out STD_LOGIC;
			m_axi_mem_wready : in STD_LOGIC;
			m_axi_mem_wstrb : out STD_LOGIC_VECTOR ( 3 downto 0 );
			m_axi_mem_wvalid : out STD_LOGIC;
		
			error : out std_logic
		);
	end component;

	----------------------------------------------------------
	-- alu
	----------------------------------------------------------
	signal alu_enable : std_logic;
	signal alu_add_in_tvalid : std_logic;
	signal alu_add_in_tdata : std_logic_vector(255 downto 0);
	signal alu_add_in_tuser : std_logic_vector(8 downto 0);
	signal alu_add_out_tvalid : std_logic;
	signal alu_add_out_tdata : std_logic_vector(127 downto 0);
	signal alu_add_out_tuser : std_logic_vector(8 downto 0);
	
	signal alu_sub_in_tvalid : std_logic;
	signal alu_sub_in_tdata : std_logic_vector(255 downto 0);
	signal alu_sub_in_tuser : std_logic_vector(8 downto 0);
	signal alu_sub_out_tvalid : std_logic;
	signal alu_sub_out_tdata : std_logic_vector(127 downto 0);
	signal alu_sub_out_tuser : std_logic_vector(8 downto 0);
	
	signal alu_abs_in_tvalid : std_logic;
	signal alu_abs_in_tdata : std_logic_vector(127 downto 0);
	signal alu_abs_in_tuser : std_logic_vector(8 downto 0);
	signal alu_abs_out_tvalid : std_logic;
	signal alu_abs_out_tdata : std_logic_vector(127 downto 0);
	signal alu_abs_out_tuser : std_logic_vector(8 downto 0);
	
	signal alu_add_int16_in_tvalid : std_logic;
	signal alu_add_int16_in_tdata : std_logic_vector(31 downto 0);
	signal alu_add_int16_in_tuser : std_logic_vector(8 downto 0);
	signal alu_add_int16_out_tvalid : std_logic;
	signal alu_add_int16_out_tdata : std_logic_vector(15 downto 0);
	signal alu_add_int16_out_tuser : std_logic_vector(8 downto 0);
	
	signal alu_sub_int16_in_tvalid : std_logic;
	signal alu_sub_int16_in_tdata : std_logic_vector(31 downto 0);
	signal alu_sub_int16_in_tuser : std_logic_vector(8 downto 0);
	signal alu_sub_int16_out_tvalid : std_logic;
	signal alu_sub_int16_out_tdata : std_logic_vector(15 downto 0);
	signal alu_sub_int16_out_tuser : std_logic_vector(8 downto 0);
	
	----------------------------------------------------------
	-- decode
	----------------------------------------------------------
	signal decode_enable : std_logic;
	signal decode_upper_instruction_data : std_logic_vector(63 downto 0);
	signal decode_upper_instruction_data_valid : std_logic;
	signal decode_upper_instruction_data_ready : std_logic;
	
	signal decode_upper_operand_address1 : std_logic_vector(4 downto 0);
	signal decode_upper_operand_address2 : std_logic_vector(4 downto 0);
	signal decode_lower_immediate : std_logic_vector(15 downto 0);
	signal decode_lower_immediate_valid : std_logic;
	--signal decode_upper_operand_address2_valid : std_logic;
	signal decode_upper_use_i : std_logic;
	signal decode_upper_update_i : std_logic;
	signal decode_upper_i_data : std_logic_vector(31 downto 0);
	signal decode_upper_destination_address : std_logic_vector(4 downto 0);
	signal decode_upper_destination_strobe : std_logic_vector(3 downto 0);
	
	signal decode_upper_operation : std_logic_vector(4 downto 0);
	signal decode_upper_operation_valid : std_logic;
	
	signal decode_lower_operand_address1 : std_logic_vector(3 downto 0);
	signal decode_lower_operand_address2 : std_logic_vector(3 downto 0);
	signal decode_lower_destination_address : std_logic_vector(5 downto 0);
	signal decode_lower_operation : std_logic_vector(7 downto 0);
	signal decode_lower_operation_valid : std_logic;
	
	----------------------------------------------------------
	-- registers
	----------------------------------------------------------
	signal registers_port_vfa_address : std_logic_vector(4 downto 0);
	signal registers_port_vfa_data : std_logic_vector(127 downto 0);
	signal registers_port_vfa_pending : std_logic;
	signal registers_port_vfb_address : std_logic_vector(4 downto 0);
	signal registers_port_vfb_data : std_logic_vector(127 downto 0);
	signal registers_port_vfb_pending : std_logic;
	
	signal registers_port_vfc_address : std_logic_vector(4 downto 0);
	signal registers_port_vfc_write_data : std_logic_vector(127 downto 0);
	signal registers_port_vfc_write : std_logic;
	signal registers_port_vfc_write_strobe : std_logic_vector(3 downto 0);
	
	signal registers_port_vfd_address : std_logic_vector(4 downto 0);
	signal registers_port_vfd_pending : std_logic;
	signal registers_port_vfd_write : std_logic;
	signal registers_port_vfd_write_pending : std_logic;
	
	signal registers_port_vfe_address : std_logic_vector(4 downto 0);
	signal registers_port_vfe_data : std_logic_vector(127 downto 0);
	signal registers_port_vfe_pending : std_logic;
	
	signal registers_port_vff_address : std_logic_vector(4 downto 0);
	signal registers_port_vff_write_data : std_logic_vector(127 downto 0);
	signal registers_port_vff_write : std_logic;
	signal registers_port_vff_write_strobe : std_logic_vector(3 downto 0);

	signal registers_port_vfg_address : std_logic_vector(4 downto 0);
	signal registers_port_vfg_pending : std_logic;
	signal registers_port_vfg_write : std_logic;
	signal registers_port_vfg_write_pending : std_logic;	
	
	signal registers_port_via_address : std_logic_vector(3 downto 0);
	signal registers_port_via_data : std_logic_vector(15 downto 0);
	signal registers_port_via_pending : std_logic;
	
	signal registers_port_vib_address : std_logic_vector(3 downto 0);
	signal registers_port_vib_data : std_logic_vector(15 downto 0);
	signal registers_port_vib_pending : std_logic;
	
	signal registers_port_vic_address : std_logic_vector(3 downto 0);
	signal registers_port_vic_pending : std_logic;
	signal registers_port_vic_write : std_logic;
	signal registers_port_vic_write_pending : std_logic;
	
	signal registers_port_vid_address : std_logic_vector(3 downto 0);
	signal registers_port_vid_write_data : std_logic_vector(15 downto 0);
	signal registers_port_vid_write : std_logic;
	--signal registers_port_vid_write_strobe : std_logic_vector(3 downto 0);
	
	signal registers_port_vie_address : std_logic_vector(3 downto 0);
	signal registers_port_vie_write_data : std_logic_vector(15 downto 0);
	signal registers_port_vie_write : std_logic;
	--signal registers_port_vie_write_strobe : std_logic_vector(3 downto 0);
	
	----------------------------------------------------------
	-- register read
	----------------------------------------------------------
	signal readreg_enable : std_logic;
	signal readreg_stall : std_logic;
	
	----------------------------------------------------------
	-- readmem
	----------------------------------------------------------	
	signal readmem_read_address : std_logic_vector(31 downto 0);
	signal readmem_read_address_valid : std_logic;
	signal readmem_read_address_ready : std_logic;
	signal readmem_read_address_register : std_logic_vector(5 downto 0);
	signal readmem_read_data : std_logic_vector(127 downto 0);
	signal readmem_read_data_register : std_logic_vector(5 downto 0);
	signal readmem_read_data_valid : std_logic;
	signal readmem_read_data_ready : std_logic;
	
begin
	debug <= registers_port_vfe_data(127) & registers_port_vfe_data(96) & registers_port_vfe_data(95) & registers_port_vfe_data(64) & registers_port_vfe_data(63) & registers_port_vfe_data(32) & registers_port_vfe_data(31) & registers_port_vfe_data(0);
		
	--registers_port_vfa_address <= decode_upper_operand_address1;
	--registers_port_vfb_address <= decode_upper_operand_address2;
	registers_port_vfd_address <= decode_upper_destination_address;
	
	
	vpu_alu_i1 : vpu_alu port map(
		resetn => resetn,
		clock => clock,
		enable => alu_enable,
		
		add_in_tvalid => alu_add_in_tvalid,
		add_in_tdata => alu_add_in_tdata,
		add_in_tuser => alu_add_in_tuser,
		add_out_tvalid => alu_add_out_tvalid,
		add_out_tdata => alu_add_out_tdata,
		add_out_tuser => alu_add_out_tuser,
	
		sub_in_tvalid => alu_sub_in_tvalid,
		sub_in_tdata => alu_sub_in_tdata,
		sub_in_tuser => alu_sub_in_tuser,
		sub_out_tvalid => alu_sub_out_tvalid,
		sub_out_tdata => alu_sub_out_tdata,
		sub_out_tuser => alu_sub_out_tuser,
	
		abs_in_tvalid => alu_abs_in_tvalid,
		abs_in_tdata => alu_abs_in_tdata,
		abs_in_tuser => alu_abs_in_tuser,
		abs_out_tvalid => alu_abs_out_tvalid,
		abs_out_tdata => alu_abs_out_tdata,
		abs_out_tuser => alu_abs_out_tuser,
	
		add_int16_in_tvalid => alu_add_int16_in_tvalid,
		add_int16_in_tdata => alu_add_int16_in_tdata,
		add_int16_in_tuser => alu_add_int16_in_tuser,
		add_int16_out_tvalid => alu_add_int16_out_tvalid,
		add_int16_out_tdata => alu_add_int16_out_tdata,
		add_int16_out_tuser => alu_add_int16_out_tuser,
	
		sub_int16_in_tvalid => alu_sub_int16_in_tvalid,
		sub_int16_in_tdata => alu_sub_int16_in_tdata,
		sub_int16_in_tuser => alu_sub_int16_in_tuser,
		sub_int16_out_tvalid => alu_sub_int16_out_tvalid,
		sub_int16_out_tdata => alu_sub_int16_out_tdata,
		sub_int16_out_tuser => alu_sub_int16_out_tuser
		);
	
	vpu_decode_upper_i1 : vpu_decode port map(
		resetn => resetn,
		clock => clock,
		enable => decode_enable,
		
		instruction_data => decode_upper_instruction_data,
		instruction_data_valid => decode_upper_instruction_data_valid,
		instruction_data_ready => decode_upper_instruction_data_ready,
	
		upper_operand_address1 => decode_upper_operand_address1,
		upper_operand_address2 => decode_upper_operand_address2,
		--upper_operand_address2_valid => decode_upper_operand_address2_valid,
		upper_use_i => decode_upper_use_i,
		upper_write_i => decode_upper_update_i,
		upper_write_i_data => decode_upper_i_data,
		upper_destination_address => decode_upper_destination_address,
		upper_destination_strobe => decode_upper_destination_strobe,
		upper_operation => decode_upper_operation,
		upper_operation_valid => decode_upper_operation_valid,
	
		lower_operand_address1 => decode_lower_operand_address1,
		lower_operand_address2 => decode_lower_operand_address2,
		lower_immediate => decode_lower_immediate,
		lower_immediate_valid => decode_lower_immediate_valid,
		lower_destination_address => decode_lower_destination_address,
		lower_operation => decode_lower_operation,
		lower_operation_valid => decode_lower_operation_valid
		);
	
	vpu_registers_i1 : vpu_registers port map(
		resetn => resetn,
		clock => clock,
		
		port_vfa_address => registers_port_vfa_address,
		port_vfa_data => registers_port_vfa_data,
		port_vfa_pending => registers_port_vfa_pending,
	
		port_vfb_address => registers_port_vfb_address,
		port_vfb_data => registers_port_vfb_data,
		port_vfb_pending => registers_port_vfb_pending,
	
		port_vfc_address => registers_port_vfc_address,
		port_vfc_write_data => registers_port_vfc_write_data,
		port_vfc_write => registers_port_vfc_write,
		port_vfc_write_strobe => registers_port_vfc_write_strobe,
	
		port_vfd_address => registers_port_vfd_address,
		port_vfd_pending => registers_port_vfd_pending,
		port_vfd_write => registers_port_vfd_write,
		port_vfd_write_pending => registers_port_vfd_write_pending,
		
		port_vfe_address => registers_port_vfe_address,
		port_vfe_data => registers_port_vfe_data,
		port_vfe_pending => registers_port_vfe_pending,
	
		port_vff_address => registers_port_vff_address,
		port_vff_write_data => registers_port_vff_write_data,
		port_vff_write => registers_port_vff_write,
		port_vff_write_strobe => registers_port_vff_write_strobe,
	
		port_vfg_address => registers_port_vfg_address,
		port_vfg_pending => registers_port_vfg_pending,
		port_vfg_write => registers_port_vfg_write,
		port_vfg_write_pending => registers_port_vfg_write_pending,
	
		port_via_address => registers_port_via_address,
		port_via_data => registers_port_via_data,
		port_via_pending => registers_port_via_pending,
	
		port_vib_address => registers_port_vib_address,
		port_vib_data => registers_port_vib_data,
		port_vib_pending => registers_port_vib_pending,
		
		port_vic_address => registers_port_vic_address,
		port_vic_pending => registers_port_vic_pending,
		port_vic_write => registers_port_vic_write,
		port_vic_write_pending => registers_port_vic_write_pending,
	
		port_vid_address => registers_port_vid_address,
		port_vid_write_data => registers_port_vid_write_data,
		port_vid_write => registers_port_vid_write,
		--port_vid_write_strobe : in std_logic_vector(3 downto 0);
	
		port_vie_address => registers_port_vie_address,
		port_vie_write_data => registers_port_vie_write_data,
		port_vie_write => registers_port_vie_write
		--port_vie_write_strobe : in std_logic_vector(3 downto 0)
		);
	
	vpu_writeback_i1 : vpu_writeback port map(
		resetn => resetn,
		clock => clock,
		
		port_vfa_address => registers_port_vfc_address,
		port_vfa_write_data => registers_port_vfc_write_data,
		port_vfa_write => registers_port_vfc_write,
		port_vfa_write_strobe => registers_port_vfc_write_strobe,

		port_vfb_address => registers_port_vff_address,
		port_vfb_write_data => registers_port_vff_write_data,
		port_vfb_write => registers_port_vff_write,
		port_vfb_write_strobe => registers_port_vff_write_strobe,
		
		-- register integer
		port_via_address => registers_port_vid_address,
		port_via_write_data => registers_port_vid_write_data,
		port_via_write => registers_port_vid_write,
	
		port_vib_address => registers_port_vie_address,
		port_vib_write_data => registers_port_vie_write_data,
		port_vib_write => registers_port_vie_write,

		-- alu floating	
		add_out_tvalid => alu_add_out_tvalid,
		add_out_tdata => alu_add_out_tdata,
		add_out_tuser => alu_add_out_tuser,
	
		-- alu integer
	    alu_add_int16_out_tvalid => alu_add_int16_out_tvalid and not alu_add_int16_out_tuser(6),
	    alu_add_int16_out_tdata => alu_add_int16_out_tdata,
	    alu_add_int16_out_tuser => alu_add_int16_out_tuser,
	
	    alu_sub_int16_out_tvalid => alu_sub_int16_out_tvalid,
	    alu_sub_int16_out_tdata => alu_sub_int16_out_tdata,
	    alu_sub_int16_out_tuser => alu_sub_int16_out_tuser,
	
		-- memory read
		read_data => readmem_read_data,
		read_data_register => readmem_read_data_register,
		read_data_valid => readmem_read_data_valid,
		read_data_ready => readmem_read_data_ready
		);
	
	vpu_read_register_i1 : vpu_read_register port map(
		resetn => resetn,
		clock => clock,
		enable => readreg_enable,
		
		decode_upper_operand_address1 => decode_upper_operand_address1,
		decode_upper_operand_address2 => decode_upper_operand_address2,
		--decode_upper_operand_address2_valid => decode_upper_operand_address2_valid,
		decode_upper_use_i => decode_upper_use_i,
		--decode_upper_update_i => decode_upper_update_i,
		--decode_upper_i_data => decode_upper_i_data,
		decode_upper_destination_address => decode_upper_destination_address,
		decode_upper_destination_strobe => decode_upper_destination_strobe,
	
		decode_upper_alu_operation => decode_upper_operation,
		decode_upper_alu_operation_valid => decode_upper_operation_valid,
	
	
		registers_port_vfa_address => registers_port_vfa_address,
		registers_port_vfa_data => registers_port_vfa_data,
		registers_port_vfa_pending => registers_port_vfa_pending,
	
		registers_port_vfb_address => registers_port_vfb_address,
		registers_port_vfb_data => registers_port_vfb_data,
		registers_port_vfb_pending => registers_port_vfb_pending,
	
		registers_port_vfd_address => registers_port_vfd_address,
		registers_port_vfd_pending => registers_port_vfd_pending,
		registers_port_vfd_write => registers_port_vfd_write,
		registers_port_vfd_write_pending => registers_port_vfd_write_pending,
	
		registers_port_vfe_address => registers_port_vfg_address,
		registers_port_vfe_pending => registers_port_vfg_pending,
		registers_port_vfe_write => registers_port_vfg_write,
		registers_port_vfe_write_pending => registers_port_vfg_write_pending,
	
	
		alu_add_in_tvalid => alu_add_in_tvalid,
		alu_add_in_tdata => alu_add_in_tdata,
		alu_add_in_tuser => alu_add_in_tuser,
	
		alu_sub_in_tvalid => alu_sub_in_tvalid,
		alu_sub_in_tdata => alu_sub_in_tdata,
		alu_sub_in_tuser => alu_sub_in_tuser,
	
		alu_abs_in_tvalid => alu_abs_in_tvalid,
		alu_abs_in_tdata => alu_abs_in_tdata,
		alu_abs_in_tuser => alu_abs_in_tuser,
	
	    alu_add_int16_in_tvalid => alu_add_int16_in_tvalid,
	    alu_add_int16_in_tdata => alu_add_int16_in_tdata,
	    alu_add_int16_in_tuser => alu_add_int16_in_tuser,
	
	    alu_sub_int16_in_tvalid => alu_sub_int16_in_tvalid,
	    alu_sub_int16_in_tdata => alu_sub_int16_in_tdata,
	    alu_sub_int16_in_tuser => alu_sub_int16_in_tuser,
	
		-- LOWER
		decode_lower_operand_address1 => decode_lower_operand_address1,
		decode_lower_operand_address2 => decode_lower_operand_address2,
		decode_lower_immediate => decode_lower_immediate,
		decode_lower_immediate_valid => decode_lower_immediate_valid,
		decode_lower_destination_address => decode_lower_destination_address,
	
		decode_lower_operation => decode_lower_operation,
		decode_lower_operation_valid => decode_lower_operation_valid,
	
	
		registers_port_via_address => registers_port_via_address,
		registers_port_via_data => registers_port_via_data,
		registers_port_via_pending => registers_port_via_pending,
	
		registers_port_vib_address => registers_port_vib_address,
		registers_port_vib_data => registers_port_vib_data,
		registers_port_vib_pending => registers_port_vib_pending,
	
		registers_port_vic_address => registers_port_vic_address,
		registers_port_vic_pending => registers_port_vic_pending,
		registers_port_vic_write => registers_port_vic_write,
		registers_port_vic_write_pending => registers_port_vic_write_pending,
	
		stall => readreg_stall
		);
	
	
	vpu_instruction_reader_i1 : vpu_instruction_reader port map(
		resetn => resetn,
		clock => clock,
	
		m_axi_mem_araddr => m_axi_mem_araddr,
		m_axi_mem_arburst => m_axi_mem_arburst,
		m_axi_mem_arcache => m_axi_mem_arcache,
		m_axi_mem_arlen => m_axi_mem_arlen,
		m_axi_mem_arlock => m_axi_mem_arlock,
		m_axi_mem_arprot => m_axi_mem_arprot,
		m_axi_mem_arready => m_axi_mem_arready,
		m_axi_mem_arsize => m_axi_mem_arsize,
		m_axi_mem_arvalid => m_axi_mem_arvalid,
		m_axi_mem_awaddr => m_axi_mem_awaddr,
		m_axi_mem_awburst => m_axi_mem_awburst,
		m_axi_mem_awcache => m_axi_mem_awcache,
		m_axi_mem_awlen => m_axi_mem_awlen,
		m_axi_mem_awlock => m_axi_mem_awlock,
		m_axi_mem_awprot => m_axi_mem_awprot,
		m_axi_mem_awready => m_axi_mem_awready,
		m_axi_mem_awsize => m_axi_mem_awsize,
		m_axi_mem_awvalid => m_axi_mem_awvalid,
		m_axi_mem_bready => m_axi_mem_bready,
		m_axi_mem_bresp => m_axi_mem_bresp,
		m_axi_mem_bvalid => m_axi_mem_bvalid,
		m_axi_mem_rdata => m_axi_mem_rdata,
		m_axi_mem_rlast => m_axi_mem_rlast,
		m_axi_mem_rready => m_axi_mem_rready,
		m_axi_mem_rresp => m_axi_mem_rresp,
		m_axi_mem_rvalid => m_axi_mem_rvalid,
		m_axi_mem_wdata => m_axi_mem_wdata,
		m_axi_mem_wlast => m_axi_mem_wlast,
		m_axi_mem_wready => m_axi_mem_wready,
		m_axi_mem_wstrb => m_axi_mem_wstrb,
		m_axi_mem_wvalid => m_axi_mem_wvalid,
	
		instruction_data => decode_upper_instruction_data,
		instruction_data_valid => decode_upper_instruction_data_valid, 
		instruction_data_ready => decode_upper_instruction_data_ready
	);
	
	decode_enable <= (readmem_read_address_ready or not readmem_read_address_valid) and not readreg_stall;
	alu_enable <= readmem_read_address_ready or not readmem_read_address_valid;
	readreg_enable <= readmem_read_address_ready or not readmem_read_address_valid;
	
	readmem_read_address <= x"000" & alu_add_int16_out_tdata & x"0";
	readmem_read_address_valid <= alu_add_int16_out_tvalid and alu_add_int16_out_tuser(6);
	readmem_read_address_register <= alu_add_int16_out_tuser(5 downto 0);
	vpu_readmem_i0 : vpu_readmem port map(
			resetn => resetn,
			clock => clock,
	
			read_address => readmem_read_address,
			read_address_valid => readmem_read_address_valid,
			read_address_ready => readmem_read_address_ready,
			read_address_register => readmem_read_address_register,
			read_data => readmem_read_data,
			read_data_register => readmem_read_data_register,
			read_data_valid => readmem_read_data_valid,
			read_data_ready => readmem_read_data_ready,
	
			m_axi_mem_araddr => m_axi_mem2_araddr,
			m_axi_mem_arburst => m_axi_mem2_arburst,
			m_axi_mem_arcache => m_axi_mem2_arcache,
			m_axi_mem_arlen => m_axi_mem2_arlen,
			m_axi_mem_arlock => m_axi_mem2_arlock,
			m_axi_mem_arprot => m_axi_mem2_arprot,
			m_axi_mem_arready => m_axi_mem2_arready,
			m_axi_mem_arsize => m_axi_mem2_arsize,
			m_axi_mem_arvalid => m_axi_mem2_arvalid,
			m_axi_mem_awaddr => m_axi_mem2_awaddr,
			m_axi_mem_awburst => m_axi_mem2_awburst,
			m_axi_mem_awcache => m_axi_mem2_awcache,
			m_axi_mem_awlen => m_axi_mem2_awlen,
			m_axi_mem_awlock => m_axi_mem2_awlock,
			m_axi_mem_awprot => m_axi_mem2_awprot,
			m_axi_mem_awready => m_axi_mem2_awready,
			m_axi_mem_awsize => m_axi_mem2_awsize,
			m_axi_mem_awvalid => m_axi_mem2_awvalid,
			m_axi_mem_bready => m_axi_mem2_bready,
			m_axi_mem_bresp => m_axi_mem2_bresp,
			m_axi_mem_bvalid => m_axi_mem2_bvalid,
			m_axi_mem_rdata => m_axi_mem2_rdata,
			m_axi_mem_rlast => m_axi_mem2_rlast,
			m_axi_mem_rready => m_axi_mem2_rready,
			m_axi_mem_rresp => m_axi_mem2_rresp,
			m_axi_mem_rvalid => m_axi_mem2_rvalid,
			m_axi_mem_wdata => m_axi_mem2_wdata,
			m_axi_mem_wlast => m_axi_mem2_wlast,
			m_axi_mem_wready => m_axi_mem2_wready,
			m_axi_mem_wstrb => m_axi_mem2_wstrb,
			m_axi_mem_wvalid => m_axi_mem2_wvalid
		);
end vpu_core_behavioral;
