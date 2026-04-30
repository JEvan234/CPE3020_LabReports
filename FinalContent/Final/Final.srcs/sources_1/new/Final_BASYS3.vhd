----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 01:50:11 PM
-- Design Name: 
-- Module Name: Final_BASYS3 - Final_BASYS3_ARCH
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

entity Final_BASYS3 is
  Port (
    sw: in std_logic_vector(0 downto 0);
    led: out std_logic_vector(2 downto 0);
    clk: in std_logic;
    btnC: in std_logic
    );
    
end Final_BASYS3;

architecture Final_BASYS3_ARCH of Final_BASYS3 is
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
        dirMode => sw(0),
        clock => clk,
        reset => btnC,
        leds => led
        );

end Final_BASYS3_ARCH;
