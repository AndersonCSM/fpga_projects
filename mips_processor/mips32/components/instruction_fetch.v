module instruction_fetch(
    input reset,clk,zero,branch,jump,
    input [31:0] offset,

    output [31:0] instruction
    );
    
    wire [31:0] JTA, BTA, PC_plus_4;
    wire [31:0] PC_address, Actual_PC_Address, Branch_Address;

    // Registrador PC (apenas armazena o valor)
    program_counter program_counter(
        .clk(clk),
        .reset(reset),
        .PC_next(Actual_PC_Address),
        .PC(PC_address)
    );

    // Somador PC + 4
    assign PC_plus_4 = PC_address + 32'd4;

    // instantiate memory
    instruction_memory instruction_memory(
        .address(PC_address),
        .reset(reset),
        .instruction(instruction)
    );
    
    // Calculate BTA
    assign BTA = PC_plus_4 + (offset << 2);
    
    // Calculate JTA
    assign JTA = {PC_plus_4[31:28], {instruction[25:0], 2'b00}};
    
    // Branch MUX
    assign Branch_Address = (zero & branch)? BTA : PC_plus_4;
    
    // Jump MUX
    assign Actual_PC_Address = jump? JTA : Branch_Address;
   
endmodule