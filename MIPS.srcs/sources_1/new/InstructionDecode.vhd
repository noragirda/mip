
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity InstructionDecode is
  Port (
    clk: in std_logic;
    instr: in std_logic_vector(15 downto 0);
    writeData: in std_logic_vector(15 downto 0);   
    en: in std_logic;
   
    regWrite: in std_logic;
    regDst: in std_logic;
    extOp: in std_logic; 
    
    rd1: out std_logic_vector(15 downto 0);
    rd2: out std_logic_vector(15 downto 0);
    ext_imm: out std_logic_vector(15 downto 0);
    func: out std_logic_vector(2 downto 0);
    sa: out std_logic
    
   );
end InstructionDecode;

architecture Behavioral of InstructionDecode is
signal rt, rs, rd: std_logic_vector(2 downto 0);
signal imd: std_logic_vector(6 downto 0);
signal writeAddr: std_logic_vector(2 downto 0);
signal extImm: std_logic_vector(15 downto 0);
component registerFile is port(
clk: in std_logic;
en: in std_logic;
wen: in std_logic;

ra1: in std_logic_vector(2 downto 0);
ra2: in std_logic_vector(2 downto 0);

wa1: in std_logic_vector(2 downto 0);

-- the outputs
output1: out std_logic_vector(15 downto 0);
output2: out std_logic_vector(15 downto 0)
);
end component registerFile;

begin
    rs<=instr(12 downto 10);
    rt<=instr(9 downto 7);
    rd<=instr(6 downto 4);
    imd<=instr(6 downto 0);
    process(regDst)
    begin
        if(regDst='1') then
            writeAddr<=rd;
        else
            writeAddr<=rt;
        end if;
    end process;
    regFile: registerFile port map(clk, en,regWrite,rs,rt,writeAddr, rd1, rd2);
    func<=instr(2 downto 0);
    sa<=instr(3);
	process(extOp)
	begin
		if(extOp='1') then
			if(instr(6)='1') then
				extImm<="111111111"&imd;
			else
				extImm<="000000000"&imd;
			end if;
		else
			extImm<="000000000"&imd;
		end if;
	end process;
	ext_imm<=extImm;
end Behavioral;
