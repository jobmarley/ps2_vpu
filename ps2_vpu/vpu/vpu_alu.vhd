library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_std.all;

entity vpu_alu is
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
	
	    -- sub cannot be used as the same time as add !!!!
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
end vpu_alu;

architecture vpu_alu_behavioral of vpu_alu is
COMPONENT floating_point_0
  PORT (
    aclk : IN STD_LOGIC;
    aclken : IN STD_LOGIC;
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_a_tuser : IN STD_LOGIC_VECTOR(9 DOWNTO 0);
    s_axis_b_tvalid : IN STD_LOGIC;
    s_axis_b_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_operation_tvalid : IN STD_LOGIC;
    s_axis_operation_tdata : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tuser : OUT STD_LOGIC_VECTOR(9 DOWNTO 0)
  );
END COMPONENT;
	
COMPONENT floating_point_1
  PORT (
    s_axis_a_tvalid : IN STD_LOGIC;
    s_axis_a_tdata : IN STD_LOGIC_VECTOR(31 DOWNTO 0);
    s_axis_a_tuser : IN STD_LOGIC_VECTOR(8 DOWNTO 0);
    m_axis_result_tvalid : OUT STD_LOGIC;
    m_axis_result_tdata : OUT STD_LOGIC_VECTOR(31 DOWNTO 0);
    m_axis_result_tuser : OUT STD_LOGIC_VECTOR(8 DOWNTO 0)
  );
END COMPONENT;
	
COMPONENT c_addsub_1
  PORT (
    A : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    B : IN STD_LOGIC_VECTOR(15 DOWNTO 0);
    CLK : IN STD_LOGIC;
    ADD : IN STD_LOGIC;
    CE : IN STD_LOGIC;
    S : OUT STD_LOGIC_VECTOR(15 DOWNTO 0)
  );
END COMPONENT;

	
	----------------------------------------------------------
	-- add/sub
	----------------------------------------------------------
    signal add_sub_a_tdata : STD_LOGIC_VECTOR(127 DOWNTO 0);
    signal add_sub_b_tdata : STD_LOGIC_VECTOR(127 DOWNTO 0);
    signal add_sub_tuser : STD_LOGIC_VECTOR(8 DOWNTO 0);
    signal add_sub_tvalid : STD_LOGIC;
    signal add_sub_operation_tdata : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
    signal add_sub_result_tvalid : STD_LOGIC_VECTOR(3 downto 0);
    signal add_sub_result_tdata : STD_LOGIC_VECTOR(127 DOWNTO 0);
    signal add_sub_result_tuser : STD_LOGIC_VECTOR(39 DOWNTO 0);
	
	----------------------------------------------------------
	-- abs
	----------------------------------------------------------
	signal abs_result_tvalid : std_logic_vector(3 downto 0);
	signal abs_result_tdata : std_logic_vector(127 downto 0);
    signal abs_result_tuser : std_logic_vector(8 downto 0);
	
	----------------------------------------------------------
	-- addsub int16
	----------------------------------------------------------
	signal addsub_int16_a : std_logic_vector(15 downto 0);
	signal addsub_int16_b : std_logic_vector(15 downto 0);
	signal addsub_int16_result : std_logic_vector(15 downto 0);
	signal addsub_int16_operation : std_logic;
	type addsub_tuser_array is array (NATURAL range<>) of std_logic_vector(add_int16_in_tuser'LENGTH - 1 downto 0);
	constant addsub_int16_latency : NATURAL := 2;
	signal addsub_tuser_reg : addsub_tuser_array(addsub_int16_latency-1 downto 0);
	signal addsub_tvalid_reg : std_logic_vector(addsub_int16_latency-1 downto 0);
	signal addsub_operation_reg : std_logic_vector(addsub_int16_latency-1 downto 0);
begin
	
	add_out_tvalid <= add_sub_result_tvalid(0) and not add_sub_result_tuser(9);
	add_out_tdata <= add_sub_result_tdata;
	add_out_tuser <= add_sub_result_tuser(8 downto 0);
	
	sub_out_tvalid <= add_sub_result_tvalid(0) and add_sub_result_tuser(9);
	sub_out_tdata <= add_sub_result_tdata;
	sub_out_tuser <= add_sub_result_tuser(8 downto 0);
		
	abs_out_tvalid <= abs_result_tvalid(0);
	abs_out_tdata <= abs_result_tdata;
	abs_out_tuser <= abs_result_tuser;
	
	add_int16_out_tdata <= addsub_int16_result;
	add_int16_out_tvalid <= addsub_tvalid_reg(addsub_int16_latency-1) and addsub_operation_reg(addsub_int16_latency-1);
	add_int16_out_tuser <= addsub_tuser_reg(addsub_int16_latency-1);
	sub_int16_out_tdata <= addsub_int16_result;
	sub_int16_out_tvalid <= addsub_tvalid_reg(addsub_int16_latency-1) and not addsub_operation_reg(addsub_int16_latency-1);
	sub_int16_out_tuser <= addsub_tuser_reg(addsub_int16_latency-1);

	process (clock)
	begin
		if enable = '1' and rising_edge(clock) then
			addsub_tuser_reg(addsub_int16_latency-1 downto 1) <= addsub_tuser_reg(addsub_int16_latency-2 downto 0);
			if add_int16_in_tvalid = '1' then
				addsub_tuser_reg(0) <= add_int16_in_tuser;
			else
				addsub_tuser_reg(0) <= sub_int16_in_tuser;
			end if;
			addsub_tvalid_reg(addsub_int16_latency-1 downto 1) <= addsub_tvalid_reg(addsub_int16_latency-2 downto 0);
			addsub_tvalid_reg(0) <= add_int16_in_tvalid or sub_int16_in_tvalid;
			addsub_operation_reg(addsub_int16_latency-1 downto 1) <= addsub_operation_reg(addsub_int16_latency-2 downto 0);
			addsub_operation_reg(0) <= add_int16_in_tvalid;
		end if;
	end process;
		
	-- floating point add/sub management
	process(
		resetn,
		
		add_in_tvalid,
		add_in_tdata,
		add_in_tuser,
		
		sub_in_tvalid,
		sub_in_tdata,
		sub_in_tuser
	    )
	begin
		add_sub_tvalid <= '0';
		add_sub_a_tdata <= (others => '0');
		add_sub_b_tdata <= (others => '0');
		add_sub_tuser <= (others => '0');
		add_sub_operation_tdata <= (others => '0');
		
		if resetn = '0' then
		else
			if add_in_tvalid = '1' then
				add_sub_tvalid <= '1';
				add_sub_a_tdata <= add_in_tdata(127 downto 0);
				add_sub_b_tdata <= add_in_tdata(255 downto 128);
				add_sub_tuser <= add_in_tuser;
				add_sub_operation_tdata <= "00000000";
		    elsif sub_in_tvalid = '1' then
				add_sub_tvalid <= '1';
				add_sub_a_tdata <= sub_in_tdata(127 downto 0);
				add_sub_b_tdata <= sub_in_tdata(255 downto 128);
				add_sub_tuser <= sub_in_tuser;
				add_sub_operation_tdata <= "00000001";
			end if;
		end if;
	end process;
	
	process(
		resetn,
		
		add_int16_in_tvalid,
		add_int16_in_tdata,
		
		sub_int16_in_tvalid,
		sub_int16_in_tdata
	    )
	begin
		addsub_int16_a <= (others => '0');
		addsub_int16_b <= (others => '0');
		addsub_int16_operation <= '0';
		
		if resetn = '0' then
		else
			if add_int16_in_tvalid = '1' then
				addsub_int16_a <= add_int16_in_tdata(15 downto 0);
				addsub_int16_b <= add_int16_in_tdata(31 downto 16);
				addsub_int16_operation <= '1';
		    elsif sub_int16_in_tvalid = '1' then
				addsub_int16_a <= sub_int16_in_tdata(15 downto 0);
				addsub_int16_b <= sub_int16_in_tdata(31 downto 16);
				addsub_int16_operation <= '0';
			end if;
		end if;
	end process;
	
add_sub_i0 : floating_point_0
  PORT MAP (
    aclk => clock,
	aclken => enable,
    s_axis_a_tvalid => add_sub_tvalid,
    s_axis_a_tdata => add_sub_a_tdata(31 downto 0),
    s_axis_a_tuser => sub_in_tvalid & add_sub_tuser,
    s_axis_b_tvalid => add_sub_tvalid,
    s_axis_b_tdata => add_sub_b_tdata(31 downto 0),
    s_axis_operation_tvalid => add_sub_tvalid,
    s_axis_operation_tdata => add_sub_operation_tdata,
    m_axis_result_tvalid => add_sub_result_tvalid(0),
    m_axis_result_tdata => add_sub_result_tdata(31 downto 0),
    m_axis_result_tuser => add_sub_result_tuser(9 downto 0)
  );
	add_sub_i1 : floating_point_0
  PORT MAP (
    aclk => clock,
	aclken => enable,
    s_axis_a_tvalid => add_sub_tvalid,
    s_axis_a_tdata => add_sub_a_tdata(63 downto 32),
    s_axis_a_tuser => sub_in_tvalid & add_sub_tuser,
    s_axis_b_tvalid => add_sub_tvalid,
    s_axis_b_tdata => add_sub_b_tdata(63 downto 32),
    s_axis_operation_tvalid => add_sub_tvalid,
    s_axis_operation_tdata => add_sub_operation_tdata,
    m_axis_result_tvalid => add_sub_result_tvalid(1),
    m_axis_result_tdata => add_sub_result_tdata(63 downto 32),
    m_axis_result_tuser => add_sub_result_tuser(19 downto 10)
  );
	add_sub_i2 : floating_point_0
  PORT MAP (
    aclk => clock,
	aclken => enable,
    s_axis_a_tvalid => add_sub_tvalid,
    s_axis_a_tdata => add_sub_a_tdata(95 downto 64),
    s_axis_a_tuser => sub_in_tvalid & add_sub_tuser,
    s_axis_b_tvalid => add_sub_tvalid,
    s_axis_b_tdata => add_sub_b_tdata(95 downto 64),
    s_axis_operation_tvalid => add_sub_tvalid,
    s_axis_operation_tdata => add_sub_operation_tdata,
    m_axis_result_tvalid => add_sub_result_tvalid(2),
    m_axis_result_tdata => add_sub_result_tdata(95 downto 64),
    m_axis_result_tuser => add_sub_result_tuser(29 downto 20)
  );
	add_sub_i3 : floating_point_0
  PORT MAP (
    aclk => clock,
	aclken => enable,
    s_axis_a_tvalid => add_sub_tvalid,
    s_axis_a_tdata => add_sub_a_tdata(127 downto 96),
    s_axis_a_tuser => sub_in_tvalid & add_sub_tuser,
    s_axis_b_tvalid => add_sub_tvalid,
    s_axis_b_tdata => add_sub_b_tdata(127 downto 96),
    s_axis_operation_tvalid => add_sub_tvalid,
    s_axis_operation_tdata => add_sub_operation_tdata,
    m_axis_result_tvalid => add_sub_result_tvalid(3),
    m_axis_result_tdata => add_sub_result_tdata(127 downto 96),
    m_axis_result_tuser => add_sub_result_tuser(39 downto 30)
  );
  
abs_i0 : floating_point_1
  PORT MAP (
    s_axis_a_tvalid => abs_in_tvalid,
    s_axis_a_tdata => abs_in_tdata(31 downto 0),
    s_axis_a_tuser => abs_in_tuser,
    m_axis_result_tvalid => abs_result_tvalid(0),
    m_axis_result_tdata => abs_result_tdata(31 downto 0),
    m_axis_result_tuser => abs_result_tuser
  );
abs_i1 : floating_point_1
  PORT MAP (
    s_axis_a_tvalid => abs_in_tvalid,
    s_axis_a_tdata => abs_in_tdata(63 downto 32),
    s_axis_a_tuser => abs_in_tuser,
    m_axis_result_tvalid => abs_result_tvalid(1),
    m_axis_result_tdata => abs_result_tdata(63 downto 32)
  );
abs_i2 : floating_point_1
  PORT MAP (
    s_axis_a_tvalid => abs_in_tvalid,
    s_axis_a_tdata => abs_in_tdata(95 downto 64),
    s_axis_a_tuser => abs_in_tuser,
    m_axis_result_tvalid => abs_result_tvalid(2),
    m_axis_result_tdata => abs_result_tdata(95 downto 64)
  );
abs_i3 : floating_point_1
  PORT MAP (
    s_axis_a_tvalid => abs_in_tvalid,
    s_axis_a_tdata => abs_in_tdata(127 downto 96),
    s_axis_a_tuser => abs_in_tuser,
    m_axis_result_tvalid => abs_result_tvalid(3),
    m_axis_result_tdata => abs_result_tdata(127 downto 96)
  );
	
addsub_int16_i0 : c_addsub_1
  PORT MAP (
    A => addsub_int16_a,
    B => addsub_int16_b,
    CLK => clock,
    ADD => addsub_int16_operation,
    CE => enable,
    S => addsub_int16_result
  );
end vpu_alu_behavioral;
