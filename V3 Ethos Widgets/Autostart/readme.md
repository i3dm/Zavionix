# Zavionix Autostart

Start and cooling control for manually started turbines for FrSky radios running Ethos.

Autostart is designed for older turbines with separate RC-controlled starter and glow-plug controllers. Using RPM and exhaust gas temperature (EGT) telemetry from an RDT sensor, it reproduces the starting and cooling sequences normally handled by a turbine ECU.

## What it does

- Sequences the starter and igniter during starting and runs the starter during cooling.
- Provides configurable start and stop switches, starter and igniter output levels, timing, ignition timeout, and self-sustaining RPM.
- Offers touchscreen controls and displays turbine telemetry and sequence status.
- Provides starter and igniter sources for use in the model's mixer configuration.

## Setup

Assign RPM and EGT telemetry, configure the start/stop controls and sequence parameters for your turbine, and map the widget's starter and igniter sources to the appropriate controller channels.

Copy the complete `Autostart` folder to the radio's `scripts` folder, add the widget to a screen, and open **Configure Widget** to select your sources and settings. Use a full-screen layout.

See the [V3 widget installation instructions](../readme.md#installation) for more details. Displayed readings depend on the telemetry provided by your model.
