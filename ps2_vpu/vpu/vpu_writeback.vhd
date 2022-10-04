
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.vpu_utils.all;

entity vpu_writeback is
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
end vpu_writeback;

architecture vpu_writeback_behavioral of vpu_writeback is
begin


	process(clock)
	begin
		if rising_edge(clock) then
		end if;
	end process;

	process(
		resetn,
		
		add_out_tvalid,
		add_out_tdata,
		add_out_tuser,
		
		read_data_valid,
		read_data_register,
		read_data,
		
		alu_add_int16_out_tvalid,
		alu_add_int16_out_tdata,
		alu_add_int16_out_tuser,
		alu_sub_int16_out_tvalid,
		alu_sub_int16_out_tuser,
		alu_sub_int16_out_tdata
		)
		variable vadd_user : alu_user_t;
	begin
		vadd_user := slv_to_alu_user(add_out_tuser);
		
		port_vfa_address <= (others => '0');
		port_vfa_write_data <= (others => '0');
		port_vfa_write_strobe <= (others => '0');
		port_vfa_write <= '0';
		
		port_vfb_address <= (others => '0');
		port_vfb_write_data <= (others => '0');
		port_vfb_write <= '0';
		port_vfb_write_strobe <= (others => '0');
		
		read_data_ready <= '0';
		
		port_via_address <= (others => '0');
		port_via_write_data <= (others => '0');
		port_via_write <= '0';
		
		port_vib_address <= (others => '0');
		port_vib_write_data <= (others => '0');
		port_vib_write <= '0';
		
		if resetn = '0' then
		else
			-- write add result to registers
			if add_out_tvalid = '1' then
				port_vfa_address <= vadd_user.fd;
				port_vfa_write_data <= add_out_tdata;
				port_vfa_write_strobe <= vadd_user.dest;
				port_vfa_write <= '1';
			end if;
			
			read_data_ready <= '1';
			if read_data_valid = '1' then
				if read_data_register(5) = '1' then
					port_vfb_address <= read_data_register(4 downto 0);
					port_vfb_write_data <= read_data(127 downto 0);
					port_vfb_write <= '1';
					port_vfb_write_strobe <= (others => '1');
				else
					port_via_address <= read_data_register(3 downto 0);
					port_via_write_data <= read_data(15 downto 0);
					port_via_write <= '1';
				end if;
			end if;
			
			-- we need only 1 port since they have the same latency
			-- the processor cannot issue 2 instructions at once
			if alu_add_int16_out_tvalid = '1' then
				vadd_user := slv_to_alu_user(alu_add_int16_out_tuser);
				port_vib_address <= vadd_user.fd(3 downto 0);
				port_vib_write_data <= alu_add_int16_out_tdata;
				port_vib_write <= '1' and not alu_add_int16_out_tuser(8);
			elsif alu_sub_int16_out_tvalid = '1' then
				vadd_user := slv_to_alu_user(alu_sub_int16_out_tuser);
				port_vib_address <= vadd_user.fd(3 downto 0);
				port_vib_write_data <= alu_sub_int16_out_tdata;
				port_vib_write <= '1' and not alu_add_int16_out_tuser(8);
			end if;
			
		end if;
	end process;
end vpu_writeback_behavioral;
