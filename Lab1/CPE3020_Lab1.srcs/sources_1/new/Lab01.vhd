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
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab01 is
    port (
    switch00: in std_logic;
    switch01: in std_logic;
    switch02: in std_logic;
    switch03: in std_logic;
    led00: out std_logic
  );
end Lab01;

architecture Lab01_ARCH of Lab01 is

begin
    led00 <= (switch00 AND (switch01 OR switch02 OR switch03)) OR (switch01 AND switch02 AND switch03);

end Lab01_ARCH;