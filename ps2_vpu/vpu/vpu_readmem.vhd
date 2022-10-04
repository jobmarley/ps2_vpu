library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;
use work.vpu_utils.all;


entity vpu_readmem is
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
end vpu_readmem;

architecture vpu_readmem_behavioral of vpu_readmem is
	signal data_reg : std_logic_vector(127 downto 0);
	signal data_reg_next : std_logic_vector(127 downto 0);
	signal data_valid_reg : std_logic;
	signal data_valid_reg_next : std_logic;
	signal data_register_reg : std_logic_vector(5 downto 0);
	signal data_register_reg_next : std_logic_vector(5 downto 0);
	
	type state_t is (state_read_address, state_read_address2, state_read_data, state_read_data2);
	signal state : state_t;
	signal state_next : state_t;
	signal read_address_reg : std_logic_vector(31 downto 0);
	signal read_address_reg_next : std_logic_vector(31 downto 0);
begin
	read_data <= data_reg;
	read_data_valid <= data_valid_reg;
	read_data_register <= data_register_reg;
	
	process(clock)
	begin
		if rising_edge(clock) then
			data_reg <= data_reg_next;
			data_valid_reg <= data_valid_reg_next;
			state <= state_next;
			data_register_reg <= data_register_reg_next;
			read_address_reg <= read_address_reg_next;
		end if;
	end process;

	process(
		resetn,
	
		state,
		
		data_reg,
		data_valid_reg,
		data_register_reg,
		read_data_ready,
		read_address_register,
		read_address,
		read_address_reg,
		read_address_valid,
		
	
		m_axi_mem_arready,
		m_axi_mem_rvalid,
		m_axi_mem_rdata,
		m_axi_mem_rresp,
		m_axi_mem_rlast
		
		)
	begin
		m_axi_mem_awaddr <= (others => '0');
		m_axi_mem_awprot <= (others => '0');
		m_axi_mem_awvalid <= '0';
		m_axi_mem_wdata <= (others => '0');
		m_axi_mem_wstrb <= (others => '0');
		m_axi_mem_wvalid <= '0';
		m_axi_mem_bready <= '0';
		m_axi_mem_araddr <= (others => '0');
		m_axi_mem_arprot <= (others => '0');
		m_axi_mem_arvalid <= '0';
		m_axi_mem_rready <= '0';
		
		m_axi_mem_arburst <= "01";
		m_axi_mem_arcache <= (others => '0');
		m_axi_mem_arlen <= (others => '0');
		m_axi_mem_arlock <= '0';
		m_axi_mem_arprot <= (others => '0');
		m_axi_mem_arsize <= "011";
		m_axi_mem_awburst <= (others => '0');
		m_axi_mem_awcache <= (others => '0');
		m_axi_mem_awlen <= (others => '0');
		m_axi_mem_awlock <= '0';
		m_axi_mem_awprot <= (others => '0');
		m_axi_mem_awsize <= (others => '0');
		m_axi_mem_wlast <= '0';
		
		data_reg_next <= data_reg;
		state_next <= state;
		data_register_reg_next <= data_register_reg;
		read_address_reg_next <= read_address_reg;
		
		error <= '0';
		
		data_valid_reg_next <= data_valid_reg and not read_data_ready;
		
		read_address_ready <= '0';
		
		if resetn = '0' then
			data_reg_next <= (others => '0');
			data_valid_reg_next <= '0';
			read_address_reg_next <= (others => '0');
		else
			case state is
				when state_read_address =>
					read_address_ready <= '1';
					m_axi_mem_araddr <= read_address;
					read_address_reg_next <= read_address;
					m_axi_mem_arvalid <= read_address_valid;
					m_axi_mem_arlen <= "0000000" & read_address_register(5);
					data_register_reg_next <= read_address_register;
					if m_axi_mem_arready = '1' then
						state_next <= state_read_data;
					elsif read_address_valid = '1' then
						state_next <= state_read_address2;
					end if;
				when state_read_address2 =>
					read_address_ready <= '0';
					m_axi_mem_araddr <= read_address_reg;
					m_axi_mem_arvalid <= '1';
					m_axi_mem_arlen <= "0000000" & data_register_reg(5);
					if m_axi_mem_arready = '1' then
						state_next <= state_read_data;
					end if;
				when state_read_data =>
					if data_valid_reg = '0' or read_data_ready = '1' then
						m_axi_mem_rready <= '1';
						if m_axi_mem_rvalid = '1' then
							data_reg_next(63 downto 0) <= m_axi_mem_rdata;
							error <= m_axi_mem_rresp(1);
							if m_axi_mem_rlast = '1' then
								state_next <= state_read_address;
								data_valid_reg_next <= '1';
							else
								state_next <= state_read_data2;
							end if;
						end if;
					end if;
				when state_read_data2 =>
					m_axi_mem_rready <= '1';
					if m_axi_mem_rvalid = '1' then
						data_valid_reg_next <= '1';
						data_reg_next(127 downto 64) <= m_axi_mem_rdata;
						error <= m_axi_mem_rresp(1);
						state_next <= state_read_address;
					end if;
				when others =>
			end case;
		end if;
	end process;
end vpu_readmem_behavioral;
