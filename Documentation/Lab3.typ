// Lab Report 3: Jacob Evans

#set page(paper: "a4")
#set text(size:32pt)
#set raw(syntaxes: "VHDL.sublime-syntax")

= Lab03
Sequential Shifter Lab
#v(200pt)
#set text(size: 16pt)
Designer: Jacob Evans \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 02 - 25 \
#pagebreak()

= Design Description
In this lab I used sequential design to implement a lit LED that can "jump" its position across the 16 lights of the Basys 3 Board. In other words, if there is an input at btnL or btnR, then the light to the corresponding direction will be lit and the original will be turned off.

= Component Diagram
#figure(image("assets/Lab03/Component03.svg"),
  caption: [Component Block Diagram])

= Design Block Diagram
#figure(image("assets/Lab03/Design03.svg",
  width: 90%),
  caption: [Design Block Diagram])

= Design Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 02/23/2026 05:46:14 PM
-- Design Name: Sequential Shifter
-- Module Name: Lab3 - Lab3_ARCH
-- Project Name: 
-- Target Devices: Artix 7 - Basys 3 FPGA Board
-- Description: This device takes button inputs and coorelates them to an led that can "jump" from position to position across the leds from 0 to 15.
-- It also shows the current led value on the 7-segment display.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab3 is
  Port (
    leftButton  : in  std_logic;
    rightButton : in  std_logic;
    clk         : in  std_logic;
    reset       : in  std_logic;
    leds        : out std_logic_vector(15 downto 0);
    sevenSegs   : out std_logic_vector(6 downto 0);
    anodes      : out std_logic_vector(3 downto 0)
  );
end Lab3;

architecture Lab3_ARCH of Lab3 is

signal ledState     : std_logic_vector(15 downto 0) := "0000000000000001";

signal rightDigit   : std_logic_vector(3 downto 0) := "0000";
signal blankEn       : std_logic := '0';

-- Debounce Signals
signal leftSync, rightSync       : std_logic := '0';
signal leftCount, rightCount     : unsigned(19 downto 0) := (others => '0');
signal leftDb, rightDb           : std_logic := '0'; -- debounced signals
signal leftPrevDb, rightPrevDb   : std_logic := '0'; -- previous debounced states

constant DEBOUNCE_MAX : unsigned(19 downto 0) := x"FFFFF"; -- adjust for ~10ms

begin

-- process for led lights
process(clk, reset)
begin
    if reset = '1' then
        ledState       <= "0000000000000001";
        leftCount      <= (others => '0');
        rightCount     <= (others => '0');
        leftDb         <= '0';
        rightDb        <= '0';
        leftPrevDb    <= '0';
        rightPrevDb   <= '0';
        
    elsif rising_edge(clk) then
        -- Left Button Debounce -- (works by adding a small delay to count past a certain period)
        leftSync <= leftButton;  -- assign the button input to the synced input
        if leftSync = leftDb then
            -- reset the count if signals match
            leftCount <= (others => '0');
        else
            -- count up if they dont
            if leftCount < DEBOUNCE_MAX then
                leftCount <= leftCount + 1;
            else
                -- once the counter passes the set max, apply the synced value to the Db input
                leftDb <= leftSync;
                leftCount <= (others => '0');
            end if;
        end if;
        -- Right Button Debounce --
        rightSync <= rightButton;
        if rightSync = rightDb then
            rightCount <= (others => '0');
        else
            if rightCount < DEBOUNCE_MAX then
                rightCount <= rightCount + 1;
            else
                rightDb <= rightSync;
                rightCount <= (others => '0');
            end if;
        end if;

        -- Input Detection --
        -- Move LED Left
        if (leftDb = '1' and leftPrevDb = '0') then
            if ledState /= "1000000000000000" then
                ledState <= std_logic_vector(unsigned(ledState) sll 1);
            end if;
        end if;

        -- Move LED Right
        if (rightDb = '1' and rightPrevDb = '0') then
            if ledState /= "0000000000000001" then
                ledState <= std_logic_vector(unsigned(ledState) srl 1);
            end if;
        end if;

        -- Update previous states for edge detection
        leftPrevDb  <= leftDb;
        rightPrevDb <= rightDb;

    end if;
end process;

-- Process for 7 seg display
process(clk, reset)
begin
    if reset = '1' then
        blankEn    <= '1';
    elsif rising_edge(clk) then
        case ledState is
            when "0000000000000010" =>
                rightDigit <= "0001";  -- 1
                blankEn     <= '1';
            when "0000000000000100" =>
                rightDigit <= "0010";  -- 2
                blankEn     <= '1';
            when "0000000000001000" =>
                rightDigit <= "0011";  -- 3
                blankEn     <= '1';
            when "0000000000010000" =>
                rightDigit <= "0100";  -- 4
                blankEn     <= '1';
            when "0000000000100000" =>
                rightDigit <= "0101";  -- 5
                blankEn     <= '1';
            when "0000000001000000" =>
                rightDigit <= "0110";  -- 6
                blankEn  <= '1';
            when "0000000010000000" =>
                rightDigit <= "0111";  -- 7
                blankEn     <= '1';
            when "0000000100000000" =>
                rightDigit <= "1000";  -- 8
                blankEn     <= '1';
            when "0000001000000000" =>
                rightDigit <= "1001";  -- 9
                blankEn     <= '1';
            when "0000010000000000" =>
                rightDigit <= "0000";  -- 10
                blankEn     <= '0';
            when "0000100000000000" =>
                rightDigit <= "0001";  -- 11
                blankEn     <= '0';
            when "0001000000000000" =>
                rightDigit <= "0010";  -- 12
                blankEn     <= '0';
            when "0010000000000000" =>
                rightDigit <= "0011";  -- 13
                blankEn     <= '0';
            when "0100000000000000" =>
                rightDigit <= "0100";  -- 14
                blankEn     <= '0';
            when "1000000000000000" =>
                rightDigit <= "0101";  -- 15
                blankEn     <= '0';
            when others =>
                rightDigit <= "0000";  -- default/0
                blankEn     <= '1';
        end case;
    end if;
end process;
-- Assign leds to proper port outside of process
leds <= ledState;
-- assign the port map to the 7 seg driver
 SEG_DRIVER_INST: entity work.SevenSegmentDriver
        port map (
            reset      => reset,
            clock      => clk,
            digit3     => "0000",        -- unused
            digit2     => "0000",        -- unused
            digit1     => "0001",        -- tens place
            digit0     => rightDigit,    -- ones place
            blank3     => '1',
            blank2     => '1',
            blank1     => blankEn,
            blank0     => '0',
            sevenSegs  => sevenSegs,
            anodes     => anodes
        );

end Lab3_ARCH;
```

= Test Bench Block Diagram
#figure(image("assets/Lab03/Testbench03.svg",
  width: 90%),
  caption: [Test Bench Diagram])

= Test Bench Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 03/17/2026 01:18:48 PM
-- Design Name: Sequential Shifter
-- Module Name: Lab3_TB - Lab3_TB_ARCH
-- Project Name: 
-- Target Devices: Artix 7 - Basys 3 FPGA Board
-- Description: Simulation file for the lab3 design. goes up 3 and down 3 due to time restrictions
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab3_TB is
--  Port ( );
end Lab3_TB;

architecture Lab3_TB_ARCH of Lab3_TB is

    component Lab3 is
        Port (
            leftButton  : in  std_logic;
            rightButton : in  std_logic;
            clk         : in  std_logic;
            reset       : in  std_logic;
            leds        : out std_logic_vector(15 downto 0);
            sevenSegs   : out std_logic_vector(6 downto 0);
            anodes      : out std_logic_vector(3 downto 0)
        );
    end component;
    
signal leftButton  : std_logic := '0';
signal rightButton : std_logic := '0';
signal clk         : std_logic := '0';
signal reset       : std_logic := '0';
signal leds        : std_logic_vector(15 downto 0);
signal sevenSegs   : std_logic_vector(6 downto 0);
signal anodes      : std_logic_vector(3 downto 0);

begin
    UUT: Lab3
        port map(
        leftButton  => leftButton,
        rightButton => rightButton,
        clk         => clk,
        reset       => reset,
        leds        => leds,
        sevenSegs   => sevenSegs,
        anodes      => anodes
        );
        
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;
    
    -- main input process
    process
    begin
    reset <= '1';
    wait for 100 ns;
    reset <= '0';
    wait for 10 ns;
    leftButton <= '1';
    wait for 120 ns;
    leftButton <= '0';
    wait for 120 ns;
    leftButton <= '1';
    wait for 120 ns;
    leftButton <= '0';
    wait for 120 ns;
    rightButton <= '1';
    wait for 120 ns;
    rightButton <= '0';
    wait for 120 ns;
    rightButton <= '1';
    wait for 120 ns;
    rightButton <= '0';
    wait for 120 ns;
    wait;
    end process;


end Lab3_TB_ARCH;
```
= Test Bench Results
#figure(image("assets/Lab03/Simulation3.png"),
  caption: [Simulation Results])

= Wrapper Block Diagram
#figure(image("assets/Lab03/Wrapper03.svg",
  width: 80%),
  caption: [Wrapper Block Diagram])

= Wrapper Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evams
-- 
-- Create Date: 03/17/2026 01:17:58 PM
-- Design Name: Sequential Shifter
-- Module Name: Lab3_BASYS3 - Lab3_BASYS3_ARCH
-- Target Devices: Artix 7 - Basys 3 FPGA Board
-- Description: Wrapper file to assign inputs and outputs to the corresponding board buttons and lights.
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab3_BASYS3 is
  Port (
    clk : in std_logic;
    btnL : in std_logic;
    btnC : in std_logic;
    btnR : in std_logic;
    led : out std_logic_vector(15 downto 0);
    an: out std_logic_vector(3 downto 0);
    seg: out std_logic_vector(6 downto 0)
    );
end Lab3_BASYS3;

architecture Lab3_BASYS3_ARCH of Lab3_BASYS3 is

    component Lab3 is
        Port (
            leftButton  : in  std_logic;
            rightButton : in  std_logic;
            clk         : in  std_logic;
            reset       : in  std_logic;
            leds        : out std_logic_vector(15 downto 0);
            sevenSegs   : out std_logic_vector(6 downto 0);
            anodes      : out std_logic_vector(3 downto 0)
        );
    end component;

begin

    UUT: Lab3
        port map(
        leftButton  => btnL,
        rightButton => btnR,
        clk         => clk,
        reset       => btnC,
        leds        => led,
        sevenSegs   => seg,
        anodes      => an
        );

end Lab3_BASYS3_ARCH;
```