----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2026 12:50:19 PM
-- Design Name: 
-- Module Name: Practicum2_TB - Practicum2_TB_ARCH
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

entity Practicum2_TB is
--  Port ( );
end Practicum2_TB;

architecture Practicum2_TB_ARCH of Practicum2_TB is
    signal clk: std_logic;
    signal DataIn: std_logic_vector(7 downto 0);
    signal loadEn: std_logic;
    signal clearMode: std_logic;
    signal clearEn: std_logic;
    signal dataOut: std_logic_vector(7 downto 0);

    component Practicum2 is
        Port (
            clk: in std_logic;
            DataIn: in std_logic_vector(7 downto 0);
            loadEn: in std_logic;
            clearEn: in std_logic;
            clearMode: in std_logic;
            dataOut: out std_logic_vector(7 downto 0));
    end component;
    
begin
    UUT: Practicum2 port map(
        clk => clk,
        DataIn => DataIn,
        loadEn => loadEn,
        clearEn => clearEn,
        clearMode => clearMode,
        dataOut => dataOut);
        
    process
    begin
        loadEn <= '1';
        clearEn <= '0';
        clearMode <= '0';
        DataIn <= "11111111";
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait for 10 ns;
        loadEn <= '1';
        clearEn <= '1';
        clearMode <= '0';
        DataIn <= "00001111";
        clk <= '0';
        wait for 10 ns;
        clk <= '1';
        wait;
    end process;


end Practicum2_TB_ARCH;
