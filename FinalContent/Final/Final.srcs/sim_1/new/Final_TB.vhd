----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 01:33:57 PM
-- Design Name: 
-- Module Name: Final_TB - Final_TB_ARCH
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

entity Final_TB is
--  Port ( );
end Final_TB;

architecture Final_TB_ARCH of Final_TB is
    -- Constants
    constant ACTIVE: std_logic := '1';
    
    -- Signals
    signal dirMode: std_logic;
    signal reset: std_logic;
    signal clock: std_logic;
    signal leds: std_logic_vector(2 downto 0);
    
    -- Component
    component Final is
        Port (
            dirMode: in std_logic;
            clock: in std_logic;
            reset: in std_logic;
            leds: out std_logic_vector(2 downto 0)
        );
    end component;

begin

    --UUT
    UUT: Final port map(
        dirMode => dirMode,
        clock => clock,
        reset => reset,
        leds => leds
        );
    
    -- Processes for TB
    
    CLOCK_DRIVER:process
    begin
        loop
            clock <= not ACTIVE;
            wait for 5 ns;
            clock <= ACTIVE;
            wait for 5 ns;
        end loop;
    end process;
    
    INPUT_DRIVER:process
    begin
        dirMode <= not ACTIVE;
        reset <= ACTIVE;
        wait for 10 ns;
        reset <= not ACTIVE;
        wait for 1000 ms;
        dirmode <= ACTIVE;
        wait;
    end process;

end Final_TB_ARCH;
