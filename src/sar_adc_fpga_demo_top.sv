module sar_adc_fpga_demo_top(
    input  wire clk,
    input  wire reset_btn,
    input  wire start_btn,
    input  wire [1:0] sw,
    output reg  [3:0] led
);

    parameter N = 8;

    wire [N-1:0] sar_reg;
    reg  [N-1:0] target_code;
    reg  [N-1:0] final_code;

    wire comp_out;
    wire done;

    reg start_sync_1;
    reg start_sync_2;
    wire start_pulse;

    // SW0 selects test input
    // SW0 = 0 -> equivalent Vin = 11.2 V, expected code B3
    // SW0 = 1 -> equivalent Vin = 6.5 V, expected code 68
    always @(*) begin
        if (sw[0] == 1'b0)
            target_code = 8'hB3;
        else
            target_code = 8'h68;
    end

    // Synchronize button input
    always @(posedge clk or posedge reset_btn) begin
        if (reset_btn) begin
            start_sync_1 <= 1'b0;
            start_sync_2 <= 1'b0;
        end else begin
            start_sync_1 <= start_btn;
            start_sync_2 <= start_sync_1;
        end
    end

    assign start_pulse = start_sync_1 & ~start_sync_2;

    // Digital comparator model for FPGA demo
    assign comp_out = (target_code >= sar_reg) ? 1'b1 : 1'b0;

    sar_controller #(N) sar1 (
        .clk(clk),
        .reset(reset_btn),
        .start(start_pulse),
        .comp_out(comp_out),
        .sar_reg(sar_reg),
        .done(done)
    );

    // Store final ADC output after conversion
    always @(posedge clk or posedge reset_btn) begin
        if (reset_btn)
            final_code <= 8'd0;
        else if (done)
            final_code <= sar_reg;
    end

    // SW1 selects lower or upper nibble
    always @(*) begin
        if (sw[1] == 1'b0)
            led = final_code[3:0];
        else
            led = final_code[7:4];
    end

endmodule