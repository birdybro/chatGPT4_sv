// Here's a simple Linear Feedback Shift Register (LFSR) based Random Number Generator (RNG) module using SystemVerilog. This design uses a 32-bit LFSR with a maximal-length polynomial for generating random numbers.

module lfsr_rng
(
    input wire clk,
    input wire rst,
    output reg [31:0] random_number
);

// LFSR register
reg [31:0] lfsr;

// Maximal-length polynomial for a 32-bit LFSR: x^32 + x^22 + x^2 + x^1 + 1
// (Taps at positions 32, 22, 2, 1)
always @(posedge clk or posedge rst) begin
    if (rst) begin
        // Non-zero initial value
        lfsr <= 32'hDEADBEEF;
    end else begin
        // Update LFSR value
        lfsr <= {lfsr[30:0], lfsr[31] ^ lfsr[21] ^ lfsr[1] ^ lfsr[0]};
    end
end

// Assign the LFSR value as the random number
assign random_number = lfsr;

endmodule

// In this example, the LFSR is 32 bits long and uses a maximal-length polynomial for generating a sequence of random numbers with a long period. When the input signal rst is high, the LFSR is reset to an initial non-zero value (0xDEADBEEF). On every rising edge of the input clock signal clk, the LFSR is updated based on the XOR of the tap positions (32, 22, 2, 1). The LFSR value is then assigned to the random_number output.
