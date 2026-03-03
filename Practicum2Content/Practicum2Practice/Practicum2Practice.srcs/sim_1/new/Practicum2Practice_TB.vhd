----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2026 01:54:35 PM
-- Design Name: 
-- Module Name: Practicum2Practice_TB - Practicum2Practice_TB_ARCH
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

entity Practicum2Practice_TB is
--  Port ( );
end Practicum2Practice_TB;
    
-- For testbench, everything is defined after ARCH

architecture Practicum2Practice_TB_ARCH of Practicum2Practice_TB is

-- Define Signals
    signal switches: std_logic_vector(2 downto 0);
    signal load: std_logic;
    signal reset: std_logic;
    signal output: std_logic_vector(2 downto 0);
    signal clk: std_logic;

-- Then component (match/use the design file)
    component Practicum2Practice is
        port(
            switches: in std_logic_vector(2 downto 0);
            load: in std_logic;
            reset: in std_logic;
            output: out std_logic_vector(2 downto 0);
            clk: in std_logic);
    end component;

-- Here you assign the signals to the component
begin
    UUT: Practicum2Practice port map(
        switches => switches,
        load => load,
        reset => reset,
        output => output,
        clk => clk
        );
    
    --Put process here
    process
    begin
        clk <= '1';
        switches <= "000";
        wait for 10ns;
    -- end process
        wait;

    end process;

end Practicum2Practice_TB_ARCH;