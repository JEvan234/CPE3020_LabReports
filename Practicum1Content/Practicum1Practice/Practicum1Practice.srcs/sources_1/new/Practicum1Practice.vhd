----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 02/17/2026 02:56:11 PM
-- Design Name: Check2Switch
-- Module Name: Practicum1Practice - Practicum1Practice_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Practicum1Practice is
  Port (
    switches: in std_logic_vector(3 downto 0);
    led00: out std_logic);
    
end Practicum1Practice;

architecture Practicum1Practice_ARCH of Practicum1Practice is

begin
    with switches select
        led00 <= '1' when "0011"|"0110"|"1100"|"0101"|"1010"|"1001",
                 '0' when others;

end Practicum1Practice_ARCH;