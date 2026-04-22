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