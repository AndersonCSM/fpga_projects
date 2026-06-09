module data_memory(
    input [31:0] address,
    input [31:0] write_data,

    input mem_read, clk,
    input mem_write,

    output [31:0] read_data
);

reg [31:0] Memory [1024:0]; // 1024 * 32 = 32768 Bits = 4.096 KB

assign read_data = (mem_read) ? Memory[address[31:2]] : 32'h00000000;

always @(posedge clk) begin
    if (mem_write) begin
        Memory[address[31:2]] <= write_data;
    end
end

endmodule