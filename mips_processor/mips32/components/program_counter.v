module program_counter (
    input clk,
    input reset,
    input [31:0] PC_next,         // endereço calculado pela lógica externa (MUXes)
    
    output reg [31:0] PC          // PC atual
);
    // Bloco sequencial: apenas armazena o próximo valor do PC
    always @(posedge clk) begin
        if (!reset)
            PC <= 32'h0000_0000;
        else
            PC <= PC_next;
    end
endmodule