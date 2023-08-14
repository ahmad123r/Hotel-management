module selector_4x1 (
    input wire [31:0] input_a,
    input wire [31:0] input_b,
    input wire [31:0] input_c,
    input wire [31:0] input_d,
    input wire [1:0] select,
    output wire [31:0] output_mux
);

// The selector_4x1 module takes four input signals (input_a, input_b, input_c, input_d) and a 2-bit select signal.
// It produces a single output signal (output_mux) based on the select signal's value.

assign output_mux = (select == 2'b00) ? input_a :  // If select is 2'b00 (binary 0), output_mux is assigned input_a
             (select == 2'b01) ? input_b :  // If select is 2'b01 (binary 1), output_mux is assigned input_b
             (select == 2'b10) ? input_c :  // If select is 2'b10 (binary 2), output_mux is assigned input_c
             input_d;  // If none of the above conditions are true, output_mux is assigned input_d

endmodule
