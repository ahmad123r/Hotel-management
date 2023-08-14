module immediate_to_dest(
	input wire [13:0] imm_val,
	output reg [4:0] dest_reg_2
);
    always @*
    begin
        dest_reg_2 = imm_val[13:9]; // Assign bits [13:9] of imm_val to dest_reg_2
    end
endmodule
