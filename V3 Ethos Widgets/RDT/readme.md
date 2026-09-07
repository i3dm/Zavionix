# Zavionix RDT

Single-turbine telemetry dashboard for FrSky radios running Ethos.

RDT displays turbine telemetry received through a Zavionix RDT sensor, bringing engine condition and fuel information together on the transmitter.

## What it does

- Displays turbine RPM, exhaust gas temperature (EGT), ECU status, ECU battery voltage, and pump information.
- Shows fuel information supplied by the ECU or calculated from pump telemetry, depending on the selected ECU type.
- Provides configurable low-fuel and engine-cut alerts, plus a fuel reset switch.
- Includes receiver signal strength, receiver battery telemetry, and an air-pressure source.

## Setup

Select the correct ECU type and assign its telemetry sources using the sensor configuration spreadsheet included in this folder. Set the tank size, calibrate the fuel factor where applicable, and configure the fuel reset and alert settings.

Copy the complete `RDT` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
