// Lab Report 4: Jacob Evans

#set page(paper: "a4")
#set text(size:32pt, font: "JetBrainsMono NF")
#set raw(syntaxes: "VHDL.sublime-syntax")

= Lab04
LED Light Lab
#v(200pt)
#set text(size: 16pt)
Designer: Jacob Evans, Trevor Cooper \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 03 - 21 \
#pagebreak()

= Design Description
This Design feeds a serialized input to the Adafruit Neopixel Light Stick in order for it to display a color in accordance to the 3 input switches input, with each combination 0 through 7 corresponding to a color. The current number value will also be displayed on the right digit of the seven segment display interface.
= Component Diagram
#figure(image("assets/Lab04/Component04.svg",
    width: 100%),
    caption: [Component Block Diagram])
= Design Block Diagram
#figure(image("assets/Lab04/Design04.svg",
    width: 100%),
    caption: [Design Block Diagram])

== State Machine Bubble Diagram
//Update the following
#figure(image("assets/Lab04/State_Bubble.svg",
    width: 95%),
    caption: [State Machine Bubble Diagram])

= Design Code
```vhdl
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
    data_out  : out std_logic;
    
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

-- Switch Process
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





-- State Machine
process(clock, reset)
begin
    if (reset = '1') then
        state <= IDLE;
        data_out <= '0';
        clk_cnt <= 0;
        bit_cnt <= 0;
        shift_reg <= (others => '0');

    elsif rising_edge(clock) then
        case state is

            when IDLE =>
                data_out <= '0';
                state <= LOAD;  -- auto-trigger

            when LOAD =>
                shift_reg <= data_in;
                bit_cnt <= 0;
                clk_cnt <= 0;
                state <= SEND_HIGH;

            when SEND_HIGH =>
                data_out <= '1';

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
                data_out <= '0';

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
                data_out <= '0';
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
```

= Simulation Block Diagram
#figure(image("assets/Lab04/Testbench04.svg",
    width: 100%),
    caption: [Simulation Block Diagram])

#pagebreak()
= Simulation Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper, Jacob Evans
-- 
-- Create Date: 03/24/2026 11:08:28 AM
-- Design Name: Lab4 Component
-- Module Name: rgb - rgb_ARCH
-- Project Name: Lab 4 RGB neopixel stick interface
-- Target Devices: Basys3 - Artix 7
-- Description: Test Bench Driver for the Lab 4 rgb component
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab4_TB is
--  Port ( );
end Lab4_TB;

architecture Lab4_TB_ARCH of Lab4_TB is
    signal clock : std_logic := '0';
    signal reset : std_logic := '1';
    signal switches : std_logic_vector(2 downto 0) := "000";
    signal data_out : std_logic;
    signal segments: std_logic_vector(6 downto 0);
    signal anodes: std_logic_vector(3 downto 0);
    
    constant clock_period : time := 10 ns;
    
    component Lab4 
        Port(
            clock : in std_logic;
            reset : in std_logic;
            switches : in std_logic_vector(2 downto 0);
            data_out : out std_logic;
            segments: out std_logic_vector(6 downto 0);
            anodes: out std_logic_vector(3 downto 0)
        );
    end component;
begin
    UUT: Lab4 port map(
        clock => clock,
        reset => reset,
        switches => switches,
        data_out => data_out,
        segments => segments,
        anodes => anodes
    );

    -- Clock generation
    clock_process :process
    begin
        clock <= '0';
        wait for clock_period/2;
        clock <= '1';
        wait for clock_period/2;
    end process;

    -- Stimulus process
    stim_proc: process
    begin
        -- Reset
        reset <= '1';
        wait for 50 ns;
        reset <= '0';

        -- Test all 8 switch combinations
        switches <= "000"; -- OFF
        wait for 120 us;

        switches <= "001"; -- GREEN
        wait for 120 us;

        switches <= "010"; -- RED
        wait for 120 us;

        switches <= "011"; -- BLUE
        wait for 120 us;

        switches <= "100"; -- YELLOW
        wait for 120 us;

        switches <= "101"; -- MAGENTA
        wait for 120 us;

        switches <= "110"; -- CYAN
        wait for 120 us;

        switches <= "111"; -- WHITE
        wait for 120 us;

        wait;
    end process;

end Lab4_TB_ARCH;
```
= Simulation Results
#figure(image("assets/Lab04/SimulationResults04.png"))

= Wrapper Block Diagram
#figure(image("assets/Lab04/Wrapper04.svg",
    width: 100%),
    caption: [Wrapper Block Diagram])
#pagebreak()

= Wrapper Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper, Jacob Evans
-- 
-- Create Date: 03/24/2026 11:08:28 AM
-- Design Name: Lab4 Component
-- Module Name: rgb - rgb_ARCH
-- Project Name: Lab 4 RGB neopixel stick interface
-- Target Devices: Basys3 - Artix 7
-- Description: Wrapper file for the Lab 4 rgb component
--
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity Lab4_BASYS3 is
  Port (
        clk     : in std_logic;                       -- 100 MHz clock
        sw      : in std_logic_vector(2 downto 0);    -- 3 switches
        btnC    : in std_logic;                       -- reset button
        JA      : out std_logic_vector(7 downto 0);    -- RGB data line
        seg: out std_logic_vector(6 downto 0);
        an: out std_logic_vector(3 downto 0)
    );
end Lab4_BASYS3;

architecture Lab4_BASYS3_ARCH of Lab4_BASYS3 is
    signal led_out : std_logic;
    
    component Lab4 
        Port(
            clock : in std_logic;
            reset : in std_logic;
            switches : in std_logic_vector(2 downto 0);
            data_out : out std_logic;
            segments: out std_logic_vector(6 downto 0);
            anodes: out std_logic_vector(3 downto 0)
        );
    end component;
begin
    UUT: Lab4 port map(
        clock => clk,
        reset => btnC,
        switches => sw,
        data_out => led_out,
        segments => seg,
        anodes => an
    );
    -- connect to JA
    JA(0) <= led_out;
    -- prevent floating pins
    JA(7 downto 1) <= (others => '0');

end Lab4_BASYS3_ARCH;
```