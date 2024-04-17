

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_std.all;
use IEEE.std_logic_unsigned.all;

entity executeUnit is
  Port (
  pc_1: in std_logic_vector(15 downto 0);
  rd1: in std_logic_vector(15 downto 0);
  rd2: in std_logic_vector(15 downto 0);
  ext_imm: in std_logic_vector(15 downto 0);
  
  func: in std_logic_vector(2 downto 0);
  sa: in std_logic;
  
  ALUsrc: in std_logic;
  ALUOp: in std_logic_vector(2 downto 0);
  
  br_Addr: out std_logic_vector(15 downto 0);
  ALURes: out std_logic_vector(15 downto 0);
  zero: out std_logic  
   );
end executeUnit;

architecture Behavioral of executeUnit is
signal mux1: std_logic_vector(15 downto 0);
signal ALUCtrl: std_logic_vector(3 downto 0);
signal res1: std_logic_vector(15 downto 0);
signal sum: std_logic_vector(16 downto 0);
signal brAd: std_logic_vector(15 downto 0);
begin

process(ALUsrc)
begin
    if(ALUsrc='1')then
        mux1<=ext_imm;
    else
        mux1<=rd2;
    end if;
end process;
process(func, ALUOp)
begin
    case ALUOp is
        when "000" =>
            case func is
                when "000" =>
                    ALUCtrl <= "0000"; -- add
                when "001" =>
                    ALUCtrl <= "0001"; -- sub
                when "010" =>
                    ALUCtrl <= "0010"; -- sll
                when "011" =>
                    ALUCtrl <= "0011"; -- srl
                when "100" =>
                    ALUCtrl <= "0100"; -- and
                when "101" =>
                    ALUCtrl <= "0101"; -- or
                when "110" =>
                    ALUCtrl <= "0110"; -- xor
                when others =>
                    ALUCtrl<="0111"; --xnor
            end case;

        when "001" =>
            ALUCtrl <= "0000"; -- add

        when "010" =>
            ALUCtrl <= "0000"; -- lw (assuming lw uses add under the hood)

        when "011" =>
            ALUCtrl <= "0000"; -- sw (assuming sw uses add under the hood)

        when "100" =>
            ALUCtrl <= "1000"; -- beq

        when "101" =>
            ALUCtrl <= "0100"; -- and

        when "110" =>
            ALUCtrl <= "0101"; -- or

        when others =>
            ALUCtrl<="1111"; --Jump
    end case;
end process;

process(ALUCtrl, rd1, mux1)
variable sum: std_logic_vector(16 downto 0);
begin
 case ALUCtrl is
        when "0000" => -- add
            sum := std_logic_vector(unsigned("0" & rd1) + unsigned("0" & mux1));
            zero <= sum(16);
            res1 <= sum(15 downto 0);
            
        when "0001" => -- sub
            sum := std_logic_vector(unsigned("0" & rd1) - unsigned("0" & mux1));
            zero <= sum(16);
            res1 <= sum(15 downto 0);

        when "0010" => -- sll (shift left logical)
            res1 <= std_logic_vector(shift_left(unsigned(rd1), to_integer(unsigned(mux1(4 downto 0)))));

        when "0011" => -- srl (shift right logical)
            res1 <= std_logic_vector(shift_right(unsigned(rd1), to_integer(unsigned(mux1(4 downto 0)))));


        when "0100" => -- and
            res1 <= rd1 and mux1;
            if res1 = "0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;

        when "0101" => -- or
            res1 <= rd1 or mux1;
            if res1 = "0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;

        when "0110" => -- xor
            res1 <= rd1 xor mux1;
            if res1 = "0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;

        when "0111" => -- xnor
            res1 <= rd1 xnor mux1;
            if res1 = "0000000000000000" then
                zero <= '1';
            else
                zero <= '0';
            end if;

        when "1010" => -- beq (branch if equal)
            res1 <= "0000000000000000";  -- Placeholder, usually the PC is manipulated outside this process
            if rd1 = mux1 then
                zero <= '1';
            else
                zero <= '0';
            end if;

        when "1111" => -- jump (not an ALU operation traditionally, handling could be different)
            res1 <= mux1;  -- Usually, the address to jump to
            zero <= '0';   -- No condition flag affected

        when others =>
            -- Handle unexpected ALUCtrl codes gracefully
            res1 <= (others => 'X');
            zero <= 'X';
    end case;
end process;

process(pc_1, ext_imm)
begin
        brAd<=ext_imm+pc_1;
end process;

end Behavioral;
