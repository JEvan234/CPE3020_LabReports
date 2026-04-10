----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2026 03:39:11 PM
-- Design Name: 
-- Module Name: Practicum3Practice_BASYS3 - Practicum3Practice_BASYS3_ARCH
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

entity Practicum3Practice_BASYS3 is
  Port (
    btnC: in std_logic;
    btnL: in std_logic;
    btnR: in std_logic;
    clk: in std_logic;
    led: out std_logic_vector(3 downto 0));
    
end Practicum3Practice_BASYS3;

architecture Practicum3Practice_BASYS3_ARCH of Practicum3Practice_BASYS3 is

    component Practicum3Practice is
        port(
            nextButton: in std_logic;
            prevButton: in std_logic;
            clock: in std_logic;
            reset: in std_logic;
            leds: out std_logic_vector(3 downto 0));
    end component;

begin
    UUT: Practicum3Practice port map(
        nextButton => btnL,
        prevButton => btnR,
        reset => btnC,
        clock => clk,
        leds => led);
        

end Practicum3Practice_BASYS3_ARCH;
