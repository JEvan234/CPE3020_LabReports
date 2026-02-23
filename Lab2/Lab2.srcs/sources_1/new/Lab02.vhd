----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- Create Date: 02/11/2026 02:06:30 PM
-- Design Name: Lab02
-- Module Name: Lab02 - Lab02_ARCH
-- Project Name: Hardware Integration Lab
-- Target Devices: Basys3 - Artix 7
-- Description: Split into 3 sections, this component will display a number entered from the right 3 switches, and light up that number of LEDS cooresponding to a left/right button input.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
entity Lab02 is
  Port (
    leftButton: in std_logic;
    rightButton: in std_logic;
    bitCount: in std_logic_vector(2 downto 0);
    leftLeds: out std_logic_vector(15 downto 9);
    rightLeds: out std_logic_vector(6 downto 0);
    whichNum: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0));
end Lab02;

architecture Lab02_ARCH of Lab02 is

begin
    --define only right Seg7
    an <= "1110";
    
    SEG7_DECODER: with bitCount select
        whichNum <= "1000000" when "000", --0
                    "1111001" when "001", --1
                    "0100100" when "010", --2
                    "0110000" when "011", --3
                    "0011001" when "100", --4
                    "0010010" when "101", --5
                    "0000010" when "110", --6
                    "1111000" when "111", --7
                    "1000000" when others; -- others, same as 0

-- Implement Left and Right Function
    RIGHT_FUNCTION: process(rightButton, bitCount)
        begin 
            if rightButton = '1' then
                case bitCount is
                    when "001" => --1
                        rightLeds <= "0000001";
                    when "010" => --2
                        rightLeds <= "0000011";
                    when "011" => --3
                        rightLeds <= "0000111";
                    when "100" => --4
                        rightLeds <= "0001111";
                    when "101" => --5
                        rightLeds <= "0011111";
                    when "110" => --6
                        rightLeds <= "0111111";
                    when "111" => --7
                        rightLeds <= "1111111";
                    when others => --0 and others
                        rightLeds <= "0000000";
                end case;
            else 
                rightLeds <= "0000000";
            end if;
        end process;
        
    LEFT_FUNCTION: process(leftButton, bitCount)
        begin 
            if leftButton = '1' then
                case bitCount is
                    when "001" => --1
                        leftLeds <= "1000000";
                    when "010" => --2
                        leftLeds <= "1100000";
                    when "011" => --3
                        leftLeds <= "1110000";
                    when "100" => --4
                        leftLeds <= "1111000";
                    when "101" => --5
                        leftLeds <= "1111100";
                    when "110" => --6
                        leftLeds <= "1111110";
                    when "111" => --7
                        leftLeds <= "1111111";
                    when others => --0 and others
                        leftLeds <= "0000000";
                end case;
            else
                leftLeds <= "0000000";
            end if;
        end process;
            

end Lab02_ARCH;