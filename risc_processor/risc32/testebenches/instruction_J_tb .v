`timescale 1ns / 1ps

module instruction_fibonacci_tb;
    reg clk;
    reg reset;
    
    // Instancia o módulo principal RISC passando o parâmetro para carregar o teste Fibonacci (teste = 4)
    RISC #(
        .teste(3)
    ) uut (
        .clk(clk),
        .reset(reset)
    );
    
    // Gera o clock com período de 2ns (frequência de 500MHz)
    always #1 clk = ~clk;
    
    initial begin
        // Inicialização
        clk = 0;
        reset = 0;
        
        // Mantém reset por 1ns e então libera
        #1 reset = 1;
        
        // Simula por tempo suficiente para rodar o loop de fibonacci
        // O loop roda 31 vezes. Cada iteração possui algumas instruções.
        #2000;

        $finish;
    end

    // Gera arquivo VCD para visualização no GTKWave
    initial begin
        $dumpfile("waveforms/teste_j.vcd");
        $dumpvars(0, instruction_fibonacci_tb);
    end
    
    // Monitor opcional para acompanhar os valores sendo calculados
    initial begin
        $monitor("Time=%0t | PC=%d | ALU Result=%d | MemData=%d | Zero=%b", 
                 $time, 
                 uut.dp.instruction_fetch.program_counter.PC,
                 uut.dp.alu_unit.result,
                 uut.dp.data_memory.read_data,
                 uut.dp.alu_unit.zero);
    end

endmodule
