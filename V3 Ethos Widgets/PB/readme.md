# Zavionix PB

Dual power-supply telemetry dashboard for FrSky radios running Ethos.

PB provides a two-battery power-monitoring screen for models with telemetry from their power distribution system.

## What it does

- Displays separate voltage, current, remaining capacity, and battery percentage readings for both batteries.
- Helps compare the load and remaining capacity of the two supplies.
- Includes receiver signal strength and receiver battery readings.
- Provides a configurable low remaining-capacity alert.

## Setup

Assign each supply's voltage, current, and consumed-capacity sensors. Enter the two battery capacities and configure the low-battery threshold and alert interval.

Copy the complete `PB` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
