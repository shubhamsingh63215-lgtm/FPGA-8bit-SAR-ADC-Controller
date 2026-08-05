// sar_adc_top.sv
// Top-level SAR ADC module wiring together sample-and-hold, DAC, comparator and SAR
// controller. Provides both analog (vdac, v_sampled) and digital (digital_out) outputs
// for simulation and verification.

module sar_adc_top #(
    parameter int N = 8
)(
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  real  vin,

    output logic [N-1:0] digital_out,
    output logic done,

    // Analog signals exported for verification
    output real vdac,
    output real v_sampled,
    output logic comp_out
);

    logic [N-1:0] sar_reg;

    // Sample-and-hold captures the input voltage when 'start' is asserted
    sample_hold sh1 (
        .clk(clk),
        .sample(start),
        .vin(vin),
        .v_sampled(v_sampled)
    );

    // DAC model driven by the SAR register
    dac_model #(.N(N)) dac1 (
        .digital_in(sar_reg),
        .vdac(vdac)
    );

    // Comparator compares sampled voltage against DAC output
    comparator_model comp1 (
        .vin(v_sampled),
        .vdac(vdac),
        .comp_out(comp_out)
    );

    // SAR controller performs the successive-approximation algorithm
    sar_controller #(.N(N)) sar1 (
        .clk(clk),
        .reset(reset),
        .start(start),
        .comp_out(comp_out),
        .sar_reg(sar_reg),
        .done(done)
    );

    assign digital_out = sar_reg;

endmodule
