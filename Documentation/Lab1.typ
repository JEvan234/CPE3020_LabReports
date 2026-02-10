// Lab report 1: Jacob Evans

#set page(
	paper: "a4"
)
#set text(size: 32pt)
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
	image("./assets/Lab01/Component01.svg"),
	caption: [Component Diagram]
)

= Design Diagram
#figure(
	image("./assets/Lab01/Design01.svg"),
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
  image("./assets/Lab01/Testbench01.svg"),
  caption: [Test Bench Block Diagram]
)

= Test Bench Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 02/09/2026 02:52:51 PM
-- Design Name: Referree Lab
-- Module Name: Lab01_TB - Lab01_TB_ARCH
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

entity Lab01_TB is
--  Port ( );
end Lab01_TB;

architecture Lab01_TB_ARCH of Lab01_TB is
    signal switch00: std_logic := '0';
    signal switch01: std_logic := '0';
    signal switch02: std_logic := '0';
    signal switch03: std_logic := '0';
    signal led00: std_logic;
    
    component Lab01 is
        Port (
            switch00: in std_logic;
            switch01: in std_logic;
            switch02: in std_logic;
            switch03: in std_logic;
            led00: out std_logic
        );
    end component;
    
begin
    UUT: Lab01 port map(
        switch00 => switch00,
        switch01 => switch01,
        switch02 => switch02,
        switch03 => switch03,
        led00 => led00
    );
    process
    begin
        switch00 <= '0';
        switch01 <= '0';
        switch02 <= '0';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '0';
        switch02 <= '0';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '0';
        switch02 <= '1';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '0';
        switch02 <= '1';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '1';
        switch02 <= '0';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '1';
        switch02 <= '0';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '1';
        switch02 <= '1';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '1';
        switch02 <= '1';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '0';
        switch02 <= '0';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '0';
        switch02 <= '0';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '0';
        switch02 <= '1';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '0';
        switch02 <= '1';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '1';
        switch02 <= '0';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '1';
        switch02 <= '0';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '1';
        switch02 <= '1';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '1';
        switch02 <= '1';
        switch03 <= '1';
        wait for 10 ns;
        wait;
    end process;
    

end Lab01_TB_ARCH;
```
#pagebreak()
= Basys3 Wrapper Block Diagram
#figure(
  image("./assets/Lab01/Wrapper01.svg"),
  caption: [Basys3 Wrapper Block Diagram]
)

= Basys3 Wrapper Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 02/09/2026 02:52:51 PM
-- Design Name: Referree Lab
-- Module Name: Lab01_Basys3 - Lab01_Basys3_ARCH
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

entity Lab01_Basys3 is
  Port (
  sw : in std_logic_vector (3 downto 0);
  led : out std_logic_vector (0 downto 0));
end Lab01_Basys3;

architecture Lab01_Basys3_ARCH of Lab01_Basys3 is

    signal switch00: std_logic := '0';
    signal switch01: std_logic := '0';
    signal switch02: std_logic := '0';
    signal switch03: std_logic := '0';
    signal led00: std_logic;
    
    component Lab01 is
        Port (
            switch00: in std_logic;
            switch01: in std_logic;
            switch02: in std_logic;
            switch03: in std_logic;
            led00: out std_logic
        );
    end component;
begin
    UUT: Lab01 port map(
    switch00 => sw(0),
    switch01 => sw(1),
    switch02 => sw(2),
    switch03 => sw(3),
    led00 => led(0)
    );

end Lab01_Basys3_ARCH;
```