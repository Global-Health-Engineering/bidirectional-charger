# Hardware

## Main MATLAB Scripts  
1.	main.m  
This is the entry point for the project workflow. It automatically runs the setup of system parameters, PI controller tuning, and plots the simulation or hardware results. To launch the full workflow, open MATLAB and run:  
main

2.	parameters.m  
Defines all system and hardware-related parameters, such as ADC conversions, grid and DC specifications, filter values, and PLL settings.

3.	pi_tuning.m  
Tunes PI controllers for D/Q current loops, DC link voltage control, and reactive power control based on state-space models and automatic tuning via MATLAB's pidtune().

4.	plot_results.m  
Generates all necessary plots for analyzing logged signals like PLL output, DQ voltage/current, modulation signal, and power measurements. Time axis is remapped for clarity.

5. `pll_function_wrapper.c`
C-based S-Function for PLL to extracts grid phase angle for dq transformations

6. `volt_curr_delay_wrapper.c`
C-based S-Function for synthetizing the missing Beta component to perform d&q transformation


## Simulink Models  
•	Inverter_simulation.slx  
Simulates the inverter’s dynamic behavior. Layout:  
•	- Center: Inverter switching logic  
•	- Left: Logging and measurement blocks  
•	- Right: PLL and DQ transformations  
•	- Bottom: Control algorithms  
To use: run main.m, then launch the simulation in Simulink.

•	microcontroller.slx  
Used to generate embedded code for the TI C2000 MCU. Layout:  
•	- Left: ADC signal acquisition  
•	- Center: Control logic  
•	- Right: PWM output via ePWM module  
Requires C2000 support package and Embedded Coder.

## Code Generation Folder  
•	Microcontroller_ert_rtw/  
Auto-generated folder containing C code and headers from Simulink builds.

•	Microcontroller_ert_rtw/CCS_Project/  
Contains a pre-configured Code Composer Studio (CCS) project. Open this in CCS to build and flash the code onto the microcontroller.

## Installation

### Requirements
- MATLAB (R2020a or newer)
- Simulink
- Control System Toolbox
- Embedded Coder (for compiling S-Functions and generating code)
- Simscape Electrical (if modeling real components)
- TI C2000 Support Package (required for all microcontroller builds)

💡 Microcontroller-specific notes:
- For **F28M35x (Concerto)**: Dual-core support is assumed. This project uses only the C28 core for control, so ensure M3 core grants access to peripherals.
- For **F28069 / F28027**: Use standard ePWM and ADC modules. Some changes in peripheral block mapping may be required.
- For **F28379D**: Ensure compatibility with dual ADCs and advanced PWM configurations if you adapt the control loops.

---

### Setup
1. Copy the project folder into your MATLAB workspace
2. Run `main.m` (or `main.m`, depending on folder name)
3. Open the Simulink model `microcontroller.slx` 

---

## Support

For questions, feedback, or collaboration proposals:

- Email: **fsartore@ethz.ch**
- Code comments and documentation (especially in PLL and controller design scripts)

Microcontroller-specific troubleshooting tips:
- F28M35x: Check shared memory configuration and M3 access granting
- F28069/F28379D: Confirm correct ADC start-of-conversion triggers (e.g., from ePWM)

---

## Roadmap

Potential future extensions include:
- Integration with detailed battery models (SoC estimation, protection layers)
- Extension to multi-converter architectures (e.g., AC/DC + DC/DC coordination)
- Implementation of grid-forming control strategies (virtual impedance, droop control)

Support for additional TI microcontrollers may be added in future forks.

---

## Contributing

Contributions are welcome. To ensure clarity and stability:

1. Fork the repository
2. Create a feature branch (`git checkout -b feature-name`)
3. Commit changes with meaningful messages
4. Push and open a pull request

When contributing:
- Ensure compatibility with at least one supported TI MCU (preferably F28M35x or F28069)
- Comment any added logic or parameter files
- Update PI tuning, PLL, and dq transformation scripts if modified

---

## Authors

Developed by **Federico Sartore** as part of his Master’s Thesis at **ETH Zurich – Energy Science and Technology program**.

---

## License

**Note:** This project requires a licensed copy of **MATLAB** and **Simulink**, along with necessary toolboxes such as Control System Toolbox and Embedded Coder for real-time simulation and code generation.

To compile and deploy code to TI microcontrollers, you must install the appropriate **TI C2000 Hardware Support Package**.

---

## Project Status

**Active – Finalized for thesis integration.**  
This repository reflects the version used in thesis simulations and analysis. Additional updates may follow based on hardware testing or microgrid deployment experiments.

Microcontroller compatibility:
- ✅ F28M35x (Concerto series) – verified and tested
- ⚠️ F28069 – compatible with minor changes
- ⚠️ F28379D – advanced features supported, requires model adaptation
