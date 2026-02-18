----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2026 12:43:41 PM
-- Design Name: 
-- Module Name: Practicum1 - Practicum1_ARCH
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

entity Practicum1 is
  Port (
    sensors: in std_logic_vector(3 downto 0);
    even: out std_logic;
    odd: out std_logic);
    
end Practicum1;

architecture Practicum1_ARCH of Practicum1 is

begin
    CHECK_EVEN: with sensors select
        even <= '1' when "0011"|"0110"|"1100"|"1001"|"1010"|"0101"|"1111",
                '0' when others;
                
    CHECK_ODD: with sensors select
        odd <= '1' when "0001"|"0010"|"0100"|"1000"|"1110"|"1101"|"1011"|"0111",
               '0' when others;

end Practicum1_ARCH;
