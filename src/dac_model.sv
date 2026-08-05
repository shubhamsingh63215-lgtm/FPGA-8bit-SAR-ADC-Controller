// dac_model.sv
// Behavioral N-bit DAC model for SAR ADC simulation.
// Converts the N-bit digital input to an analog real-valued vdac.

module dac_model #(
    parameter int N = 8
)(
    input  logic [N-1:0] digital_in,
    output real vdac
);

    // Reference voltage (adjustable)
    parameter real VREF = 16.0;

    // Convert digital input to real voltage. Use real cast for correct arithmetic.
    always_comb begin
        vdac = (real'(digital_in) * VREF) / (2.0 ** N);
    end

endmodule
