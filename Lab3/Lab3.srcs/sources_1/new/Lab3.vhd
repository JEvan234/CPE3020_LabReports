----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 02/23/2026 05:46:14 PM
-- Design Name: 
-- Module Name: Lab3 - Lab3_ARCH
-- Project Name: 
-- Target Devices: Artix 7 - Basys 3 FPGA Board
-- Description: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
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

signal led_state     : std_logic_vector(15 downto 0) := "0000000000000001";

signal right_digit   : std_logic_vector(3 downto 0) := "0000";
signal blankEn       : std_logic := '0';

-- Debounce Signals
signal left_sync, right_sync       : std_logic := '0';
signal left_count, right_count     : unsigned(19 downto 0) := (others => '0');
signal left_db, right_db           : std_logic := '0'; -- debounced signals
signal left_prev_db, right_prev_db : std_logic := '0'; -- previous debounced states

constant DEBOUNCE_MAX : unsigned(19 downto 0) := x"FFFFF"; -- adjust for ~10ms

begin

-- process for led lights
process(clk, reset)
begin
    if reset = '1' then
        -- reset everything (including debounce values)
        led_state       <= "0000000000000001";
        left_count      <= (others => '0');
        right_count     <= (others => '0');
        left_db         <= '0';
        right_db        <= '0';
        left_prev_db    <= '0';
        right_prev_db   <= '0';
    elsif rising_edge(clk) then

        -- LEFT BUTTON DEBOUNCE -- (works by adding a small delay with the counter to count past the bounced period)
        left_sync <= leftButton;  -- assign the button input to the synced input
        if left_sync = left_db then
            left_count <= (others => '0');  -- stable, reset counter
        else
            if left_count < DEBOUNCE_MAX then
                left_count <= left_count + 1;
            else
                left_db <= left_sync;  -- stable long enough, update debounced
                left_count <= (others => '0');
            end if;
        end if;

        -- RIGHT BUTTON DEBOUNCE --
        right_sync <= rightButton;
        if right_sync = right_db then
            right_count <= (others => '0');
        else
            if right_count < DEBOUNCE_MAX then
                right_count <= right_count + 1;
            else
                right_db <= right_sync;
                right_count <= (others => '0');
            end if;
        end if;

        -- Input Detection --
        -- Move LED Left
        if (left_db = '1' and left_prev_db = '0') then
            if led_state /= "1000000000000000" then
                led_state <= std_logic_vector(unsigned(led_state) sll 1);
            end if;
        end if;

        -- Move LED Right
        if (right_db = '1' and right_prev_db = '0') then
            if led_state /= "0000000000000001" then
                led_state <= std_logic_vector(unsigned(led_state) srl 1);
            end if;
        end if;

        -- Update previous states for edge detection
        left_prev_db  <= left_db;
        right_prev_db <= right_db;

    end if;
end process;

-- Process for 7 seg display
process(clk, reset)
begin
    if reset = '1' then
        blankEn    <= '1';
    elsif rising_edge(clk) then
        case led_state is
            when "0000000000000010" =>
                right_digit <= "0001";  -- 1
                blankEn     <= '1';
            when "0000000000000100" =>
                right_digit <= "0010";  -- 2
                blankEn     <= '1';
            when "0000000000001000" =>
                right_digit <= "0011";  -- 3
                blankEn     <= '1';
            when "0000000000010000" =>
                right_digit <= "0100";  -- 4
                blankEn     <= '1';
            when "0000000000100000" =>
                right_digit <= "0101";  -- 5
                blankEn     <= '1';
            when "0000000001000000" =>
                right_digit <= "0110";  -- 6
                blankEn  <= '1';
            when "0000000010000000" =>
                right_digit <= "0111";  -- 7
                blankEn     <= '1';
            when "0000000100000000" =>
                right_digit <= "1000";  -- 8
                blankEn     <= '1';
            when "0000001000000000" =>
                right_digit <= "1001";  -- 9
                blankEn     <= '1';
            when "0000010000000000" =>
                right_digit <= "0000";  -- 10
                blankEn     <= '0';
            when "0000100000000000" =>
                right_digit <= "0001";  -- 11
                blankEn     <= '0';
            when "0001000000000000" =>
                right_digit <= "0010";  -- 12
                blankEn     <= '0';
            when "0010000000000000" =>
                right_digit <= "0011";  -- 13
                blankEn     <= '0';
            when "0100000000000000" =>
                right_digit <= "0100";  -- 14
                blankEn     <= '0';
            when "1000000000000000" =>
                right_digit <= "0101";  -- 15
                blankEn     <= '0';
            when others =>
                right_digit <= "0000";  -- default/0
                blankEn     <= '1';
        end case;
    end if;
end process;
-- Assign leds to proper port outside of process
leds <= led_state;
-- assign the port map to the 7 seg driver
 SEG_DRIVER_INST: entity work.SevenSegmentDriver
        port map (
            reset      => reset,
            clock      => clk,
            digit3     => "0000",        -- unused
            digit2     => "0000",        -- unused
            digit1     => "0001",    -- tens place
            digit0     => right_digit,   -- ones place
            blank3     => '1',
            blank2     => '1',
            blank1     => blankEn,
            blank0     => '0',
            sevenSegs  => sevenSegs,
            anodes     => anodes
        );

end Lab3_ARCH;