<h1 style="font-size:36px"><strong>FPGA-Based 8-bit SAR ADC Controller</strong></h1>

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

<h2 style="font-size:22px"><strong>Overview</strong></h2>

<p>This project implements an 8-bit Successive Approximation Register Analog-to-Digital Converter controller using SystemVerilog and the AMD/Xilinx Vivado design flow.</p>

<p>The project contains two connected but technically different implementations:</p>

<h3 style="font-size:18px"><strong>Behavioral SAR ADC simulation</strong></h3>

<ul>
  <li>Models the sample-and-hold, DAC, comparator, and SAR controller.</li>
  <li>Uses the SystemVerilog real data type for analog voltage values.</li>
  <li>Demonstrates the complete bit-by-bit SAR binary-search process.</li>
  <li>Is intended for simulation and waveform analysis.</li>
</ul>

<h3 style="font-size:18px"><strong>Synthesizable PYNQ-Z2 FPGA demonstrator</strong></h3>

<ul>
  <li>Uses only synthesizable digital logic.</li>
  <li>Demonstrates two verified conversion results through the PYNQ-Z2 switches, push buttons, and LEDs.</li>
  <li>Uses precomputed output codes because real-valued analog models cannot be synthesized directly into FPGA logic.</li>
</ul>

<p><strong>[!IMPORTANT]</strong> The FPGA demonstrator is a digital hardware demonstration of the SAR conversion results. It is not a complete physical mixed-signal ADC because the current board i[...]
</p>

<h2 style="font-size:22px"><strong>Project Objectives</strong></h2>

<ul>
  <li>Understand the binary-search operation of a SAR ADC.</li>
  <li>Design the SAR controller as a finite state machine.</li>
  <li>Model the sample-and-hold, DAC, and comparator in SystemVerilog.</li>
  <li>Verify conversion behavior through Vivado behavioral simulation.</li>
  <li>Compare theoretical and simulated digital output codes.</li>
  <li>Create a synthesizable hardware demonstrator for the PYNQ-Z2.</li>
  <li>Complete synthesis, implementation, timing analysis, bitstream generation, and FPGA programming.</li>
  <li>Establish a foundation for a future real mixed-signal or 12-bit SAR ADC implementation.</li>
</ul>

<h2 style="font-size:22px"><strong>Key Features</strong></h2>

<ul>
  <li>8-bit SAR conversion algorithm</li>
  <li>MSB-to-LSB binary-search operation</li>
  <li>Modular SystemVerilog design</li>
  <li>Sample-and-hold behavioral model</li>
  <li>Ideal 8-bit DAC behavioral model</li>
  <li>Comparator behavioral model</li>
  <li>Synthesizable SAR controller FSM</li>
  <li>Self-checking simulation testbench</li>
  <li>PYNQ-Z2 hardware demonstrator</li>
  <li>Switch-based test-case selection</li>
  <li>Nibble-based LED output display</li>
  <li>XDC pin constraints for the Zynq-7020</li>
  <li>Complete Vivado FPGA design flow</li>
</ul>

<h2 style="font-size:22px"><strong>SAR ADC Architecture</strong></h2>

<pre>
flowchart LR
    VIN[Analog Input Vin] --> SH[Sample and Hold]
    SH --> CMP[Comparator]
    SAR[SAR Controller FSM] --> DAC[8-bit DAC Model]
    DAC --> CMP
    CMP -->|Comparison Result| SAR
    SAR --> DOUT[8-bit Digital Output]
    CLK[Clock / Start / Reset] --> SAR
</pre>

<p>The controller starts from the most significant bit and performs one comparison for each bit:</p>

<ol>
  <li>Set the current trial bit to 1.</li>
  <li>Convert the trial code into a DAC voltage.</li>
  <li>Compare the DAC voltage with the sampled input.</li>
  <li>Keep the bit when Vin &gt;= Vdac; otherwise clear it.</li>
  <li>Continue from the MSB to the LSB.</li>
  <li>Assert done when the final 8-bit code is valid.</li>
</ol>

<p>For an ideal N-bit ADC:</p>

<ul>
  <li>Number of levels = 2^N</li>
  <li>LSB size = Vref / 2^N</li>
  <li>Digital code = floor(Vin × 2^N / Vref)</li>
</ul>

<p>For this 8-bit simulation:</p>

<ul>
  <li>N = 8</li>
  <li>Vref = 16 V</li>
  <li>Levels = 256</li>
  <li>LSB = 16 / 256 = 0.0625 V</li>
</ul>

<h2 style="font-size:22px"><strong>Block Diagram</strong></h2>

<p>The block diagram below summarizes the main functional blocks and signal flow of the SAR ADC project. A brief description of each block follows.</p>

<p align="center">
<img width="612" height="370" alt="Picture1" src="https://github.com/user-attachments/assets/dde7863a-db5f-4601-874d-4b1e33bdda31" />

</p>

<ul>
  <li><strong>Analog Input (Vin)</strong> — The analog signal to be converted by the SAR ADC.</li>
  <li><strong>Sample-and-Hold (S/H)</strong> — Captures and holds Vin during the conversion period (behavioral model used in simulation).</li>
  <li><strong>Digital-to-Analog Converter (DAC)</strong> — Ideal 8-bit DAC model that converts the trial digital code proposed by the SAR controller into a comparison voltage.</li>
  <li><strong>Comparator</strong> — Compares the held analog input to the DAC output and outputs a binary decision (Vin &gt;= Vdac).</li>
  <li><strong>SAR Controller (FSM)</strong> — Implements the MSB-to-LSB binary search algorithm; it updates the trial code based on comparator results and asserts a done signal when the final code is ready.</li>
  <li><strong>Digital Output</strong> — The final 8-bit digital code, visible in simulation waveforms or presented by the FPGA demonstrator using precomputed codes and LED/nibble display.</li>
</ul>

<p>This block diagram provides a high-level view of how the behavioral models (S/H, DAC, comparator) interact with the synthesizable SAR controller to produce a final digital result.</p>

<h2 style="font-size:22px"><strong>Design Organization</strong></h2>

<pre>
flowchart LR
    TB[tb_sar_adc.sv] --> TOP[sar_adc_top.sv]
    TOP --> SH[sample_hold.sv]
    TOP --> DAC[dac_model.sv]
    TOP --> CMP[comparator_model.sv]
    TOP --> CTRL[sar_controller.sv]
</pre>

<pre>
flowchart LR
    SW0[SW0: Test Case] --> CODE[Precomputed 8-bit Result]
    BTN1[BTN1: Start] --> FSM[Demo FSM]
    BTN0[BTN0: Reset] --> FSM
    FSM --> CODE
    CODE --> MUX[Nibble Selector]
    SW1[SW1: Upper / Lower Nibble] --> MUX
    MUX --> LED[LD3:LD0]
</pre>

<h2 style="font-size:22px"><strong>Repository Structure</strong></h2>

<pre>
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

├── constraints/
│   └── pynq_z2_sar_adc.xdc

├── testbench/
│   └── tb_sar_adc.sv

├── docs/
│   ├── SAR_ADC_Project_Report.pdf
│   └── SAR_ADC_Project_Presentation.pdf

├── images/
│   ├── sar_adc_block_diagram.png
│   ├── rtl_schematic.png
│   ├── waveform_vin_11_2V.png
│   ├── waveform_vin_6_5V.png
│   ├── pynq_z2_board.jpg
│   └── hardware_demo_leds.jpg

└── results/
    ├── synthesis_utilization_report.rpt
    ├── implementation_utilization_report.rpt
    ├── timing_summary_report.rpt
    ├── power_report.rpt
    ├── drc_report.rpt
    └── io_report.rpt
</pre>

<p>Some documentation, images, and reports may be added progressively as the repository is finalized.</p>

<h2 style="font-size:22px"><strong>Module Descriptions</strong></h2>

<p><strong>src/sample_hold.sv</strong> — Simulation only: Captures and holds the real-valued analog input during conversion.</p>

<p><strong>src/dac_model.sv</strong> — Simulation only: Converts the 8-bit trial code into an ideal real-valued DAC output.</p>

<p><strong>src/comparator_model.sv</strong> — Simulation only: Compares the held input voltage with the DAC output.</p>

<p><strong>src/sar_controller.sv</strong> — Synthesizable: Implements the SAR binary-search algorithm as an FSM.</p>

<p><strong>src/sar_adc_top.sv</strong> — Simulation integration: Connects the sample-and-hold, DAC, comparator, and SAR controller.</p>

<p><strong>testbench/tb_sar_adc.sv</strong> — Simulation only: Generates the clock, reset, start pulse, and two analog test cases.</p>

<p><strong>src/sar_adc_fpga_demo_top.sv</strong> — Synthesizable: Implements the switch/button/LED demonstration on the PYNQ-Z2.</p>

<p><strong>constraints/pynq_z2_sar_adc.xdc</strong> — Constraint file: Maps clock, buttons, switches, and LEDs to physical FPGA pins.</p>

<h2 style="font-size:22px"><strong>FSM Operation</strong></h2>

<p>The behavioral SAR controller uses four states:</p>

<ul>
  <li><strong>IDLE</strong> — Waits for the start signal and clears the previous result.</li>
  <li><strong>SAMPLE</strong> — Captures the analog input and initializes the MSB trial.</li>
  <li><strong>CONVERT</strong> — Tests each bit from bit 7 down to bit 0.</li>
  <li><strong>DONE</strong> — Asserts done to indicate that digital_out is valid.</li>
</ul>

<p>The FPGA demonstration module uses a simplified three-state sequence: IDLE → CONVERT → DONE</p>

<h2 style="font-size:22px"><strong>Simulation Parameters</strong></h2>

<ul>
  <li>Resolution: 8 bits</li>
  <li>Reference voltage: 16 V</li>
  <li>Number of quantization levels: 256</li>
  <li>LSB size: 0.0625 V</li>
  <li>Maximum ideal quantization error: ±0.03125 V</li>
  <li>Simulation clock: 100 MHz (10 ns period)</li>
  <li>Ideal 8-bit SNR: Approximately 49.92 dB</li>
</ul>

<h2 style="font-size:22px"><strong>Simulation Test Cases</strong></h2>

<h3 style="font-size:18px"><strong>Test Case 1</strong></h3>

<p>Vin = 11.2 V, Vref = 16 V</p>

<p>Expected code: D = floor(11.2 / 0.0625) = 179 → Binary = 10110011 (0xB3)</p>


<img width="1004" height="625" alt="image" src="https://github.com/user-attachments/assets/d1d24eb5-c37c-4bdd-82ef-da1b39ad8940" />


<h3 style="font-size:18px"><strong>Test Case 2</strong></h3>

<p>Vin = 6.5 V, Vref = 16 V</p>

<p>Result: Binary = 01101000 (0x68) → Decimal = 104 → Reconstructed voltage = 6.5 V</p>

<img width="1000" height="644" alt="image" src="https://github.com/user-attachments/assets/e29ba84f-3d74-4bca-bff9-7c442f340cff" />


<h2 style="font-size:22px"><strong>Results Summary</strong></h2>

<p>The intermediate digital_out values visible in the waveform are trial codes generated by the SAR binary search. The final output should be read only when done = 1.</p>

<h2 style="font-size:22px"><strong>PYNQ-Z2 Hardware Demonstrator</strong></h2>

<p><strong>Target hardware</strong></p>

<pre>
Development board: PYNQ-Z2
FPGA/SoC: Xilinx Zynq-7020 (xc7z020clg400-1)
Board clock: 125 MHz (constraint: 8 ns)
I/O standard: LVCMOS33
</pre>

<h2 style="font-size:22px"><strong>PYNQ-Z2 Pin Mapping</strong></h2>

<pre>
Signal        Board Component   FPGA Pin   I/O Standard
clk           125 MHz system clk H16        LVCMOS33
reset_btn     BTN0              D19        LVCMOS33
start_btn     BTN1              D20        LVCMOS33
sw[0]         SW0               M20        LVCMOS33
sw[1]         SW1               M19        LVCMOS33
led[0]        LD0               R14        LVCMOS33
led[1]        LD1               P14        LVCMOS33
led[2]        LD2               N16        LVCMOS33
led[3]        LD3               M14        LVCMOS33
</pre>

<h2 style="font-size:22px"><strong>Requirements</strong></h2>

<p><strong>Software</strong></p>

<ul>
  <li>AMD/Xilinx Vivado Design Suite (support for 7 Series, Zynq-7000 SoCs, and Xilinx cable drivers)</li>
</ul>

<p><strong>Hardware</strong></p>

<ul>
  <li>PYNQ-Z2 board</li>
  <li>Micro-USB cable supporting data transfer</li>
  <li>Computer with Vivado installed</li>
</ul>

<h2 style="font-size:22px"><strong>Running the Behavioral Simulation</strong></h2>

<ol>
  <li>Open Vivado and create a new RTL Project (target part: xc7z020clg400-1).</li>
  <li>Add design sources: src/sample_hold.sv, src/dac_model.sv, src/comparator_model.sv, src/sar_controller.sv, src/sar_adc_top.sv.</li>
  <li>Add simulation source: testbench/tb_sar_adc.sv and set it as simulation top.</li>
  <li>Run → Flow Navigator → Simulation → Run Behavioral Simulation. Add internal signals to the waveform and run until conversions complete.</li>
  <li>Verify output when done = 1.</li>
</ol>

<h2 style="font-size:22px"><strong>Synthesizing the FPGA Demonstrator</strong></h2>

<ol>
  <li>Create/open a Vivado RTL project for xc7z020clg400-1.</li>
  <li>Add src/sar_adc_fpga_demo_top.sv as design source and constraints/pynq_z2_sar_adc.xdc as constraint file.</li>
  <li>Set hardware top module to sar_adc_fpga_demo_top.</li>
  <li>Run: Run Synthesis → Run Implementation → Generate Bitstream.</li>
  <li><strong>[!WARNING]</strong> Do not use tb_sar_adc or sar_adc_top as the hardware synthesis top.</li>
</ol>

<h2 style="font-size:22px"><strong>Programming the PYNQ-Z2</strong></h2>

<ol>
  <li>Connect and power the PYNQ-Z2, open Vivado Hardware Manager → Open Target → Auto Connect.</li>
  <li>Select the detected xc7z020 device → Program Device → choose sar_adc_fpga_demo_top.bit → Program.</li>
  <li>Set SW0 and SW1, press and hold BTN1 to observe LED nibble, press BTN0 to reset.</li>
</ol>

<h2 style="font-size:22px"><strong>Vivado Design Flow</strong></h2>

<pre>
flowchart LR
    RTL[SystemVerilog RTL] --> SYN[Synthesis]
    SYN --> NET[Technology Netlist]
    NET --> IMP[Implementation]
    IMP --> PLACE[Placement]
    PLACE --> ROUTE[Routing]
    ROUTE --> TIMING[Timing and DRC]
    TIMING --> BIT[Bitstream Generation]
    BIT --> HW[Program PYNQ-Z2]
</pre>

<h2 style="font-size:22px"><strong>Important Technical Distinction</strong></h2>

<p>The behavioral simulation uses real-valued analog signals which are not synthesizable; the FPGA demonstrator uses precomputed digital codes and a synthesizable FSM.</p>

<h2 style="font-size:22px"><strong>Current Project Status</strong></h2>

<ul>
  <li>SAR controller designed</li>
  <li>Behavioral analog models created</li>
  <li>Top-level simulation integration completed</li>
  <li>Testbench created and two conversion cases verified</li>
  <li>PYNQ-Z2 constraint file created</li>
  <li>Synthesis, implementation, and bitstream generation completed</li>
  <li>FPGA device programmed through Hardware Manager</li>
</ul>

<h2 style="font-size:22px"><strong>Future Improvements</strong></h2>

<ul>
  <li>Extend the controller and behavioral model to 12-bit resolution.</li>
  <li>Add parameterized resolution and reference-voltage support.</li>
  <li>Interface an external precision DAC and high-speed comparator.</li>
  <li>Add a real analog front end and sample-and-hold circuit.</li>
  <li>Add button debouncing and synchronization.</li>
  <li>Display the complete 8-bit result through UART, seven-segment display, or AXI GPIO.</li>
  <li>Integrate the Zynq XADC for comparison with the custom SAR controller.</li>
</ul>

<h2 style="font-size:22px"><strong>Authors</strong></h2>

<p>Shubham Singh &amp; Jayant Punj<br>
Department of Electronics and Communication Engineering<br>
University Institute of Engineering and Technology, Panjab University, Chandigarh</p>

