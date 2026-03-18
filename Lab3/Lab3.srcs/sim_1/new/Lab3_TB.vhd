----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 03/17/2026 01:18:48 PM
-- Design Name: Sequential Shifter
-- Module Name: Lab3_TB - Lab3_TB_ARCH
-- Project Name: 
-- Target Devices: Artix 7 - Basys 3 FPGA Board
-- Description: Simulation file for the lab3 design. goes up 3 and down 3 due to time restrictions
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab3_TB is
--  Port ( );
end Lab3_TB;

architecture Lab3_TB_ARCH of Lab3_TB is

    component Lab3 is
        Port (
            leftButton  : in  std_logic;
            rightButton : in  std_logic;
            clk         : in  std_logic;
            reset       : in  std_logic;
            leds        : out std_logic_vector(15 downto 0);
            sevenSegs   : out std_logic_vector(6 downto 0);
            anodes      : out std_logic_vector(3 downto 0)
        );
    end component;
    
signal leftButton  : std_logic := '0';
signal rightButton : std_logic := '0';
signal clk         : std_logic := '0';
signal reset       : std_logic := '0';
signal leds        : std_logic_vector(15 downto 0);
signal sevenSegs   : std_logic_vector(6 downto 0);
signal anodes      : std_logic_vector(3 downto 0);

begin
    UUT: Lab3
        port map(
        leftButton  => leftButton,
        rightButton => rightButton,
        clk         => clk,
        reset       => reset,
        leds        => leds,
        sevenSegs   => sevenSegs,
        anodes      => anodes
        );
        
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;
    
    -- main input process
    process
    begin
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait for 10 ns;
    leftButton <= '1';
    wait for 120 ns;
    leftButton <= '0';
    wait for 120 ns;
    leftButton <= '1';
    wait for 120 ns;
    leftButton <= '0';
    wait for 120 ns;
    rightButton <= '1';
    wait for 120 ns;
    rightButton <= '0';
    wait for 120 ns;
    rightButton <= '1';
    wait for 120 ns;
    rightButton <= '0';
    wait for 120 ns;
    wait;
    end process;


end Lab3_TB_ARCH;