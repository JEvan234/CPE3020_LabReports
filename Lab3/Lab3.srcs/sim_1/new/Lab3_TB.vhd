----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/17/2026 01:18:48 PM
-- Design Name: 
-- Module Name: Lab3_TB - Lab3_TB_ARCH
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

-- Uncomment the following library declaration if using
-- arithmetic functions with Signed or Unsigned values
--use IEEE.NUMERIC_STD.ALL;

-- Uncomment the following library declaration if instantiating
-- any Xilinx leaf cells in this code.
--library UNISIM;
--use UNISIM.VComponents.all;

entity Lab3_TB is
--  Port ( );
end Lab3_TB;

architecture Lab3_TB_ARCH of Lab3_TB is

    component Lab3 is
        Port (
            leftButton  : in  std_logic;
            rightButton : in  std_logic;
            clk         : in  std_logic;
            reset       : in  std_logic;
            leds        : out std_logic_vector(15 downto 0)
        );
    end component;
    
signal leftButton  : std_logic := '0';
signal rightButton : std_logic := '0';
signal clk         : std_logic := '0';
signal reset       : std_logic := '0';
signal leds        : std_logic_vector(15 downto 0);

begin
    UUT: Lab3
        port map(
        leftButton  => leftButton,
        rightButton => rightButton,
        clk         => clk,
        reset       => reset,
        leds        => leds
        );
        
    clk_process : process
    begin
        while true loop
            clk <= '0';
            wait for 10 ns;
            clk <= '1';
            wait for 10 ns;
        end loop;
    end process;
    
    process
    begin
        rightButton <= '0';
        wait for 20 ns;
        rightButton <= '1';
        wait for 20 ns;
        wait;
    end process;


end Lab3_TB_ARCH;
