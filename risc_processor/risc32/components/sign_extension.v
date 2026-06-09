module sign_extension(
    input [31:0] instruction,
    input [1:0] ImmSrc,
    output reg [31:0] output_32
);
    
    always @(*) begin
        case (ImmSrc)
            // I-Type Immediate (Load, Addi)
            // Extrai bit de sinal [31] estendido, e o imediato [31:20]
            2'b00: output_32 = {{20{instruction[31]}}, instruction[31:20]};
            
            // S-Type e B-Type Immediate (Store, Branch)
            // Simplificado (linear) como solicitado pelo formato da imagem.
            // Extrai sinal [31] estendido, e o imediato separado [31:25] e [11:7]
            2'b01: output_32 = {{20{instruction[31]}}, instruction[31:25], instruction[11:7]};
            
            // J-Type Immediate (Jump)
            // Simplificado, pegando do bit 31 ao 12
            2'b10: output_32 = {{12{instruction[31]}}, instruction[31:12]};
            
            default: output_32 = 32'd0;
        endcase
    end

endmodule