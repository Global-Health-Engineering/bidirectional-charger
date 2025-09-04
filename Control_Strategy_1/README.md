# Control_Strategy_1

## Description

This repository contains a fully parametric and modular MATLAB/Simulink implementation of the **Control Strategy 1** for a bidirectional battery charger, developed as part of a Master's thesis project. The strategy is based on a clear separation of control responsibilities between the AC/DC converter, tasked with dc-link voltage control and DC/DC converter, that regulates the bidirectional power flow. 

The architecture supports batch simulations across different power requests and includes parameter tuning scripts, dq transformations, and PLL logic for grid-synchronous operation.

---

## Folder Structure and Components

### 1. `main_control_strategy_1.m`
Initializes the system and defines shared parameters across the converters:
- PWM switching frequency
- Nominal active/reactive power
- Calls setup scripts
- Optionally runs `multi_simulation.m` for batch scenarios

---

### 2. `dcdc_converter_parameters.m`
Defines all parameters for the DC/DC converter:
- Component values (inductors, resistors, etc.)
- Current control loop bandwidth
- Linearization operating point

---

### 3. `dcdc_converter_main.m`
Processes parameters and performs control design:
- Computes A, B, C, D matrices
- Extracts poles and DC gain
- Applies pole-zero cancellation to determine PI parameters

---

### 4. `acdc_converter_parameters.m`
Sets up AC/DC converter parameters:
- Defines steady-state operating points
- Estimates equivalent resistance (Rdc)
- Assigns bandwidth for:
  - d-axis current control
  - q-axis current control
  - DC-link voltage regulation
  - Reactive power control

---

### 5. `acdc_converter_main.m`
Performs system linearization and controller design:
- Models the dq current loops
- Tunes PI controllers
- Configures matrices and transfer functions for the outer voltage and reactive power control loops

---

### 6. `control_strategy_1.slx`
Main Simulink model:
- Central section: converter topology
- Bottom: AC/DC and DC/DC controllers
- Sides: utility functions (PLL, dq sync, references)
- Clearly labeled and modular

---

### 7. `multi_simulation.m`
Batch simulation script:
- Defines `P_array` and `Q_array` to sweep power requests
- `Q_switch` introduces Q as a step to improve numerical stability during simulation startup

---

### 8. `pll_sfunction_wrapper.c`
C-based S-Function for PLL implementation:
- Extracts grid angle for synchronization
- Fully commented and modular
- Can be compiled for real-time execution with Embedded Coder

---

## Installation

### Requirements
- MATLAB (R2020a or newer)
- Simulink
- Control System Toolbox
- Embedded Coder (for compiling S-Functions)
- Simscape Electrical (if simulation includes real components)

### Setup
1. Copy the project folder into your MATLAB workspace
2. Open `main_control_strategy_1.m` and run it
3. Open the Simulink model `control_strategy_1.slx`

---

## Support

If you have questions, encounter issues, or would like to collaborate, you can reach out via:

- Email: **fsartore@ethz.ch**
- Code comments and documentation (especially for PLL and PI tuning logic)

---

## Roadmap

Planned or potential future extensions include:
- Battery modelling integration
- Multi-converter controlled by one inverter
- Grid forming algorithm


---

## Contributing

Contributions are welcome. To maintain clarity and coherence:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature-name`)
3. Commit your changes with clear messages
4. Push and open a pull request

Before submitting:
- Update any related parameter or documentation scripts
- Add comments to explain new functionality

---

## Authors 

This code was developed by **Federico Sartore** as part of his Master’s Thesis at **ETH Zurich – Energy Science and Technology program**.

---

## License


**Note:** This project requires a valid license for **MATLAB** and **Simulink**, along with specific toolboxes (e.g., Control System Toolbox, Embedded Coder) in order to run and compile certain components such as S-Functions.


## Project Status

**Active – Finalized for thesis integration.**  
The repository reflects the validated version used for academic results and thesis submission. Further extensions may follow based on experimental validation or future research.
