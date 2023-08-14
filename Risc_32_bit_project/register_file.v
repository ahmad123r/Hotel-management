module Register_file(
    input wire clk,
    input wire reg_write,
    input wire [4:0] read_reg1,
    input wire [4:0] read_reg2,
    input wire [4:0] write_reg,
    input wire [31:0] data_in,
    output reg [31:0] data_out1,
    output reg [31:0] data_out2
);

    reg [31:0] reg_file [31:0]; // Array representing the register file with 32 registers
    integer idx;

    initial
    begin
        for (idx = 0; idx < 32; idx = idx + 1) begin
            reg_file[idx] = 32'b0; // Initialize all registers in the register file with 0
        end
    end

    always @* begin
        data_out1 = reg_file[read_reg1]; // Assign the value of the register at read_reg1 to data_out1
        data_out2 = reg_file[read_reg2]; // Assign the value of the register at read_reg2 to data_out2
    end

    always @(posedge clk) begin
        if (reg_write) begin
            reg_file[write_reg] = data_in; // Write the data_in value to the register at write_reg
        end
    end
			
endmodule


module Register_A(    
    input wire write_enable_A,
    input wire [31:0] input_reg,
    output reg [31:0] output_reg
);
    always @* 
    begin                 
        if (write_enable_A) begin
            output_reg <= input_reg; // Assign the input_reg value to the output_reg when write_enable_A is high
        end
    end
endmodule


module Register_B(
    input wire write_enable_B,
    input wire [31:0] input_reg,
    output reg [31:0] output_reg
);
    reg internal_reg;

    always @*
    begin
        if (write_enable_B) begin
            output_reg = input_reg; // Assign the input_reg value to the output_reg when write_enable_B is high
        end
    end
endmodule


module alu_result_register(
    input wire clk,
    input wire [31:0] in,
    output reg [31:0] out
);

    always @(posedge clk)
    begin
        out <= in; // Assign the value of in to out on the positive edge of the clock
    end
endmodule
