----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper and Jacob Evans 
-- 
-- Create Date: 04/10/2026 05:33:55 PM
-- Design Name: stabilization_package
-- Module Name: stabilization_package - stabilization_package_ARCH
-- Project Name: Package for Lap Project
-- Target Devices: Basys3 - Artix 7
-- Description: Provides functions and contants to metastabilize and debounce button inputs
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package stabilization_package is 
    constant ACTIVE: std_logic;
    function metastabilize (unstableInput: std_logic; reset: std_logic; signal clock: std_logic) return std_logic;
end package;


package body stabilization_package is
    constant ACTIVE: std_logic := '1';

    function metastabilize (unstableInput: std_logic; reset: std_logic; signal clock: std_logic) return std_logic is
        variable safeOutput: std_logic;
        variable unsafeOutput: std_logic;
    begin
        if (reset=ACTIVE) then
            safeOutput := not ACTIVE;
            unsafeOutput := not ACTIVE;
        elsif (rising_edge(clock)) then
            safeOutput := unsafeOutput;
            unsafeOutput := unstableInput;
        end if;
            return safeOutput;
    end function;
    
    
end package body;