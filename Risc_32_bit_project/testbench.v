`timescale 1ns / 1ps

module datapath_tb;

    // Inputs
    reg clk;	 

    // Instantiate the Unit Under Test (UUT)
    datapath uut (
	.sysClk(clk)
    );	
	

    always
    #10 clk = ~clk; 

    initial begin
        // Initialize Inputs
        clk = 0;
		
		#5
		clk = 0; 
		
		#2000
		$finish;
    end	
	always @(negedge clk) begin
		if(uut.stopSignal == 1 & uut.isStackEmpty == 1)
			begin  		  
				#150ns
				$finish;
			end
	end
	

endmodule
