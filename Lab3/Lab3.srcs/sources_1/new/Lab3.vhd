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

constant DEBOUNCE_MAX : unsigned(19 downto 0) := to_unsigned(5, 20); -- adjust for ~10ms

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