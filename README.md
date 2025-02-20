# **Floating Point Addition and Multiplication Unit**

## **Introduction**

### **1.1 Context**

The main objectives of this module are to explore the need for floating-point numbers, their standard representation, and how various floating-point arithmetic operations (addition, subtraction, multiplication, etc.) are carried out. 

Floating-point representation allows for the support of a wider range of values than fixed-point or integer representations. The core arithmetic functions used in this system are summation, subtraction, multiplication, and division. In this floating-point unit, input values are provided in IEEE-754 format, specifically using 32-bit single-precision floating-point numbers.

The application of this floating-point arithmetic unit is located within the math coprocessor, designed to handle floating-point calculations efficiently.

### **1.2 Objectives**

The primary goal is to design a floating-point arithmetic unit (ALU) using VHDL and integrate it into a Xilinx Vivado project. A testbench has been included for simulation purposes to validate the functionality of the unit. 

The design approach follows a **Bottom-up design methodology**, where simpler logic blocks such as **Comparator**, **Adder**, **Shifter**, and others are implemented first, before progressing to the final integration of the arithmetic unit.

---

### **Features**

- **IEEE-754 Single Precision**: Implements arithmetic operations using 32-bit IEEE-754 standard for single-precision floating-point numbers.
- **VHDL Implementation**: The unit is written in VHDL and is integrated into a Xilinx Vivado project.
- **Simulation**: A testbench is provided to simulate and validate the design before implementation on hardware.

---

### **Getting Started**

To get started with the project:
1. Clone the repository.
2. Open the project in **Xilinx Vivado**.
3. Simulate the unit using the provided testbench.
4. Implement the design on the FPGA (optional).

---

### **How to Run Simulation**

1. Open Vivado and load the project.
2. Compile the design and run the simulation using the provided testbench.
3. Observe the waveform outputs to validate the functionality of the floating-point operations.

---

### **Contributing**

Feel free to fork the project, submit issues, or pull requests for improvements or fixes.
