----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evams
-- 
-- Create Date: 03/17/2026 01:17:58 PM
-- Design Name: Sequential Shifter
-- Module Name: Lab3_BASYS3 - Lab3_BASYS3_ARCH
-- Target Devices: Artix 7 - Basys 3 FPGA Board
-- Description: Wrapper file to assign inputs and outputs to the corresponding board buttons and lights.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab3_BASYS3 is
  Port (
    clk : in std_logic;
    btnL : in std_logic;
    btnC : in std_logic;
    btnR : in std_logic;
    led : out std_logic_vector(15 downto 0);
    an: out std_logic_vector(3 downto 0);
    seg: out std_logic_vector(6 downto 0)
    );
end Lab3_BASYS3;

architecture Lab3_BASYS3_ARCH of Lab3_BASYS3 is

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

begin

    UUT: Lab3
        port map(
        leftButton  => btnL,
        rightButton => btnR,
        clk         => clk,
        reset       => btnC,
        leds        => led,
        sevenSegs   => seg,
        anodes      => an
        );

end Lab3_BASYS3_ARCH;
