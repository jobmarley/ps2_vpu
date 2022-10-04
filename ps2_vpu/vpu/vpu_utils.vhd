library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


package vpu_utils is
	
	type alu_user_t is record
		fd : std_logic_vector(4 downto 0);
		dest : std_logic_vector(3 downto 0);
	end record;
	
	function slv_to_alu_user(data : std_logic_vector) return alu_user_t;
	function alu_user_to_slv(data : alu_user_t) return std_logic_vector;
	
	function sign_extend(data : std_logic_vector; len : NATURAL) return std_logic_vector;
end vpu_utils;

package body vpu_utils is
	function slv_to_alu_user(data : std_logic_vector) return alu_user_t is
		variable vuser : alu_user_t;
	begin
		vuser.fd := data(4 downto 0);
		vuser.dest := data(8 downto 5);
		return vuser;
	end function;
	
	function alu_user_to_slv(data : alu_user_t) return std_logic_vector is
		variable vresult : std_logic_vector(8 downto 0);
	begin
		vresult(4 downto 0) := data.fd;
		vresult(8 downto 5)  := data.dest;
		return vresult;
	end function;
	
	function sign_extend(data : std_logic_vector; len : NATURAL) return std_logic_vector is
		variable vresult : std_logic_vector(len-1 downto 0);
	begin
		vresult(data'LENGTH-1 downto 0) := data;
		for i in len-1 downto data'LENGTH loop
			vresult(i) := '0';--data(data'LENGTH-1);
		end loop;
		return vresult;
	end function;
end vpu_utils;
