----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2026 01:01:36 PM
-- Design Name: 
-- Module Name: Practicum3_TB - Practicum3_TB_ARCH
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

entity Practicum3_TB is
--  Port ( );
end Practicum3_TB;

architecture Practicum3_TB_ARCH of Practicum3_TB is
    -- Define Component of UUT
    component Practicum3 is
        Port (
            nextEn: in std_logic;
            redMode: in std_logic;
            blueMode: in std_logic;
            anodes: out std_logic_vector(3 downto 0);
            segments: out std_logic_vector(6 downto 0);
            clock: in std_logic;
            reset: in std_logic);
    end component;

    -- Define signals for testing
    signal nextEn: std_logic := '0';
    signal redMode: std_logic := '0';
    signal blueMode: std_logic := '0';
    signal anodes: std_logic_vector(3 downto 0);
    signal segments: std_logic_vector(6 downto 0);
    signal clock: std_logic := '0';
    signal reset: std_logic := '0';
    
begin
    
    -- Port map
    UUT: Practicum3 port map(
        nextEn => nextEn,
        redMode => redMode,
        blueMode => blueMode,
        anodes => anodes,
        segments => segments,
        clock => clock,
        reset => reset);
        
        
    -- Clock loop
    process
    begin
        loop
            clock <= '1';
            wait for 10 ns;
            clock <= '0';
            wait for 10 ns;
        end loop;
    end process;
    
    -- Main input test process
    process
    begin
        redMode <= '1';
        nextEn <= '1';
        wait for 20 ns;
        nextEn <= '0';
        wait for 20 ns;
        nextEn <= '1';
        wait for 20 ns;
        nextEn <= '0';
        wait for 20 ns;
        nextEn <= '1';
        wait for 20 ns;
        nextEn <= '0';
        wait for 20 ns;
        nextEn <= '1';
        wait for 20 ns;
        nextEn <= '0';
        wait for 20 ns;
        wait;
    
    end process;

end Practicum3_TB_ARCH;
