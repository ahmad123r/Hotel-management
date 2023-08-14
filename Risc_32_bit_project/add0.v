module add0(
    input [31:0] in_pc, // Input: Program counter value
    input [13:0] in_immediate, // Input: Immediate value
    output reg [31:0] branch_address // Output: Computed branch address
);
    wire [31:0] immediate_extend; // Wire for extended immediate value

    assign immediate_extend = {18'b0, in_immediate}; // Extend immediate value with 18 leading zeroes

    always @*
    begin
        branch_address <= in_pc + immediate_extend; // Compute the branch address by adding in_pc and immediate_extend
    end
endmodule
