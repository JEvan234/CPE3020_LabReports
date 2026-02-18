----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2026 03:11:20 PM
-- Design Name: 
-- Module Name: Practicum1Practice_TB - Practicum1Practice_TB_ARCH
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

entity Practicum1Practice_TB is
--  Port ( );
end Practicum1Practice_TB;

architecture Practicum1Practice_TB_ARCH of Practicum1Practice_TB is
    signal switches: std_logic_vector(3 downto 0) := "0000";
    signal led00: std_logic := '0';
    
    component Practicum1Practice is
        port(
        switches: in std_logic_vector(3 downto 0);
        led00: out std_logic);
    end component;
        
begin
    UUT: Practicum1Practice port map(
        switches => switches,
        led00 => led00);

    process
    begin
        switches <= "0000";
        wait for 10ns;
        switches <= "0001";
        wait for 10ns;
        switches <= "0011";
        wait for 10ns;
        switches <= "0110";
        wait for 10ns;
        switches <= "1101";
        wait for 10ns;
        switches <= "0110";
        wait for 10ns;
        
        wait;
    end process;

end Practicum1Practice_TB_ARCH;
