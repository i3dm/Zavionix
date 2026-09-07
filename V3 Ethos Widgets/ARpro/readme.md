# Zavionix ARpro

Dual-battery and receiver diagnostics dashboard for FrSky radios running Ethos.

ARpro combines the dual-battery monitoring of AR with additional receiver and stabilization telemetry for models that provide these extra sensors.

## What it does

- Displays voltage, current, remaining capacity, and battery percentage for two supplies.
- Adds receiver frame and failsafe readings for both receivers.
- Displays live gain and AGC values for the X, Y, and Z axes.
- Includes receiver signal strength, receiver battery readings, and a configurable low-battery alert.

## Setup

Assign both batteries' telemetry and capacities, then select the frame, failsafe, live-gain, and AGC sources supplied by your equipment. These additional displays require the corresponding telemetry sources.

Copy the complete `ARpro` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
