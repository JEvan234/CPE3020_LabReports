----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper and Jacob Evans
-- 
-- Create Date: 04/11/2026 02:15:31 PM
-- Design Name: CPE3020 Project
-- Module Name: final_BASYS - final_BASYS_ARCH
-- Project Name: RGB light strip pong game
-- Target Devices: Basys3 - Artix 7
-- Description: Basys 3 Wrapper for the final project
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

entity final_BASYS is
  Port (
    clk     : in std_logic;                       -- 100 MHz clock
    sw      : in std_logic_vector(15 downto 0);    -- all switches
    btnC    : in std_logic;                       -- reset button
    btnR    : in std_logic;                       -- right button
    btnL    : in std_logic;                       -- left button
    JA      : out std_logic_vector(7 downto 0);    -- RGB data line
    seg: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0)

  );
end final_BASYS;

architecture final_BASYS_ARCH of final_BASYS is
    signal internal_sw : std_logic_vector(5 downto 0);
    
    component final
        port(
            switches: in std_logic_vector(5 downto 0);
            leftButton: in std_logic;
            rightButton: in std_logic;
            reset: in std_logic;
            clock: in std_logic;
            dataOut: out std_logic;
            segments: out std_logic_vector(6 downto 0);
            anodes: out std_logic_vector(3 downto 0)
        );
    end component;

begin
    internal_sw <= sw(15 downto 13) & sw(2 downto 0);
    UUT: final port map(
        clock => clk,
        reset => btnC,
        leftButton => btnL,
        rightButton => btnR,
        switches => internal_sw,
        dataOut => JA(0),
        segments => seg,
        anodes => an
    );
    -- prevent floating pins
    JA(7 downto 1) <= (others => '0');
    
end final_BASYS_ARCH;
