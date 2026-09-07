# Zavionix GAS

Telemetry dashboard for combustion-engine models for FrSky radios running Ethos.

GAS brings engine RPM, temperature readings, and fuel information together on one screen for gas-powered models.

## What it does

- Displays engine RPM and up to five temperature sources.
- Displays remaining fuel using the assigned fuel sensor, tank size, and fuel factor.
- Provides a configurable low-fuel alert.
- Includes receiver signal strength and receiver battery telemetry.

## Setup

Assign the RPM, temperature, and fuel telemetry sources. Enter the tank size, adjust the fuel factor to suit the sensor readings, and set the low-fuel threshold and alert interval.

Copy the complete `GAS` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
