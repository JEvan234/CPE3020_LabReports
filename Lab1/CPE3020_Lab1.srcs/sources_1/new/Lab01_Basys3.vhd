----------------------------------------------------------------------------------
-- Company: 
-- Engineer: 
-- 
-- Create Date: 02/10/2026 02:20:09 PM
-- Design Name: 
-- Module Name: Lab01_Basys3 - Lab01_Basys3_ARCH
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

entity Lab01_Basys3 is
  Port (
  sw : in std_logic_vector (3 downto 0);
  led : out std_logic_vector (0 downto 0));
end Lab01_Basys3;

architecture Lab01_Basys3_ARCH of Lab01_Basys3 is

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
    switch00 => sw(0),
    switch01 => sw(1),
    switch02 => sw(2),
    switch03 => sw(3),
    led00 => led(0)
    );

end Lab01_Basys3_ARCH;
