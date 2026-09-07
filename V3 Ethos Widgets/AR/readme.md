# Zavionix AR

Dual-battery telemetry dashboard for FrSky radios running Ethos.

AR brings the main readings from a model's two battery supplies onto one screen, making it easy to compare their condition during a flight.

## What it does

- Displays voltage, current, remaining capacity in mAh, and a battery percentage for each supply.
- Shows receiver signal strength and receiver battery telemetry alongside the battery readings.
- Provides a configurable low remaining-capacity alert.

## Setup

Assign the voltage, current, and consumed-capacity sources for each battery, enter each battery's capacity, and set the low-battery threshold and alert interval.

Copy the complete `AR` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
