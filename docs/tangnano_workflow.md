# Tang Nano Development Workflow

This document outlines two development workflows for the Gowin Tang Nano boards (1K, 9K, 20K):
1. **Gowin IDE (Windows):** Official GUI toolchain.
2. **oss-cad-suite (Linux/Mac):** Open-source toolchain (Yosys, nextpnr, openFPGALoader).

---

## Part 1: Gowin IDE (Windows)

### 1. Installation

1. Download **Gowin FPGA Designer (Education)** from [Gowin's Website](https://www.gowinsemi.com/en/support/download_eda/).
2. Run the installer as Administrator. It will also install the **Gowin Programmer** and USB FTDI drivers.
3. Open Gowin FPGA Designer. If it opens without errors, installation is successful.

**Warning:** The installation and project paths must contain only letters, numbers, and underscores. Avoid spaces, special characters, and accents.

### 2. Create Project

1. Open **Gowin FPGA Designer**
2. `File` → `New` → **FPGA Design Project** → OK
3. Configure Project Name and Path.
4. Select device (e.g., Series: GW1NZ, Device: GW1NZ-1, Package: QN48, Speed: C6/I5).
5. Click **Finish**.

### 3. Create Verilog File and Synthesis

1. `File` → `New` → **Verilog File** → Save as `top.v`.
2. Write your HDL code.
3. In the **Process** panel, double-click **Synthesize**.
4. Check for success in the terminal output.

### 4. Constraints and Programming

1. Use the **Floorplanner** to map your Verilog ports to the physical pins of your board (generates `.cst` file).
2. Double-click **Place & Route** in the Process panel.
3. Double-click **Program Device**. Ensure the cable is detected as `USB Debugger A`.
4. Run SRAM Program or Flash Program with your `.fs` bitstream file.

---

## Part 2: Open Source Toolchain (Linux)

**Prerequisite:** Install `oss-cad-suite` as detailed in [`suit_install.md`](suit_install.md).

### 1. Project Structure

Create your project folder and add a `Makefile` to automate the build process:

```
your_project/
├── Makefile
├── src/
│   └── top.v
└── constraints/
    └── pins.cst
```

### 2. Complete Makefile

```makefile
# Gowin FPGA Build System

PROJECT := top
DEVICE := GW1NZ-1
FAMILY := GW1N
FPGA_BOARD := tangnano1k

VERILOG_FILES := src/top.v
CST_FILE := constraints/pins.cst

JSON_SYNTH := build/$(PROJECT).json
JSON_PNR := build/$(PROJECT)_pnr.json
BITSTREAM := build/$(PROJECT).fs

.PHONY: all synth pnr pack program clean

all: pack

synth: $(JSON_SYNTH)
$(JSON_SYNTH): $(VERILOG_FILES)
	mkdir -p build
	yosys -p "read_verilog $(VERILOG_FILES); synth_gowin -json $(JSON_SYNTH)"

pnr: $(JSON_PNR)
$(JSON_PNR): $(JSON_SYNTH) $(CST_FILE)
	nextpnr-gowin --device $(DEVICE) --cst $(CST_FILE) --json $(JSON_SYNTH) --write $(JSON_PNR)

pack: $(BITSTREAM)
$(BITSTREAM): $(JSON_PNR)
	gowin_pack -d $(DEVICE) -o $(BITSTREAM) $(JSON_PNR)

program: $(BITSTREAM)
	openFPGALoader -b $(FPGA_BOARD) $(BITSTREAM)

clean:
	rm -rf build/
```

### 3. Development Flow

1. **Synthesis:** `make synth` (Uses Yosys to convert HDL to netlist).
2. **Place and Route:** `make pnr` (Uses nextpnr to place logic elements and route connections).
3. **Bitstream Generation:** `make pack` (Uses Apicula / gowin_pack to generate `.fs` file).
4. **Programming:** `make program` (Uses openFPGALoader to flash the board).

Check [`suit_install.md`](suit_install.md) for troubleshooting USB permissions and toolchain paths if commands fail.
