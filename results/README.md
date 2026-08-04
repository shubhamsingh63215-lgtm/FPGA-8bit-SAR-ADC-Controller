# Results

This directory contains the verified simulation results and FPGA implementation evidence for the **8-bit SAR ADC Controller** implemented using SystemVerilog and AMD/Xilinx Vivado on the **PYNQ-Z2** development board.

> [!IMPORTANT]
> Exact FPGA utilization, timing, power, and DRC values must be copied directly from the generated Vivado reports. Placeholder fields in this document should not be replaced with estimated or assumed values.

---

## 1. Project Configuration

| Parameter | Value |
|---|---|
| Project | FPGA-Based 8-bit SAR ADC Controller |
| HDL | SystemVerilog / Verilog |
| FPGA board | PYNQ-Z2 |
| FPGA device | `xc7z020clg400-1` |
| Simulation top | `tb_sar_adc` |
| Hardware top | `sar_adc_fpga_demo_top` |
| Constraint file | `pynq_z2_sar_adc.xdc` |
| Behavioral simulation clock | 100 MHz |
| FPGA board clock | 125 MHz |
| FPGA clock period constraint | 8 ns |
| Vivado flow | Simulation → Synthesis → Implementation → Bitstream → Hardware Programming |

---

## 2. Design Flow Status

| Stage | Status |
|---|---|
| SystemVerilog design sources created | Completed |
| Behavioral simulation | Completed |
| Testbench verification | Completed |
| Synthesis | Completed |
| Implementation | Completed |
| Bitstream generation | Completed |
| Hardware Manager connection | Completed |
| FPGA programming through JTAG | Completed |
| Final LED-output verification | Requires final documented hardware evidence |

Vivado successfully programmed the `xc7z020` device through Hardware Manager. The recorded programming status included:

```text
End of startup status: HIGH
```

This confirms that the FPGA configuration process completed successfully.

---

## 3. Behavioral Simulation Parameters

| Parameter | Value |
|---|---:|
| ADC resolution | 8 bits |
| Reference voltage, `Vref` | 16 V |
| Number of quantization levels | 256 |
| LSB size | 0.0625 V |
| Maximum ideal quantization error | ±0.03125 V |
| Ideal 8-bit SNR | Approximately 49.92 dB |
| Conversion method | Successive approximation / binary search |

The digital output code is calculated as:

```text
Digital Code = floor(Vin / LSB)
```

with:

```text
LSB = Vref / 2^N
    = 16 / 256
    = 0.0625 V
```

---

## 4. Verified Simulation Results

### Test Case 1 — Vin = 11.2 V

```text
Vin  = 11.2 V
Vref = 16 V
LSB  = 0.0625 V
```

Calculation:

```text
Digital code = floor(11.2 / 0.0625)
             = floor(179.2)
             = 179
```

Result:

| Quantity | Value |
|---|---|
| Binary output | `10110011` |
| Hexadecimal output | `0xB3` |
| Decimal output | 179 |
| Reconstructed voltage | 11.1875 V |
| Quantization error | 0.0125 V |
| Verification status | Passed |

---

### Test Case 2 — Vin = 6.5 V

```text
Vin  = 6.5 V
Vref = 16 V
LSB  = 0.0625 V
```

Calculation:

```text
Digital code = 6.5 / 0.0625
             = 104
```

Result:

| Quantity | Value |
|---|---|
| Binary output | `01101000` |
| Hexadecimal output | `0x68` |
| Decimal output | 104 |
| Reconstructed voltage | 6.5 V |
| Quantization error | 0 V |
| Verification status | Passed |

---

## 5. Simulation Results Summary

| Test | Input Voltage | Expected Code | Simulated Code | Hex | Decimal | Reconstructed Voltage | Error | Status |
|---|---:|---:|---:|---:|---:|---:|---:|---|
| 1 | 11.2 V | `10110011` | `10110011` | `0xB3` | 179 | 11.1875 V | 0.0125 V | Passed |
| 2 | 6.5 V | `01101000` | `01101000` | `0x68` | 104 | 6.5 V | 0 V | Passed |

> The intermediate values of `digital_out` seen during simulation are SAR trial codes. The final output is valid when the `done` signal is asserted.

---

## 6. SAR Conversion Sequence

### Vin = 11.2 V

| Bit Tested | Trial Code | DAC Voltage | Comparison | Decision |
|---:|---:|---:|---|---|
| Bit 7 | `10000000` | 8.0 V | 11.2 V > 8.0 V | Keep |
| Bit 6 | `11000000` | 12.0 V | 11.2 V < 12.0 V | Clear |
| Bit 5 | `10100000` | 10.0 V | 11.2 V > 10.0 V | Keep |
| Bit 4 | `10110000` | 11.0 V | 11.2 V > 11.0 V | Keep |
| Bit 3 | `10111000` | 11.5 V | 11.2 V < 11.5 V | Clear |
| Bit 2 | `10110100` | 11.25 V | 11.2 V < 11.25 V | Clear |
| Bit 1 | `10110010` | 11.125 V | 11.2 V > 11.125 V | Keep |
| Bit 0 | `10110011` | 11.1875 V | 11.2 V > 11.1875 V | Keep |

Final result:

```text
10110011 = 0xB3 = 179
```

### Vin = 6.5 V

| Bit Tested | Trial Decision |
|---:|---|
| Bit 7 | Clear |
| Bit 6 | Keep |
| Bit 5 | Keep |
| Bit 4 | Clear |
| Bit 3 | Keep |
| Bit 2 | Clear |
| Bit 1 | Clear |
| Bit 0 | Clear |

Final result:

```text
01101000 = 0x68 = 104
```

---

## 7. FPGA Hardware Demonstrator Results

The synthesizable FPGA top module uses the PYNQ-Z2 switches, buttons, and LEDs to demonstrate the two verified output codes.

### Hardware controls

| Control | Function |
|---|---|
| `SW0` | Selects the test case |
| `SW1` | Selects upper or lower nibble |
| `BTN0` | Resets the design |
| `BTN1` | Starts the demonstration conversion |
| `LD3:LD0` | Displays the selected 4-bit nibble |

### Expected LED patterns

| `SW0` | Demonstrated Result | `SW1` | Selected Nibble | Expected `LD3:LD0` |
|---:|---:|---:|---:|---:|
| 0 | `0xB3` | 0 | Lower nibble | `0011` |
| 0 | `0xB3` | 1 | Upper nibble | `1011` |
| 1 | `0x68` | 0 | Lower nibble | `1000` |
| 1 | `0x68` | 1 | Upper nibble | `0110` |

> Final board-level LED photographs or screenshots should be added to the repository after the hardware output has been visibly confirmed.

---

## 8. FPGA Pin Mapping

| Signal | Board Component | FPGA Pin | I/O Standard |
|---|---|---|---|
| `clk` | 125 MHz system clock | H16 | LVCMOS33 |
| `reset_btn` | BTN0 | D19 | LVCMOS33 |
| `start_btn` | BTN1 | D20 | LVCMOS33 |
| `sw[0]` | SW0 | M20 | LVCMOS33 |
| `sw[1]` | SW1 | M19 | LVCMOS33 |
| `led[0]` | LD0 | R14 | LVCMOS33 |
| `led[1]` | LD1 | P14 | LVCMOS33 |
| `led[2]` | LD2 | N16 | LVCMOS33 |
| `led[3]` | LD3 | M14 | LVCMOS33 |

---

## 9. Synthesis Results

Copy the values below from the Vivado **Synthesis Utilization Report**.

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| Slice LUTs | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| Slice Registers | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| LUT as Logic | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| LUT as Memory | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| Block RAM | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| DSP Slices | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| Bonded I/O | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| BUFG | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |

Recommended report file:

```text
synthesis_utilization_report.rpt
```

---

## 10. Implementation Results

Copy the final post-route utilization values from the Vivado **Implementation Utilization Report**.

| Resource | Used | Available | Utilization |
|---|---:|---:|---:|
| Slice LUTs | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| Slice Registers | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| F7/F8 Multiplexers | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| Block RAM | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| DSP Slices | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |
| I/O Ports | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` | `ADD ACTUAL VALUE` |

Recommended report file:

```text
implementation_utilization_report.rpt
```

---

## 11. Timing Results

Copy these values from the post-implementation Vivado **Timing Summary Report**.

| Timing Metric | Result |
|---|---:|
| Clock period constraint | 8 ns |
| Target clock frequency | 125 MHz |
| WNS — Worst Negative Slack | `ADD ACTUAL VALUE` |
| TNS — Total Negative Slack | `ADD ACTUAL VALUE` |
| WHS — Worst Hold Slack | `ADD ACTUAL VALUE` |
| THS — Total Hold Slack | `ADD ACTUAL VALUE` |
| Setup failing endpoints | `ADD ACTUAL VALUE` |
| Hold failing endpoints | `ADD ACTUAL VALUE` |
| Timing constraints met | `YES / NO` |

Timing is considered successfully closed when the generated report confirms that all required setup and hold checks pass.

Recommended report file:

```text
timing_summary_report.rpt
```

---

## 12. Power Results

Vivado power values are estimates unless realistic signal activity and environmental parameters are provided.

| Power Metric | Result |
|---|---:|
| Total on-chip power | `ADD ACTUAL VALUE` |
| Dynamic power | `ADD ACTUAL VALUE` |
| Device static power | `ADD ACTUAL VALUE` |
| Clock power | `ADD ACTUAL VALUE` |
| Logic power | `ADD ACTUAL VALUE` |
| Signal power | `ADD ACTUAL VALUE` |
| I/O power | `ADD ACTUAL VALUE` |
| Junction temperature | `ADD ACTUAL VALUE` |
| Thermal margin | `ADD ACTUAL VALUE` |
| Confidence level | `ADD ACTUAL VALUE` |

Recommended report file:

```text
power_report.rpt
```

---

## 13. Design Rule Check Results

Copy the values from the final Vivado DRC report.

| DRC Metric | Result |
|---|---:|
| Critical warnings | `ADD ACTUAL VALUE` |
| Errors | `ADD ACTUAL VALUE` |
| Warnings | `ADD ACTUAL VALUE` |
| Informational messages | `ADD ACTUAL VALUE` |
| Bitstream-blocking violations | `ADD ACTUAL VALUE` |
| Final DRC status | `PASSED / FAILED` |

Recommended report file:

```text
drc_report.rpt
```

---

## 14. Route Status

| Route Metric | Result |
|---|---:|
| Total nets | `ADD ACTUAL VALUE` |
| Routed nets | `ADD ACTUAL VALUE` |
| Unrouted nets | `ADD ACTUAL VALUE` |
| Routing conflicts | `ADD ACTUAL VALUE` |
| Route status | `COMPLETE / INCOMPLETE` |

Recommended report file:

```text
route_status_report.rpt
```

---

## 15. Bitstream and Hardware Programming

| Item | Result |
|---|---|
| Hardware top module | `sar_adc_fpga_demo_top` |
| Generated bitstream | `sar_adc_fpga_demo_top.bit` |
| Target device | `xc7z020clg400-1` |
| Programming interface | Vivado Hardware Manager / USB-JTAG |
| Device detection | Successful |
| FPGA programming | Successful |
| End of startup status | HIGH |

The bitstream should preferably be distributed through the repository's **GitHub Releases** section instead of committing the complete Vivado run directories.

---

## 16. Recommended Files in This Directory

```text
results/
├── README.md
├── synthesis_utilization_report.rpt
├── implementation_utilization_report.rpt
├── timing_summary_report.rpt
├── power_report.rpt
├── drc_report.rpt
├── io_report.rpt
├── route_status_report.rpt
├── bitstream_generation_status.txt
└── hardware_programming_status.txt
```

Waveform screenshots, RTL schematics, implementation screenshots, and hardware photographs should be placed in the separate [`images`](../images) directory.

---

## 17. Final Result

<img width="1000" height="644" alt="image" src="https://github.com/user-attachments/assets/1231f0db-2799-4714-8075-fcebc507b7a1" />

<img width="1004" height="625" alt="image" src="https://github.com/user-attachments/assets/a1452428-c4d4-4725-8e7a-715d66f794eb" />

The project successfully demonstrates:

- Correct 8-bit SAR binary-search behavior in behavioral simulation
- Verified conversion results for `Vin = 11.2 V` and `Vin = 6.5 V`
- Successful synthesis and implementation of the hardware demonstrator
- Successful bitstream generation
- Successful programming of the PYNQ-Z2 FPGA through Vivado Hardware Manager

The current FPGA module demonstrates verified digital output codes. A complete physical ADC implementation would additionally require an external analog sample-and-hold circuit, precision DAC, and comparator.
