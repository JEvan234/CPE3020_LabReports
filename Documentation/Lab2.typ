// Lab Report 2: Jacob Evans

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
```

#pagebreak()
= Test Bench Diagram
#figure(
    image("./assets/Lab02/Testbench02.svg",
    width: 90%),
    caption: [Test Bench Block Diagram]
)

= Test Bench Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- Create Date: 02/11/2026 02:06:30 PM
-- Design Name: Lab02_TB
-- Module Name: Lab02 - Lab02_TB_ARCH
-- Project Name: Hardware Integration Lab
-- Target Devices: Basys3 - Artix 7
-- Description: Test bench for Lab2 Component, Shows all Test conditions. First with no buttons, then Left button, then Right button.
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab02_TB is
--  Port ( );
end Lab02_TB;

architecture Lab02_TB_ARCH of Lab02_TB is
--Signals
    signal leftButton: std_logic := '0';
    signal rightButton: std_logic := '0';
    signal bitCount: std_logic_vector(2 downto 0) := "000";
    signal leftLeds: std_logic_vector(15 downto 9) := "0000000";
    signal rightLeds: std_logic_vector(6 downto 0) := "0000000";
    signal whichNum: std_logic_vector(6 downto 0) := "0000000";
    
    --Define Component
    component Lab02
        Port (
        leftButton: in std_logic;
        rightButton: in std_logic;
        bitCount: in std_logic_vector(2 downto 0);
        leftLeds: out std_logic_vector(15 downto 9);
        rightLeds: out std_logic_vector(6 downto 0);
        whichNum: out std_logic_vector(6 downto 0));
    end component;
    
begin
    UUT: Lab02 port map(
    leftButton => leftButton,
    rightButton => rightButton,
    bitCount => bitCount,
    rightLeds => rightLeds,
    leftLeds => leftLeds,
    whichNum => whichNum);
    
    process
    begin
        bitCount <= "000";
        leftButton <= '0';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "001";
        leftButton <= '0';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "010";
        leftButton <= '0';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "011";
        leftButton <= '0';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "100";
        leftButton <= '0';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "101";
        leftButton <= '0';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "110";
        leftButton <= '0';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "111";
        leftButton <= '0';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "000";
        leftButton <= '1';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "001";
        leftButton <= '1';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "010";
        leftButton <= '1';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "011";
        leftButton <= '1';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "100";
        leftButton <= '1';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "101";
        leftButton <= '1';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "110";
        leftButton <= '1';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "111";
        leftButton <= '1';
        rightButton <= '0';
        wait for 10ns;
        bitCount <= "000";
        leftButton <= '0';
        rightButton <= '1';
        wait for 10ns;
        bitCount <= "001";
        leftButton <= '0';
        rightButton <= '1';
        wait for 10ns;
        bitCount <= "010";
        leftButton <= '0';
        rightButton <= '1';
        wait for 10ns;
        bitCount <= "011";
        leftButton <= '0';
        rightButton <= '1';
        wait for 10ns;
        bitCount <= "100";
        leftButton <= '0';
        rightButton <= '1';
        wait for 10ns;
        bitCount <= "101";
        leftButton <= '0';
        rightButton <= '1';
        wait for 10ns;
        bitCount <= "110";
        leftButton <= '0';
        rightButton <= '1';
        wait for 10ns;
        bitCount <= "111";
        leftButton <= '0';
        rightButton <= '1';
        wait for 10ns;
        wait;
    end process;

end Lab02_TB_ARCH;
```
#pagebreak()
= Test Bench Results
#figure(
    image("./assets/Lab02/Lab2_TB_Results.png")
)

= Wrapper Design Block

= Wrapper Design Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- Create Date: 02/11/2026 02:06:30 PM
-- Design Name: Lab02_BASYS3
-- Module Name: Lab02 - Lab02_BASYS3_ARCH
-- Project Name: Hardware Integration Lab
-- Target Devices: Basys3 - Artix 7
-- Description: Wrapper File for the Lab2 Component. Accounts for all 3 switches, all 16 leds, and the most-right 7-Seg Display
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab02_Basys3 is
  Port (
    sw : in std_logic_vector (2 downto 0);
    led : out std_logic_vector (15 downto 0);
    btnL: in std_logic;
    btnR: in std_logic;
    seg: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0)
  );
  
  
end Lab02_Basys3;

architecture Lab02_Basys3_ARCH of Lab02_Basys3 is
    
    --Define Component
    component Lab02
        Port (
        leftButton: in std_logic;
        rightButton: in std_logic;
        bitCount: in std_logic_vector(2 downto 0);
        leftLeds: out std_logic_vector(15 downto 9);
        rightLeds: out std_logic_vector(6 downto 0);
        whichNum: out std_logic_vector(6 downto 0);
        an: out std_logic_vector(3 downto 0));
    end component;

begin
    -- Drive the unused LEDs to 0
    led(7) <= '0';
    led(8) <= '0';
    
    UUT: Lab02 port map(
    leftButton => btnL,
    rightButton => btnR,
    bitCount => sw,
    rightLeds => led(6 downto 0),
    leftLeds => led(15 downto 9),
    whichNum => seg,
    an => an
    
    );

end Lab02_Basys3_ARCH;
```