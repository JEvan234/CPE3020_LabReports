----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/15/2026 03:14:40 PM
-- Design Name: 
-- Module Name: Lab02_TB - Lab02_TB_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Test bench for Lab2 Component, Shows all Test conditions. First with no buttons, then Left button, then Right button.

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
