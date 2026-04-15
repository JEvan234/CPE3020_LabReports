// Final Project: Trevor Cooper and Jacob Evans

#set page(paper: "a4")
#set text(size:32pt, font: "JetBrainsMono NF")
#set raw(syntaxes: "VHDL.sublime-syntax")

= Project
LED Light Strip Pong Game
#v(200pt)
#set text(size: 16pt)
Designer: Trevor Cooper and Jacob Evans \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 04 - 03 \
#pagebreak()

= Design Description
In this design, We will be building on from our lab 4 assignment and allow for all 8 lights to be lit up as a single background color, selectable from the right switches. On top of this we will add a "ball" that has its own selectable color and its position on the strip can be changed from a button input. All button inputs will be debounced and metastable.

= Component Diagram
#figure(image("assets/Project/Component05.svg",
  width: 100%))

= Design Block Diagram
#figure(image("assets/Project/Design05.svg",
  width: 100%))

= Package Code
```vhdl
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
```

= Design Code

= Simulation Block Diagram
#figure(image("assets/Project/Testbench05.svg",
  width: 100%))

= Simulation Code

= Simulation Results

= Wrapper Block Diagram

= Wrapper Code