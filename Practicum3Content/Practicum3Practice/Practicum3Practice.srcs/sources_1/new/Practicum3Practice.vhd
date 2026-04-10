----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 04/06/2026 05:35:34 PM
-- Design Name: 
-- Module Name: Practicum3Practice - Practicum3Practice_ARCH
-- Project Name: Practice for State Machine practicum
-- Target Devices: Basys 3 - Artix 7
-- Tool Versions: 
-- Description: Displays a different LED per state, uses debounced buttons to change between states
-- 
-- Dependencies: none
-- 
-- Revision: none
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Practicum3Practice is
  Port (
    -- Define all the ports, these are not device specific
    nextButton: in std_logic;
    prevButton: in std_logic;
    clock: in std_logic;
    reset: in std_logic;
    leds: out std_logic_vector(3 downto 0));
    
end Practicum3Practice;

architecture Practicum3Practice_ARCH of Practicum3Practice is
    -- Define the state_type and all possible states
    type states_t is (STATE_A, STATE_B, STATE_C, STATE_D);
    -- Define current and next state for the transition logic
    signal currentState: states_t;
    signal nextState: states_t;

    -- Created internal debounced signals
    signal dbNextButton: std_logic;
    signal dbPrevButton: std_logic;

begin

-- First, debounce the inputs
DEBOUNCE: process(clock, reset)
    -- Create internal counters, this debounce is sequential, also look into the Held state
    variable countNext : integer := 0;
    variable countPrev : integer := 0;
    variable nextHeld  : std_logic := '0';
    variable prevHeld  : std_logic := '0';
begin
    -- Give reset condition, reset everything to 0
    if reset = '1' then
        countNext := 0;
        countPrev := 0;
        nextHeld := '0';
        prevHeld := '0';
        dbNextButton <= '0';
        dbPrevButton <= '0';
    -- For main logic, should be done in rising edge
    elsif rising_edge(clock) then
        dbNextButton <= '0';
        dbPrevButton <= '0';
        -- Check if condition for nextButton
        if nextButton = '1' then
            -- if the button is held, but held state is 0, count up, once the count maxes out, the debounced button output is 1, and held state goes to 1
            if nextHeld = '0' then
                if countNext < 500000 then
                    countNext := countNext + 1;
                else
                    dbNextButton <= '1';
                    nextHeld := '1';
                end if;
            end if;
        else
            -- if the button input is not one, reset the count and held state
            countNext := 0;
            nextHeld := '0';
        end if;
        
        -- Same process for previous button
        if prevButton = '1' then
            if prevHeld = '0' then
                if countPrev < 500000 then
                    countPrev := countPrev + 1;
                else
                    dbPrevButton <= '1';
                    prevHeld := '1';
                end if;
            end if;
        else
            countPrev := 0;
            prevHeld := '0';
        end if;

    end if;
end process;

-- Process for transitioning between states (reset to state A, otherwise make the current state the next state on clock edge
STATE_TRAN: process(clock, reset)
begin
    if reset = '1' then
        currentState <= STATE_A;
    elsif rising_edge(clock) then
        currentState <= nextState;
    end if;
end process;

-- Process for storing all of the states data
STATE_REG: process(currentState, dbNextButton, dbPrevButton)
begin

    case currentState is
        when STATE_A =>
            -- Set the condition for each state, if a button state is not pressed, then the state stays the same, state must have that logic for any kind of memory
            leds <= "0001";
            nextState <= currentState;
            -- Button conditions for the state
            if dbNextButton = '1' then
                nextState <= STATE_B;
            elsif dbPrevButton = '1' then
                nextState <= STATE_D;
            end if;
        
        -- Same logic for all other states
        when STATE_B =>
            leds <= "0010";
            nextState <= currentState;
            if dbNextButton = '1' then
                nextState <= STATE_C;
            elsif dbPrevButton = '1' then
                nextState <= STATE_A;
            end if;

        when STATE_C =>
            leds <= "0100";
            nextState <= currentState;
            if dbNextButton = '1' then
                nextState <= STATE_D;
            elsif dbPrevButton = '1' then
                nextState <= STATE_B;
            end if;

        when STATE_D =>
            leds <= "1000";
            nextState <= currentState;
            if dbNextButton = '1' then
                nextState <= STATE_A;
            elsif dbPrevButton = '1' then
                nextState <= STATE_C;
            end if;
    end case;

end process;

end Practicum3Practice_ARCH;