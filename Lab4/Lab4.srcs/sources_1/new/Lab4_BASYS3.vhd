----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper, Jacob Evans
-- 
-- Create Date: 03/24/2026 11:08:28 AM
-- Design Name: Lab4 Component
-- Module Name: rgb - rgb_ARCH
-- Project Name: Lab 4 RGB neopixel stick interface
-- Target Devices: Basys3 - Artix 7
-- Description: Wrapper file for the Lab 4 rgb component
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab4_BASYS3 is
  Port (
        clk     : in std_logic;                       -- 100 MHz clock
        sw      : in std_logic_vector(2 downto 0);    -- 3 switches
        btnC    : in std_logic;                       -- reset button
        JA      : out std_logic_vector(7 downto 0);    -- RGB data line
        seg: out std_logic_vector(6 downto 0);
        an: out std_logic_vector(3 downto 0)
    );
end Lab4_BASYS3;

architecture Lab4_BASYS3_ARCH of Lab4_BASYS3 is
    signal led_out : std_logic;
    
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
        clock => clk,
        reset => btnC,
        switches => sw,
        data_out => led_out,
        segments => seg,
        anodes => an
    );
    -- connect to JA
    JA(0) <= led_out;
    -- prevent floating pins
    JA(7 downto 1) <= (others => '0');

end Lab4_BASYS3_ARCH;