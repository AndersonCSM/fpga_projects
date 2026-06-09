# Implementação de Processador RISC

Este diretório contém implementações genéricas em HDL baseadas no modelo Computador com Conjunto Reduzido de Instruções (RISC).

## Visão Geral

Este projeto explora arquiteturas RISC customizadas, com forte influência de modelos como o RISC-V, otimizadas para desenvolvimento em FPGA. O foco do design é a simplicidade, baixa utilização de recursos lógicos e clareza educacional no caminho de dados (datapath) de ciclo único.

## Index

- [32-Bit Architecture (`risc32`)](#32-bit-architecture-risc32)

---

## 32-Bit Architecture (`risc32`)

### Formato de Instrução
O formato de instrução é de tamanho fixo (32 bits), seguindo os padrões RISC clássicos para decodificação rápida e eficiente em hardware.

### Tipos de Instrução
- **Tipo R:** Operações aritméticas e lógicas entre registradores.
- **Tipo I:** Operações com imediatos curtos, loads e alguns desvios.
- **Tipo S/B:** Instruções de store e desvios condicionais.
- **Tipo J:** Desvios incondicionais (saltos).

### Operações
O conjunto de instruções base suporta:
- **Aritméticas e Lógicas:** `add`, `sub`, `and`, `or`, `slt`
- **Transferência de Memória:** `lw`, `sw`
- **Controle de Fluxo:** `beq`, `j`

### Arquivos de Implementação
A divisão modular do código em Verilog reflete as etapas do datapath:
- `program_counter.v`: Controlador do fluxo do programa.
- `instruction_memory.v`: Armazenamento de instruções (ROM).
- `data_memory.v`: Armazenamento de dados (RAM).
- `register_file.v`: Arquivo de registradores base da arquitetura.
- `alu_unit.v`: Unidade Lógica e Aritmética.
- `sign_extension.v`: Extensão de sinal.
- `control_unit.v` / `alu_control.v`: Unidades responsáveis pelo roteamento e controle de multiplexadores.
- `datapath.v` / `RISC.v`: Módulos integradores (Top-level).

### Testes
Os módulos de teste (testbenches) verificam a execução do datapath inteiro:
- Validação das instruções Tipo R e Tipo I.
- Validação do fluxo de controle (desvios).
- Teste funcional executando algoritmos como a sequência de Fibonacci.

### Arquivo Waveform
A simulação do RTL gera um arquivo `.vcd`, permitindo a visualização gráfica dos sinais internos do datapath em softwares como GTKWave.
