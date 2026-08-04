module sample_hold(
    input  logic clk,
    input  logic sample,
    input  real vin,
    output real v_sampled
);

    real held_value;

    always_ff @(posedge clk) begin
        if (sample)
            held_value <= vin;
    end

    assign v_sampled = held_value;

endmodule