----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/17/2026 06:39:40 PM
-- Design Name: 
-- Module Name: Practicum1Practice2_TB - Practicum1Practice2_TB_ARCH
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

entity Practicum1Practice2_TB is
--  Port ( );
end Practicum1Practice2_TB;

architecture Practicum1Practice2_TB_ARCH of Practicum1Practice2_TB is
    signal switch0: std_logic := '0';
    signal switch1: std_logic := '0';
    signal switch2: std_logic := '0';
    signal switch3: std_logic := '0';
    signal led0: std_logic := '0';
    
    component Practicum1Practice2 is
        Port (
            switch0: in std_logic;
            switch1: in std_logic;
            switch2: in std_logic;
            switch3: in std_logic;
            led0: out std_logic);
    end component;
begin
    UUT: Practicum1Practice2 port map(
        switch0 => switch0,
        switch1 => switch1,
        switch2 => switch2,
        switch3 => switch3,
        led0 => led0);
        
        process
        begin
            switch0 <= '0';
            switch1 <= '0';
            switch2 <= '0';
            switch3 <= '0';
            wait for 10ns;
            switch0 <= '1';
            switch1 <= '0';
            switch2 <= '0';
            switch3 <= '1';
            wait for 10ns;
            switch0 <= '0';
            switch1 <= '1';
            switch2 <= '1';
            switch3 <= '0';
            wait for 10ns;
            switch0 <= '1';
            switch1 <= '1';
            switch2 <= '1';
            switch3 <= '1';
            wait for 10ns;
            wait;
        end process;
            

end Practicum1Practice2_TB_ARCH;
