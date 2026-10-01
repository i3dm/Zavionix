# Zavionix ARcombined

Copy this entire `ARcombined` folder to the radio's `/scripts/ARcombined` folder, restart
the radio, and add **Zavionix ARcombined** as a full-screen widget.

At the top of its configuration menu, **Widget Display** selects **AR** (the
default) or **AR pro**. The remaining menu and display are supplied by the
corresponding original V3.1.12 widget. Changing the selection immediately
rebuilds the menu. Each mode keeps its own battery and sensor settings, and
the selection and both configurations are saved with the widget.

All images and the low-battery sound are included; ARcombined does not require AR
or ARpro to be installed. Both modes share exactly two calculated sensors:
**ARcombined Batt1 %** and **ARcombined Batt2 %**, with the same sensor IDs in both modes.
Switching modes reuses these sensors. Their IDs are separate from AR and ARpro.

`ar.lua` and `arpro.lua` are copied from AR and ARpro with the calculated sensor
names and IDs updated. ARpro's sound path uses the bundled `LowBat.wav`.

ARcombined uses the same lazy loader as ARpro: main.lua registers a lightweight
widget; the first paint, configure, read, write, or wakeup callback loads
widget_impl.lua and replaces the proxies with direct callbacks. Creation alone
does not load either display implementation. The read callback restores both
modes' settings. All loader files are included in this standalone folder.
