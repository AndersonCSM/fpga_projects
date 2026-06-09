module alu_control( 
     input   [1:0] ALUop,
     input   [2:0] funct3,
     input   [6:0] funct7,
     
     output  reg [2:0] ALUoperation
);

    always @(*) begin 
        casex (ALUop)
            2'b00 : begin // lw, sw, addi
                ALUoperation = 3'b010; // add
            end
          
            2'b01 : begin // beq
                ALUoperation = 3'b110; // subtract
            end
          
            2'b10 : begin // R-type
                case (funct3)
                    3'b000 : begin
                        if (funct7[5] == 1'b1)
                            ALUoperation = 3'b110; // sub
                        else
                            ALUoperation = 3'b010; // add
                    end  
                    
                    3'b111 : begin
                        ALUoperation = 3'b000; // and
                    end  
                    
                    3'b110 : begin
                        ALUoperation = 3'b001; // or
                    end  
                    
                    3'b010 : begin
                        ALUoperation = 3'b111; // set less than (slt)
                    end 
                    
                    default : ALUoperation = 3'bxxx;
                endcase
            end
         
            default : ALUoperation = 3'bxxx;

        endcase
    end
    
endmodule