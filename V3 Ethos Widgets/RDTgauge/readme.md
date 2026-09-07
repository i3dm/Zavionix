# Zavionix RDTgauge

Turbine telemetry with graphical gauges for FrSky radios running Ethos.

RDTgauge presents single-turbine telemetry in a graphical gauge layout for quick visual checks of engine readings and fuel state.

## What it does

- Displays gauges for turbine readings including RPM, EGT, ECU battery voltage, pump information, and fuel.
- Shows ECU status and uses ECU-reported or calculated fuel information according to the selected ECU type.
- Allows gauge ranges to be configured for RPM, ECU battery voltage, pump output, and EGT.
- Includes low-fuel and engine-cut alert settings, a fuel reset switch, and receiver and air-pressure telemetry.

## Setup

Select the ECU type and map the telemetry sources using the included sensor configuration spreadsheet. Configure the tank size and fuel factor, then set gauge ranges appropriate to your turbine.

Copy the complete `RDTgauge` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
