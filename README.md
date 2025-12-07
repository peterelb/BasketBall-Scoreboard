# Microprocessor Lab Project – PIC16F877A + C# PC Application

## Overview

This project consists of:

1. **Embedded firmware (`project.asm`)** running on a **PIC16F877A** microcontroller.  
2. **C# desktop application** running on a laptop/PC.

The PIC board handles all low-level I/O (sensors, actuators, LCD, etc.), while the C# application provides a user interface to monitor data and send commands over a serial connection (UART → USB).

---

## Features

- **PIC16F877A firmware (`project.asm`)**
  - Initializes I/O ports, timers, ADC, UART and other on-chip peripherals.
  - Reads inputs from sensors / switches.
  - Drives outputs such as LEDs, relays, motors, LCD, etc. (depending on your wiring).
  - Implements a simple **serial protocol** to communicate with the PC.
  - Optionally displays status information on a 16x2 LCD (if connected).

- **C# desktop application**
  - Connects to the PIC board via **COM (serial) port**.
  - Sends control commands to the microcontroller.
  - Receives and displays feedback (sensor values, status flags, etc.).
  - Provides basic UI controls (buttons, text fields, indicators) for easy interaction.

> **Note:** Customize this section with your exact project goal, e.g. *“temperature monitoring,” “motor speed control,” “line follower robot,”* etc.

---

## Repository Structure



```text
.
├── Firmware/
│   ├── project.asm        # PIC16F877A assembly source code
│   └── project.hex        # (Optional) Compiled firmware image
│
├── PC_App/
│   ├── TestProgramApp.sln    # C# solution file
│   ├── TestProgramApp.csproj # C# project file
|   ├── Form1                 # C# project file
|   ├── Form1.Designer        # C# project file 
│   └──  Program
|                  
│
└── README.md              # This file
