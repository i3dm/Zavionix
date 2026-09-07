# Zavionix Heli

Electric helicopter telemetry dashboard for FrSky radios running Ethos.

Heli combines flight battery monitoring with helicopter RPM, temperature, and flight mode information on a single screen.

## What it does

- Displays battery voltage, current, remaining capacity, and battery percentage.
- Adds RPM, temperature, and the selected flight mode source.
- Supports LiPo, HV LiPo, Li-ion, and LiFe battery settings and a configurable cell count.
- Includes receiver signal strength, receiver battery readings, and a configurable low-battery alert.

## Setup

Configure the flight battery's chemistry, cell count, and capacity. Assign voltage, current, consumption, RPM, temperature, and flight mode sources, then set the battery alert parameters.

Copy the complete `Heli` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) and the installation manual included in this folder for more details. Displayed readings depend on the telemetry provided by your model.

## Screenshot

<img width="1147" height="692" alt="Zavionix Heli widget showing helicopter telemetry" src="https://github.com/user-attachments/assets/f2b654ff-a83b-4eb3-8ea4-10c626e4b67a" />
