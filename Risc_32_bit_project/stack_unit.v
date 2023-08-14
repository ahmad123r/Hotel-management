module Stack_unit( 
    input clk,
    input wire stack_push,
    input wire [31:0] data_input,
    output reg [31:0] data_output,
    output reg is_empty = 1'b1,
    output reg is_full = 1'b0,
    input wire stack_pop
);
    localparam STACK_DEPTH = 4'b1111; // Parameter representing the depth of the stack (number of entries)

    reg [31:0] stack_memory [3:0]; // Array representing the stack memory with 4 entries
    reg [3:0] stack_pointer = 4'b0000; // Register holding the current stack pointer value
    reg empty_status = 1; // Status flag indicating if the stack is empty (initialized as empty)
    reg full_status = 0; // Status flag indicating if the stack is full (initialized as not full)

    always @(posedge clk) begin
        if (stack_push && !full_status) begin // If stack_push signal is high and the stack is not full
            stack_memory[stack_pointer] <= data_input; // Store the data_input in the stack memory at the current stack pointer
            stack_pointer <= stack_pointer + 4'b0001; // Increment the stack pointer by 1
        end
        if (stack_pop && !empty_status) begin // If stack_pop signal is high and the stack is not empty
            stack_pointer <= stack_pointer - 4'b0001; // Decrement the stack pointer by 1
        end

        if (stack_pointer == 4'b0000) begin // If the stack pointer is at the bottom (empty)
            is_empty <= 1'b1; // Set the is_empty flag to indicate that the stack is empty
            is_full <= 1'b0; // Clear the is_full flag
        end else if (stack_pointer == STACK_DEPTH) begin // If the stack pointer is at the top (full)
            is_full <= 1'b1; // Set the is_full flag to indicate that the stack is full
            is_empty <= 1'b0; // Clear the is_empty flag
        end else begin // If the stack pointer is neither at the top nor at the bottom
            is_full <= 1'b0; // Clear the is_full flag
            is_empty <= 1'b0; // Clear the is_empty flag
        end
    end

    always @(stack_pointer) begin
        if (stack_pointer == 4'b0000) begin // If the stack pointer is at the bottom (empty)
            empty_status <= 1'b1; // Set the empty_status flag to indicate that the stack is empty
            full_status <= 1'b0; // Clear the full_status flag
        end else if (stack_pointer == STACK_DEPTH) begin // If the stack pointer is at the top (full)
            full_status <= 1'b1; // Set the full_status flag to indicate that the stack is full
            empty_status <= 1'b0; // Clear the empty_status flag
        end else begin // If the stack pointer is neither at the top nor at the bottom
            full_status <= 1'b0; // Clear the full_status flag
            empty_status <= 1'b0; // Clear the empty_status flag
        end
    end

    always @(stack_pointer or is_empty) begin
        if (!is_empty) begin // If the stack is not empty
            data_output <= stack_memory[stack_pointer - 4'b0001]; // Assign the data from the stack memory at the previous stack pointer position to the data_output
        end
    end
endmodule
