# Tang Nano on Linux — Complete Guide

Installation and configuration guide for the `oss-cad-suite` toolchain for FPGA development with Tang Nano on Linux.

**Platforms:** Tang Nano 1K, 20K and variants  
**Toolchain:** `oss-cad-suite` (Yosys, nextpnr, openFPGALoader)  
**Support:** Linux (Ubuntu 20.04+, Debian, Fedora, etc.)

---

## Index

1. [Overview](#overview)
2. [Prerequisites](#prerequisites)
3. [Installing oss-cad-suite](#installing-oss-cad-suite)
4. [Configuring Environment Variables](#configuring-environment-variables)
5. [Installing OpenFPGALoader](#installing-openfpgaloader)
6. [USB/Driver Configuration](#usbdriver-configuration)
7. [Verifying Installation](#verifying-installation)
8. [Basic Usage](#basic-usage)
9. [Troubleshooting](#troubleshooting)

---

## Overview

To work with **Tang Nano** on Linux, you need:

| Tool | Function |
|------------|--------|
| **oss-cad-suite** | Synthesis, Place & Route, Bitstream (Yosys + nextpnr) |
| **openFPGALoader** | FPGA programmer via USB/JTAG |
| **USB Drivers** | Communication with FPGA |

### Recommended Layout

```bash
/home/tools/
  oss-cad-suite/        # Global installation (shared)
    bin/
    lib/
    share/

hdl/
  tang_nano_1k/
    blink/              # Projects
    teste/
  tang_nano_20k/
```

---

## Prerequisites

- **Linux:** Ubuntu 20.04 LTS or later (recommended)
- **Disk space:** ≥ 5 GB
- **Internet access:** For downloading toolchains
- **Root/sudo access:** For global installation

### System Dependencies

#### Ubuntu/Debian

```bash
sudo apt update
sudo apt install -y \
    build-essential \
    git \
    cmake \
    pkg-config \
    libusb-1.0-0-dev \
    libusb-1.0-0 \
    python3 \
    python3-pip \
    python3-dev \
    libftdi1-dev \
    libftdi-dev \
    libmpsse-dev
```

#### Fedora/RHEL

```bash
sudo dnf install -y \
    gcc \
    g++ \
    git \
    cmake \
    pkg-config \
    libusbx-devel \
    python3 \
    python3-devel \
    libftdi-devel
```

---

## Installing oss-cad-suite

### Option A: Global Installation (Recommended)

Instalar em `/home/tools/` para compartilhar entre projetos.

```bash
# Criar diretório
sudo mkdir -p /home/tools
cd /home/tools

# Determinar versão (substituir VERSION pela tag mais recente)
# Acesse: https://github.com/YosysHQ/oss-cad-suite-build/releases

# Fazer download (Linux x64)
VERSION="2024-01-01"  # Exemplo: ajuste para a versão mais recente
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/${VERSION}/oss-cad-suite-linux-x64-${VERSION}.tgz

# Extrair
sudo tar xzf oss-cad-suite-linux-x64-${VERSION}.tgz

# Remover arquivo compactado
sudo rm oss-cad-suite-linux-x64-${VERSION}.tgz

# Verificar instalação
ls -la /home/tools/oss-cad-suite/bin/
```

### Opção B: Instalação Local (Projeto Específico)

Se preferir instalar apenas para um projeto:

```bash
cd hdl/tang_nano_1k

# Download e extração
wget https://github.com/YosysHQ/oss-cad-suite-build/releases/download/VERSION/oss-cad-suite-linux-x64.tgz
tar xzf oss-cad-suite-linux-x64.tgz
rm oss-cad-suite-linux-x64.tgz

# Usar path local em vez de global
```

---

## Configuring Environment Variables

### 1. Edit `~/.bashrc`

```bash
nano ~/.bashrc
# or
vim ~/.bashrc
```

### 2. Add to End of File

```bash
# === oss-cad-suite (FPGA Tang Nano) ===
export FPGA_TOOLS="/home/tools/oss-cad-suite"
export PATH="${FPGA_TOOLS}/bin:$PATH"
export LD_LIBRARY_PATH="${FPGA_TOOLS}/lib:$LD_LIBRARY_PATH"
```

### 3. Reload Configuration

```bash
source ~/.bashrc
```

### 4. Verify

```bash
yosys --version
nextpnr-gowin --version
openFPGALoader --version
```

---

## Installing OpenFPGALoader

**openFPGALoader** is the programmer to load bitstreams into the FPGA.

### Opção A: Via Pacote (Se Disponível)

```bash
sudo apt install openfpgaloader
```

### Opção B: Compilar do Source (Recomendado)

```bash
# Clonar repositório
git clone https://github.com/trabucayre/openFPGALoader.git
cd openFPGALoader

# Criar diretório de build
mkdir build && cd build

# Configurar CMake
cmake -DCMAKE_BUILD_TYPE=Release ..

# Compilar (use todos os cores)
make -j$(nproc)

# Instalar globalmente
sudo make install

# Ou instalar localmente
mkdir -p ~/.local/bin
cp openFPGALoader ~/.local/bin/
echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.bashrc
source ~/.bashrc
```

### Verificação

```bash
openFPGALoader --version
```

---

## USB/Driver Configuration

### 1. Connect Tang Nano

Connect the board via USB-C.

### 2. Create udev Rules

```bash
sudo tee /etc/udev/rules.d/99-fpga.rules > /dev/null << 'EOF'
# Anlogic FPGA (Tang Nano, etc.)
SUBSYSTEMS=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6010", MODE="0666"

# Other Gowin/FTDI devices
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6001", MODE="0666"
SUBSYSTEM=="usb", ATTRS{idVendor}=="0403", ATTRS{idProduct}=="6014", MODE="0666"
EOF
```

### 3. Reload Rules

```bash
sudo udevadm control --reload-rules
sudo udevadm trigger
```

### 4. Add User to Group (Optional, to avoid sudo)

```bash
sudo usermod -a -G dialout $USER
sudo usermod -a -G plugdev $USER

# Login again to apply
exit
# Reconnect or run:
# newgrp dialout
```

---

## Verifying Installation

### Complete Checklist

```bash
# 1. Verify Yosys
yosys -version

# Expected output:
# Yosys 0.26+...

# 2. Verify nextpnr
nextpnr-gowin --version

# 3. Verify openFPGALoader
openFPGALoader --version

# 4. Connect Tang Nano and detect
openFPGALoader --detect

# Expected output:
# found 1 device
#   idcode 0x100681b
#   manufacturer Gowin
#   family GW1NZ
#   model  GW1NZ-1
```

---

markdown_content = """# Guia de Instalação do OSS CAD Suite e Configuração do VS Code no Windows

Este guia orienta o processo de instalação do **OSS CAD Suite** (pacote que reúne ferramentas open-source para EDA como Yosys, Verilator, Icarus Verilog e openFPGALoader) e a preparação do **Visual Studio Code** para o desenvolvimento e verificação de hardware, com suporte completo a **SystemVerilog**.

---

## 1. Instalação Windows

O OSS CAD Suite é distribuído como um binário pré-compilado para Windows. Siga os passos abaixo para instalar e configurar as variáveis de ambiente:

### Passo 1: Download
1. Acesse o repositório oficial no GitHub: [YosysHQ/oss-cad-suite-build/releases](https://github.com/YosysHQ/oss-cad-suite-build/releases).
2. Na aba **Releases**, localize a versão mais recente (A versão para windows parou de ser atualizada recentemente, busque por versões de releases mais antigas).
3. Na seção **Assets**, baixe o arquivo correspondente ao Windows 64-bit (geralmente nomeado como `oss-cad-suite-windows-x64-YYYYMMDD.exe` ou formato `.zip`).

### Passo 2: Extração
1. Crie uma pasta diretamente na raiz do seu disco local para evitar problemas com espaços em branco nos caminhos do sistema. 
   * Exemplo recomendado: `C:\\oss-cad-suite`
2. Extraia todo o conteúdo do arquivo baixado dentro dessa pasta.

### Passo 3: Configuração do PATH (Variáveis de Ambiente)
Para utilizar as ferramentas a partir de qualquer terminal ou extensão do VS Code, é necessário adicionar o diretório `bin` ao PATH do Windows:
1. Pressione a tecla `Windows` no teclado, digite **Editar as variáveis de ambiente do sistema** e pressione `Enter`.
2. Na janela que se abrir, clique no botão **Variáveis de Ambiente...** (canto inferior direito).
3. Na seção **Variáveis do sistema**, localize a variável chamada **Path** e dê um duplo clique (ou selecione e clique em *Editar*).
4. Clique no botão **Novo** do lado direito e adicione o caminho exato para a pasta `bin` da sua instalação.
   * Exemplo: `C:\\oss-cad-suite\\bin`
5. Clique em **OK** em todas as janelas para salvar as alterações.

---

## 2. Validação da Instalação

Abra um **novo** terminal (Prompt de Comando ou PowerShell) para carregar as novas variáveis de ambiente e execute os seguintes comandos para garantir que tudo foi instalado com sucesso:

```bash
# Verificar Yosys (Síntese)
yosys --version

# Verificar Verilator (Linter e Simulação)
verilator --version

# Verificar Icarus Verilog (Simulação)
iverilog -V

# Verificar openFPGALoader (Gravação em FPGA)
openFPGALoader --version

```
## Basic Usage

### Compile Project

```bash
cd hdl/tang_nano_1k/blink

# Via Makefile (if available)
make all

# Or manually with yosys
yosys -m gw1n -d gw1n -p "synth_gowin -json blink.json" blink.v

# Place & Route with nextpnr
nextpnr-gowin --json blink.json --asc blink.asc --device GW1NZ-1

# Generate bitstream
gowin_pack -d GW1NZ-1 -o blink.fs blink.asc
```

### Program FPGA

```bash
# Detect device
openFPGALoader --detect

# Program
openFPGALoader -b tangnano1k blink.fs

# Or with specific bus ID
openFPGALoader -b tangnano1k -d "0:0000:0000" blink.fs
```

---

## Troubleshooting

### "Command not found: yosys"

**Cause:** oss-cad-suite not in PATH

**Solution:**
```bash
# 1. Check location
ls -la /home/tools/oss-cad-suite/bin/yosys

# 2. Check ~/.bashrc
cat ~/.bashrc | grep "FPGA_TOOLS\|oss-cad-suite"

# 3. Reload
source ~/.bashrc

# 4. Test again
yosys --version
```

### "Device not found" when programming

**Cause:** Tang Nano not detected, missing drivers or insufficient permissions

**Solution:**
```bash
# 1. Check USB connection
lsusb | grep -i ftdi

# 2. Reconnect board

# 3. Reapply udev rules
sudo udevadm control --reload-rules
sudo udevadm trigger

# 4. If necessary, use sudo
sudo openFPGALoader -b tangnano1k blink.fs

# 5. Test again
openFPGALoader --detect
```

### USB Permission Problems

```bash
# Add user to plugdev group
sudo usermod -a -G plugdev $USER

# Logout and login to apply

# Or run with sudo
sudo openFPGALoader --detect
```

### Slow Compilation

The oss-cad-suite can be slow on VMs or older machines. Consider:
- Using `-j$(nproc)` for parallel builds
- Running on host machine instead of VM

### openFPGALoader Compilation Errors

```bash
# Reinstall dependencies
sudo apt install -y libftdi-dev libftdi1-dev libusb-1.0-0-dev

# Clean previous build
rm -rf build/
mkdir build && cd build

# Recompile
cmake -DCMAKE_BUILD_TYPE=Release ..
make -j$(nproc)
sudo make install
```

---

## References

- **oss-cad-suite:** https://github.com/YosysHQ/oss-cad-suite-build
- **openFPGALoader:** https://github.com/trabucayre/openFPGALoader
- **Gowin Semiconductor:** https://www.gowinsemi.com/
- **Yosys:** http://www.clifford.at/yosys/
- **nextpnr:** https://github.com/YosysHQ/nextpnr

---

**Última atualização:** 6 de maio de 2026
