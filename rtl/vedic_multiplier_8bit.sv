// In SystemVerilog, you can design a synchronous 8-bit Vedic Multiplier module using the Urdhva Tiryakbhyam Sutra. Here's an example of a synchronous 8-bit Vedic Multiplier module:

module synchronous_vedic_multiplier_8bit (
    input logic clk,
    input logic rst_n,
    input logic start,
    input logic [7:0] A,
    input logic [7:0] B,
    output logic [15:0] P,
    output logic done
);

    // Internal signals
    logic [15:0] vedic_res;
    logic busy;

    // Main process
    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            vedic_res <= 16'h0;
            busy <= 1'b0;
        end else if (start && !busy) begin
            vedic_res <= vedic_8bit_mul(A, B);
            busy <= 1'b1;
        end else if (busy) begin
            busy <= 1'b0;
        end
    end

    // Output assignment
    assign P = vedic_res;
    assign done = !busy;

    // Vedic multiplication function
    function automatic [15:0] vedic_8bit_mul(input logic [7:0] x, input logic [7:0] y);
        logic [15:0] z;
        logic [7:0] p0, p1, p2, p3;

        p0 = vedic_2bit_mul(x[1:0], y[1:0]);
        p1 = vedic_2bit_mul(x[3:2], y[3:2]);
        p2 = vedic_2bit_mul(x[5:4], y[5:4]);
        p3 = vedic_2bit_mul(x[7:6], y[7:6]);

        z[1:0]   = p0[1:0];
        z[3:2]   = p0[3:2] ^ p1[1:0];
        z[5:4]   = p1[3:2] ^ p0[5:4] ^ p2[1:0];
        z[7:6]   = p1[5:4] ^ p2[3:2] ^ p3[1:0];
        z[9:8]   = p1[7:6] ^ p2[5:4] ^ p3[3:2];
        z[11:10] = p2[7:6] ^ p3[5:4];
        z[13:12] = p3[7:6];
        z[15:14] = p3[9:8];

        return z;
    endfunction

    // 2-bit Vedic multiplication function
    function automatic [3:0] vedic_2bit_mul(input logic [1:0] x, input logic [1:0] y);
        logic [3:0] z;

        z[0] = x[0] & y[0];
        z[1] = x[0] & y[1] ^ x[1] & y[0];
        z[2] = x[1] & y[1];
        z[3] = z[1];

        return z;
    endfunction

endmodule

// This synchronous Vedic Multiplier module takes a clock and an active-low reset signal. When the start signal is asserted,

// ChatGPT 4 stopped writing after this. As to WHY you may want to use this kind of multiplier, look no further than this paper --> https://core.ac.uk/download/pdf/235196202.pdf
