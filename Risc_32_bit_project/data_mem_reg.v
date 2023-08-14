module data_memory_reg(
	input wire clk,
	input wire [31:0] input_reg,
	output reg [31:0] output_reg
);
    always @(posedge clk)
    begin
        output_reg <= output_reg; // The output_reg is assigned its current value on the positive edge of the clock
    end
endmodule
