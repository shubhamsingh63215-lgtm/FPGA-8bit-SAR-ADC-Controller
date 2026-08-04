module comparator_model(
    input real vin,
    input real vdac,
    output logic comp_out
);

always_comb begin
    if (vin >= vdac)
        comp_out = 1'b1;
    else
        comp_out = 1'b0;
end

endmodule