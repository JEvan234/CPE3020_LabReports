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
    clk         : in  std_logic;  -- 100 MHz on Basys 3
    reset       : in  std_logic;
    leds        : out std_logic_vector(15 downto 0)
  );
end Lab3;

architecture Lab3_ARCH of Lab3 is

signal led_state     : std_logic_vector(15 downto 0) := "0000000000000001";

-- Debounce signals
signal left_sync, right_sync       : std_logic := '0';
signal left_count, right_count     : unsigned(19 downto 0) := (others => '0');
signal left_db, right_db           : std_logic := '0'; -- debounced signals
signal left_prev_db, right_prev_db : std_logic := '0'; -- previous debounced states

constant DEBOUNCE_MAX : unsigned(19 downto 0) := x"FFFFF"; -- adjust for ~10ms

begin

process(clk, reset)
begin
    if reset = '1' then
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
-- Assign leds to proper port outside of process

leds <= led_state;

end Lab3_ARCH;
