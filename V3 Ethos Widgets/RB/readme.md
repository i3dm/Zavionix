# Zavionix RB

Redundant battery telemetry dashboard for FrSky radios running Ethos.

RB provides an overview of a model's redundant battery supplies, with separate readings for each side of the power system.

## What it does

- Displays voltage, current, remaining capacity, and battery percentage for each battery.
- Makes it easy to compare both power supplies on the same screen.
- Includes receiver signal strength and receiver battery telemetry.
- Provides a configurable low remaining-capacity alert.

## Setup

Assign the two sets of voltage, current, and consumed-capacity telemetry sources. Enter each battery's capacity and configure the low-battery threshold and alert interval.

Copy the complete `RB` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
