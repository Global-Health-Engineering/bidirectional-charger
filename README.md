# Master Thesis – Bidirectional Battery Charger Control

This repository contains all simulation models, control scripts, and embedded code related to the development of a bidirectional single-phase battery charger for e-bikes. The content is organized into three main folders, corresponding to the core components of the thesis work.

---

📁 Control_Strategy_1/  
Implements the first control strategy for power regulation, where:
- The **AC/DC stage** regulates the  **DC-link voltage**
- The **DC/DC stage** handles power regulation

Includes:
- MATLAB scripts for parameter setup and PI tuning
- Simulink model of the full charger topology
- Batch simulation support for different power references



---

📁 Control_Strategy_2/  
Implements the second control strategy, where:
- The **DC/DC stage** is responsible for **DC-link voltage regulation**
- The **AC/DC stage** focuses solely on **active regulation**

Includes:
- MATLAB scripts for parameter setup and PI tuning
- Simulink model of the full charger topology
- Batch simulation support for different power references



---

📁 Hardware/  
Contains embedded code generation models and scripts for deployment on a **TI C2000 microcontroller (F28M35x)**.

Includes:
- Simulink models tailored for code generation (ADC, ePWM, control logic)
- Auto-generated C code and headers
- Pre-configured Code Composer Studio (CCS) project



---

Each subfolder contains its own `README.md` with detailed descriptions of files, setup instructions, and simulation/compilation steps.

