module sign_extension(
    input [15:0] input_16,
    
    output [31:0] output_32
    );
    
    // extende o sinal preservando o valor numérico
    assign output_32 = (input_16[15] == 1'b1)? {{16{1'b1}},input_16} :{{16{1'b0}},input_16};
     
endmodule