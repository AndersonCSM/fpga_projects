module register_file(
    input [4:0] register_read_1,
    input [4:0] register_read_2,
    input [4:0] write_register,

    input [31:0] write_data,

    input reg_write, reg_clk, reset,

    output [31:0] read_data_1,
    output [31:0] read_data_2
);

reg [31:0] Registers [31:0];

integer i;
initial begin
    for (i = 0; i < 32; i = i + 1) begin
        Registers[i] = 32'h00000000;
    end
end

assign read_data_1 = (!reset)? 32'h00000000  : Registers[register_read_1];
assign read_data_2 = (!reset)? 32'h00000000  : Registers[register_read_2];

// Debug wires to make them visible in GTKWave (Icarus Verilog doesn't dump memory arrays by default)
wire [31:0] debug_r0 = Registers[0];
wire [31:0] debug_r1 = Registers[1];
wire [31:0] debug_r5 = Registers[5];

always @(posedge reg_clk) begin
    // $display("Writing to register %d: %d, %d", write_register, write_data,reg_write);
    
    if( reg_write == 1'b1 ) begin
        Registers[write_register] <= write_data;
    end
end

endmodule