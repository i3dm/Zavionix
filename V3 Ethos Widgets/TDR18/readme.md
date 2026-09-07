# Zavionix TDR18

Receiver power telemetry dashboard for FrSky radios running Ethos.

TDR18 provides a power-monitoring screen for a TDR18 receiver installation, combining two battery voltage readings with current and consumed-capacity telemetry.

## What it does

- Displays both supply voltages, current, and remaining battery capacity.
- Uses the configured capacities of both batteries with a shared consumed-capacity source to calculate their remaining capacity.
- Includes receiver signal strength and receiver battery telemetry.
- Provides a configurable low remaining-capacity alert.

## Setup

Assign the two voltage sources and the shared current and capacity sources. Enter both battery capacities, select the receiver telemetry sources, and configure the low-battery alert.

Copy the complete `TDR18` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
