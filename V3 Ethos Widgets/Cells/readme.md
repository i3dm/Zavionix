# Zavionix Cells

Individual battery cell monitor for FrSky radios running Ethos.

Cells displays individual cell voltages so you can spot a weak cell and monitor the condition of a battery pack.

## What it does

- Supports packs with up to eight cells.
- Shows individual cell voltages, total pack voltage, and a battery percentage estimate.
- Provides separate configurable alerts for low pack voltage and low cell voltage.
- Supports different widget sizes and an adjustable font size.

## Setup

Assign a compatible cell-voltage telemetry sensor using the Lipo Sensor setting. Select the battery type, pack and cell voltage thresholds, alert interval, and font size.

Copy the complete `Cells` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Choose a widget area and font size that suit your screen.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
