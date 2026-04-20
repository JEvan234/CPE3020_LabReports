// Final Project: Trevor Cooper and Jacob Evans

#set page(paper: "a4")
#set text(size:24pt, font: "JetBrainsMono NF")
#set raw(syntaxes: "VHDL.sublime-syntax")

= Project
LED Light Strip Pong Game
#v(200pt)
#set text(size: 12pt)
Designer: Trevor Cooper and Jacob Evans \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 04 - 03 \
#pagebreak()

= Design Description
In this design, We will be building on from our lab 4 assignment and allow for all 8 lights to be lit up as a single background color, 
selectable from the right switches. On top of this we will add a "ball" that has its own selectable color and its position on the strip 
can be changed from a button input. All button inputs will be debounced and metastable.

= Component Diagram
#figure(image("assets/Project/Component05.svg",
  width: 100%))

= Design Block Diagram
#figure(image("assets/Project/Design05.svg",
  width: 100%))

= Design Code
```vhdl
-- Design Code goes here
```

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
    
    procedure metastabilize1 (
        signal unstableInput: in std_logic;
        signal stage1Output: out std_logic
    );
    
    -- To use this multistage procedure in metastability, use a signal as the stage1 input and stage one output
    
    procedure metastabilize2 (
        signal stage1Input: in std_logic;
        signal safeOutput: out std_logic
    );
    
    procedure debounce (
        signal bouncedInput        : in  std_logic;
        signal stablePrev  : in  std_logic;
        signal countIn     : in  integer;
        signal countMax    : in  integer;

        signal dbOutput  : out std_logic;
        signal countNext   : out integer
    );
    
end package;


package body stabilization_package is
    constant ACTIVE: std_logic := '1';
    
    -- MetaStability
    
    procedure metastabilize1 (
        signal unstableInput: in  std_logic;
        signal stage1Output: out std_logic
        ) is
    begin
        stage1Output <= unstableInput;
    end procedure;


    procedure metastabilize2 (
        signal stage1Input: in  std_logic;
        signal safeOutput: out std_logic
        ) is
    begin
        safeOutput <= stage1Input;
    end procedure;
    
    
    
    -- Debouncing

    procedure debounce (
        signal bouncedInput: in  std_logic;
        signal stablePrev: in  std_logic;
        signal countIn: in  integer;
        signal countMax: in  integer;

        signal dbOutput: out std_logic;
        signal countNext: out integer
    ) is
    begin

        -- default behavior: keep current state
        dbOutput <= stablePrev;
        countNext  <= countIn;

    -- if input differs from current stable value, reset counter
        if bouncedInput /= stablePrev then
            countNext <= 0;

        else
            if countIn < countMax then
                countNext <= countIn + 1;
            else
                dbOutput <= bouncedInput;
            end if;
        end if;

    end procedure;    
    
end package body;

-- Refer to github readme for example usecase
```

= Simulation Block Diagram
#figure(image("assets/Project/Testbench05.svg",
  width: 100%))

= Simulation Code
```vhdl
-- Test Bench code goes here
```

= Simulation Results
// Talk to trevor about simulation

= Wrapper Block Diagram
//Make Wrapper

= Wrapper Code
```vhdl
-- Wrapper Code goes here
```