// Lab report 1: Jacob Evans

#set page(
	paper: "a4"
)
#set text(size: 24pt, font: "DejaVu Sans")

= Lab01
Referree Lab
#v(200pt)
#set text(size: 16pt)
Designer: Jacob Evans \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 02 - 04 \
#pagebreak()
= Design Description
The purpose of this design is to take in 4 switch inputs from "refs" as either a high or low call, and then return the resulting total call in the form of an led output. 

= Component Diagram
#figure(
	image("./assets/Component01.svg"),
	caption: [Component Diagram]
)

= Design Diagram
#figure(
	image("./assets/Design01.svg"),
  caption: [Design Diagram]
)
#pagebreak()
= Design Code
#set raw(syntaxes: "VHDL.sublime-syntax")

```vhdl
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
```

#pagebreak()
= Test Bench Diagram
#figure(
  image("./assets/Testbench01.svg"),
  caption: [Test Bench Block Diagram]
)
#pagebreak()
= Test Bench Code

#pagebreak()
= Basys3 Wrapper Block Diagram
#figure(
  image("./assets/Wrapper.svg"),
  caption: [Basys3 Wrapper Block Diagram]
)
#pagebreak()
= Basys3 Wrapper Code