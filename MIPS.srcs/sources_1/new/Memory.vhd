----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 08.04.2024 17:56:40
-- Design Name: 
-- Module Name: Memory - Behavioral
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;
entity Memory is
  Port 
  ( 
    adress:in std_logic_vector(3 downto 0);
    clk: in std_logic;
    en:in std_logic;
    instruction:out std_logic_vector(15 downto 0) 
  );
end Memory;

architecture Behavioral of Memory is
type rom is array(0 to 15) of std_logic_vector(15 downto 0);
signal mem:rom:= 
(
0=> B"000_010_100_000_0_000",--add 2+4
1=>B"000_010_010_110_0_010",--sll
2=>B"000_111_010_000_0_110",-- XOR 111 010
3=>B"101_111_000_0001111",--andi
others=>B"000_100_010_000_0_001"
);
begin 
process(clk, en)
begin
if(rising_edge(clk)) then
    if(en='1') then 
        instruction<=mem(conv_integer(adress));
    end if;
end if;
end process;

end Behavioral;
