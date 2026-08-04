`timescale 1ns/1ps

module tb_sar_adc;

    logic clk;
    logic reset;
    logic start;
    real vin;

    logic [7:0] digital_out;
    logic done;
    real vdac;
    real v_sampled;
    logic comp_out;

    sar_adc_top #(8) uut (
        .clk(clk),
        .reset(reset),
        .start(start),
        .vin(vin),
        .digital_out(digital_out),
        .done(done),
        .vdac(vdac),
        .v_sampled(v_sampled),
        .comp_out(comp_out)
    );

    always #5 clk = ~clk;

    initial begin
        clk = 0;
        reset = 1;
        start = 0;
        vin = 0.0;

        #20 reset = 0;

        vin = 11.2;
        #10 start = 1;
        #10 start = 0;

        wait(done);
        #20;

        $display("Input Vin        = %f V", vin);
        $display("Digital Output   = %b", digital_out);
        $display("Decimal Output   = %0d", digital_out);
        $display("Final DAC Voltage= %f V", vdac);

        vin = 6.5;
        #20 start = 1;
        #10 start = 0;

        wait(done);
        #20;

        $display("Input Vin        = %f V", vin);
        $display("Digital Output   = %b", digital_out);
        $display("Decimal Output   = %0d", digital_out);
        $display("Final DAC Voltage= %f V", vdac);

        #100;
        $finish;
    end

endmodule