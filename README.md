FPGA-Based 8-bit SAR ADC Controller

<p align="center">
  <strong>Design, behavioral simulation, synthesis, implementation, and FPGA demonstration of an 8-bit Successive Approximation Register ADC controller using SystemVerilog on the PYNQ-Z2.</strong>
</p>

<p align="center">
  <img alt="SystemVerilog" src="https://img.shields.io/badge/HDL-SystemVerilog-blue">
  <img alt="AMD Xilinx Vivado" src="https://img.shields.io/badge/Tool-AMD%20Xilinx%20Vivado-red">
  <img alt="PYNQ-Z2" src="https://img.shields.io/badge/Board-PYNQ--Z2-purple">
  <img alt="Zynq-7020" src="https://img.shields.io/badge/Device-xc7z020clg400--1-orange">
  <img alt="License MIT" src="https://img.shields.io/badge/License-MIT-green">
</p>

Overview

This project implements an 8-bit Successive Approximation Register Analog-to-Digital Converter controller using SystemVerilog and the AMD/Xilinx Vivado design flow.

The project contains two connected but technically different implementations:

Behavioral SAR ADC simulation

Models the sample-and-hold, DAC, comparator, and SAR controller.

Uses the SystemVerilog real data type for analog voltage values.

Demonstrates the complete bit-by-bit SAR binary-search process.

Is intended for simulation and waveform analysis.

Synthesizable PYNQ-Z2 FPGA demonstrator

Uses only synthesizable digital logic.

Demonstrates two verified conversion results through the PYNQ-Z2 switches, push buttons, and LEDs.

Uses precomputed output codes because real-valued analog models cannot be synthesized directly into FPGA logic.

[!IMPORTANT]The FPGA demonstrator is a digital hardware demonstration of the SAR conversion results. It is not a complete physical mixed-signal ADC because the current board implementation does not include an external analog sample-and-hold, precision DAC, or analog comparator.

Project Objectives

Understand the binary-search operation of a SAR ADC.

Design the SAR controller as a finite state machine.

Model the sample-and-hold, DAC, and comparator in SystemVerilog.

Verify conversion behavior through Vivado behavioral simulation.

Compare theoretical and simulated digital output codes.

Create a synthesizable hardware demonstrator for the PYNQ-Z2.

Complete synthesis, implementation, timing analysis, bitstream generation, and FPGA programming.

Establish a foundation for a future real mixed-signal or 12-bit SAR ADC implementation.

Key Features

8-bit SAR conversion algorithm

MSB-to-LSB binary-search operation

Modular SystemVerilog design

Sample-and-hold behavioral model

Ideal 8-bit DAC behavioral model

Comparator behavioral model

Synthesizable SAR controller FSM

Self-checking simulation testbench

PYNQ-Z2 hardware demonstrator

Switch-based test-case selection

Nibble-based LED output display

XDC pin constraints for the Zynq-7020

Complete Vivado FPGA design flow

SAR ADC Architecture

flowchart LR
    VIN[Analog Input Vin] --> SH[Sample and Hold]
    SH --> CMP[Comparator]
    SAR[SAR Controller FSM] --> DAC[8-bit DAC Model]
    DAC --> CMP
    CMP -->|Comparison Result| SAR
    SAR --> DOUT[8-bit Digital Output]
    CLK[Clock / Start / Reset] --> SAR

The controller starts from the most significant bit and performs one comparison for each bit:

Set the current trial bit to 1.

Convert the trial code into a DAC voltage.

Compare the DAC voltage with the sampled input.

Keep the bit when Vin >= Vdac; otherwise clear it.

Continue from the MSB to the LSB.

Assert done when the final 8-bit code is valid.

For an ideal N-bit ADC:

Number of levels = 2^N
LSB size         = Vref / 2^N
Digital code     = floor(Vin × 2^N / Vref)

For this 8-bit simulation:

N      = 8
Vref   = 16 V
Levels = 256
LSB    = 16 / 256 = 0.0625 V

Design Organization

Behavioral simulation path

flowchart LR
    TB[tb_sar_adc.sv] --> TOP[sar_adc_top.sv]
    TOP --> SH[sample_hold.sv]
    TOP --> DAC[dac_model.sv]
    TOP --> CMP[comparator_model.sv]
    TOP --> CTRL[sar_controller.sv]

FPGA hardware demonstration path

flowchart LR
    SW0[SW0: Test Case] --> CODE[Precomputed 8-bit Result]
    BTN1[BTN1: Start] --> FSM[Demo FSM]
    BTN0[BTN0: Reset] --> FSM
    FSM --> CODE
    CODE --> MUX[Nibble Selector]
    SW1[SW1: Upper / Lower Nibble] --> MUX
    MUX --> LED[LD3:LD0]

Repository Structure

FPGA-8bit-SAR-ADC-Controller/
│
├── README.md
├── LICENSE
├── .gitignore
│
├── src/
│   ├── comparator_model.sv
│   ├── dac_model.sv
│   ├── sample_hold.sv
│   ├── sar_controller.sv
│   ├── sar_adc_top.sv
│   └── sar_adc_fpga_demo_top.sv
│
├── constraints/
│   └── pynq_z2_sar_adc.xdc
│
├── testbench/
│   └── tb_sar_adc.sv
│
├── docs/
│   ├── SAR_ADC_Project_Report.pdf
│   └── SAR_ADC_Project_Presentation.pdf
│
├── images/
│   ├── sar_adc_block_diagram.png
│   ├── rtl_schematic.png
│   ├── waveform_vin_11_2V.png
│   ├── waveform_vin_6_5V.png
│   ├── pynq_z2_board.jpg
│   └── hardware_demo_leds.jpg
│
└── results/
    ├── synthesis_utilization_report.rpt
    ├── implementation_utilization_report.rpt
    ├── timing_summary_report.rpt
    ├── power_report.rpt
    ├── drc_report.rpt
    └── io_report.rpt

Some documentation, images, and reports may be added progressively as the repository is finalized.

Module Descriptions

File

Type

Purpose

src/sample_hold.sv

Simulation only

Captures and holds the real-valued analog input during conversion.

src/dac_model.sv

Simulation only

Converts the 8-bit trial code into an ideal real-valued DAC output.

src/comparator_model.sv

Simulation only

Compares the held input voltage with the DAC output.

src/sar_controller.sv

Synthesizable

Implements the SAR binary-search algorithm as an FSM.

src/sar_adc_top.sv

Simulation integration

Connects the sample-and-hold, DAC, comparator, and SAR controller.

testbench/tb_sar_adc.sv

Simulation only

Generates the clock, reset, start pulse, and two analog test cases.

src/sar_adc_fpga_demo_top.sv

Synthesizable

Implements the switch/button/LED demonstration on the PYNQ-Z2.

constraints/pynq_z2_sar_adc.xdc

Constraint file

Maps clock, buttons, switches, and LEDs to physical FPGA pins.

FSM Operation

The behavioral SAR controller uses four states:

State

Function

IDLE

Waits for the start signal and clears the previous result.

SAMPLE

Captures the analog input and initializes the MSB trial.

CONVERT

Tests each bit from bit 7 down to bit 0.

DONE

Asserts done to indicate that digital_out is valid.

The FPGA demonstration module uses a simplified three-state sequence:

IDLE → CONVERT → DONE

Simulation Parameters

Parameter

Value

Resolution

8 bits

Reference voltage

16 V

Number of quantization levels

256

LSB size

0.0625 V

Maximum ideal quantization error

±0.03125 V

Simulation clock

100 MHz

Simulation clock period

10 ns

Ideal 8-bit SNR

Approximately 49.92 dB

Simulation Test Cases

Test Case 1

Vin  = 11.2 V
Vref = 16 V

Expected code:

D = floor(11.2 / 0.0625)
  = floor(179.2)
  = 179

Result:

Binary       = 10110011
Hexadecimal  = 0xB3
Decimal      = 179
Reconstructed voltage = 179 × 0.0625 = 11.1875 V
Quantization error     = 11.2 - 11.1875 = 0.0125 V

Test Case 2

Vin  = 6.5 V
Vref = 16 V

Result:

Binary       = 01101000
Hexadecimal  = 0x68
Decimal      = 104
Reconstructed voltage = 104 × 0.0625 = 6.5 V
Quantization error     = 0 V

Results Summary

Input Voltage

Expected Code

Simulated Code

Hex

Decimal

Reconstructed Voltage

11.2 V

10110011

10110011

0xB3

179

11.1875 V

6.5 V

01101000

01101000

0x68

104

6.5 V

The intermediate digital_out values visible in the waveform are trial codes generated by the SAR binary search. The final output should be read only when done = 1.

Expected Waveform Signals

The following signals are useful when analyzing the behavioral simulation:

Signal

Description

clk

Simulation clock

reset

Active-high reset

start

Starts one conversion

vin

Real-valued analog input

v_sampled

Held analog sample

digital_out[7:0]

SAR trial code and final result

vdac

Real-valued DAC output

comp_out

Comparator decision

done

Indicates valid final output

<!--
After uploading the original high-resolution images, uncomment these lines:

## Simulation Waveforms

### Vin = 11.2 V
![Waveform for Vin = 11.2 V](images/waveform_vin_11_2V.png)

### Vin = 6.5 V
![Waveform for Vin = 6.5 V](images/waveform_vin_6_5V.png)

## Synthesized RTL Schematic
![Synthesized RTL Schematic](images/rtl_schematic.png)

## PYNQ-Z2 Hardware
![PYNQ-Z2 Board](images/pynq_z2_board.jpg)
-->

PYNQ-Z2 Hardware Demonstrator

Target hardware

Item

Specification

Development board

PYNQ-Z2

FPGA/SoC

Xilinx Zynq-7020

Part

xc7z020clg400-1

Board clock

125 MHz

Clock period constraint

8 ns

I/O standard

LVCMOS33

User controls

Board Control

Function

SW0

Selects the precomputed conversion case

SW1

Selects the lower or upper nibble

BTN0

Resets the hardware demonstration FSM

BTN1

Starts the demonstration conversion

LD3:LD0

Displays one nibble of the 8-bit result

Test-case selection

SW0

Demonstrated Input

Loaded Result

0

11.2 V equivalent

0xB3

1

6.5 V equivalent

0x68

Nibble selection

SW1

LED Output

0

result[3:0] — lower nibble

1

result[7:4] — upper nibble

Expected LED patterns

SW0

Result

SW1

Selected Nibble

LD3:LD0

0

0xB3

0

Lower nibble

0011

0

0xB3

1

Upper nibble

1011

1

0x68

0

Lower nibble

1000

1

0x68

1

Upper nibble

0110

[!NOTE]In the current sar_adc_fpga_demo_top.sv implementation, the LEDs are enabled while the demonstration FSM is in its DONE state. For a steady visible output during testing, keep BTN1 pressed while observing the LEDs. Releasing the button returns the FSM to IDLE, where the LEDs are cleared.

PYNQ-Z2 Pin Mapping

Signal

Board Component

FPGA Pin

I/O Standard

clk

125 MHz system clock

H16

LVCMOS33

reset_btn

BTN0

D19

LVCMOS33

start_btn

BTN1

D20

LVCMOS33

sw[0]

SW0

M20

LVCMOS33

sw[1]

SW1

M19

LVCMOS33

led[0]

LD0

R14

LVCMOS33

led[1]

LD1

P14

LVCMOS33

led[2]

LD2

N16

LVCMOS33

led[3]

LD3

M14

LVCMOS33

Requirements

Software

AMD/Xilinx Vivado Design Suite

Vivado support for:

7 Series devices

Zynq-7000 SoCs

Xilinx cable drivers

Hardware

PYNQ-Z2 board

Micro-USB cable supporting data transfer

Computer with Vivado installed

Ethernet is not required for programming the FPGA through Vivado Hardware Manager. USB/JTAG is sufficient for this RTL demonstration.

Running the Behavioral Simulation

Open Vivado and create a new RTL Project.

Select the target part:

xc7z020clg400-1

Add these files as Design Sources:

src/sample_hold.sv
src/dac_model.sv
src/comparator_model.sv
src/sar_controller.sv
src/sar_adc_top.sv

Add the following file as a Simulation Source:

testbench/tb_sar_adc.sv

In the Simulation Sources hierarchy, set tb_sar_adc as the simulation top module.

Run:

Flow Navigator
→ Simulation
→ Run Simulation
→ Run Behavioral Simulation

Add the relevant internal signals to the waveform window.

Run the simulation until both conversions complete.

Verify the output when done = 1.

Synthesizing the FPGA Demonstrator

Create or open a Vivado RTL project for xc7z020clg400-1.

Add src/sar_adc_fpga_demo_top.sv as a design source.

Add constraints/pynq_z2_sar_adc.xdc as the constraint file.

Set the hardware top module to sar_adc_fpga_demo_top.

Run:

Run Synthesis
→ Run Implementation
→ Generate Bitstream

[!WARNING]Do not use tb_sar_adc or sar_adc_top as the hardware synthesis top. tb_sar_adc is a testbench, while sar_adc_top contains real-valued simulation models.

Programming the PYNQ-Z2

Connect the PYNQ-Z2 to the computer through the USB/JTAG port.

Power on the board.

Open Hardware Manager in Vivado.

Select Open Target → Auto Connect.

Select the detected xc7z020 device.

Click Program Device.

Select sar_adc_fpga_demo_top.bit.

Program the FPGA.

Set SW0 and SW1.

Press and hold BTN1 to observe the corresponding LED nibble.

Press BTN0 to reset the design.

Vivado Design Flow

flowchart LR
    RTL[SystemVerilog RTL] --> SYN[Synthesis]
    SYN --> NET[Technology Netlist]
    NET --> IMP[Implementation]
    IMP --> PLACE[Placement]
    PLACE --> ROUTE[Routing]
    ROUTE --> TIMING[Timing and DRC]
    TIMING --> BIT[Bitstream Generation]
    BIT --> HW[Program PYNQ-Z2]

The project completed the main FPGA stages:

RTL elaboration

Synthesis

Implementation

Design-rule checks

Timing analysis

Bitstream generation

Device programming through Vivado Hardware Manager

The design is expected to meet the 8 ns clock constraint with non-negative WNS and zero TNS. Exact utilization, timing, and power values should be taken from the generated Vivado reports in the results/ directory.

Important Technical Distinction

Feature

Behavioral Simulation

FPGA Demonstrator

Analog input represented directly

Yes, using real

No

Sample-and-hold model

Yes

No physical analog circuit

DAC model

Yes, ideal mathematical model

No external DAC

Comparator model

Yes, ideal comparison

No external comparator

SAR controller

Yes

Demonstration FSM

Synthesizable

Partially

Yes

Physical analog conversion

No

No

Purpose

Verify SAR algorithm and waveforms

Demonstrate digital output behavior on hardware

This distinction prevents the project from incorrectly claiming that an analog signal is directly converted by FPGA fabric alone.

Current Project Status

SAR controller designed

Behavioral analog models created

Top-level simulation integration completed

Testbench created

Two conversion cases verified

PYNQ-Z2 constraint file created

Synthesis completed

Implementation completed

Bitstream generated

FPGA device programmed through Hardware Manager

Final high-resolution screenshots added to the repository

Complete board-level LED demonstration media added

External mixed-signal hardware integrated

Limitations

SystemVerilog real signals are simulation-only and cannot be synthesized into FPGA logic.

The current FPGA demonstrator uses precomputed conversion codes rather than a real analog input.

No external sample-and-hold, DAC, or comparator is connected.

The current output interface displays only four bits at a time.

Button inputs are not debounced or synchronized for a production-grade interface.

The behavioral model assumes ideal DAC and comparator characteristics.

DNL, INL, noise, offset, and settling-time nonidealities are not included in the current simulation.

Future Improvements

Extend the controller and behavioral model to 12-bit resolution.

Add parameterized resolution and reference-voltage support.

Interface an external precision DAC and high-speed comparator.

Add a real analog front end and sample-and-hold circuit.

Add button debouncing and synchronization.

Display the complete 8-bit result through UART, seven-segment display, or AXI GPIO.

Integrate the Zynq XADC for comparison with the custom SAR controller.

Add AXI-Lite control through the Zynq Processing System.

Use the PYNQ Python framework for control, plotting, and data analysis.

Add automated verification for multiple input voltages.

Measure or model SNR, SINAD, ENOB, DNL, and INL.

Add continuous conversion and configurable sampling frequency.

12-bit Theoretical Extension

The project report also discusses a theoretical 12-bit extension:

Parameter

12-bit Value

Reference voltage

1 V

Number of levels

4096

LSB size

Approximately 244 µV

Half-LSB

Approximately 122 µV

Ideal SNR

Approximately 74 dB

ENOB for SINAD = 68 dB

Approximately 11 bits

Conversion decisions

12

This extension requires significantly tighter comparator-offset, DAC-settling, noise, and PCB-layout performance than the current ideal 8-bit simulation.

Documentation

Detailed design theory, calculations, module descriptions, waveform analysis, FPGA implementation steps, and source-code appendices are provided in the project report under the docs/ directory.

Recommended documentation filenames:

docs/SAR_ADC_Project_Report.pdf
docs/SAR_ADC_Project_Presentation.pdf

Authors

Shubham SinghJayant Punj

Department of Electronics and Communication EngineeringUniversity Institute of Engineering and TechnologyPanjab University, Chandigarh

License

This project is released under the MIT License. See the LICENSE file for details.

Acknowledgements

This project was developed using the AMD/Xilinx Vivado Design Suite and the PYNQ-Z2 development board as part of an Electronics and Communication Engineering FPGA design project.
