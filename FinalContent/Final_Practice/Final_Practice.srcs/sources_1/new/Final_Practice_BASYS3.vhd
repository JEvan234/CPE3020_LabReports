----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/28/2026 02:24:53 PM
-- Design Name: 
-- Module Name: Final_Practice_BASYS3 - Final_Practice_BASYS3_ARCH
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

entity Final_Practice_BASYS3 is
  Port (
    sw: in std_logic_vector(1 downto 0);
    led: out std_logic_vector(1 downto 0);
    clk: in std_logic;
    btnC: in std_logic);
end Final_Practice_BASYS3;

architecture Final_Practice_BASYS3_ARCH of Final_Practice_BASYS3 is

    component Final_Practice is
        Port (
        switches: in std_logic_vector(1 downto 0);
        leds: out std_logic_vector(1 downto 0);
        clock: in std_logic;
        reset: in std_logic);
    end component;

begin

    UUT: Final_Practice port map(
        switches => sw,
        leds => led,
        clock => clk,
        reset => btnC);

end Final_Practice_BASYS3_ARCH;
