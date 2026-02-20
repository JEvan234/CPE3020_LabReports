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

entity Lab02_Basys3 is
  Port (
    sw : in std_logic_vector (2 downto 0);
    led : out std_logic_vector (15 downto 0);
    btnL: in std_logic;
    btnR: in std_logic;
    seg: out std_logic_vector(6 downto 0)
  );
  
  
end Lab02_Basys3;

architecture Lab02_Basys3_ARCH of Lab02_Basys3 is
    signal leftButton: std_logic := '0';
    signal rightButton: std_logic := '0';
    signal bitCount: std_logic_vector(2 downto 0) := "000";
    signal leftLeds: std_logic_vector(15 downto 8) := "00000000";
    signal rightLeds: std_logic_vector(7 downto 0) := "00000000";
    signal whichNum: std_logic_vector(6 downto 0) := "0000000";
    
    --Define Component
    component Lab02
        Port (
        leftButton: in std_logic;
        rightButton: in std_logic;
        bitCount: in std_logic_vector(2 downto 0);
        leftLeds: out std_logic_vector(15 downto 8);
        rightLeds: out std_logic_vector(7 downto 0);
        whichNum: out std_logic_vector(6 downto 0));
    end component;

begin
    UUT: Lab02 port map(
    leftButton => btnL,
    rightButton => btnR,
    bitCount => sw,
    rightLeds => led(7 downto 0),
    leftLeds => led(15 downto 8),
    whichNum => seg
    );

end Lab02_Basys3_ARCH;
