`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 11/27/2024 06:05:13 PM
// Design Name: 
// Module Name: register_file_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module register_file_tb;

    // Inputs
    reg [4:0] register_read_1, register_read_2, write_register, address, address2;
    reg reg_write, clk, reset;
    reg [31:0] write_data;

    // Outputs
    wire [31:0] read_data_1, read_data_2;

    // Instantiate the Unit Under Test (UUT)
    register_file uut (
        .register_read_1(register_read_1),
        .register_read_2(register_read_2),
        .write_register(write_register),
        .write_data(write_data),
        .reg_write(reg_write),
        .clk(clk),
        .reset(reset),
        .read_data_1(read_data_1),
        .read_data_2(read_data_2)
    );

    integer i;

    // Initialize values
    initial begin
        // Initialize inputs
        clk = 0;
        reset = 1;
        reg_write = 0;
        address = 0;
        address2 = 0;

        // Apply reset pulse
        #5 reset = 0; // Assert reset
        #20 reset = 1; // Deassert reset

        // Write zero to all registers (if not handled by reset in module)
        for (i = 0; i < 32; i = i + 1) begin
            uut.Registers[i] = 32'h00000000; // Optional if reset logic is implemented
        end

        // Write to registers
        for (i = 0; i < 5; i = i + 1) begin
            write_register = i;
            write_data = i * 10; // Example data
            reg_write = 1;
            #10; // Wait for a clock cycle
        end
        reg_write = 0; // Disable write

        // Read from reg    isters
        for (i = 0; i < 5; i = i + 1) begin
            register_read_1 = i;
            register_read_2 = 4 - i;
            #10; // Wait for a clock cycle
        end

        // End simulation
        #100;
        
    end

    // Clock generation
    always #5 clk = ~clk;

endmodule
