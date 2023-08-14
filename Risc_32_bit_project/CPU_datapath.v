module datapath(
    input wire sysClk
);

    // Input and output wires
    wire [31:0] PCPlusOne; // Output: Next value of Program Counter (PC) incremented by one
    wire [4:0] FCode; // Output: Functional code extracted from instruction
    wire [4:0] RDest; // Output: Destination register extracted from instruction
    wire [31:0] instr; // Output: Current instruction fetched from Program Memory
    wire [31:0] MemOutput; // Output: Data read from Memory
    wire [13:0] immediate; // Output: Immediate value extracted from instruction
    wire [4:0] RSource1; // Output: Source register 1 extracted from instruction
    wire [31:0] PCRegOutput; // Output: Value of Program Counter (PC) from PC_Register
    wire [31:0] wrData; // Output: Data to be written to Memory or Register file
    wire stopSignal; // Output: Stop signal indicating end of program execution
    wire [1:0] InstrType; // Output: Instruction type extracted from instruction
    wire [31:0] signedExt; // Output: Sign-extended immediate value
    wire [31:0] readDataSecond; // Output: Data read from Register file (source 2)
    wire [31:0] registerA; // Output: Data from Register file (source 1)
    wire [1:0] ALUSourceB; // Output: Source B for ALU operation
    wire [31:0] readDataFirst; // Output: Data read from Register file (source 1)
    wire [4:0] RSource2; // Output: Source register 2 extracted from instruction
    wire [31:0] JumpImmediate; // Output: Immediate value for jump instruction
    wire [4:0] readReg2; // Output: Source register 2 for Register file read
    wire [31:0] operandSecond; // Output: Second operand for ALU operation
    wire [31:0] unsignedExt; // Output: Zero-extended immediate value
    wire [31:0] memRegOutput; // Output: Data read from Memory or Register file
    wire [31:0] registerB; // Output: Data from Register file (source 2)
    wire [31:0] computationResult; // Output: Result of ALU operation
    wire [31:0] ShiftAmt; // Output: Shift amount for shift instruction
    wire [31:0] operandFirst; // Output: First operand for ALU operation
    wire [31:0] branchPCVal; // Output: Target PC value for branch instruction
    wire [31:0] branchAddr; // Output: Computed branch address
    wire [4:0] FCodeOutput; // Output: Functional code output from ALU operation
    wire stackPopSignal; // Output: Signal indicating stack pop operation
    wire [31:0] extended; // Output: Immediate value after extension
    wire zeroCheck; // Output: Signal indicating zero condition
    wire negativeCheck; // Output: Signal indicating negative condition
    wire [31:0] nextPCVal; // Output: Next value of Program Counter (PC)
    wire isStackFull; // Output: Signal indicating stack is full
    wire carryCheck; // Output: Signal indicating carry condition
    wire [31:0] targetPC; // Output: Target value for PC
    wire [31:0] stackOutput; // Output: Data read from Stack memory
    wire [31:0] ALUOutput; // Output: Result of ALU operation
    wire zeroOutCheck; // Output: Signal indicating zero output condition
    wire stackPushSignal; // Output: Signal indicating stack push operation
    wire ReadReg2Source; // Output: Signal indicating source of ReadReg2
    wire isStackEmpty; // Output: Signal indicating stack is empty
    wire [1:0] PCSourceChoice; // Output: Choice for Program Counter (PC) source
    wire PCWriteSignal; // Output: Signal to write to Program Counter (PC)
    wire [1:0] InstrTypeOutput; // Output: Instruction type output from ALU operation
    wire MemToRegSignal; // Output: Signal indicating Memory-to-Register operation
    wire RegWriteSignal; // Output: Signal indicating Register write operation
    wire ALUSourceA; // Output: Source A for ALU operation
    wire MemReadSignal; // Output: Signal indicating Memory read operation
    wire InstrWriteSignal; // Output: Signal to write to Instruction Register (IR)
    wire regWriteASignal; // Output: Signal indicating Register A write operation
    wire regWriteBSignal; // Output: Signal indicating Register B write operation
    wire MemWriteSignal; // Output: Signal indicating Memory write operation
    wire ExtensionSource; // Output: Source for immediate extension

    // Instantiate the modules and connect the wires
    ProgramMemory b1(PCRegOutput, instr, PCPlusOne); // Program Memory module for instruction fetch
    selector_2x1 b7(RSource2, RDest, ReadReg2Source, readReg2); // 2x1 Selector for source register 2
    selector_2x1 b5(memRegOutput, ALUOutput, MemToRegSignal, wrData); // 2x1 Selector for Memory or Register data
    immediate_to_dest b6(immediate, RSource2); // Immediate to Destination register conversion
    RAM b2(sysClk, ALUOutput, registerB, MemReadSignal, MemWriteSignal, MemOutput); // Random Access Memory module
    Instr_Reg b3(sysClk, InstrWriteSignal, instr, FCode, RSource1, RDest, immediate, InstrType, stopSignal); // Instruction Register module
    Register_B b14(regWriteBSignal, readDataSecond, registerB); // Register B module
    PC_Register b0(sysClk, nextPCVal, PCRegOutput, PCWriteSignal); // Program Counter Register module
    Register_file b8(sysClk, RegWriteSignal, RSource1, readReg2, RDest, wrData, readDataFirst, readDataSecond); // Register file module
    data_memory_reg b4(sysClk, MemOutput, memRegOutput); // Data Memory Register module
    selector_2x1 b12(signedExt, unsignedExt, ExtensionSource, extended); // 2x1 Selector for immediate extension
    immediate_gen b9(RSource1, RDest, immediate, JumpImmediate); // Immediate generation module
    Unsigned_Extender b11(immediate, unsignedExt); // Unsigned Extender module
    SAExtend b13(immediate, ShiftAmt); // Sign-Extended Extend module
    Sign_Extender b10(immediate, signedExt); // Sign Extender module
    selector_2x1 b16(PCRegOutput, registerA, ALUSourceA, operandFirst); // 2x1 Selector for source register 1
    add0 b19(PCPlusOne, immediate, branchAddr); // Adder module for branch address computation
    component_alu b18(operandFirst, operandSecond, InstrTypeOutput, FCodeOutput, computationResult, zeroCheck, carryCheck, negativeCheck); // ALU module
    Register_A b15(regWriteASignal, readDataFirst, registerA); // Register A module
    selector_2x1 b20(PCPlusOne, branchAddr, zeroOutCheck, branchPCVal); // 2x1 Selector for branch PC value
    controller b25(sysClk, FCode, InstrType, stopSignal, isStackEmpty, isStackFull, negativeCheck, zeroCheck, carryCheck, PCWriteSignal, MemReadSignal, MemWriteSignal, MemToRegSignal, InstrWriteSignal, ReadReg2Source, zeroOutCheck, stackPopSignal, stackPushSignal, PCSourceChoice, InstrTypeOutput, FCodeOutput, ALUSourceB, ALUSourceA, RegWriteSignal, ExtensionSource, regWriteASignal, regWriteBSignal); // Controller module
    selector_4x1 b23(computationResult, ALUOutput, PCPlusOne, branchPCVal, PCSourceChoice, targetPC); // 4x1 Selector for PC source choice
    alu_result_register b21(sysClk, computationResult, ALUOutput); // ALU Result Register module
    selector_2x1 b24(targetPC, stackOutput, stackPopSignal, nextPCVal); // 2x1 Selector for next PC value
    Stack_unit b22(sysClk, stackPushSignal, PCPlusOne, stackOutput, isStackEmpty, isStackFull, stackPopSignal); // Stack unit module
    selector_4x1 b17(registerB, JumpImmediate, ShiftAmt, extended, ALUSourceB, operandSecond); // 4x1 Selector for ALU source B
endmodule
