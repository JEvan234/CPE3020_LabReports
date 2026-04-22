----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper and Jacob Evans
-- 
-- Create Date: 04/11/2026 01:50:32 PM
-- Design Name: CPE3020 Project
-- Module Name: final - final_ARCH
-- Project Name: RGB light strip pong game
-- Target Devices: Basys3 - Artix 7
-- Description: In this design, We will be building on from our lab 4 assignment and allow for all 8 lights to be lit up as a single background color, 
-- selectable from the right switches. On top of this we will add a "ball" that has its own selectable color and its position on the strip 
-- can be changed from a button input. All button inputs will be debounced and metastable.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
-- Our Package
use work.stabilization_package.all;
use IEEE.NUMERIC_STD.ALL;

entity final is
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
end final;

architecture final_ARCH of final is

    --Internal Signals
    signal dataInBack: std_logic_vector(23 downto 0);
    signal dataInBall: std_logic_vector(23 downto 0);
    
    -- Ball position (0-7 for LED stick)
    signal ballPos : integer range 0 to 7 := 0;
    
    --NEW debounce signals
    signal leftDbPrev, rightDbPrev : std_logic := '0';
    
    -- LEFT button signals
    signal leftSync0, leftSync1 : std_logic := '0';
    signal leftDb : std_logic := '0';
    signal leftCount : integer := 0;
    signal leftPulse : std_logic := '0';

    -- RIGHT button signals
    signal rightSync0, right_sync1 : std_logic := '0';
    signal rightDb : std_logic := '0';
    signal rightCount : integer := 0;
    signal rightPulse : std_logic := '0';

    -- debounce constant
    constant DB_MAX : integer := 500000;  -- ~5 ms at 100 MHz
    signal DB_MAX_SIG : integer := 500000;
    
    -- LED serialization signals/constants
    signal ledFrame : std_logic_vector(191 downto 0); -- 8 LEDs * 24 bits
    signal bitIndex : integer range 0 to 191 := 0;
    signal clkCount : integer := 0;

    -- State Machine(dataOut)
    type led_state_t is (RESET_LATCH, SEND_BIT_HIGH, SEND_BIT_LOW);
    signal ledState : led_state_t := RESET_LATCH;
    
    constant T0H : integer := 35;  -- 0.35 us
    constant T1H : integer := 90;  -- 0.9 us
    constant TOTAL : integer := 125; -- 1.25 us total
    constant RESET_TIME : integer := 10000; --100 us
    
    
    -- State machine(button)
    type states_t is (IDLE, MOVE_LEFT, MOVE_RIGHT);
    signal currentState: states_t;
    signal nextState: states_t;
    
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

-- debouncing and metastability (from package)
process(clock, reset)
begin
    if rising_edge(clock) then
    -- Left Button

        -- metastability
        metastabilize1(leftButton, leftSync0);
        metastabilize2(leftSync0, leftSync1);

        -- debounce
        debounce(
            leftSync1,
            leftDbPrev,
            leftCount,
            DB_MAX_SIG,
            leftDb,
            leftCount
        );
        
        
        -- Pulse (one clock when pressed)
        leftPulse <= '0'; --default
        if (leftDb = '1' and leftDbPrev = '0') then
            leftPulse <= '1';
        end if;
        leftDbPrev <= leftDb;

        
    -- Right button
        
        -- metastability
        metastabilize1(rightButton, rightSync0);
        metastabilize2(rightSync0, right_sync1);

        -- debounce
        debounce(
            right_sync1,
            rightDbPrev,
            rightCount,
            DB_MAX_SIG,
            rightDb,
            rightCount
        );
        
        -- Pulse (one clock when pressed)
        rightPulse <= '0'; --default
        if (rightDb = '1' and rightDbPrev = '0') then
            rightPulse <= '1';
        end if;
        rightDbPrev <= rightDb;

    end if;
end process;

-- next state logic
process(currentState, leftPulse, rightPulse)
begin
    case currentState is
        when IDLE =>
            if leftPulse = '1' then
                nextState <= MOVE_LEFT;
            elsif rightPulse = '1' then
                nextState <= MOVE_RIGHT;
            else
                nextState <= IDLE;
            end if;
            
        when MOVE_LEFT =>
            nextState <= IDLE;

        when MOVE_RIGHT =>
            nextState <= IDLE;

        when others =>
            nextState <= IDLE;
    end case;
end process;

-- State Machine(combo)
process(clock, reset)
begin
    if reset = '1' then
        currentState <= IDLE;
        ballPos <= 0;

    elsif rising_edge(clock) then
        currentState <= nextState;

        case nextState is
            when MOVE_LEFT =>
                if ballPos = 0 then
                    ballPos <= 7;
                else
                    ballPos <= ballPos - 1;
                end if;

            when MOVE_RIGHT =>
                if ballPos = 7 then
                    ballPos <= 0;
                else
                    ballPos <= ballPos + 1;
                end if;

            when others => null;
        end case;
    end if;
end process;

-- LED array
process(dataInBack, dataInBall, ballPos)
    variable temp : std_logic_vector(191 downto 0);
begin
    for i in 0 to 7 loop
        if i = ballPos then
            temp((i*24+23) downto (i*24)) := dataInBall;
        else
            temp((i*24+23) downto (i*24)) := dataInBack;
        end if;
    end loop;

    ledFrame <= temp;
end process;

-- Serial for dataOut
process(clock, reset)
    variable currentBit : std_logic;
    variable highTime : integer;
begin
    if reset = '1' then
        ledState <= RESET_LATCH;
        clkCount <= 0;
        bitIndex <= 0;
        dataOut <= '0';

    elsif rising_edge(clock) then

        case ledState is

            -- RESET/LATCH
            when RESET_LATCH =>
                dataOut <= '0';
                if clkCount < RESET_TIME then
                    clkCount <= clkCount + 1;
                else
                    clkCount <= 0;
                    bitIndex <= 0;
                    ledState <= SEND_BIT_HIGH;
                end if;

            -- SEND HIGH
            when SEND_BIT_HIGH =>
                currentBit := ledFrame(191 - bitIndex);

                dataOut <= '1';

                if (currentBit = '1' and clkCount >= T1H) or
                   (currentBit = '0' and clkCount >= T0H) then
                    clkCount <= 0;
                    ledState <= SEND_BIT_LOW;
                else
                    clkCount <= clkCount + 1;
                end if;

            -- SEND LOW
            when SEND_BIT_LOW =>
                currentBit := ledFrame(191 - bitIndex);

                if currentBit = '1' then
                    highTime := T1H;
                else
                    highTime := T0H;
                end if;
                dataOut <= '0';

                if clkCount >= (TOTAL - highTime) then
                    clkCount <= 0;
                    if bitIndex = 191 then
                        ledState <= RESET_LATCH;
                    else
                        bitIndex <= bitIndex + 1;
                        ledState <= SEND_BIT_HIGH;
                    end if;
                else
                    clkCount <= clkCount + 1;
                end if;

        end case;
    end if;
end process;



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


end final_ARCH;