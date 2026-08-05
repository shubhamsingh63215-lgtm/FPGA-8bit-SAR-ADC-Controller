// sample_hold.sv
// Simple sample-and-hold model. On a rising clock edge, when 'sample' is asserted,
// the input vin is captured and held on v_sampled.

module sample_hold (
    input  logic clk,
    input  logic sample,
    input  real vin,
    output real v_sampled
);

    // held_value stores the most recently sampled analog input
    real held_value = 0.0;

    // Capture the input on the rising edge of the clock when sample is asserted
    always_ff @(posedge clk) begin
        if (sample)
            held_value <= vin;
    end

    // Continuous assignment to the output
    assign v_sampled = held_value;

endmodule
