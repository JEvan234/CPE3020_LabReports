----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2026 12:37:47 PM
-- Design Name: 
-- Module Name: Practicum2 - Practicum2_ARCH
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

entity Practicum2 is
  Port (
    clk: in std_logic;
    DataIn: in std_logic_vector(7 downto 0);
    loadEn: in std_logic;
    clearEn: in std_logic;
    clearMode: in std_logic;
    dataOut: out std_logic_vector(7 downto 0));
    
end Practicum2;

architecture Practicum2_ARCH of Practicum2 is

begin
    process(clk, clearEn)
    variable dataValue: std_logic_vector( 7 downto 0);
    begin
        dataValue := "00000000";
        if rising_edge(clk) then
            if (clearEn = '1') then
                if (clearMode = '1') then
                    dataValue(7 downto 4) := "0000";
                elsif (clearMode = '0') then
                    dataValue(3 downto 0) := "0000";
                end if;
            else
                if (loadEn = '1') then
                    dataValue := DataIn;
                end if;
            end if;
        else
            dataOut <= dataValue;
        end if;
        dataOut <= dataValue;
    end process;
                
end Practicum2_ARCH;
