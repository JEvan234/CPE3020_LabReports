----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 03/24/2026 11:31:18 AM
-- Design Name: LED light Driver Assignment
-- Module Name: Lab4 Assignment
-- Project Name: 
-- Target Devices: Basys 3, Artix 7
-- Tool Versions: 
-- Description: 
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
    
    constant clock_period : time := 10 ns;
    
    component Lab4 
        Port(
            clock : in std_logic;
            reset : in std_logic;
            switches : in std_logic_vector(2 downto 0);
            data_out : out std_logic
        );
    end component;
begin
    UUT: Lab4 port map(
        clock => clock,
        reset => reset,
        switches => switches,
        data_out => data_out
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
        wait for 50 ns;
        reset <= '0';

        -- Test all 8 switch combinations
        switches <= "000"; -- OFF
        wait for 200 us;

        switches <= "001"; -- GREEN
        wait for 200 us;

        switches <= "010"; -- RED
        wait for 200 us;

        switches <= "011"; -- BLUE
        wait for 200 us;

        switches <= "100"; -- YELLOW
        wait for 200 us;

        switches <= "101"; -- MAGENTA
        wait for 200 us;

        switches <= "110"; -- CYAN
        wait for 200 us;

        switches <= "111"; -- WHITE
        wait for 200 us;

        wait;
    end process;

end Lab4_TB_ARCH;
