module Instr_Reg(
	input wire clk,
	input wire IR_Write,
	input wire [31:0] in_reg,
	output reg [4:0] Operation,
	output reg [4:0] Src_1,
	output reg [4:0] Dest,
	output reg [13:0] immediate,
	output reg [1:0] instr_type,
	output reg halt_bit
);
    always @*
    begin
        if (IR_Write)
        begin
            Operation <= in_reg[31:27]; // Assign bits [31:27] of in_reg to the Operation output
            Src_1 <= in_reg[26:22]; // Assign bits [26:22] of in_reg to the Src_1 output
            Dest <= in_reg[21:17]; // Assign bits [21:17] of in_reg to the Dest output
            immediate <= in_reg[16:3]; // Assign bits [16:3] of in_reg to the immediate output
            instr_type <= in_reg[2:1]; // Assign bits [2:1] of in_reg to the instr_type output
            halt_bit <= in_reg[0]; // Assign bit 0 of in_reg to the halt_bit output
        end
    end
endmodule
