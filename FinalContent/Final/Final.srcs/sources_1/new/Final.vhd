----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/29/2026 12:58:41 PM
-- Design Name: 
-- Module Name: Final - Final_ARCH
-- Project Name: 
-- Target Devices: 
-- Tool Versions: 
-- Description: 
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

entity Final is
  Port (
    dirMode: in std_logic;
    clock: in std_logic;
    reset: in std_logic;
    leds: out std_logic_vector(2 downto 0)
    );
end Final;

architecture Final_ARCH of Final is
    -- Constants
    constant ACTIVE: std_logic := '1';
    constant ZERO: std_logic_vector(2 downto 0) := "001";
    constant ONE: std_logic_vector(2 downto 0) := "010";
    constant TWO: std_logic_vector(2 downto 0) := "100";
    
    -- States
    type states_t is (STATE_ZERO, STATE_ONE, STATE_TWO);
    signal currentState: states_t;
    signal nextState: states_t;
    
    -- Signal for clock filtering for 4hz
    signal filterClock: std_logic;
    constant counterMax: integer := 25000000;

begin

    CLOCK_FILTER: process(clock, reset)
        variable counter: integer range 0 to counterMax;
    begin
        if reset = ACTIVE then
            filterClock <= not ACTIVE;
        elsif rising_edge(clock) then
            -- Filter logic
            if counter /= counterMax then
                counter := counter + 1;
                filterClock <= not ACTIVE;
            else
                counter := 0;
                filterClock <= ACTIVE;
            end if;
        end if;
    end process;

    STATE_TRAN: process(filterClock, reset)
    begin
        if reset = ACTIVE then
            currentState <= STATE_ZERO;
        elsif rising_edge(filterClock) then
            currentState <= nextState;
        end if;
    end process;
    
    STATE_REG: process(dirMode, currentState)
    begin
        case currentState is
            when STATE_ZERO =>
                --Zero
                leds <= ZERO;
                if dirMode = ACTIVE then
                    nextState <= STATE_ONE;
                else
                    nextState <= STATE_TWO;
                end if;
                
            when STATE_ONE =>
                --One
                leds <= ONE;
                if dirMode = ACTIVE then
                    nextState <= STATE_TWO;
                else
                    nextState <= STATE_ZERO;
                end if;
                
            when STATE_TWO =>
                --Two
                leds <= TWO;
                if dirMode = ACTIVE then
                    nextState <= STATE_ZERO;
                else
                    nextState <= STATE_ONE;
                end if;
        end case;
    end process;

end Final_ARCH;
