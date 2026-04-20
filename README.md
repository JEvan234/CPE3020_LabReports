# CPE3020_LabReports
Lab Reports for my CPE3020 (VHDL Programming) Course. All written reports are written in typst.

## There are some issues running implementation on Windows OS, Please do not run Anything after simulations on windows

You will get some errors with file paths for Wrapper files

# Example process for debouncing
```vhdl
Example process to use (be sure to declare all signals above the process)
process(clock, reset)
begin
    if rising_edge(clock) then
        metastabilize1(inputSignal, intermidiateSignal);
        metastabilize2(intermediatesignal, bouncedSignal);
        debounce(bouncedSignal, stablePrev, countInSignal, countMaxSignal (acts as variable), dbOutputSignal, countNextSignal);
        countInSignal <= countnextSignal;
    end if;
end process;
```
