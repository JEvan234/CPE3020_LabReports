----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/08/2026 12:42:53 PM
-- Design Name: 
-- Module Name: Practicum3 - Practicum3_ARCH
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

entity Practicum3 is
  Port (
    nextEn: in std_logic;
    redMode: in std_logic;
    blueMode: in std_logic;
    anodes: out std_logic_vector(3 downto 0);
    segments: out std_logic_vector;
    clock: in std_logic;
    reset: in std_logic);
    
end Practicum3;

architecture Practicum3_ARCH of Practicum3 is
    type state_t is (A,B,C,D,E,F);
    signal currentState: state_t := A;
    signal nextState: state_t := B;


begin

-- bind anodes
anodes <= "1110";

-- Begin state machine logic
STATE_TRAN: process(clock, reset)
begin
    if reset = '1' then
        currentState <= A;
    elsif rising_edge(clock) then
        currentState <= nextState;
    end if;
end process;


STATE_REG: process(redMode, blueMode)
begin
    case currentState is
        when A =>
            segments <= "1111110";
            
            if nextEn = '1' then
                if redMode = '1' and blueMode = '0' then
                    -- clockwise
                    nextState <= B;
                    
                elsif blueMode = '1' and redMode = '0' then
                    -- counter-clockwise
                    nextState <= F;
                    
                else
                    nextState <= A;
                    
                end if;
            else
                nextState <= A;
            end if;
            
        when B =>
            segments <= "1111101";
            
            if nextEn = '1' then
                if redMode = '1' and blueMode = '0' then
                    -- clockwise
                    nextState <= C;
                    
                elsif blueMode = '1' and redMode = '0' then
                    -- counter-clockwise
                    nextState <= A;
                    
                else
                    nextState <= B;
                    
                end if;
            else
                nextState <= B;
            end if;
            
        when C =>
            segments <= "1111011";
            
            if nextEn = '1' then
                if redMode = '1' and blueMode = '0' then
                    -- clockwise
                    nextState <= D;
                    
                elsif blueMode = '1' and redMode = '0' then
                    -- counter-clockwise
                    nextState <= B;
                    
                else
                    nextState <= C;
                    
                end if;
            else
                nextState <= C;
            end if;
            
        when D =>
            segments <= "1110111";
            
            if nextEn = '1' then
                if redMode = '1' and blueMode = '0' then
                    -- clockwise
                    nextState <= E;
                    
                elsif blueMode = '1' and redMode = '0' then
                    -- counter-clockwise
                    nextState <= C;
                    
                else
                    nextState <= D;
                    
                end if;
            else
                nextState <= D;
            end if;
            
        when E =>
            segments <= "1101111";
            
            if nextEn = '1' then
                if redMode = '1' and blueMode = '0' then
                    -- clockwise
                    nextState <= F;
                    
                elsif blueMode = '1' and redMode = '0' then
                    -- counter-clockwise
                    nextState <= D;
                    
                else
                    nextState <= E;
                    
                end if;
            else
                nextState <= E;
            end if;
            
        when F =>
            segments <= "1011111";
            
            if nextEn = '1' then
                if redMode = '1' and blueMode = '0' then
                    -- clockwise
                    nextState <= A;
                    
                elsif blueMode = '1' and redMode = '0' then
                    -- counter-clockwise
                    nextState <= E;
                    
                else
                    nextState <= F;
                    
                end if;
            else
                nextState <= F;
            end if;
            
    end case;
end process;


end Practicum3_ARCH;
