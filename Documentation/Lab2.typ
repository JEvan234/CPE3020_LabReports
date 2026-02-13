// Lab Reprt 2: Jacob Evans

#set page(paper: "a4")
#set text(size:32pt)
#set raw(syntaxes: "VHDL.sublime-syntax")

= Lab02
Hardware Interfacing Lab
#v(200pt)
#set text(size: 16pt)
Designer: Jacob Evans \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 02 - 11 \
#pagebreak()
= Design Description
The purpose of this lab is to interface the hardware with our design in such a way that a binary value provided by the 3 right switches (sw0, sw1, and sw2) can be passed through and light up the corresponding number of leds on either side provided by the pushbuttons. These systems (left and right) are able to be used at the same time. 

= Design Diagram
#figure(
  image("./assets/Lab02/Design02.svg",
  width: 110%),
  caption: [Design Block Diagram]
)

#pagebreak()
= Design Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- Create Date: 02/11/2026 02:06:30 PM
-- Design Name: Lab02
-- Module Name: Lab02 - Lab02_ARCH
-- Project Name: Hardware Integration Lab
-- Target Devices: Basys3 - Artix 7
-- Description: 
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
        whichNum <= "1000000" when "000", --1
                    "1111001" when "001", --2
                    "0000000" when "010", --Fill in rest
                    "0000000" when "011",
                    "0000000" when "100",
                    "0000000" when "101",
                    "0000000" when "110",
                    "0000000" when "111",
                    "0000000" when others;

-- Implement Left and Right Function
    RIGHT_FUNCTION: process(rightButton, bitCount)
        begin 
            if rightButton = '0' then
                case bitCount is
                    when "000" =>
                        rightLeds <= "11111111";
                end case;
            end if;
        end process;
        
    LEFT_FUNCTION: process(leftButton, bitCount)
        begin 
            if leftButton = '0' then
                case bitCount is
                    when "000" =>
                        rightLeds <= "11111111";
                end case;
            end if;
        end process;
            

end Lab02_ARCH;
```