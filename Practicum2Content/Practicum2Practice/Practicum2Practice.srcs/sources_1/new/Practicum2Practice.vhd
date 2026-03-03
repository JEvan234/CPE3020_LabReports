----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 03/02/2026 02:18:53 PM
-- Design Name: 
-- Module Name: Practicum2Practice - Practicum2Practice_ARCH
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

entity Practicum2Practice is
  Port (
    switches: in std_logic_vector(2 downto 0);
    load: in std_logic;
    reset: in std_logic;
    output: out std_logic_vector(2 downto 0);
    clk: in std_logic);
    
end Practicum2Practice;

architecture Practicum2Practice_ARCH of Practicum2Practice is

begin
    process(clk,reset)
    variable reg_value: std_logic_vector(2 downto 0);
    begin
        if rising_edge(clk) then
            if (reset = '1') then
                reg_value := "000";
            elsif load = '1' then
                reg_value := switches;
            end if;
        end if;
        output <= reg_value;
    end process;
            
end Practicum2Practice_ARCH;