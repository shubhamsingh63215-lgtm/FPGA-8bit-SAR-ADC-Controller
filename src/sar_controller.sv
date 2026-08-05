// sar_controller.sv
// Successive Approximation Register (SAR) controller that implements a simple
// state machine to perform an N-bit ADC conversion using a comparator.

module sar_controller #(
    parameter int N = 8
)(
    input  wire clk,
    input  wire reset,
    input  wire start,
    input  wire comp_out,
    output reg  [N-1:0] sar_reg,
    output reg  done
);

    // State encoding
    localparam logic [1:0] IDLE      = 2'd0;
    localparam logic [1:0] SET_BIT   = 2'd1;
    localparam logic [1:0] WAIT_COMP = 2'd2;
    localparam logic [1:0] DECIDE    = 2'd3;

    reg [1:0] state;
    integer   bit_index;

    // Sequential state machine
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            sar_reg   <= '0;
            bit_index <= N - 1;
            done      <= 1'b0;
            state     <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    done <= 1'b0;
                    if (start) begin
                        sar_reg   <= '0;
                        bit_index <= N - 1;
                        state     <= SET_BIT;
                    end
                end

                SET_BIT: begin
                    sar_reg[bit_index] <= 1'b1;
                    state <= WAIT_COMP;
                end

                WAIT_COMP: begin
                    // short wait state to allow comparator to evaluate
                    state <= DECIDE;
                end

                DECIDE: begin
                    // If comparator indicates vin < vdac, clear the bit
                    if (comp_out == 1'b0)
                        sar_reg[bit_index] <= 1'b0;

                    // If this was the least significant bit, conversion is done
                    if (bit_index == 0) begin
                        done  <= 1'b1;
                        state <= IDLE;
                    end else begin
                        bit_index <= bit_index - 1;
                        state <= SET_BIT;
                    end
                end

                default: begin
                    state <= IDLE;
                end
            endcase
        end
    end

endmodule
