----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/07/2026 03:15:16 PM
-- Design Name: 
-- Module Name: Practicum3Practice_TB - Practicum3Practice_TB_ARCH
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

entity Practicum3Practice_TB is
--  Port ( );
end Practicum3Practice_TB;

architecture Practicum3Practice_TB_ARCH of Practicum3Practice_TB is

    component Practicum3Practice is
        port(
            nextButton: in std_logic;
            prevButton: in std_logic;
            clock: in std_logic;
            reset: in std_logic;
            leds: out std_logic_vector(3 downto 0));
    end component;

    --signals
    signal nextButton: std_logic := '0';
    signal prevButton: std_logic := '0';
    signal clock: std_logic := '0';
    signal reset: std_logic := '0';
    signal leds: std_logic_vector(3 downto 0);


begin
    UUT: Practicum3Practice port map(
        nextButton => nextButton,
        prevButton => prevButton,
        clock => clock,
        reset => reset,
        leds => leds);
        
        
    CLOCK_PROCESS: process
    begin
        loop
            clock <= '0';
            wait for 10 ns;
            clock <= '1';
            wait for 10 ns;
        end loop;
    end process;
    
    MAIN_PROCESS: process
    begin
        reset <= '1';
        nextButton <= '0';
        prevButton <= '0';
        wait for 10 ns;
        reset <= '0';
        nextButton <= '0';
        prevButton <= '0';
        wait for 10 ns;
        wait;
    end process;
        
    


end Practicum3Practice_TB_ARCH;
