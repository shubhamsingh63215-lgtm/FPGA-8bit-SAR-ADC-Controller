module dac_model #(parameter N = 8)(
    input  logic [N-1:0] digital_in,
    output real vdac
);

    parameter real VREF = 16.0;

    always_comb begin
        vdac = (real'(digital_in) * VREF) / (2.0 ** N);
    end

endmodule