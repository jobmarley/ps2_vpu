library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity vpu_test is
	port (
		sys_clk_p : in std_logic;
		sys_clk_n : in std_logic;
	
		CPU_RESET : in std_logic;
			
		led : out std_logic_vector(7 downto 0)
	);
end vpu_test;

architecture vpu_test_behavioral of vpu_test is
component design_3 is
  port (
    CLK_IN1_D_0_clk_n : in STD_LOGIC;
    CLK_IN1_D_0_clk_p : in STD_LOGIC;
    leds : out STD_LOGIC_VECTOR ( 7 downto 0 )
  );
  end component design_3;
begin
design_3_i: component design_3
     port map (
      CLK_IN1_D_0_clk_n => sys_clk_n,
      CLK_IN1_D_0_clk_p => sys_clk_p,
      leds(7 downto 0) => led
    );


end vpu_test_behavioral;
