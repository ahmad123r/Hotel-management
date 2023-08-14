module RAM(
    input wire clk_signal,
    input wire [31:0] addr,
    input  reg [31:0] data_input,
    input wire read_enable,
    input wire write_enable,
    output  reg [31:0] data_output
);
    reg [31:0] ram_data[0:1024]; // Internal memory array with 1024 locations (32-bit each)

    always @(posedge clk_signal)
    begin
        if (write_enable)
        begin
            ram_data[addr] = data_input; // Write data_input to the specified address in ram_data
        end
        if (read_enable)
        begin
            data_output = ram_data[addr]; // Read data from the specified address in ram_data and assign it to data_output
        end
    end
endmodule

module ProgramMemory(
    input wire [31:0] PC_input,
    output reg [31:0] Opcode,
    output reg [31:0] PC_output
);
    reg [31:0] code_mem[2048:0]; // Internal memory array with 2048 locations (32-bit each)

    initial begin
code_mem[0] = 32'b00000000000000000000000000000000; // No-OP
code_mem[1] = 32'b00001000010000100000000000110010; // addi r1, r1, 6
code_mem[2] = 32'b00001000100001000000000000011010; // addi r2, r2, 3
code_mem[3] = 32'b00010000010001100010000000000000; // add r3, r2, r1
code_mem[4] = 32'b00000000010010000000000100000110; // sll r4, r1, 2
code_mem[5] = 32'b00001000000000000000000000010100; // JAL 2
code_mem[6] = 32'b00000111111111111111111111010100; // J -6
code_mem[7] = 32'b00011000000001100000000000000010; // sw r3, [r4]
code_mem[8] = 32'b00010001010000000000000000000011; // lw r5, [r0]  
    end

    always @* begin
        Opcode = code_mem[PC_input]; // Read the opcode at the address specified by PC_input and assign it to Opcode
        PC_output <= PC_input + 1; // Increment the PC_input value by 1 and assign it to PC_output
    end

endmodule
