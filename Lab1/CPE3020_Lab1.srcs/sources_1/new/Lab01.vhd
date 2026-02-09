----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 02/09/2026 02:52:51 PM
-- Design Name: Referree Lab
-- Module Name: Lab01 - Lab01_ARCH
-- Project Name: 
-- Target Devices: Basys3 - Artix 7 FPGA Board
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

entity Lab01 is
    port (
    A: in std_logic;
    B: in std_logic;
    C: in std_logic;
    D: in std_logic;
    F: out std_logic
  );
end Lab01;

architecture Lab01_ARCH of Lab01 is

begin
    F <= (A AND (B OR C OR D)) OR (B AND C AND D);

end Lab01_ARCH;