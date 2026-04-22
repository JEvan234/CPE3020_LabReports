// Final Project: Trevor Cooper and Jacob Evans

#set page(paper: "a4")
#set text(size:24pt)
#set raw(syntaxes: "VHDL.sublime-syntax")

= Project
LED Light Strip Pong Game
#v(200pt)
#set text(size: 12pt)
Designer: Trevor Cooper and Jacob Evans \
Class: CPE 3020 \
Term: Spring 2026 \ 
Date: 2026 - 04 - 03 \
#pagebreak()

= Design Description
In this design, We will be building on from our lab 4 assignment and allow for all 8 lights to be lit up as a single background color, 
selectable from the right switches. On top of this we will add a "ball" that has its own selectable color and its position on the strip 
can be changed from a button input. All button inputs will be debounced and metastable.

= Component Diagram
#figure(image("assets/Project/Component05.svg",
  width: 90%),
  caption: [Component Diagram])

= Design Block Diagram
#figure(image("assets/Project/Design05.svg",
  width: 90%),
  caption: [Design Block Diagram])

= Design Code
```vhdl
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
            leftDb,
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
            rightDb,
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
```

= Package Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper and Jacob Evans 
-- 
-- Create Date: 04/10/2026 05:33:55 PM
-- Design Name: stabilization_package
-- Module Name: stabilization_package - stabilization_package_ARCH
-- Project Name: Package for Lap Project
-- Target Devices: Basys3 - Artix 7
-- Description: Provides functions and contants to metastabilize and debounce button inputs
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package stabilization_package is 
    constant ACTIVE: std_logic;
    
    procedure metastabilize1 (
        signal unstableInput: in std_logic;
        signal stage1Output: out std_logic
    );
    
    -- To use this multistage procedure in metastability, use a signal as the stage1 input and stage one output
    
    procedure metastabilize2 (
        signal stage1Input: in std_logic;
        signal safeOutput: out std_logic
    );
    
    procedure debounce (
        signal bouncedInput        : in  std_logic;
        signal stablePrev  : in  std_logic;
        signal countIn     : in  integer;
        signal countMax    : in  integer;

        signal dbOutput  : out std_logic;
        signal countNext   : out integer
    );
    
end package;


package body stabilization_package is
    constant ACTIVE: std_logic := '1';
    
    -- MetaStability
    
    procedure metastabilize1 (
        signal unstableInput: in  std_logic;
        signal stage1Output: out std_logic
        ) is
    begin
        stage1Output <= unstableInput;
    end procedure;


    procedure metastabilize2 (
        signal stage1Input: in  std_logic;
        signal safeOutput: out std_logic
        ) is
    begin
        safeOutput <= stage1Input;
    end procedure;
    
    
    
    -- Debouncing

    procedure debounce (
        signal bouncedInput: in  std_logic;
        signal stablePrev: in  std_logic;
        signal countIn: in  integer;
        signal countMax: in  integer;

        signal dbOutput: out std_logic;
        signal countNext: out integer
    ) is
    begin

        -- default behavior: keep current state
        dbOutput <= stablePrev;
        countNext  <= countIn;

    -- if input differs from current stable value, reset counter
        if bouncedInput /= stablePrev then
            countNext <= 0;

        else
            if countIn < countMax then
                countNext <= countIn + 1;
            else
                dbOutput <= bouncedInput;
            end if;
        end if;

    end procedure;    
    
end package body;

-- Refer to github readme for example usecase
```

= Simulation Block Diagram
#figure(image("assets/Project/Testbench05.svg",
  width: 100%),
  caption: [Simulation Block Diagram])

#pagebreak()
= Simulation Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper and Jacob Evans
-- 
-- Create Date: 04/11/2026 02:05:46 PM
-- Design Name: CPE3020 Project
-- Module Name: final_TB - final_TB_ARCH
-- Project Name: RGB light strip pong game
-- Target Devices: Basys3 - Artix 7
-- Description: Test bench file for the CPE 3020 project. Uses loops to emulate clock cycle and
-- iterate through the switches.
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity final_TB is
--  Port ( );
end final_TB;

architecture final_TB_ARCH of final_TB is
    signal switches : std_logic_vector(5 downto 0) := (others => '0');
    signal leftButton, rightButton, reset, clock : std_logic := '0';
    signal dataOut : std_logic;
    signal segments : std_logic_vector(6 downto 0);
    signal anodes : std_logic_vector(3 downto 0);

    component final
        port(
            switches: in std_logic_vector(5 downto 0);
            leftButton: in std_logic;
            rightButton: in std_logic;
            reset: in std_logic;
            clock: in std_logic;
            dataOut: out std_logic;
            segments: out std_logic_vector(6 downto 0);
            anodes: out std_logic_vector(3 downto 0)
        );
    end component;
begin
    UUT: final port map(
        clock => clock,
        reset => reset,
        leftButton => leftButton,
        rightButton => rightButton,
        switches => switches,
        dataOut => dataOut,
        segments => segments,
        anodes => anodes
    );

-- clock
    process
    begin
        while true loop
            clock <= '0'; wait for 20 us;
            clock <= '1'; wait for 20 us;
        end loop;
    end process;

    -- Testing
    process
    begin
        reset <= '1'; wait for 200 us;
        reset <= '0';

        -- checking switches
        for t in 0 to 63 loop
            switches <= std_logic_vector(to_unsigned(t,6));
            wait for 50 us;
        end loop;
        
        -- move right
        rightButton <= '1'; wait for 50 us;
        rightButton <= '0';

        wait for 200 us;

        -- move left
        leftButton <= '1'; wait for 50 us;
        leftButton <= '0';

        wait;
    end process;


end final_TB_ARCH;
```

= Simulation Results
#figure(image("assets/Project/Simulation5.png"))

= Wrapper Block Diagram
#figure(image("assets/Project/Wrapper05.svg",
    width: 80%),
    caption: [Wrapper Block Diagram])

= Wrapper Code
```vhdl
----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper and Jacob Evans
-- 
-- Create Date: 04/11/2026 02:15:31 PM
-- Design Name: CPE3020 Project
-- Module Name: final_BASYS - final_BASYS_ARCH
-- Project Name: RGB light strip pong game
-- Target Devices: Basys3 - Artix 7
-- Description: Basys 3 Wrapper for the final project
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity final_BASYS is
  Port (
    clk     : in std_logic;                       -- 100 MHz clock
    sw      : in std_logic_vector(15 downto 0);    -- all switches
    btnC    : in std_logic;                       -- reset button
    btnR    : in std_logic;                       -- right button
    btnL    : in std_logic;                       -- left button
    JA      : out std_logic_vector(7 downto 0);    -- RGB data line
    seg: out std_logic_vector(6 downto 0);
    an: out std_logic_vector(3 downto 0)

  );
end final_BASYS;

architecture final_BASYS_ARCH of final_BASYS is
    signal internal_sw : std_logic_vector(5 downto 0);
    
    component final
        port(
            switches: in std_logic_vector(5 downto 0);
            leftButton: in std_logic;
            rightButton: in std_logic;
            reset: in std_logic;
            clock: in std_logic;
            dataOut: out std_logic;
            segments: out std_logic_vector(6 downto 0);
            anodes: out std_logic_vector(3 downto 0)
        );
    end component;

begin
    internal_sw <= sw(15 downto 13) & sw(2 downto 0);
    UUT: final port map(
        clock => clk,
        reset => btnC,
        leftButton => btnL,
        rightButton => btnR,
        switches => internal_sw,
        dataOut => JA(0),
        segments => seg,
        anodes => an
    );
    -- prevent floating pins
    JA(7 downto 1) <= (others => '0');
    
end final_BASYS_ARCH;
```