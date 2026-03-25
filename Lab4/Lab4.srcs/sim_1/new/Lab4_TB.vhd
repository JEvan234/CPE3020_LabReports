----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/24/2026 05:12:38 PM
-- Design Name: 
-- Module Name: Lab4_TB - Lab4_TB_ARCH
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

entity Lab4_TB is
--  Port ( );
end Lab4_TB;
    
architecture Lab4_TB_ARCH of Lab4_TB is
signal dataIn: std_logic_vector(31 downto 0);
signal dataOut: std_logic;
signal clock: std_logic;
signal reset: std_logic;

    component Lab4 is
        Port (
        dataIn: in std_logic_vector(31 downto 0);
        dataOut: out std_logic;
        clock: in std_logic;
        reset: in std_logic);
    end component;

begin
       UUT: Lab4 port map(
           dataIn => dataIn,
           dataOut => dataOut,
           clock => clock,
           reset => reset);
           
    -- Clock Process
    process
    begin
        while true loop
            clock <= '0';
            wait for 10 ns;
            clock <= '1';
            wait for 10 ns;
        end loop;
    end process;
    
    -- Main Process
    process
    begin
        dataIn <= "11111111000000001111111100000000";
        reset <= '1';
        wait for 50 ns;
        reset <= '0';
        wait for 1300 ns;
        wait;
    end process;
    


end Lab4_TB_ARCH;
