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
    leftLeds: out std_logic_vector(15 downto 8);
    rightLeds: out std_logic_vector(7 downto 0);
    whichNum: out std_logic_vector(6 downto 0));
end Lab02;

architecture Lab02_ARCH of Lab02 is

begin
    
    SEG7_DECODER: with bitCount select
        whichNum <= "0000001" when "000", --0
                    "1001111" when "001", --1
                    "0010010" when "010", --2
                    "0000110" when "011", --3
                    "1001100" when "100", --4
                    "0100100" when "101", --5
                    "0100000" when "110", --6
                    "0001111" when "111", --7
                    "0000001" when others; -- others, same as 0

-- Implement Left and Right Function
    RIGHT_FUNCTION: process(rightButton, bitCount)
        begin 
            if rightButton = '0' then
                case bitCount is
                    when "001" => --1
                        rightLeds <= "11111110";
                    when "010" => --2
                        rightLeds <= "11111100";
                    when "011" => --3
                        rightLeds <= "11111000";
                    when "100" => --4
                        rightLeds <= "11110000";
                    when "101" => --5
                        rightLeds <= "11100000";
                    when "110" => --6
                        rightLeds <= "11000000";
                    when "111" => --7
                        rightLeds <= "10000000";
                    when others => --0 and others
                        rightLeds <= "11111111";
                end case;
            else 
                rightLeds <= "11111111";
            end if;
        end process;
        
    LEFT_FUNCTION: process(leftButton, bitCount)
        begin 
            if leftButton = '0' then
                case bitCount is
                    when "001" => --1
                        leftLeds <= "01111111";
                    when "010" => --2
                        leftLeds <= "00111111";
                    when "011" => --3
                        leftLeds <= "00011111";
                    when "100" => --4
                        leftLeds <= "00001111";
                    when "101" => --5
                        leftLeds <= "00000111";
                    when "110" => --6
                        leftLeds <= "00000011";
                    when "111" => --7
                        leftLeds <= "00000001";
                    when others => --0 and others
                        leftLeds <= "11111111";
                end case;
            else
                leftLeds <= "11111111";
            end if;
        end process;
            

end Lab02_ARCH;