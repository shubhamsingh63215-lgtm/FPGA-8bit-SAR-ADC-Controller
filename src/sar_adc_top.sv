module sar_adc_top #(parameter N = 8)(
    input  logic clk,
    input  logic reset,
    input  logic start,
    input  real vin,

    output logic [N-1:0] digital_out,
    output logic done,

    output real vdac,
    output real v_sampled,
    output logic comp_out
);

    logic [N-1:0] sar_reg;

    sample_hold sh1 (
        .clk(clk),
        .sample(start),
        .vin(vin),
        .v_sampled(v_sampled)
    );

    dac_model #(N) dac1 (
        .digital_in(sar_reg),
        .vdac(vdac)
    );

    comparator_model comp1 (
        .vin(v_sampled),
        .vdac(vdac),
        .comp_out(comp_out)
    );

    sar_controller #(N) sar1 (
        .clk(clk),
        .reset(reset),
        .start(start),
        .comp_out(comp_out),
        .sar_reg(sar_reg),
        .done(done)
    );

    assign digital_out = sar_reg;

endmodule