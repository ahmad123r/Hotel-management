module Unsigned_Extender(
    input wire [13:0] input_extend,
    output reg [31:0] output_extended
);

always @*
begin
    output_extended[13:0] = input_extend; // Assign the lower 14 bits of input_extend to output_extended
    output_extended[31:14] = 0; // Assign 0 to the upper 18 bits of output_extended
end

endmodule


module SAExtend (
    input wire [13:0] input_imm,
    output reg [31:0] output_extended
);

always @*
begin
    output_extended[4:0] = input_imm[8:4]; // Assign bits [8:4] of input_imm to bits [4:0] of output_extended
    output_extended[31:5] = 0; // Assign 0 to the remaining bits [31:5] of output_extended
end

endmodule


module Sign_Extender(
    input wire [13:0] in_extend,
    output reg [31:0] out_extended
);

always @*
begin 
	
    out_extended[13:0] = in_extend; // Assign the lower 14 bits of in_extend to out_extended
    if (in_extend[13]) // If bit 13 of in_extend is 1 (negative value)
				begin
					out_extended[31:14] = 262143; // Assign 262143 (0x3FFFF) to the upper 18 bits of out_extended (sign extension)
				end	
			else // If bit 13 of in_extend is 0 (positive value)
				begin
					out_extended[31:14] = 0; // Assign 0 to the upper 18 bits of out_extended
				end
end

endmodule

module immediate_gen(
	input wire [4:0] src_reg,
	input wire [4:0] dest_reg,
	input wire [13:0] immediate_val,
	output reg [31:0] PC_immediate
);

always @*
begin
	if (src_reg[4] == 1'b1) // If bit 4 of src_reg is 1
		begin
			PC_immediate[31:24] = 8'b11111111; // Assign 8'b11111111 to bits [31:24] of PC_immediate
		end	
	else // If bit 4 of src_reg is 0
		begin
			PC_immediate[31:24] = 8'b00000000; // Assign 8'b00000000 to bits [31:24] of PC_immediate
		end

	PC_immediate[23:19] = src_reg[4:0]; // Assign bits [4:0] of src_reg to bits [23:19] of PC_immediate
	PC_immediate[18:14] = dest_reg[4:0]; // Assign bits [4:0] of dest_reg to bits [18:14] of PC_immediate
	PC_immediate[13:0] = immediate_val[13:0]; // Assign the lower 14 bits of immediate_val to bits [13:0] of PC_immediate
end

endmodule
