----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper, Jacob Evans
-- 
-- Create Date: 03/24/2026 11:08:28 AM
-- Design Name: Lab4 Component
-- Module Name: rgb - rgb_ARCH
-- Project Name: Lab 4 RGB neopixel stick interface
-- Target Devices: Basys3 - Artix 7
-- Description: Test Bench Driver for the Lab 4 rgb component
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab4_TB is
--  Port ( );
end Lab4_TB;

architecture Lab4_TB_ARCH of Lab4_TB is
    signal clock : std_logic := '0';
    signal reset : std_logic := '1';
    signal switches : std_logic_vector(2 downto 0) := "000";
    signal data_out : std_logic;
    signal segments: std_logic_vector(6 downto 0);
    signal anodes: std_logic_vector(3 downto 0);
    
    constant clock_period : time := 10 ns;
    
    component Lab4 
        Port(
            clock : in std_logic;
            reset : in std_logic;
            switches : in std_logic_vector(2 downto 0);
            data_out : out std_logic;
            segments: out std_logic_vector(6 downto 0);
            anodes: out std_logic_vector(3 downto 0)
        );
    end component;
begin
    UUT: Lab4 port map(
        clock => clock,
        reset => reset,
        switches => switches,
        data_out => data_out,
        segments => segments,
        anodes => anodes
    );

    -- Clock generation
    clock_process :process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- Test all 8 switch combinations
        switches <= "000"; -- OFF
        wait for 120 us;

        switches <= "001"; -- GREEN
        wait for 120 us;

        switches <= "010"; -- RED
        wait for 120 us;

        switches <= "011"; -- BLUE
        wait for 120 us;

        switches <= "100"; -- YELLOW
        wait for 120 us;

        switches <= "101"; -- MAGENTA
        wait for 120 us;

        switches <= "110"; -- CYAN
        wait for 120 us;

        switches <= "111"; -- WHITE
        wait for 120 us;

        wait;
    end process;

end Lab4_TB_ARCH;