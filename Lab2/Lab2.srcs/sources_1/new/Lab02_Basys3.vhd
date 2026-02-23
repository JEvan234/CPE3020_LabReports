----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/20/2026 05:43:44 PM
-- Design Name: 
-- Module Name: Lab02_Basys3 - Lab02_Basys3_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
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
