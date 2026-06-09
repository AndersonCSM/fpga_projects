module control_unit(
     input    [6:0] opcode,
      
     output  reg    RegWrite,  
     output  reg    MemToReg, 
     output  reg  [1:0] ImmSrc,
     output  reg    ALUsrc,  
     output  reg    branch,   
     output  reg    jump, 
     output  reg    memWrite,  
     output  reg    memRead,
     output  reg  [1:0] ALUop
);

     always @(*) begin 
          case (opcode)
               7'b0110011 : begin // R_Type instruction
                    RegWrite = 1;  
                    MemToReg = 0; 
                    ImmSrc = 2'bxx; 
                    ALUsrc = 0;  
                    branch = 0;    
                    memWrite = 0;  
                    ALUop = 2'b10;  
                    memRead = 0;  
                    jump = 0;
               end 
              
               7'b0010011 : begin  // I-Type arithmetic (addi)
                    RegWrite = 1;  
                    MemToReg = 0; 
                    ImmSrc = 2'b00; 
                    ALUsrc = 1;  
                    branch = 0;    
                    memWrite = 0;  
                    ALUop = 2'b00;  
                    memRead = 0;  
                    jump = 0;
               end 
               
               7'b0000011 : begin  // load (lw) instruction
                    RegWrite = 1;  
                    MemToReg = 1; 
                    ImmSrc = 2'b00; 
                    ALUsrc = 1;  
                    branch = 0;    
                    memWrite = 0;  
                    ALUop = 2'b00;  
                    memRead = 1;  
                    jump = 0;
               end 
              
               7'b0100011 : begin  // store (sw) instruction
                    RegWrite = 0;  
                    MemToReg = 1'bx; 
                    ImmSrc = 2'b01; 
                    ALUsrc = 1;  
                    branch = 0;    
                    memWrite = 1;  
                    ALUop = 2'b00;  
                    memRead = 0;  
                    jump = 0;
               end 
              
               7'b1100011 : begin  // beq instruction
                    RegWrite = 0;  
                    MemToReg = 1'bx; 
                    ImmSrc = 2'b01; 
                    ALUsrc = 0;  
                    branch = 1;    
                    memWrite = 0;  
                    ALUop = 2'b01;  
                    memRead = 0;  
                    jump = 0;
               end 
            
               7'b1101111 : begin  // jump instruction (jal)
                    RegWrite = 0;  
                    MemToReg = 1'bx; 
                    ImmSrc = 2'b10; 
                    ALUsrc = 1'bx;  
                    branch = 0;    
                    memWrite = 0;  
                    ALUop = 2'bxx;  
                    memRead = 0;  
                    jump = 1;
               end 
            
               default : begin
                    RegWrite = 0;  
                    MemToReg = 1'bx; 
                    ImmSrc = 2'bxx; 
                    ALUsrc = 1'bx;  
                    branch = 0;    
                    memWrite = 0;  
                    ALUop = 2'bxx;  
                    memRead = 0;  
                    jump = 0;
               end
          endcase
     end
     
endmodule