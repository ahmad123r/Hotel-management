module component_alu (
  input [31:0] input_A, // Input operand A
  input [31:0] input_B, // Input operand B
  input [1:0] input_Type, // Input ALU type
  input [4:0] input_Func, // Input ALU function
  output reg [31:0] output_Result, // Output result
  output reg output_ZeroFlag = 0, // Output zero flag
  output reg output_CarryFlag = 0, // Output carry flag
  output reg output_NegativeFlag = 0 // Output negative flag
);
  always @*
  begin
    output_CarryFlag = 0; // Initialize carry flag
    output_ZeroFlag = 0; // Initialize zero flag
    output_NegativeFlag = 0; // Initialize negative flag

    case (input_Type) // Select ALU type
      2'b00: // Arithmetic operation
        case (input_Func) // Select arithmetic function
          5'b00000: output_Result = input_A & input_B; // Bitwise AND
          5'b00001:
            begin
              output_Result = input_A + input_B; // Addition
              if (output_Result < input_A) // Check for carry
                output_CarryFlag = 1;
            end
          5'b00010: output_Result = input_A - input_B; // Subtraction
          5'b00011: output_Result = input_A - input_B; // Subtraction
        endcase
      2'b01: // Logical operation
        case (input_Func) // Select logical function
          5'b00000: output_Result = input_A & input_B; // Bitwise AND
          5'b00001:
            begin
              output_Result = input_A + input_B; // Addition
              if (output_Result < input_A) // Check for carry
                output_CarryFlag = 1;
            end
          5'b00010:
            begin
              output_Result = input_A + input_B; // Addition
              if (output_Result < input_A) // Check for carry
                output_CarryFlag = 1;
            end
          5'b00011:
            begin
              output_Result = input_A + input_B; // Addition
              if (output_Result < input_A) // Check for carry
                output_CarryFlag = 1;
            end
          5'b00100: output_Result = input_A - input_B; // Subtraction
        endcase
      2'b10: // Comparison operation
        case (input_Func) // Select comparison function
          5'b00000:
            begin
              output_Result = input_A + input_B; // Addition
              if (output_Result < input_A) // Check for carry
                output_CarryFlag = 1;
            end
          5'b00001:
            begin
              output_Result = input_A + input_B; // Addition
              if (output_Result < input_A) // Check for carry
                output_CarryFlag = 1;
            end
        endcase
      2'b11: // Shift operation
        case (input_Func) // Select shift function
          5'b00000: output_Result = input_A << input_B; // Left shift
          5'b00001: output_Result = input_A >> input_B; // Right shift
          5'b00010: output_Result = input_A << input_B; // Left shift
          5'b00011: output_Result = input_A >> input_B; // Right shift
        endcase
    endcase

    if (output_Result == 0) // Check if result is zero
      output_ZeroFlag = 1;

    if (output_Result < 0) // Check if result is negative
      output_NegativeFlag = 1;
  end
endmodule
