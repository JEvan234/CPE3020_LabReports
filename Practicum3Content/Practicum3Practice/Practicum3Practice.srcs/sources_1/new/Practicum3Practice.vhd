----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/06/2026 05:35:34 PM
-- Design Name: 
-- Module Name: Practicum3Practice - Practicum3Practice_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: Displays a different LED per state, uses debounced buttons to change between states
-- 
-- Dependencies: 
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Practicum3Practice is
  Port (
    nextButton: in std_logic;
    prevButton: in std_logic;
    clock: in std_logic;
    reset: in std_logic;
    leds: out std_logic_vector(3 downto 0));
    
end Practicum3Practice;

architecture Practicum3Practice_ARCH of Practicum3Practice is

    type states_t is (STATE_A, STATE_B, STATE_C, STATE_D);
    signal currentState: states_t;
    signal nextState: states_t;

begin

STATE_TRAN: process(clock, reset)
begin
    -- Process for state transitions, double check
    if reset = '1' then
        currentState <= STATE_A;
    else
        if rising_edge(clock) then
            nextState <= currentState;
        end if;
    end if;

end process;


STATE_REG: process
begin
    -- process for storing state data
    case currentState is
        when STATE_A =>
            --state a
            
        when STATE_B =>
            -- state b
            
        when STATE_C =>
            -- state c
        
        when STATE_D =>
            -- state d
    end case;

end process;

end Practicum3Practice_ARCH;
