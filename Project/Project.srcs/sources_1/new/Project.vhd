----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 04/15/2026 12:48:19 PM
-- Design Name: 
-- Module Name: Project - Project_ARCH
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

use work.stabilization_package.all;

entity Project is
  Port (
    switches: in std_logic_vector(5 downto 0);
    leftButton: in std_logic;
    rightButton: in std_logic;
    reset: in std_logic;
    clock: in std_logic;
    dataOut: out std_logic;
    segments: out std_logic_vector(6 downto 0);
    anodes: out std_logic_vector(3 downto 0)
    );
    
end Project;

architecture Project_ARCH of Project is

    --Internal Signals
    signal dataInBack: std_logic_vector(23 downto 0);
    signal dataInBall: std_logic_vector(23 downto 0);
    
    -- Debounce Signals
    signal leftDB: std_logic;
    signal rightDB: std_logic;
    
    
    -- State machine
    type states_t is (IDLE, SEND_HIGH, SEND_LOW, RESET_STATE);
    signal current_state: states_t;
    signal next_state: states_t;
    
    -- SevenSeg Signals
    signal digit3 : std_logic_vector(3 downto 0);
    signal digit2 : std_logic_vector(3 downto 0);
    signal digit1 : std_logic_vector(3 downto 0);
    signal digit0 : std_logic_vector(3 downto 0);

    signal blank3 : std_logic := '0';
    signal blank2 : std_logic := '1'; -- this display should be blank
    signal blank1 : std_logic := '1'; -- this display should be blank
    signal blank0 : std_logic := '0';
    
    
    -- SevenSeg Component
    component SevenSegmentDriver
        port(
            reset: in std_logic;
            clock: in std_logic;

            digit3: in std_logic_vector(3 downto 0);
            digit2: in std_logic_vector(3 downto 0);
            digit1: in std_logic_vector(3 downto 0);
            digit0: in std_logic_vector(3 downto 0);

            blank3: in std_logic;
            blank2: in std_logic;
            blank1: in std_logic;
            blank0: in std_logic;

            sevenSegs: out std_logic_vector(6 downto 0);
            anodes: out std_logic_vector(3 downto 0)
        );    
    end component;

begin

-- Switches Process (return data in as 48 bits)
process(switches)
begin
    -- Background Case
    case switches(2 downto 0) is
        when "000" => dataInBack <= x"A5FF00"; -- YELLOW
        when "001" => dataInBack <= x"00FF00"; -- RED
        when "010" => dataInBack <= x"FF0000"; -- GREEN
        when "011" => dataInBack <= x"0000FF"; -- BLUE
        when "100" => dataInBack <= x"FFFF00"; -- LIME
        when "101" => dataInBack <= x"FF00FF"; -- CYAN
        when "110" => dataInBack <= x"00FFFF"; -- MAGENTA
        when others => dataInBack <= x"FFFFFF"; -- WHITE
    end case;
    
    -- Ball case
    case switches(5 downto 3) is
        when "000" => dataInBall <= x"A5FF00"; -- YELLOW
        when "001" => dataInBall <= x"00FF00"; -- RED
        when "010" => dataInBall <= x"FF0000"; -- GREEN
        when "011" => dataInBall <= x"0000FF"; -- BLUE
        when "100" => dataInBall <= x"FFFF00"; -- LIME
        when "101" => dataInBall <= x"FF00FF"; -- CYAN
        when "110" => dataInBall <= x"00FFFF"; -- MAGENTA
        when others => dataInBall <= x"FFFFFF"; -- WHITE
    end case;
    
end process;

-- Debounce process (using package)
process(clock, reset)
begin
    -- Metastabilize
    leftDB <= metastabilize (leftButton, reset, clock);
    rightDB <= metastabilize (rightButton, reset, clock);
    -- Begin debounce here
end process;

-- Dataout(serialization) Process




-- Seven Seg display
-- Assign digits
digit3 <= "0" & switches(5 downto 3);            -- Ball Hex
digit2 <= "0000";                                -- ignored (blanked)
digit1 <= "0000";                                -- ignored (blanked)
digit0 <= "0" & switches(2 downto 0);            -- Background Hex

-- Instantiate the seven segment driver
DISPLAY: SevenSegmentDriver
port map(
    reset => reset,
    clock => clock,

    digit3 => digit3,
    digit2 => digit2,
    digit1 => digit1,
    digit0 => digit0,

    blank3 => blank3,
    blank2 => blank2,
    blank1 => blank1,
    blank0 => blank0,

    sevenSegs => segments,
    anodes => anodes
);

end Project_ARCH;
