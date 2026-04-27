----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/27/2026 04:56:40 PM
-- Design Name: 
-- Module Name: Final_Practice - Final_Practice_ARCH
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

entity Final_Practice is
  Port (
    switches: in std_logic_vector(1 downto 0);
    leds: out std_logic_vector(1 downto 0);
    clock: in std_logic;
    reset: in std_logic);
end Final_Practice;

architecture Final_Practice_ARCH of Final_Practice is
    -- Constants
    constant ACTIVE: std_logic := '1';
    
    constant ZERO: std_logic_vector := "00";
    constant ONE: std_logic_vector := "01";
    constant TWO: std_logic_vector := "10";
    constant THREE: std_logic_vector := "11";
    
    -- States
    type states_t is (STATE_ZERO, STATE_ONE, STATE_TWO, STATE_THREE);
    signal currentState: states_t;
    signal nextState: states_t;
    
begin

    STATE_TRAN: process(clock, reset)
    begin
        if reset = ACTIVE then
            currentState <= STATE_ZERO;
        elsif rising_edge(clock) then
            currentState <= nextState;
        end if;
    end process;
    
    -- Be sure to call currentState in the process
    STATE_REG: process(currentState, switches)
    begin
        case (currentState) is
            when STATE_ZERO =>
                --Zero Case
                leds <= ZERO;
                if switches = ONE then
                    nextState <= STATE_ONE;
                    
                elsif switches = TWO then
                    nextState <= STATE_TWO;
                    
                elsif switches = THREE then
                    nextState <= STATE_THREE;
                    
                else
                    nextState <= STATE_ZERO;
                end if;
                
            when STATE_ONE =>
                --One Case
                leds <= ONE;
                if switches = ZERO then
                    nextState <= STATE_ZERO;
                    
                elsif switches = TWO then
                    nextState <= STATE_TWO;
                    
                elsif switches = THREE then
                    nextState <= STATE_THREE;
                    
                else
                    nextState <= STATE_ONE;
                end if;
                
            when STATE_TWO =>
                -- Two case
                leds <= TWO;
                if switches = ONE then
                    nextState <= STATE_ONE;
                    
                elsif switches = ZERO then
                    nextState <= STATE_ZERO;
                    
                elsif switches = THREE then
                    nextState <= STATE_THREE;
                    
                else
                    nextState <= STATE_TWO;
                end if;
                
            when STATE_THREE =>
                -- 3 case
                leds <= THREE;
                if switches = ONE then
                    nextState <= STATE_ONE;
                    
                elsif switches = TWO then
                    nextState <= STATE_TWO;
                    
                elsif switches = ZERO then
                    nextState <= STATE_ZERO;
                    
                else
                    nextState <= STATE_THREE;
                end if;
                
        end case;
    end process;

end Final_Practice_ARCH;