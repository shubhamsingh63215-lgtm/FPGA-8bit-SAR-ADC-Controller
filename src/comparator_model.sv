// comparator_model.sv
// Simple behavioral comparator model used for SAR ADC simulation.
// Compares sampled input (vin) against DAC output (vdac).

module comparator_model (
    input  real vin,
    input  real vdac,
    output logic comp_out
);

    // combinational comparator: comp_out is high when vin >= vdac
    always_comb begin
        comp_out = (vin >= vdac) ? 1'b1 : 1'b0;
    end

endmodule
