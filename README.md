## 1-Bit Full Adder Using 4×1 Multiplexers | Verilog

A **Verilog implementation of a 1-bit full adder using 4×1 multiplexer (MUX) blocks**, designed and simulated in **Xilinx Vivado**.  
This document explains:

- **What a full adder is**
- **How a 4×1 MUX works**
- **How to build a 1-bit full adder using two 4×1 MUXes running in parallel**
- The **truth table**, **K‑maps**, **input assignments**, and **simulation results**

The project includes the **RTL design**, **testbench**, **simulation waveform**, and **console-style output** verifying correct behavior.

---

## Table of Contents

- [What Is a Full Adder?](#what-is-a-full-adder)
- [4×1 Multiplexer Basics](#4×1-multiplexer-basics)
- [1-Bit Full Adder Truth Table](#1-bit-full-adder-truth-table)
- [K‑Map Derivation and MUX Input Mapping](#k-map-derivation-and-mux-input-mapping)
  - [Sum Output \(S\) Using a 4×1 MUX](#sum-output-s-using-a-4×1-mux)
  - [Carry Output \(C\_o\) Using a 4×1 MUX](#carry-output-co-using-a-4×1-mux)
- [Implementing the Full Adder Using Two 4×1 MUXes](#implementing-the-full-adder-using-two-4×1-muxes)
- [Circuit Diagram](#circuit-diagram)
- [Waveform Diagram](#waveform-diagram)
- [Testbench Output](#testbench-output)
- [Running the Project in Vivado](#running-the-project-in-vivado)
- [Project Files](#project-files)

---

## What Is a Full Adder?

A **1-bit full adder** is a combinational logic circuit that adds **three 1‑bit binary inputs**:

- **A** – first operand bit  
- **B** – second operand bit  
- **C\_i** – input carry (carry‑in)

It produces **two outputs**:

- **S** – sum bit  
- **C\_o** – carry‑out bit

Conceptually, it performs:

\[
A + B + C\_i = C\_o\,S
\]

where \(S\) is the least significant bit of the sum and \(C\_o\) is the carry to the next higher bit.

---

## 4×1 Multiplexer Basics

A **4×1 multiplexer** has:

- **Inputs**: \(I_0, I_1, I_2, I_3\)  
- **Select lines**: \(S_1, S_0\)  
- **Output**: \(Y\)

The select lines form a **2‑bit binary number** that chooses exactly **one input** to be routed to the output:

| S1 | S0 | Selected Input | Output        |
|----|----|----------------|---------------|
| 0  | 0  | \(I_0\)        | \(Y = I_0\)   |
| 0  | 1  | \(I_1\)        | \(Y = I_1\)   |
| 1  | 0  | \(I_2\)        | \(Y = I_2\)   |
| 1  | 1  | \(I_3\)        | \(Y = I_3\)   |

In this project, we use:

- **Two 4×1 MUXes in parallel**
  - One MUX generates the **sum \(S\)**
  - One MUX generates the **carry \(C\_o\)**
- The **same select lines** for both:
  - **\(S_0 = B\)**
  - **\(S_1 = A\)**
- The third input **\(C\_i\)** is used inside each MUX as part of the data inputs \(I_0\ldots I_3\).

---

## 1-Bit Full Adder Truth Table

The complete truth table for the 1‑bit full adder is:

| A | B | C\_i | S | C\_o |
|---|---|------|---|------|
| 0 | 0 | 0    | 0 | 0    |
| 0 | 0 | 1    | 1 | 0    |
| 0 | 1 | 0    | 1 | 0    |
| 0 | 1 | 1    | 0 | 1    |
| 1 | 0 | 0    | 1 | 0    |
| 1 | 0 | 1    | 0 | 1    |
| 1 | 1 | 0    | 0 | 1    |
| 1 | 1 | 1    | 1 | 1    |

From this table, the well‑known Boolean expressions are:

\[
S = A \oplus B \oplus C\_i
\]
\[
C\_o = AB + BC\_i + AC\_i
\]

In this implementation, we do **not** realize these expressions directly with gates; instead, we **realize both outputs using 4×1 multiplexers**.

---

## K‑Map Derivation and MUX Input Mapping

To implement a function with a 4×1 MUX:

- Choose **two variables as select lines**.
- Use the **third variable** within the input assignments \(I_0\ldots I_3\).

Here we choose:

- **Selector mapping**:
  - **\(S_1 = A\)**
  - **\(S_0 = B\)**
- **Remaining variable**:
  - **\(C\_i\)** is used inside the input functions.

So each MUX will have a truth table of the form:

| S1 (A) | S0 (B) | Selected Input | Output |
|--------|--------|----------------|--------|
| 0      | 0      | \(I_0\)        | \(f(A=0,B=0,C\_i)\) |
| 0      | 1      | \(I_1\)        | \(f(A=0,B=1,C\_i)\) |
| 1      | 0      | \(I_2\)        | \(f(A=1,B=0,C\_i)\) |
| 1      | 1      | \(I_3\)        | \(f(A=1,B=1,C\_i)\) |

We now derive \(I_0\ldots I_3\) for **S** and **C\_o** separately using K‑maps.

### Sum Output \(S\) Using a 4×1 MUX

K‑map for **sum \(S\)** with **rows = A**, **columns = (B, C\_i)**:

| A \\ B,C\_i | 00 | 01 | 11 | 10 |
|------------|----|----|----|----|
| 0          | 0  | 1  | 0  | 1  |
| 1          | 1  | 0  | 1  | 0  |

Grouping by \((A,B)\) and examining dependence on \(C\_i\), we obtain the MUX input assignments:

| S1 (A) | S0 (B) | S | MUX Input Definition |
|--------|--------|---|----------------------|
| 0      | 0      | \(S = C\_i\)   | \(I_0 = C\_i\)   |
| 0      | 1      | \(S = \overline{C\_i}\) | \(I_1 = \overline{C\_i}\) |
| 1      | 0      | \(S = \overline{C\_i}\) | \(I_2 = \overline{C\_i}\) |
| 1      | 1      | \(S = C\_i\)   | \(I_3 = C\_i\)   |

So the **sum MUX** has:

- **\(I_0 = C\_i\)**
- **\(I_1 = \overline{C\_i}\)**
- **\(I_2 = \overline{C\_i}\)**
- **\(I_3 = C\_i\)**

with **\(S_1 = A\)** and **\(S_0 = B\)**.

### Carry Output \(C\_o\) Using a 4×1 MUX

K‑map for **carry \(C\_o\)** with **rows = A**, **columns = (B, C\_i)**:

| A \\ B,C\_i | 00 | 01 | 11 | 10 |
|------------|----|----|----|----|
| 0          | 0  | 0  | 1  | 0  |
| 1          | 0  | 1  | 1  | 1  |

From this map, for each \((A,B)\) pair, we derive dependence on \(C\_i\):

| S1 (A) | S0 (B) | C\_o | MUX Input Definition |
|--------|--------|------|----------------------|
| 0      | 0      | 0          | \(I_0 = 0\)   |
| 0      | 1      | \(C\_o = C\_i\)      | \(I_1 = C\_i\) |
| 1      | 0      | \(C\_o = C\_i\)      | \(I_2 = C\_i\) |
| 1      | 1      | 1          | \(I_3 = 1\)   |

So the **carry MUX** has:

- **\(I_0 = 0\)**
- **\(I_1 = C\_i\)**
- **\(I_2 = C\_i\)**
- **\(I_3 = 1\)**

again with **\(S_1 = A\)** and **\(S_0 = B\)**.

---

## Implementing the Full Adder Using Two 4×1 MUXes

Using the mappings above, the full adder is implemented with:

- **MUX 1 (Sum MUX)**  
  - Select lines: **\(S_1 = A\)**, **\(S_0 = B\)**  
  - Data inputs:
    - \(I_0 = C\_i\)
    - \(I_1 = \overline{C\_i}\)
    - \(I_2 = \overline{C\_i}\)
    - \(I_3 = C\_i\)
  - Output: **\(S\)**

- **MUX 2 (Carry MUX)**  
  - Select lines: **\(S_1 = A\)**, **\(S_0 = B\)**  
  - Data inputs:
    - \(I_0 = 0\)
    - \(I_1 = C\_i\)
    - \(I_2 = C\_i\)
    - \(I_3 = 1\)
  - Output: **\(C\_o\)**

These two MUXes run **in parallel** and share the same select lines, so for each combination of \(A\) and \(B\), both **S** and **\(C\_o\)** are produced simultaneously using appropriate functions of \(C\_i\).

A compact view of the overall behavior is:

| A | B | C\_i | Selected Inputs | S (from Sum MUX) | C\_o (from Carry MUX) |
|---|---|------|-----------------|------------------|------------------------|
| 0 | 0 | 0    | \(I_0\)         | \(C\_i = 0\)     | 0                      |
| 0 | 0 | 1    | \(I_0\)         | \(C\_i = 1\)     | 0                      |
| 0 | 1 | 0    | \(I_1\)         | \(\overline{C\_i} = 1\) | 0              |
| 0 | 1 | 1    | \(I_1\)         | \(\overline{C\_i} = 0\) | 1              |
| 1 | 0 | 0    | \(I_2\)         | \(\overline{C\_i} = 1\) | 0              |
| 1 | 0 | 1    | \(I_2\)         | \(\overline{C\_i} = 0\) | 1              |
| 1 | 1 | 0    | \(I_3\)         | \(C\_i = 0\)     | 1                      |
| 1 | 1 | 1    | \(I_3\)         | \(C\_i = 1\)     | 1                      |

which matches the standard full‑adder truth table.

---

## Circuit Diagram

The circuit consists of:

- Two **4×1 multiplexers**:
  - One for **sum \(S\)**
  - One for **carry \(C\_o\)**
- Common select lines **A** and **B**
- Shared input **\(C\_i\)** driving the internal MUX data inputs

ASCII view:

```text
        A (S1)          B (S0)
         │               │
      ┌──┴──┐         ┌──┴──┐
      │    S│         │   Cₒ│
      │ 4×1 │         │ 4×1 │
      │ MUX │         │ MUX │
      └┬────┘         └┬────┘
       │ I0..I3        │ I0..I3
       │               │
      Cᵢ, 0, 1 and Cᵢ̄ (as per mappings)
```

Rendered schematic from Vivado:

![1-Bit Full Adder Circuit Using 4×1 Multiplexers](imageAssets/fullAdderMultiplexerCircuit.png)

---

## Waveform Diagram

The behavioral simulation verifies operation by:

1. Sweeping through **all 8 combinations** of inputs \(A, B, C\_i\).  
2. Observing that the outputs \(S\) and \(C\_o\) match the full‑adder truth table for each case.

Signals observed:

```text
Inputs :
  A, B, C_i
Outputs:
  S, C_o
```

Simulation waveform:

![1-Bit Full Adder Waveform Using 4×1 Multiplexers](imageAssets/fullAdderMultiplexerWaveform.png)

---

## Testbench Output

Conceptual console-style view of the testbench results:

```text
A B C_in | S C_o
----------------
0 0  0   | 0 0
0 0  1   | 1 0
0 1  0   | 1 0
0 1  1   | 0 1
1 0  0   | 1 0
1 0  1   | 0 1
1 1  0   | 0 1
1 1  1   | 1 1
```

These results confirm that **\(S\)** and **\(C\_o\)** match the expected full‑adder behavior for all possible input combinations.

---

## Running the Project in Vivado

### 1. Launch Vivado

Open **Xilinx Vivado**.

### 2. Create a New RTL Project

- **Create Project**  
- Choose **RTL Project**  
- Enable **Do not specify sources at this time** (optional) or add them directly.

### 3. Add Design and Simulation Files

Design Sources:

```text
fourToOneMultiplexer.v
fullAdderMultiplexer.v
```

Simulation Sources:

```text
fullAdderMultiplexer_tb.v
```

Set `fullAdderMultiplexer_tb.v` as the **simulation top module**.

### 4. Run Behavioral Simulation

In Vivado:

```text
Flow → Run Simulation → Run Behavioral Simulation
```

Observe the signals:

```text
Inputs : A, B, C_i
Outputs: S, C_o
```

Verify from the waveform that the outputs follow the **truth table** and match the console-style output listed above.

---

## Project Files

| File                         | Description                                                     |
|------------------------------|-----------------------------------------------------------------|
| `fourToOneMultiplexer.v`     | 4×1 multiplexer module used as the basic building block        |
| `fullAdderMultiplexer.v`     | 1-bit full adder implemented using two 4×1 MUX modules         |
| `fullAdderMultiplexer_tb.v`  | Testbench that stimulates the full adder and records waveforms |

---

**Author**: **Kadhir Ponnambalam**
