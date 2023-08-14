module PC_Register(
    input wire clk,
    input wire [31:0] input_reg,
    output reg [31:0] output_reg,
    input wire write_enable
);

    initial begin
        output_reg <= 0; // Initialize the output_reg to 0
    end

    always @(posedge clk)
    begin
        if (write_enable)
        begin
            output_reg = input_reg; // Assign the input_reg value to the output_reg on the positive edge of the clock when write_enable is high
        end
    end
endmodule
