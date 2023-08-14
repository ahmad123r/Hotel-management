module selector_2x1 (
  input wire [31:0] input_a,
  input wire [31:0] input_b,
  input wire select,
  output wire [31:0] output_mux
);

// The selector_2x1 module takes two input signals (input_a, input_b) and a single-bit select signal.
// It produces a single output signal (output_mux) based on the select signal's value.

assign output_mux = (select == 0) ? input_a : input_b;
// If select is 0, output_mux is assigned input_a.
// Otherwise, if select is 1, output_mux is assigned input_b.

endmodule
