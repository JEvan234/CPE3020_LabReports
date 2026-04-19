----------------------------------------------------------------------------------
-- Company: Kennesaw State University
-- Engineer: Trevor Cooper and Jacob Evans 
-- 
-- Create Date: 04/10/2026 05:33:55 PM
-- Design Name: stabilization_package
-- Module Name: stabilization_package - stabilization_package_ARCH
-- Project Name: Package for Lap Project
-- Target Devices: Basys3 - Artix 7
-- Description: Provides functions and contants to metastabilize and debounce button inputs
-- 
-- Revision:
-- Revision 0.01 - File Created
-- Additional Comments:
-- 
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

package stabilization_package is 
    constant ACTIVE: std_logic;
    
    procedure metastabilize1 (
        signal unstableInput: in std_logic;
        signal stage1Output: out std_logic
    );
    
    -- To use this multistage procedure in metastability, use a signal as the stage1 input and stage one output
    
    procedure metastabilize2 (
        signal stage1Input: in std_logic;
        signal safeOutput: out std_logic
    );
    
    procedure debounce (
        signal bouncedInput        : in  std_logic;
        signal stablePrev  : in  std_logic;
        signal countIn     : in  integer;
        signal countMax    : in  integer;

        signal dbOutput  : out std_logic;
        signal countNext   : out integer
    );
    
end package;


package body stabilization_package is
    constant ACTIVE: std_logic := '1';
    
    -- MetaStability
    
    procedure metastabilize1 (
        signal unstableInput: in  std_logic;
        signal stage1Output: out std_logic
        ) is
    begin
        stage1Output <= unstableInput;
    end procedure;


    procedure metastabilize2 (
        signal stage1Input: in  std_logic;
        signal safeOutput: out std_logic
        ) is
    begin
        safeOutput <= stage1Input;
    end procedure;
    
    
    
    -- Debouncing

    procedure debounce (
        signal bouncedInput: in  std_logic;
        signal stablePrev: in  std_logic;
        signal countIn: in  integer;
        signal countMax: in  integer;

        signal dbOutput: out std_logic;
        signal countNext: out integer
    ) is
    begin

        -- default behavior: keep current state
        dbOutput <= stablePrev;
        countNext  <= countIn;

    -- if input differs from current stable value, reset counter
        if bouncedInput /= stablePrev then
            countNext <= 0;

        else
            if countIn < countMax then
                countNext <= countIn + 1;
            else
                dbOutput <= bouncedInput;
            end if;
        end if;

    end procedure;    
    
end package body;

--
-- Example process to use (be sure to declare all signals above)
-- process(clock, reset)
-- begin
--    metastabilize1(inputSignal, intermidiateSignal);
--    metastabilize2(intermediatesignal, bouncedSignal);
--    debounce(bouncedSignal, stablePrev, countInSignal, countMaxSignal (acts as variable), dbOutputSignal, countNextSignal);
--    countInSignal <- countnextSignal;
--end process;
--
--
--
--