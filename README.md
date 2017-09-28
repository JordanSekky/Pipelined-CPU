# Pipelined MIPS CPU
_Team:_ ManBearPig

_Members:_
- Sam Greenberg
- Jordan Sechler
- Lukas Munoz
- Eric Marshall

### File Structure

- `includes/`: Holds non-module files that need to be included for the processor (i.e. the header file defining macros)
- `modules/`: All verilog submodules used in the processor
    - `MODULE_NAME.v`: Each module is held within its own verilog file
- `processor/`: Main verilog file where the individual modules are stitched together
- `tests/`: Tests for each module - organized to mirror the `modules` directory structure
    - `MODULE_NAME/`: A given module's tests - naming convention will match that of the module's file in `modules`
        - `files.txt`: Lists files for compiling the tests, including the module that is being tested. _Relative to the module's test folder_
        - `output.txt`: The expected output from running the test
        - `test.v`: The test to be run, written as a Verilog module
