library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Lab4 is
  Port (
    clock     : in std_logic;  -- 100 MHz
    reset     : in std_logic;
    switches  : in std_logic_vector(2 downto 0);
    data_out  : out std_logic
  );
end Lab4;

architecture Lab4_ARCH of Lab4 is

    type state_type is (IDLE, LOAD, SEND_HIGH, SEND_LOW, RESET_LATCH);
    signal state : state_type := RESET_LATCH;

    signal shift_reg : std_logic_vector(31 downto 0);
    signal data_in   : std_logic_vector(31 downto 0);

    signal bit_cnt   : integer range 0 to 32 := 0;
    signal clk_cnt   : integer := 0;

    signal current_bit : std_logic := '0';

    -- Timing (100 MHz clock, stable values)
    constant T0H : integer := 40;
    constant T0L : integer := 85;
    constant T1H : integer := 80;
    constant T1L : integer := 45;

    constant RESET_TIME : integer := 10000;

begin

-- 🎨 Switch → Color mapping (GRBW!)
process(switches)
begin
    case switches is
        when "000" => data_in <= x"FF000000"; -- GREEN
        when "001" => data_in <= x"00FF0000"; -- RED
        when "010" => data_in <= x"0000FF00"; -- BLUE
        when "011" => data_in <= x"000000FF"; -- WHITE
        when "100" => data_in <= x"FFFF0000"; -- YELLOW (G+R)
        when "101" => data_in <= x"FF00FF00"; -- CYAN (G+B)
        when "110" => data_in <= x"00FFFF00"; -- MAGENTA (R+B)
        when others => data_in <= x"FFFFFFFF"; -- WHITE FULL
    end case;
end process;


-- 🧠 FSM
process(clock, reset)
begin
    if (reset = '1') then
        state <= RESET_LATCH;
        data_out <= '0';
        clk_cnt <= 0;
        bit_cnt <= 0;
        shift_reg <= (others => '0');
        current_bit <= '0';

    elsif rising_edge(clock) then
        case state is

            when IDLE =>
                data_out <= '0';
                state <= LOAD;

            when LOAD =>
                shift_reg <= data_in;
                current_bit <= data_in(31);
                bit_cnt <= 0;
                clk_cnt <= 0;
                state <= SEND_HIGH;

            when SEND_HIGH =>
                data_out <= '1';

                if (current_bit = '1') then
                    if (clk_cnt >= T1H-1) then
                        clk_cnt <= 0;
                        state <= SEND_LOW;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                else
                    if (clk_cnt >= T0H-1) then
                        clk_cnt <= 0;
                        state <= SEND_LOW;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;
                end if;

            when SEND_LOW =>
                data_out <= '0';

                if (current_bit = '1') then
                    if (clk_cnt >= T1L-1) then
                        clk_cnt <= 0;

                        shift_reg <= shift_reg(30 downto 0) & '0';
                        current_bit <= shift_reg(30);
                        bit_cnt <= bit_cnt + 1;

                        if (bit_cnt = 31) then
                            state <= RESET_LATCH;
                        else
                            state <= SEND_HIGH;
                        end if;
                    else
                        clk_cnt <= clk_cnt + 1;
                    end if;

                else
                    if (clk_cnt >= T0L-1) then
                        clk_cnt <= 0;

                        shift_reg <= shift_reg(30 downto 0) & '0';
                        current_bit <= shift_reg(30);
                        bit_cnt <= bit_cnt + 1;

                        if (bit_cnt = 31) then
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
                if (clk_cnt >= RESET_TIME-1) then
                    clk_cnt <= 0;
                    state <= LOAD;
                else
                    clk_cnt <= clk_cnt + 1;
                end if;

        end case;
    end if;
end process;

end Lab4_ARCH;