// In SystemVerilog, you can create a parameterized fractional clock divider using a module with input parameters to define the clock division ratio. Here's an example of such a module:

module fractional_clock_divider
#(
  parameter DIV_NOM = 1,      // Clock division numerator
  parameter DIV_DENOM = 2     // Clock division denominator
)
(
  input  logic clk_in,        // Input clock
  input  logic rst_n,         // Active-low reset
  output logic clk_out        // Output clock
);

  logic [31:0] counter;       // Counter to maintain division ratio
  logic [31:0] threshold;     // Threshold value for division

  // Calculate the threshold value for the given division ratio
  always_comb begin
    threshold = (1 << 32) * DIV_NOM / DIV_DENOM;
  end

  // Main clock divider logic
  always_ff @(posedge clk_in or negedge rst_n) begin
    if (!rst_n) begin
      counter <= 32'h0;
      clk_out <= 1'b0;
    end
    else begin
      counter <= counter + 32'h1;
      if (counter < threshold) begin
        clk_out <= ~clk_out;
      end
    end
  end

endmodule

// This module uses a 32-bit counter to maintain the clock division ratio, and a threshold value calculated from the given numerator (DIV_NOM) and denominator (DIV_DENOM) parameters. The counter increments on each rising edge of the input clock (clk_in). When the counter value is less than the threshold value, the output clock (clk_out) is toggled.

// To instantiate the module in your design, you can use the following code snippet:

// wire clk_in, rst_n, clk_out;

// fractional_clock_divider #(
//   .DIV_NOM(1),
//   .DIV_DENOM(4)
// ) my_clk_divider (
//   .clk_in(clk_in),
//   .rst_n(rst_n),
//   .clk_out(clk_out)
// );

// This example instantiates the fractional_clock_divider module with a clock division ratio of 1:4. Feel free to adjust the DIV_NOM and DIV_DENOM parameters according to your requirements.