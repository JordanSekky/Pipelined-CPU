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
    - `MODULE_NAME/`: Each module is held within its own directory
- `processor/`: Main verilog file where the individual modules are stitched together
- `tests/`: Tests for each module - organized to mirror the `modules` directory structure
