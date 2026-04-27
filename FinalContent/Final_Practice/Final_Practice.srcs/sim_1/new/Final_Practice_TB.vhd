----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 05:19:28 PM
-- Design Name: 
-- Module Name: Final_Practice_TB - Final_Practice_TB_ARCH
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

entity Final_Practice_TB is
--  Port ( );
end Final_Practice_TB;
    
architecture Final_Practice_TB_ARCH of Final_Practice_TB is
    -- Constants from design file
    constant ZERO: std_logic_vector := "00";
    constant ONE: std_logic_vector := "01";
    constant TWO: std_logic_vector := "10";
    constant THREE: std_logic_vector := "11";
    
    -- Signals for input driver
    signal switches: std_logic_vector(1 downto 0);
    signal leds: std_logic_vector(1 downto 0);
    signal clock: std_logic;
    signal reset: std_logic;

    -- Import Component
    component Final_Practice is
        Port (
        switches: in std_logic_vector(1 downto 0);
        leds: out std_logic_vector(1 downto 0);
        clock: in std_logic;
        reset: in std_logic);
    end component;

begin
    UUT: Final_Practice port map(
        switches => switches,
        leds => leds,
        clock => clock,
        reset => reset);
    
    CLOCK_PROCESS:process
    begin
        loop
            clock <= '0';
            wait for 10 ns;
            clock <= '1';
            wait for 10ns;
        end loop;
    end process;

    MAIN_TB_PROCESS:process
    begin
        switches <= ZERO;
        reset <= '1';
        wait for 10 ns;
        reset <= '0';
        switches <= ONE;
        wait for 50 ns;
        switches <= TWO;
        wait for 50 ns;
        switches <= THREE;
        wait;
    end process;
end Final_Practice_TB_ARCH;
