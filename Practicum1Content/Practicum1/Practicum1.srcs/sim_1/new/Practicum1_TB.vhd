----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/18/2026 12:52:46 PM
-- Design Name: 
-- Module Name: Practicum1_TB - Practicum1_TB_ARCH
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

entity Practicum1_TB is
--  Port ( );
end Practicum1_TB;

architecture Practicum1_TB_ARCH of Practicum1_TB is
    signal sensors: std_logic_vector(3 downto 0) := "0000";
    signal even: std_logic := '0';
    signal odd: std_logic := '0';

    component Practicum1
        port(
        sensors: in std_logic_vector(3 downto 0);
        even: out std_logic;
        odd: out std_logic);
    end component;
    
begin
    UUT: Practicum1 port map(
        sensors => sensors,
        even => even,
        odd => odd);
        
    process
    begin
        sensors <= "0000";
        wait for 10ns;
        sensors <= "0001";
        wait for 10ns;
        sensors <= "0010";
        wait for 10ns;
        sensors <= "0011";
        wait for 10ns;
        sensors <= "0100";
        wait for 10ns;
        sensors <= "0101";
        wait for 10ns;
        sensors <= "0110";
        wait for 10ns;
        sensors <= "0111";
        wait for 10ns;
        sensors <= "1000";
        wait for 10ns;
        sensors <= "1001";
        wait for 10ns;
        sensors <= "1010";
        wait for 10ns;
        sensors <= "1011";
        wait for 10ns;
        sensors <= "1100";
        wait for 10ns;
        sensors <= "1101";
        wait for 10ns;
        sensors <= "1110";
        wait for 10ns;
        sensors <= "1111";
        wait for 10ns;
        wait;
    end process;

end Practicum1_TB_ARCH;
