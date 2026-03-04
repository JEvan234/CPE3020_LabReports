----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 03/04/2026 12:58:33 PM
-- Design Name: 
-- Module Name: Practicum2_BASYS3 - Practicum2_BASYS3_ARCH
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

entity Practicum2_BASYS3 is
  Port (
    sw: in std_logic_vector(8 downto 0);
    btnL: in std_logic;
    btnR: in std_logic;
    led: out std_logic_vector(7 downto 0);
    clk: in std_logic);
    
end Practicum2_BASYS3;

architecture Practicum2_BASYS3_ARCH of Practicum2_BASYS3 is

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
        DataIn => sw(7 downto 0),
        loadEn => btnL,
        clearEn => btnR,
        clearMode => sw(8),
        dataOut => led);

end Practicum2_BASYS3_ARCH;
