# Control_Strategy_2

## Description

This repository contains a fully parametric and modular MATLAB/Simulink implementation of **Control Strategy 2** for a bidirectional battery charger, developed as part of a Master's thesis project. In this configuration, the DC/DC converter is responsible for regulating the DC-link voltage, while the AC/DC converter exclusively controls the grid current, enabling decoupled and bidirectional active/reactive power flow.

The architecture supports batch simulations across different power requests and includes parameter tuning scripts, dq transformations, and PLL logic for grid-synchronous operation.

---

## Folder Structure and Components

### 1. `main_control_strategy_2.m`
Initializes the system and defines shared parameters across the converters:
- PWM switching frequency
- Nominal active/reactive power
- Calls setup scripts
- Optionally runs `multi_simulation.m` for batch scenarios

---

### 2. `dcdc_converter_parameters.m`
Defines all parameters for the DC/DC converter:
- Component values (inductors, resistors, etc.)
- Linearization operating point

---

### 3. `dcdc_converter_main.m`
Processes parameters and performs control design:
- Computes A, B, C, D matrices
- Extracts poles and DC gain
- Applies pole-zero cancellation to determine PI parameters for voltage and current regulation

---

### 4. `acdc_converter_parameters.m`
Sets up AC/DC converter parameters:
- Defines steady-state operating points
- Assigns bandwidth for:
  - d-axis current control
  - q-axis current control
  - active outer controller
  - rective outer controller


---

### 5. `acdc_converter_main.m`
Performs system linearization and controller design:
- Models dq current loops
- Tunes PI controllers for current regulation
- Configures matrices and transfer functions for P/Q control

---

### 6. `control_strategy_2.slx`
Main Simulink model:
- Central section: converter topology
- Bottom: AC/DC and DC/DC controllers
- Sides: utility functions (PLL, dq sync, references)
- Modular and clearly labeled

---

### 7. `multi_simulation.m`
Batch simulation script:
- Defines `P_array` and `Q_array` to sweep power scenarios
- `Q_switch` introduces Q steps to enhance startup numerical stability

---

### 8. `pll_sfunction_wrapper.c`
C-based S-Function for PLL:
- Extracts grid phase angle for dq transformations
- Fully modular and commented
- Compatible with Embedded Coder for real-time deployment

---

## Installation

### Requirements
- MATLAB (R2020a or newer)
- Simulink
- Control System Toolbox
- Embedded Coder (for compiling S-Functions)
- Simscape Electrical (if modeling real components)

### Setup
1. Copy the project folder into your MATLAB workspace
2. Run `main_control_strategy_2.m`
3. Open the Simulink model `control_strategy_2.slx`

---

## Support

For questions, feedback, or collaboration proposals:

- Email: **fsartore@ethz.ch**
- Code comments and documentation (especially in PLL and controller design scripts)

---

## Roadmap

Potential future extensions include:
- Integration with battery models
- Extension to multi-converter architectures
- Grid-forming control implementation

---

## Contributing

Contributions are welcome. To ensure clarity and stability:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature-name`)
3. Commit changes with meaningful messages
4. Push and open a pull request

Please update documentation or parameter files as needed and comment any added logic.

---

## Authors

Developed by **Federico Sartore** as part of his Master’s Thesis at **ETH Zurich – Energy Science and Technology program**.

---

## License

**Note:** This project requires a licensed copy of **MATLAB** and **Simulink**, along with necessary toolboxes such as Control System Toolbox and Embedded Coder for real-time simulation and code generation.

---

## Project Status

**Active – Finalized for thesis integration.**  
This repository reflects the version used in the thesis simulations and results. Future updates may follow based on experimental testing.
