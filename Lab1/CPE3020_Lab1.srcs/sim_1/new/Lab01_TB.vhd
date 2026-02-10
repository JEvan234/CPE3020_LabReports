----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/09/2026 05:10:48 PM
-- Design Name: 
-- Module Name: Lab01_TB - Lab01_TB_ARCH
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

entity Lab01_TB is
--  Port ( );
end Lab01_TB;

architecture Lab01_TB_ARCH of Lab01_TB is
    signal switch00: std_logic := '0';
    signal switch01: std_logic := '0';
    signal switch02: std_logic := '0';
    signal switch03: std_logic := '0';
    signal led00: std_logic;
    
    component Lab01 is
        Port (
            switch00: in std_logic;
            switch01: in std_logic;
            switch02: in std_logic;
            switch03: in std_logic;
            led00: out std_logic
        );
    end component;
    
begin
    UUT: Lab01 port map(
        switch00 => switch00,
        switch01 => switch01,
        switch02 => switch02,
        switch03 => switch03,
        led00 => led00
    );
    process
    begin
        switch00 <= '0';
        switch01 <= '0';
        switch02 <= '0';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '0';
        switch02 <= '0';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '0';
        switch02 <= '1';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '0';
        switch02 <= '1';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '1';
        switch02 <= '0';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '1';
        switch02 <= '0';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '1';
        switch02 <= '1';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '0';
        switch01 <= '1';
        switch02 <= '1';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '0';
        switch02 <= '0';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '0';
        switch02 <= '0';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '0';
        switch02 <= '1';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '0';
        switch02 <= '1';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '1';
        switch02 <= '0';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '1';
        switch02 <= '0';
        switch03 <= '1';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '1';
        switch02 <= '1';
        switch03 <= '0';
        wait for 10 ns;
        switch00 <= '1';
        switch01 <= '1';
        switch02 <= '1';
        switch03 <= '1';
        wait for 10 ns;
        wait;
    end process;
    

end Lab01_TB_ARCH;
