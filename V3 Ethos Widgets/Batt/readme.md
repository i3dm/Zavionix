# Zavionix Batt

Flight battery telemetry dashboard for FrSky radios running Ethos.

Batt provides a dedicated overview of an electric model's flight battery, helping you track power use and remaining capacity.

## What it does

- Displays pack voltage, current, remaining capacity in mAh, and battery percentage.
- Supports LiPo, HV LiPo, Li-ion, and LiFe battery settings, with a configurable cell count.
- Shows receiver signal strength and receiver battery telemetry.
- Provides a configurable low remaining-capacity alert.

## Setup

Select the battery chemistry, cell count, and pack capacity. Assign voltage, current, and consumed-capacity telemetry sources, then set the low-battery threshold and alert interval.

Copy the complete `Batt` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.
