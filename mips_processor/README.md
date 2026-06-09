# Implementação de Processador MIPS

Este diretório contém as implementações em HDL da arquitetura de conjunto de instruções MIPS (Microprocessor without Interlocked Pipeline Stages).

## Visão Geral

A arquitetura MIPS é um design clássico de Computador com Conjunto Reduzido de Instruções (RISC), amplamente utilizado em ambientes acadêmicos e de hardware embarcado. Este projeto tem como objetivo fornecer núcleos sintetizáveis para uso em FPGA.

## Index

- [32-Bit Architecture (`mips32`)](#32-bit-architecture-mips32)
---

## 32-Bit Architecture (`mips32`)

### Formato de Instrução
As instruções MIPS de 32 bits possuem tamanho fixo de 32 bits e seguem formatos predefinidos para facilitar a decodificação no datapath de ciclo único.

### Tipos de Instrução
- **Tipo R (Register):** Instruções aritméticas e lógicas que operam exclusivamente com registradores.
- **Tipo I (Immediate):** Instruções de transferência de dados (memória) e desvios condicionais utilizando um valor imediato de 16 bits.
- **Tipo J (Jump):** Instruções de desvio incondicional.

### Operações
O processador suporta as seguintes operações básicas:
- **Aritméticas e Lógicas:** `add`, `sub`, `and`, `or`, `slt`
- **Transferência de Dados:** `lw` (load word), `sw` (store word)
- **Desvios:** `beq` (branch on equal), `j` (jump)

### Arquivos de Implementação
O datapath de ciclo único é modularizado nos seguintes arquivos Verilog:
- `program_counter.v`: Contador de programa (PC).
- `instruction_fetch.v` / `instruction_memory.v`: Busca de instruções e memória ROM.
- `data_memory.v`: Memória de dados RAM.
- `register_file.v`: Arquivo de registradores (32x32 bits).
- `alu_unit.v`: Unidade Lógica e Aritmética (ULA/ALU).
- `sign_extension.v`: Extensor de sinal de 16 para 32 bits.
- `control_unit.v` e `alu_control.v`: Unidades de controle principal e da ALU.
- `datapath.v` e `RISC.v`: Módulos de topo estruturando o caminho de dados.

### Testes
Os testbenches validam o funcionamento das instruções isoladas e em conjunto:
- Testes individuais para os formatos R e I (`add`, `sub`, `lw`, `sw`).
- Testes de desvio condicional e incondicional (`beq`, `j`).
- Teste de integração utilizando a sequência de Fibonacci em Assembly.

### Arquivo Waveform
O resultado das simulações de testbench é exportado para um arquivo de forma de onda (waveform) com extensão `.vcd`, que pode ser analisado visualmente utilizando o software GTKWave.
