----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2026 06:35:18 PM
-- Design Name: 
-- Module Name: Practicum1Practice2 - Practicum1Practice2_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Detect when either switches 0 & 3 or switches 1 & 2 are active

-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;


entity Practicum1Practice2 is
  Port (
    switch0: in std_logic;
    switch1: in std_logic;
    switch2: in std_logic;
    switch3: in std_logic;
    led0: out std_logic);
    
end Practicum1Practice2;

architecture Practicum1Practice2_ARCH of Practicum1Practice2 is

begin
    led0 <= (switch0 AND switch3) XOR (switch1 AND switch2);

end Practicum1Practice2_ARCH;
