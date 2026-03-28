----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 03/21/2026 04:54:23 PM
-- Design Name: Neopixel Display Driver
-- Module Name: Lab4 - Lab4_ARCH
-- Project Name: 
-- Description: 
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
    switches  : in  std_logic_vector(2 downto 0);
    dataOut : out std_logic;
    clock   : in  std_logic;
    reset   : in  std_logic
  );
end Lab4;

architecture Lab4_ARCH of Lab4 is
    -- States
    type state_type is (IDLE, SEND_HIGH, SEND_LOW, RESET_STATE);
    signal currentState: state_type := IDLE;
    signal nextState: state_type := IDLE;
    -- main Data input
    signal dataIn: std_logic_vector(31 downto 0) := (others => '0');
    
    -- Timings for the RGBW neopixel stick (in number of clocks)
    constant T0H : integer := 35;  --350ns, with 10ns clock: 350 / 10 = 35 
    constant T0L : integer := 80;  -- 800ns
    constant T1H : integer := 70;  -- 700ns
    constant T1L : integer := 60;  -- 600ns

begin
    -- Combinational process to take in switch input and make dataIn vector
    SWITCH_CONVERT: process(switches)
    begin
       dataIn <= (31 downto 24 => switches(2)) & -- Red 
                    (23 downto 16 => switches(1)) & -- Green 
                    (15 downto 8 => switches(0)) & -- Blue 
                    (7 downto 0 => '0'); -- White (Off)
    end process;
    
    STATE_REG: process(clock, reset)
    begin
	   if reset = '1' then
		  currentState <= RESET_STATE;
	   elsif rising_edge(clock) then
		  currentState <= nextState;
	   end if;
    end process;
    
    STATE_TRANS: process(clock, reset)
    variable countDown: integer range 80 to 0 := 0;
    variable bitCount : integer range 31 to 0 := 31;
    variable currentBit : std_logic := '0';
    begin
        if reset = '1' then
            dataOut <= '0';
            bitCount := 31;
            currentBit := '0';
        else 
            case currentState is
                when IDLE =>
                    bitCount := 31;
                    currentBit := '0';
                    nextState <= SEND_HIGH;
                when SEND_HIGH =>
                    currentBit := dataIn(bitCount);
                    if (currentBit = '0') then
                        countDown := T0H;
                        for i in 0 to countDown loop
                            dataOut <= '1';
                        end loop;
                    elsif (currentBit = '1') then
                        countDown := T1H;
                        for i in 0 to countDown loop
                            dataOut <= '1';
                        end loop;
                    end if;
                    nextState <= SEND_LOW;
                    
                when SEND_LOW =>
                    if (currentBit = '0') then
                        countDown := T0L;
                        for i in 0 to countDown loop
                            dataOut <= '0';
                        end loop;
                    elsif (currentBit = '1') then
                        countDown := T1L;
                        for i in 0 to countDown loop
                            dataOut <= '0';
                        end loop;
                    end if;
                    bitCount := bitCount - 1;
                    if bitCount > 0 then
                        nextState <= SEND_HIGH;
                    else
                        nextState <= RESET_STATE;
                    end if;
                
                when RESET_STATE =>
                    nextState <= IDLE;
                    
            end case;
        end if;
    end process;
    

end Lab4_ARCH;