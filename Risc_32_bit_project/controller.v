module controller (
    input wire input_clock,                       // Input clock signal
    input wire [4:0] function_input,               // Input for function
    input wire [1:0] function_type_input,          // Input for function type
    input wire stop_signal,                        // Stop signal input
    input wire empty_s11,                          // Empty signal input for S11
    input wire full_s11,                           // Full signal input for S11
    input wire negative,                           // Negative signal input
    input wire zero_in,                            // Zero signal input
    input wire carry,                              // Carry signal input
    output reg pc_write,                           // Program counter write output
    output reg memory_read,                        // Memory read output
    output reg memory_write,                       // Memory write output
    output reg memory_to_register,                 // Memory to register output
    output reg instruction_register_write,         // Instruction register write output
    output reg read_data_reg_2,                    // Read data register 2 output
    output reg zero_out,                           // Zero signal output
    output reg pop,                                // Pop signal output
    output reg push,                               // Push signal output
    output reg [1:0] next_pc_source,                // Next program counter source output
    output reg [1:0] function_type_out,             // Function type output
    output reg [4:0] function_out,                  // Function output
    output reg [1:0] operandB_src,                   // Operand B source output
    output reg operandA_src,                        // Operand A source output
    output reg register_write,                      // Register write output
    output reg sign_extend_src,                      // Sign extend source output
    output reg registerA_enable,                       // Register A enable output
    output reg registerB_enable                        // Register B enable output
);
    parameter AND = 7'b0000000,                     // Parameter for AND function
              ADD = 7'b0000001,                     // Parameter for ADD function
              SUB = 7'b0000010,                     // Parameter for SUB function
              CMP = 7'b0000011,                     // Parameter for CMP function
              ANDI = 7'b0100000,                    // Parameter for ANDI function
              ADDI = 7'b0100001,                    // Parameter for ADDI function
              LW = 7'b0100010,                      // Parameter for LW function
              SW = 7'b0100011,                      // Parameter for SW function
              BEQ = 7'b0100100,                     // Parameter for BEQ function
              J = 7'b1000000,                       // Parameter for J function
              JAL = 7'b1000001,                     // Parameter for JAL function
              SLL = 7'b1100000,                     // Parameter for SLL function
              SLR = 7'b1100001,                     // Parameter for SLR function
              SLLV = 7'b1100010,                    // Parameter for SLLV function
              SLRV = 7'b1100011;                    // Parameter for SLRV function
	reg [6:0] operand;                               // Operand register
	reg [3:0] state = 10;                             // State register
	parameter s0 = 0,                                 // State s0
	          s1 = 1,                                 // State s1
	          s2 = 2,                                 // State s2
	          s3 = 3,                                 // State s3
	          s4 = 4,                                 // State s4
	          s5 = 5,                                 // State s5
	          s6 = 6,                                 // State s6
	          s7 = 7,                                 // State s7
	          s8 = 8,                                 // State s8
	          s9 = 9,                                 // State s9
	          s10 = 10,                               // State s10
	          s11 = 11;                               // State s11
	always @(posedge input_clock)
	begin			 
		zero_out <= zero_in;                                    // Set zero_out to zero_in
		case(state)
			s10: begin                                          // State s10
				next_pc_source <= 2'b10;                         // Set next_pc_source to 2'b10
				pop <= 0;                                       // Set pop to 0
				state <= s0;                                    // Move to state s0
			end
			s0:begin                                             // State s0
				pc_write <= 1;                                  // Set pc_write to 1
				memory_write <= 0;                              // Set memory_write to 0
				instruction_register_write <= 1;                // Set instruction_register_write to 1
				push <= 0;                                      // Set push to 0
				if(stop_signal == 1)                            // If stop_signal is 1
				begin
					pop <= 1;                                   // Set pop to 1
				end
				else
				begin
					pop <= 0;                                   // Set pop to 0
				end
				register_write <= 0;                            // Set register_write to 0
				state <= s1;                                    // Move to state s1
			end							 
			s1: begin                                           // State s1
				pc_write <= 0;                                  // Set pc_write to 0
				pop <= stop_signal;                             // Set pop to stop_signal
				instruction_register_write <= 0;                // Set instruction_register_write to 0
				operand = {function_type_input, function_input}; // Concatenate function_type_input and function_input and assign it to operand
				state <= s3;                                    // Move to state s3
				registerA_enable <= 1;                          // Set registerA_enable to 1
				registerB_enable <= 1;                          // Set registerB_enable to 1
			end							   
			s3: begin                                           // State s3
				operand = {function_type_input, function_input}; // Concatenate function_type_input and function_input and assign it to operand
				case (operand)
    // R-Type instructions
    AND: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        read_data_reg_2 <= 0;                      // Read data register 2 output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b00;                // Function type output is set to 2'b00
        function_out <= 5'b00000;                  // Function output is set to 5'b00000
        operandB_src <= 2'b00;                     // Operand B source output is set to 2'b00
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    ADD: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        read_data_reg_2 <= 0;                      // Read data register 2 output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b00;                // Function type output is set to 2'b00
        function_out <= 5'b00001;                  // Function output is set to 5'b00001
        operandB_src <= 2'b00;                     // Operand B source output is set to 2'b00
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    SUB: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        read_data_reg_2 <= 0;                      // Read data register 2 output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b00;                // Function type output is set to 2'b00
        function_out <= 5'b00010;                  // Function output is set to 5'b00010
        operandB_src <= 2'b00;                     // Operand B source output is set to 2'b00
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    CMP: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        read_data_reg_2 <= 0;                      // Read data register 2 output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b00;                // Function type output is set to 2'b00
        function_out <= 5'b00011;                  // Function output is set to 5'b00011
        operandB_src <= 2'b00;                     // Operand B source output is set to 2'b00
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    // I-Type instructions
    ANDI: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b01;                // Function type output is set to 2'b01
        function_out <= 5'b00000;                  // Function output is set to 5'b00000
        operandB_src <= 2'b11;                     // Operand B source output is set to 2'b11
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        sign_extend_src <= 1;                       // Sign extend source output is set to 1
        state <= s2;                               // Move to state s2
    end
    ADDI: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b01;                // Function type output is set to 2'b01
        function_out <= 5'b00001;                  // Function output is set to 5'b00001
        operandB_src <= 2'b11;                     // Operand B source output is set to 2'b11
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        sign_extend_src <= 0;                       // Sign extend source output is set to 0
        state <= s2;                               // Move to state s2
    end
    LW: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 1;                          // Memory read output is set to 1
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 0;                   // Memory to register output is set to 0
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b01;                // Function type output is set to 2'b01
        function_out <= 5'b00010;                  // Function output is set to 5'b00010
        operandB_src <= 2'b11;                     // Operand B source output is set to 2'b11
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        sign_extend_src <= 0;                       // Sign extend source output is set to 0
        state <= s2;                               // Move to state s2
    end
    SW: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 1;                         // Memory write output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        read_data_reg_2 <= 1;                      // Read data register 2 output is set to 1
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b01;                // Function type output is set to 2'b01
        function_out <= 5'b00011;                  // Function output is set to 5'b00011
        operandB_src <= 2'b11;                     // Operand B source output is set to 2'b11
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        sign_extend_src <= 0;                       // Sign extend source output is set to 0
        state <= s2;                               // Move to state s2
    end
    BEQ: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        read_data_reg_2 <= 1;                      // Read data register 2 output is set to 1
        next_pc_source <= 2'b11;                   // Next program counter source output is set to 2'b11
        function_type_out <= 2'b01;                // Function type output is set to 2'b01
        function_out <= 5'b00100;                  // Function output is set to 5'b00100
        operandB_src <= 2'b00;                     // Operand B source output is set to 2'b00
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        sign_extend_src <= 0;                       // Sign extend source output is set to 0
        state <= s2;                               // Move to state s2
    end
    // J-Type instructions
    J: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 0;                   // Memory to register output is set to 0
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        next_pc_source <= 2'b00;                   // Next program counter source output is set to 2'b00
        function_type_out <= 2'b10;                // Function type output is set to 2'b10
        function_out <= 5'b00000;                  // Function output is set to 5'b00000
        operandB_src <= 2'b01;                     // Operand B source output is set to 2'b01
        operandA_src <= 0;                         // Operand A source output is set to 0
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    JAL: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 0;                   // Memory to register output is set to 0
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        next_pc_source <= 2'b00;                   // Next program counter source output is set to 2'b00
        function_type_out <= 2'b10;                // Function type output is set to 2'b10
        function_out <= 5'b00001;                  // Function output is set to 5'b00001
        operandB_src <= 2'b01;                     // Operand B source output is set to 2'b01
        operandA_src <= 0;                         // Operand A source output is set to 0
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    // S-Type instructions
    SLL: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b11;                // Function type output is set to 2'b11
        function_out <= 5'b00000;                  // Function output is set to 5'b00000
        operandB_src <= 2'b10;                     // Operand B source output is set to 2'b10
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    SLR: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b11;                // Function type output is set to 2'b11
        function_out <= 5'b00001;                  // Function output is set to 5'b00001
        operandB_src <= 2'b10;                     // Operand B source output is set to 2'b10
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    SLLV: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        read_data_reg_2 <= 0;                      // Read data register 2 output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b11;                // Function type output is set to 2'b11
        function_out <= 5'b00010;                  // Function output is set to 5'b00010
        operandB_src <= 2'b00;                     // Operand B source output is set to 2'b00
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
    SLRV: begin
        pc_write <= 0;                            // Program counter write output is set to 0
        memory_read <= 0;                          // Memory read output is set to 0
        memory_write <= 0;                         // Memory write output is set to 0
        memory_to_register <= 1;                   // Memory to register output is set to 1
        instruction_register_write <= 0;           // Instruction register write output is set to 0
        read_data_reg_2 <= 0;                      // Read data register 2 output is set to 0
        next_pc_source <= 2'b10;                   // Next program counter source output is set to 2'b10
        function_type_out <= 2'b11;                // Function type output is set to 2'b11
        function_out <= 5'b00011;                  // Function output is set to 5'b00011
        operandB_src <= 2'b00;                     // Operand B source output is set to 2'b00
        operandA_src <= 1;                         // Operand A source output is set to 1
        register_write <= 0;                       // Register write output is set to 0
        state <= s2;                               // Move to state s2
    end
endcase	
end

			s2: begin
				registerA_enable <= 0;		  		// Disable writing for reg A and B
				registerB_enable <= 0;					  
				// Move to state s5
				state <= s5;
			end
			s5: begin
				case (operand)
					AND: begin
						state <= s8;							  // Complete the rest of the states accordingly
					end
					ADD: begin
						state <= s8;
					end
					SUB: begin
						state <= s8;
					end
					CMP: begin
						state <= s0;
					end
					ANDI: begin
						state <= s8;
					end
					ADDI: begin
						state <= s8;
					end
					LW: begin
						state <= s7;
					end
					SW: begin
						state <= s7;
					end
					BEQ: begin
						state <= s0;
					end
					J: begin
						state <= s0;
					end
					JAL: begin
						push <= 1;
						state <= s11;
					end
					SLL: begin
						state <= s8;
					end
					SLR: begin
						state <= s8;
					end
					SLLV: begin
						state <= s8;
					end
					SLRV: begin
						state <= s8;
					end
				endcase
			end
			s7: begin
				registerA_enable <= 0;
				registerB_enable <= 0;
				case(operand)
					LW: begin
						state <= s8;
					end
					SW: begin
						state <= s0;
					end
				endcase
			end
			s8: begin
				register_write <= 1;
				state <= s9;
			end
			s9: begin
				register_write <= 1;
				registerA_enable <= 0;
				registerB_enable <= 0;
				state <= s0;
			end
			s11: begin
				pop <= stop_signal;
				push <= 0;
				state <= s0;
			end
		endcase	 
	end
endmodule
