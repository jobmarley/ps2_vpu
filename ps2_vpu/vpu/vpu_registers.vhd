
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;


entity vpu_registers is
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
end vpu_registers;

architecture vpu_registers_behavioral of vpu_registers is
	----------------------------------------------------------------
	-- FLOATING PORTS
	----------------------------------------------------------------
	subtype slv129 is std_logic_vector(128 downto 0);
    TYPE slv129_array IS ARRAY ( NATURAL RANGE <> ) OF slv129;
	signal vf_registers : slv129_array(31 downto 0);
	signal vf_registers_next : slv129_array(31 downto 0);
		
	signal port_vfa_data_reg : slv129;
	signal port_vfa_data_reg_next : slv129;
	signal port_vfb_data_reg : slv129;
	signal port_vfb_data_reg_next : slv129;
	signal port_vfe_data_reg : slv129;
	signal port_vfe_data_reg_next : slv129;
	signal port_vfd_pending_reg : std_logic;
	signal port_vfd_pending_reg_next : std_logic;
	signal port_vfg_pending_reg : std_logic;
	signal port_vfg_pending_reg_next : std_logic;
	
	----------------------------------------------------------------
	-- INTEGER PORTS
	----------------------------------------------------------------
	subtype slv17 is std_logic_vector(16 downto 0);
	type slv17_array is array (NATURAL range <>) of slv17;
	signal vi_registers : slv17_array(15 downto 0);
	signal vi_registers_next : slv17_array(15 downto 0);
	
	signal port_via_data_reg : slv17;
	signal port_via_data_reg_next : slv17;
	signal port_vib_data_reg : slv17;
	signal port_vib_data_reg_next : slv17;
	signal port_vic_pending_reg : std_logic;
	signal port_vic_pending_reg_next : std_logic;
begin

	port_vfa_data <= port_vfa_data_reg(127 downto 0);
	port_vfa_pending <= port_vfa_data_reg(128);
	port_vfb_data <= port_vfb_data_reg(127 downto 0);
	port_vfb_pending <= port_vfb_data_reg(128);
	port_vfe_data <= port_vfe_data_reg(127 downto 0);
	port_vfe_pending <= port_vfe_data_reg(128);
	port_vfd_pending <= port_vfd_pending_reg;
	port_vfg_pending <= port_vfg_pending_reg;
	
	port_via_data <= port_via_data_reg(15 downto 0);
	port_via_pending <= port_via_data_reg(16);
	port_vib_data <= port_vib_data_reg(15 downto 0);
	port_vib_pending <= port_vib_data_reg(16);
	port_vic_pending <= port_vic_pending_reg;
	
	vi_registers(0) <= (others => '0');
	
	process(clock)
	begin
		if rising_edge(clock) then
			vf_registers <= vf_registers_next;
			port_vfa_data_reg <= port_vfa_data_reg_next;
			port_vfb_data_reg <= port_vfb_data_reg_next;
			port_vfe_data_reg <= port_vfe_data_reg_next;
			port_vfd_pending_reg <= port_vfd_pending_reg_next;
			port_vfg_pending_reg <= port_vfg_pending_reg_next;
			
			vi_registers(15 downto 1) <= vi_registers_next(15 downto 1);
			port_via_data_reg <= port_via_data_reg_next;
			port_vib_data_reg <= port_vib_data_reg_next;
			port_vic_pending_reg <= port_vic_pending_reg_next;
		end if;
	end process;
	
	process(
		resetn,
		
		vf_registers,
		
		port_vfa_address,
		port_vfa_data_reg,
		
		port_vfb_address,
		port_vfb_data_reg,
		
		port_vfc_address,
		port_vfc_write_data,
		port_vfc_write,
		port_vfc_write_strobe,
		
		port_vfd_address,
		port_vfd_write,
		port_vfd_write_pending,
		port_vfd_pending_reg,
		
		port_vfe_address,
		port_vfe_data_reg,
		
		port_vff_address,
		port_vff_write,
		port_vff_write_data,
		port_vff_write_strobe,
	
		port_vfg_address,
		port_vfg_write,
		port_vfg_write_pending,
		port_vfg_pending_reg,
		
		vi_registers,
		
		port_via_address,
		port_via_data_reg,
		
		port_vib_address,
		port_vib_data_reg,
		
		port_vid_address,
		port_vid_write,
		port_vid_write_data,
	
		port_vie_address,
		port_vie_write,
		port_vie_write_data,
		
		port_vic_address,
		port_vic_write,
		port_vic_write_pending,
		port_vic_pending_reg
		)
	begin
		
		vf_registers_next <= vf_registers;
		vi_registers_next <= vi_registers;
		port_vfa_data_reg_next <= port_vfa_data_reg;
		port_vfb_data_reg_next <= port_vfb_data_reg;
		port_vfe_data_reg_next <= port_vfe_data_reg;
		port_vfd_pending_reg_next <= port_vfd_pending_reg;
		port_vfg_pending_reg_next <= port_vfg_pending_reg;
		
		port_via_data_reg_next <= port_via_data_reg;
		port_vib_data_reg_next <= port_vib_data_reg;
		port_vic_pending_reg_next <= port_vic_pending_reg;
		
		if resetn = '0' then
			vf_registers_next <= (others => (others => '0'));
			port_vfa_data_reg_next <= (others => '0');
			port_vfb_data_reg_next <= (others => '0');
			port_vfe_data_reg_next <= (others => '0');
			port_vfd_pending_reg_next <= '0';
			port_vfg_pending_reg_next <= '0';
	
			vi_registers_next <= (others => (others => '0'));
			port_via_data_reg_next <= (others => '0');
			port_vib_data_reg_next <= (others => '0');
			port_vic_pending_reg_next <= '0';
		else
			----------------------------------------------------------------
			-- FLOATING PORTS
			----------------------------------------------------------------
			port_vfa_data_reg_next <= vf_registers(TO_INTEGER(UNSIGNED(port_vfa_address)));
			port_vfb_data_reg_next <= vf_registers(TO_INTEGER(UNSIGNED(port_vfb_address)));
			port_vfe_data_reg_next <= vf_registers(TO_INTEGER(UNSIGNED(port_vfe_address)));
			port_vfd_pending_reg_next <= vf_registers(TO_INTEGER(UNSIGNED(port_vfd_address)))(128);
			port_vfg_pending_reg_next <= vf_registers(TO_INTEGER(UNSIGNED(port_vfg_address)))(128);
			
			if port_vfc_write = '1' then
				for i in 0 to 3 loop
					if port_vfc_write_strobe(i) = '1' then
						vf_registers_next(TO_INTEGER(UNSIGNED(port_vfc_address)))((32 * i + 31) downto (32 * i)) <= port_vfc_write_data((32 * i + 31) downto (32 * i));
					end if;
				end loop;
				vf_registers_next(TO_INTEGER(UNSIGNED(port_vfc_address)))(128) <= '0';
			end if;
			
			if port_vfd_write = '1' then
				vf_registers_next(TO_INTEGER(UNSIGNED(port_vfd_address)))(128) <= port_vfd_write_pending;
			end if;
			
			if port_vff_write = '1' then
				for i in 0 to 3 loop
					if port_vff_write_strobe(i) = '1' then
						vf_registers_next(TO_INTEGER(UNSIGNED(port_vff_address)))((32 * i + 31) downto (32 * i)) <= port_vff_write_data((32 * i + 31) downto (32 * i));
					end if;
				end loop;
				vf_registers_next(TO_INTEGER(UNSIGNED(port_vff_address)))(128) <= '0';
			end if;
						
			if port_vfg_write = '1' then
				vf_registers_next(TO_INTEGER(UNSIGNED(port_vfg_address)))(128) <= port_vfg_write_pending;
			end if;
			
			----------------------------------------------------------------
			-- INTEGER PORTS
			----------------------------------------------------------------
			port_via_data_reg_next <= vi_registers(TO_INTEGER(UNSIGNED(port_via_address)));
			port_vib_data_reg_next <= vi_registers(TO_INTEGER(UNSIGNED(port_vib_address)));
			port_vic_pending_reg_next <= vi_registers(TO_INTEGER(UNSIGNED(port_vic_address)))(16);
			
			
			if port_vic_write = '1' then
				vi_registers_next(TO_INTEGER(UNSIGNED(port_vic_address)))(16) <= port_vic_write_pending;
			end if;
			
			if port_vid_write = '1' then
				vi_registers_next(TO_INTEGER(UNSIGNED(port_vid_address))) <= '0' & port_vid_write_data;
			end if;
			if port_vie_write = '1' then
				vi_registers_next(TO_INTEGER(UNSIGNED(port_vie_address))) <= '0' & port_vie_write_data;
			end if;
			
		end if;
	end process;

end vpu_registers_behavioral;
