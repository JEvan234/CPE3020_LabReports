----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2026 01:21:10 PM
-- Design Name: 
-- Module Name: Practicum3_BASYS3 - Practicum3_BASYS3_ARCH
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

entity Practicum3_BASYS3 is
  Port (
    sw: in std_logic_vector(1 downto 0);
    seg: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0);
    clk: in std_logic;
    btnC: in std_logic;
    btnR: in std_logic);
    
end Practicum3_BASYS3;

architecture Practicum3_BASYS3_ARCH of Practicum3_BASYS3 is

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

begin

    UUT: Practicum3 port map(
        nextEn => btnR,
        blueMode => sw(0),
        redMode => sw(1),
        segments => seg,
        anodes => an,
        clock => clk,
        reset => btnC);
        
end Practicum3_BASYS3_ARCH;
