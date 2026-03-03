----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/03/2026 02:22:47 PM
-- Design Name: 
-- Module Name: Practicum2Practice_BASYS3 - Practicum2Practice_BASYS3_ARCH
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

-- Declare ports from the constraint file (sw and such)
entity Practicum2Practice_BASYS3 is
  Port (
    clk: in std_logic;
    btnL: in std_logic;
    btnR: in std_logic;
    sw: in std_logic_vector(2 downto 0));
    
end Practicum2Practice_BASYS3;

architecture Practicum2Practice_BASYS3_ARCH of Practicum2Practice_BASYS3 is

-- Define this from main design file (can resue from testbench)
    component Practicum2Practice is
        Port (
            switches: in std_logic_vector(2 downto 0);
            load: in std_logic;
            reset: in std_logic;
            output: out std_logic_vector(2 downto 0);
            clk: in std_logic);
    end component;
    -- Might need to declare if using internal signals (everything from UUT must be bound)
    signal output_internal: std_logic_vector(2 downto 0);

begin
    -- Declare the UUT, (design => basys3 part)
    UUT: Practicum2Practice port map(
        clk => clk,
        load => btnL,
        reset => btnR,
        switches => sw,
        output => output_internal
    );


end Practicum2Practice_BASYS3_ARCH;
