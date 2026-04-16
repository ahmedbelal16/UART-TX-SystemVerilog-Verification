# 🧪 UART Transmitter Verification (SystemVerilog)

📌 **Project Overview**  
Welcome to the **UART Transmitter Verification Project** — a verification environment developed using **SystemVerilog**, designed to validate the functionality of a UART Transmitter module.  

The project focuses on **constrained random verification (CRV)**, **coverage-driven methodology**, and **self-checking testbench architecture** to ensure correct UART behavior under different scenarios including parity modes and data variations.

---

## 🎯 Features
- ✅ UART TX protocol verification (Start, Data, Parity, Stop)  
- ✅ Constrained Random Verification (CRV) for diverse stimulus generation  
- ✅ Functional & Code Coverage analysis 📊  
- ✅ Golden model for expected output comparison  
- ✅ Self-checking testbench with automated validation  
- ✅ SystemVerilog Assertions (SVA) basics for checking correctness  
- ✅ Automated simulation using **QuestaSim (.do file)**  

---

## 📂 File Structure

| Path | Description |
|---|---|
| **Design/uart_tx.sv** | UART Transmitter RTL (DUT) |
| **Verification/uart_tb.sv** | Main testbench |
| **Verification/uart_interface.sv** | Interface connecting TB with DUT |
| **Verification/uart_packet.sv** | Transaction class with constrained randomization |
| **Verification/enum_pkg.sv** | Enumerations for parity modes |
| **Do , Coverage and Transcript/run.do** | Simulation automation script |
| **Do , Coverage and Transcript/transcript.log** | Simulation log output |
| **Do , Coverage and Transcript/Uart_Cov.txt** | Coverage report |
| **docs/Project_Report.pdf** | Full project documentation |

---

## 🛠️ Implementation Details

### 🖥️ DUT (UART Transmitter)
- Sends serial data using:
  - Start bit (0)  
  - 8 data bits (LSB first)  
  - Optional parity bit  
  - Stop bit (1)  
- Supports:
  - EVEN parity  
  - ODD parity  
  - NO parity  
- Includes `tx_busy` signal to indicate transmission state  

---

### 🧪 Verification Environment
- Built using **SystemVerilog classes**  
- Implements:
  - Randomized stimulus generation  
  - Packet-based transactions  
  - Controlled test scenarios  
- Uses:
  - Interfaces for clean DUT communication  
  - Modular structure for scalability  

---

### 🎲 Constrained Random Verification (CRV)
- Randomized test cases covering:
  - All data combinations  
  - Edge cases (all 0s, all 1s)  
  - Different parity modes  
- Ensures better coverage than directed testing  

---

### 📊 Coverage & Checking
- Functional coverage to track tested scenarios  
- Golden model used to generate expected output  
- Automatic comparison between:
  - Expected data  
  - Actual DUT output  
- PASS/FAIL results logged in transcript  

---

### ⏱️ Simulation Flow
- Automated using `.do` file:
  - Compilation  
  - Simulation  
  - Waveform generation  
  - Coverage collection  
- Logs stored in:
  - `transcript.log`  

---

## 🔍 Debugging & Testing
- ✅ Waveforms used to verify UART timing and transitions  
- ✅ Transcript logs show test cases and results  
- ✅ Coverage report ensures all scenarios are exercised  
- ✅ Self-checking mechanism detects mismatches automatically  

---

## 📊 Results Summary
- UART transmission verified for:
  - Multiple data patterns  
  - All parity configurations  
- No functional mismatches detected  
- Coverage achieved across different test scenarios  
- Stable and correct UART behavior confirmed  

---

## 🏁 Conclusion
This project demonstrates a complete **SystemVerilog verification environment** for a UART Transmitter using modern verification techniques such as **CRV, coverage-driven verification, and self-checking testbenches**.  

It reflects real-world verification practices and builds a strong foundation for advanced methodologies like **UVM**. 🚀  

---

## 🧑‍💻 Designed By
- **Ahmed Belal Abdelrahman**

---

## ⭐ Final Note
If you found this project useful, please ⭐ star the repository!  
Feedback is always welcome — let’s keep learning and improving together 💡
