----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper, Jacob Evans
-- 
-- Create Date: 03/24/2026 11:08:28 AM
-- Design Name: Lab4 Component
-- Module Name: rgb - rgb_ARCH
-- Project Name: Lab 4 RGB neopixel stick interface
-- Target Devices: Basys3 - Artix 7
-- Description: This Design feeds a serialized input to the Adafruit Neopixel Light Stick in order for it to
-- display a color in accordance to the 3 input switches input, with each combination 0 through 7 corresponding to a color. 
-- The current number value will also be displayed on the right digit of the seven segment display interface.
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab4 is
  Port (
    clock     : in std_logic;  -- 100 MHz
    reset     : in std_logic;
    switches  : in std_logic_vector(2 downto 0); -- 3 switches
    dataOut  : out std_logic;
    
    segments: out std_logic_vector(6 downto 0);
    anodes: out std_logic_vector(3 downto 0)
  );
end Lab4;

architecture Lab4_ARCH of Lab4 is
    signal digit3 : std_logic_vector(3 downto 0);
    signal digit2 : std_logic_vector(3 downto 0);
    signal digit1 : std_logic_vector(3 downto 0);
    signal digit0 : std_logic_vector(3 downto 0);

    signal blank3 : std_logic := '1'; -- this display should be blank
    signal blank2 : std_logic := '1'; -- this display should be blank
    signal blank1 : std_logic := '1'; -- this display should be blank
    signal blank0 : std_logic := '0';

    type state_type is (IDLE, LOAD, SEND_HIGH, SEND_LOW, RESET_LATCH);
    signal state : state_type := IDLE;

    signal shift_reg : std_logic_vector(23 downto 0);
    signal data_in   : std_logic_vector(23 downto 0);

    signal bit_cnt   : integer range 0 to 24 := 0;
    signal clk_cnt   : integer := 0;

    -- Timing (100 MHz clock)
    constant T0H : integer := 35;
    constant T0L : integer := 90;
    constant T1H : integer := 70;
    constant T1L : integer := 55;
    constant RESET_TIME : integer := 10000; -- ~100us
    
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

-- SWITCH_PROCESS
process(switches)
begin
    case switches is
        when "000" => data_in <= x"A5FF00"; -- YELLOW
        when "001" => data_in <= x"00FF00"; -- RED
        when "010" => data_in <= x"FF0000"; -- GREEN
        when "011" => data_in <= x"0000FF"; -- BLUE
        when "100" => data_in <= x"FFFF00"; -- LIME
        when "101" => data_in <= x"FF00FF"; -- CYAN
        when "110" => data_in <= x"00FFFF"; -- MAGENTA
        when others => data_in <= x"FFFFFF"; -- WHITE
    end case;
end process;





-- STATE_MACHINE
process(clock, reset)
begin
    if (reset = '1') then
        state <= IDLE;
        dataOut <= '0';
        clk_cnt <= 0;
        bit_cnt <= 0;
        shift_reg <= (others => '0');

    elsif rising_edge(clock) then
        case state is

            when IDLE =>
                dataOut <= '0';
                state <= LOAD;  -- auto-trigger

            when LOAD =>
                shift_reg <= data_in;
                bit_cnt <= 0;
                clk_cnt <= 0;
                state <= SEND_HIGH;

            when SEND_HIGH =>
                dataOut <= '1';

                if (shift_reg(23) = '1') then
                    if (clk_cnt = T1H) then
                        clk_cnt <= 0;
                        state <= SEND_LOW;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                else
                    if (clk_cnt = T0H) then
                        clk_cnt <= 0;
                        state <= SEND_LOW;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                end if;

            when SEND_LOW =>
                dataOut <= '0';

                if (shift_reg(23) = '1') then
                    if (clk_cnt = T1L) then
                        clk_cnt <= 0;

                        -- shift AFTER full bit
                        shift_reg <= shift_reg(22 downto 0) & '0';
                        bit_cnt <= bit_cnt + 1;

                        if (bit_cnt = 23) then
                            state <= RESET_LATCH;
                        else
                            state <= SEND_HIGH;
                        end if;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;

                else
                    if (clk_cnt = T0L) then
                        clk_cnt <= 0;

                        -- shift AFTER full bit
                        shift_reg <= shift_reg(22 downto 0) & '0';
                        bit_cnt <= bit_cnt + 1;

                        if (bit_cnt = 23) then
                            state <= RESET_LATCH;
                        else
                            state <= SEND_HIGH;
                        end if;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;

                end if;

            when RESET_LATCH =>
                dataOut <= '0';
                if (clk_cnt = RESET_TIME) then
                    clk_cnt <= 0;
                    state <= LOAD; -- continuously refresh LED
                else
                    clk_cnt <= clk_cnt + 1;
                end if;

        end case;
    end if;
end process;

-- Assign digits
digit3 <= "0000";                                -- ignored (blanked)"0" & switches;
digit2 <= "0000";                                -- ignored (blanked)
digit1 <= "0000";                                -- ignored (blanked)
digit0 <= "0" & switches;                        -- switch position

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

end Lab4_ARCH;