----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Jacob Evans
-- 
-- Create Date: 02/23/2026 05:46:14 PM
-- Design Name: 
-- Module Name: Lab3 - Lab3_ARCH
-- Project Name: 
-- Target Devices: Artix 7 - Basys 3 FPGA Board
-- Description: 
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

entity Lab3 is
  Port (
    leftButton : in std_logic;
    rightButton : in std_logic;
    clk : in std_logic;
    reset : in std_logic;
    leds : out std_logic_vector(15 downto 0));
end Lab3;

architecture Lab3_ARCH of Lab3 is
-- declare the values of the lights
constant ZERO      : std_logic_vector(15 downto 0) := "0000000000000001";
constant ONE       : std_logic_vector(15 downto 0) := "0000000000000010";
constant TWO       : std_logic_vector(15 downto 0) := "0000000000000100";
constant THREE     : std_logic_vector(15 downto 0) := "0000000000001000";
constant FOUR      : std_logic_vector(15 downto 0) := "0000000000010000";
constant FIVE      : std_logic_vector(15 downto 0) := "0000000000100000";
constant SIX       : std_logic_vector(15 downto 0) := "0000000001000000";
constant SEVEN     : std_logic_vector(15 downto 0) := "0000000010000000";
constant EIGHT     : std_logic_vector(15 downto 0) := "0000000100000000";
constant NINE      : std_logic_vector(15 downto 0) := "0000001000000000";
constant TEN       : std_logic_vector(15 downto 0) := "0000010000000000";
constant ELEVEN    : std_logic_vector(15 downto 0) := "0000100000000000";
constant TWELVE    : std_logic_vector(15 downto 0) := "0001000000000000";
constant THIRTEEN  : std_logic_vector(15 downto 0) := "0010000000000000";
constant FOURTEEN  : std_logic_vector(15 downto 0) := "0100000000000000";
constant FIFTEEN   : std_logic_vector(15 downto 0) := "1000000000000000";

begin
    process(clk, reset)
    variable value : integer range 15 downto 0;
    begin
        value := 0;
        if reset = '1' then
            value := 0;
       
        elsif rising_edge(clk) then
            if rightButton = '1' then
                value := value + 1;
            elsif leftButton = '1' then
                if value = 0 then
                    value := 0;
                else
                    value := value - 1;
                end if;
            end if;
        end if;
    end process;
end Lab3_ARCH;
