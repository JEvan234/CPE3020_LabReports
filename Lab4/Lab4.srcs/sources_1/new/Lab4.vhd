----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/21/2026 04:54:23 PM
-- Design Name: 
-- Module Name: Lab4 - Lab4_ARCH
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

entity Lab4 is
  Port (
    dataIn  : in  std_logic_vector(31 downto 0);
    dataOut : out std_logic;
    clock   : in  std_logic;
    reset   : in  std_logic
  );
end Lab4;

architecture Lab4_ARCH of Lab4 is
    type state_type is (IDLE, SEND_HIGH, SEND_LOW, RESET_STATE);

begin

    process(clock, reset)
    variable bitIndex   : integer range 0 to 31 := 31;
    variable currentBit : std_logic;
    variable state      : state_type := IDLE;
    begin
        if reset = '1' then
            bitIndex   := 31;
            currentBit := '0';
            state      := IDLE;
            dataOut    <= '0';
        elsif rising_edge(clock) then
            case state is
                when IDLE =>
                    -- Grab the current bit and start sending
                    currentBit := dataIn(bitIndex);
                    state := SEND_HIGH;

                when SEND_HIGH =>
                    -- Output the bit high phase (simply assign it)
                    if currentBit = '1' then
                        dataOut <= currentBit;
                        bitIndex := bitIndex - 1;
                        currentBit := dataIn(bitIndex);
                        state := SEND_HIGH;
                    else
                        state := SEND_LOW;
                    end if;

                when SEND_LOW =>
                    -- Optionally, keep the same value or set low for a protocol
                    if currentBit = '0' then
                        dataOut <= currentBit;
                        bitIndex := bitIndex - 1;
                        currentBit := dataIn(bitIndex);
                        state := SEND_LOW;
                    else
                        state := SEND_HIGH;
                    end if;

                when RESET_STATE =>
                    -- Optional idle/reset period
                    dataOut <= '0';
                    bitIndex := 31;
                    state := IDLE;

            end case;
        end if;
    end process;

end Lab4_ARCH;