
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.Numeric_std.all;

entity mem is
  Port (
    clk: in std_logic;
    MemWrite: in std_logic;
    ALURes: inout std_logic_vector(15 downto 0);
    rd2: in std_logic_vector(15 downto 0);
    
    MemData: out std_logic_vector(15 downto 0)
   );
end mem;

architecture Behavioral of mem is
type ram_type is array (0 to 15) of std_logic_vector(15 downto 0);
signal RAM: ram_type:=(others=>X"0000");
begin
process(clk)
begin
    if(rising_edge(clk)) then
        if(MemWrite='1') then
            RAM(conv_integer(ALURes))<=rd2;
        end if;
     end if;
    MemData<=RAM(conv_integer(ALURes));
end process;
end Behavioral;
