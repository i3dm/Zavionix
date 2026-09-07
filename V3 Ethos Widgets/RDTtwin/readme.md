# Zavionix RDTtwin

Twin-turbine telemetry dashboard for FrSky radios running Ethos.

RDTtwin displays left and right turbine telemetry together, allowing pilots of twin-engine models to compare both engines on one screen.

## What it does

- Displays separate RPM, EGT, ECU status, ECU battery voltage, and pump information for each turbine.
- Tracks fuel for each side using ECU telemetry or pump-based calculation, depending on ECU type.
- Provides separate left and right fuel factors, with configurable low-fuel and engine-cut alerts.
- Includes a fuel reset switch and shared receiver signal, receiver battery, and air-pressure telemetry.

## Setup

Select the ECU type and assign the left and right sensor groups using the included configuration spreadsheet. Enter the tank size, calibrate each side's fuel factor where applicable, and configure reset and alert settings.

Copy the complete `RDTtwin` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
