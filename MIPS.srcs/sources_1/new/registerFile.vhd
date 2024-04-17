
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.std_logic_unsigned.all;
use IEEE.numeric_std.all;
entity registerFile is
  Port (
        -- clock, enable, write enable
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
end registerFile;

architecture Behavioral of registerFile is
type reg is array(0 to 7) of std_logic_vector(15 downto 0);

signal regArr: reg:=
(
    others=>x"0000"               -- the rest is set to 0x00
);
begin
    process(clk)
    begin
        if(en='1') then
            if(rising_edge(clk)) then
                if(wen='1') then
                    regArr(conv_integer(ra1))<=wa1;
                  --  regArr(conv_integer(ra2))<=wa2;
                end if;
            end if;
         end if;
     end process;
    
    output1<=regArr(conv_integer(ra1));
    output2<=regArr(conv_integer(ra2));
    
end Behavioral;
