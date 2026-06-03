-- ********************************************************************************
-- **  Zavionixֲ® LZBAT Widget Screen (LZ-BAT)                                    **
-- ********************************************************************************
-- **  Author: Lior Zahavi (i3dm)ֲ®  February 2022, Email: zavionixrc@gmail.com   **
-- **  1. Widget is free to use for personal use, and its not allowed to         **
-- **  distribute or forward it to anyone else. If anyone else needs it, please  **
-- **  give him my email address and ask him to contact me.                      **
-- **  2. Widgets are given for FREE as a gift from me to the RC community which **
-- **  I love so much. If you do like to send a donation to cover some of the    **
-- **  huge amount of hours put into the development, it is always very          **
-- **  appreciated and you may do so via paypal:   i3dm@hotmail.com              **
-- ********************************************************************************

--[[
V2.0.5 - moved low battery alert to wakeup
V2.1.0 - Added GetSensorValue
V2.1.1 - changed imagepath to "img" (relative path)
V2.1.2 - removed Done_Painting logic
V2.1.3 - added version to widget menu (configure(widget))
V2.1.4 - added X14 support
V2.1.4 - fixed bug of MinCellVoltage and MaxCellVoltage ~=nil for X18
V2.1.5 - fixed no path for LowBat.wav
V3.0.1 - memory optimizations
]]--

local _ENV = setmetatable({}, {__index = _ENV})
BATversion = "V3.0.3"

PERCENT_SENSOR_REFRESH_INTERVAL = 1
percentSensors = {
	{name = "Batt %", appId = 0x0120, physId = 0x20, lastPush = 0}
}

widgetDefaults = {
	Batt_Type = 0,
	BATBattCapacity = 3000,
	BATLowBattAlert = 1000,
	BATBattAlertOnOff = true,
	BATLowBattCycleTime = 5,
	BAT_Num_Of_Cells = 3
}

drawBitmap = lcd.drawBitmap
drawRectangle = lcd.drawRectangle
drawFilledRectangle = lcd.drawFilledRectangle
drawText = lcd.drawText
drawNumber = lcd.drawNumber


getSource = system.getSource
getTime = os.clock
fmt = string.format
floor = math.floor

-- Pre-define static colors outside the loop to prevent RAM churn
batt_color = {
    [0] = lcd.RGB(210,9,9),  [1] = lcd.RGB(210,9,9),  [2] = lcd.RGB(210,9,9),
    [3] = lcd.RGB(211,98,0), [4] = lcd.RGB(211,98,0),
    [5] = lcd.RGB(248,203,0), [6] = lcd.RGB(248,203,0),
    [7] = lcd.RGB(138,183,0), [8] = lcd.RGB(138,183,0),
    [9] = lcd.RGB(23, 207, 20), [10] = lcd.RGB(23, 207, 20)
}

--local BATDone_Painting = false
Time_Temp = 0
newValue = 0
BATcount = 0
BATCyclesCounter = 0
BATbgcount = 0
BATwidgetTime = 0
imagePath = "img"
audioPath = "/"
BATRSSI1sensor = nil
BATRSSI2sensor = nil
BATRxbatt1sensor = nil
BATRxbatt2sensor = nil
RSSI1Value = nil
RSSI2Value = nil
RSSI1 = nil
RSSI2 = nil
RxBatt1Value = nil
RxBatt1 = nil
RxBatt2 = nil
TxBatt = nil
mdlimage = nil
screenSize = nil
timer = nil
TimerDigit1 = nil
TimerDigit2 = nil
TimerDigit3 = nil
TimerDigit4 = nil
BATVsensor = nil
BATAsensor = nil
BATCsensor = nil
BATVvalue = nil
BATAsensor = nil
BATCsensor = nil
mah_level = nil
BATBattCapacity = widgetDefaults.BATBattCapacity
BATCvalue = nil
BATLowBattAlert = widgetDefaults.BATLowBattAlert
BATBattAlertOnOff = widgetDefaults.BATBattAlertOnOff
Batt_warning = nil
Batt_Percentage = nil
paint_rate_Hz = 3 -- invalidate / paint LCD every paint_rate_Hz
Battery_connected_Flag = false
LipoPackVoltage = 0
BAT_Num_Of_Cells = widgetDefaults.BAT_Num_Of_Cells
Max_Lipo_Cell_Voltage = 4.40
battimage = nil
BATRSSI1sensor_old = ''
BATRSSI2sensor_old = ''
BATRxbatt1sensor_old = ''
BATRxbatt2sensor_old = ''
Batt_Type = widgetDefaults.Batt_Type
Batt_Type_old = 1
BATVsensor_old = ''
BATAsensor_old = ''
BATCsensor_old = ''
timer = system.getSource({category=CATEGORY_TIMER, member=0, options=0})
timer_x_x20 = 653
timer_y_x20 = 13
timer_x_x18 = 386
timer_y_x18 = 10
fullScreenFlag = true
window_height = nil
window_width = nil
Screen_height = nil
Screen_width = nil
screenCheckTime = 0
screenCheckPeriod = 1
screenAssetSize = nil
MaxCellVoltage = nil
MinCellVoltage = nil
myArrayPercentList = {{ 3, 0 }, { 3.093, 1 }, { 3.196, 2 }, { 3.301, 3 }, { 3.401, 4 }, { 3.477, 5 }, { 3.544, 6 }, { 3.601, 7 }, { 3.637, 8 }, { 3.664, 9 }, { 3.679, 10 }, { 3.683, 11 }, { 3.689, 12 }, { 3.692, 13 }, { 3.705, 14 }, { 3.71, 15 }, { 3.713, 16 }, { 3.715, 17 }, { 3.72, 18 }, { 3.731, 19 }, { 3.735, 20 }, { 3.744, 21 }, { 3.753, 22 }, { 3.756, 23 }, { 3.758, 24 }, { 3.762, 25 }, { 3.767, 26 }, { 3.774, 27 }, { 3.78, 28 }, { 3.783, 29 }, { 3.786, 30 }, { 3.789, 31 }, { 3.794, 32 }, { 3.797, 33 }, { 3.8, 34 }, { 3.802, 35 }, { 3.805, 36 }, { 3.808, 37 }, { 3.811, 38 }, { 3.815, 39 }, { 3.818, 40 }, { 3.822, 41 }, { 3.825, 42 }, { 3.829, 43 }, { 3.833, 44 }, { 3.836, 45 }, { 3.84, 46 }, { 3.843, 47 }, { 3.847, 48 }, { 3.85, 49 }, { 3.854, 50 }, { 3.857, 51 }, { 3.86, 52 }, { 3.863, 53 }, { 3.866, 54 }, { 3.87, 55 }, { 3.874, 56 }, { 3.879, 57 }, { 3.888, 58 }, { 3.893, 59 }, { 3.897, 60 }, { 3.902, 61 }, { 3.906, 62 }, { 3.911, 63 }, { 3.918, 64 }, { 3.923, 65 }, { 3.928, 66 }, { 3.939, 67 }, { 3.943, 68 }, { 3.949, 69 }, { 3.955, 70 }, { 3.961, 71 }, { 3.968, 72 }, { 3.974, 73 }, { 3.981, 74 }, { 3.987, 75 }, { 3.994, 76 }, { 4.001, 77 }, { 4.007, 78 }, { 4.014, 79 }, { 4.021, 80 }, { 4.029, 81 }, { 4.036, 82 }, { 4.044, 83 }, { 4.052, 84 }, { 4.062, 85 }, { 4.074, 86 }, { 4.085, 87 }, { 4.095, 88 }, { 4.105, 89 }, { 4.111, 90 }, { 4.116, 91 }, { 4.12, 92 }, { 4.125, 93 }, { 4.129, 94 }, { 4.135, 95 }, { 4.145, 96 }, { 4.176, 97 }, { 4.179, 98 }, { 4.193, 99 }, { 4.2, 100 }}
BATLowBattCycleTime = widgetDefaults.BATLowBattCycleTime

--===================================================
-- GetSensorValue - returns 0 if sensor is nil
--===================================================
local function getSensorValue(sensor)
	-- catch no sensor provided
		if sensor == nil then
			return 0
		end
	-- catch value is nil
	local v = sensor:value()
		if v == nil then
			return 0
		end
	return v
end

local function valueOrDefault(value, default)
	if value == nil then
		return default
	end
	return value
end

local function numberOrDefault(value, default, minValue, maxValue)
	local numberValue = tonumber(value)
	if numberValue == nil then
		return default
	end
	if minValue ~= nil and numberValue < minValue then
		return default
	end
	if maxValue ~= nil and numberValue > maxValue then
		return default
	end
	return numberValue
end

local function setFieldDefault(field, value)
	if field ~= nil and type(field.default) == "function" then
		field:default(value)
	end
end

local function clampPercent(value)
	local percent = tonumber(value)
	if percent == nil then
		return nil
	end
	if percent < 0 then
		return 0
	end
	if percent > 100 then
		return 100
	end
	return percent
end

local function ensurePercentSensor(sensorState)
	if sensorState.sensor ~= nil then
		return sensorState.sensor
	end

	sensorState.sensor = getSource({category = CATEGORY_TELEMETRY_SENSOR, appId = sensorState.appId})
	if sensorState.sensor ~= nil then
		if type(sensorState.sensor.unit) == "function" then sensorState.sensor:unit(UNIT_PERCENT) end
		if type(sensorState.sensor.decimals) == "function" then sensorState.sensor:decimals(0) end
		if type(sensorState.sensor.minimum) == "function" then sensorState.sensor:minimum(0) end
		if type(sensorState.sensor.maximum) == "function" then sensorState.sensor:maximum(100) end
		if type(sensorState.sensor.protocolUnit) == "function" then sensorState.sensor:protocolUnit(UNIT_PERCENT) end
		if type(sensorState.sensor.protocolDecimals) == "function" then sensorState.sensor:protocolDecimals(0) end
		return sensorState.sensor
	end

	local ok, sensor = pcall(model.createSensor, {type = SENSOR_TYPE_DIY})
	if not ok or sensor == nil then
		ok, sensor = pcall(model.createSensor)
	end
	if not ok or sensor == nil then
		return nil
	end

	sensor:name(sensorState.name)
	sensor:unit(UNIT_PERCENT)
	sensor:decimals(0)
	sensor:appId(sensorState.appId)
	sensor:physId(sensorState.physId)
	if type(sensor.minimum) == "function" then sensor:minimum(0) end
	if type(sensor.maximum) == "function" then sensor:maximum(100) end
	if type(sensor.protocolUnit) == "function" then sensor:protocolUnit(UNIT_PERCENT) end
	if type(sensor.protocolDecimals) == "function" then sensor:protocolDecimals(0) end

	sensorState.sensor = sensor
	return sensorState.sensor
end

local function pushPercentSensorValue(sensor, value)
	if sensor == nil then
		return
	end

	local ok = false
	if type(sensor.rawValue) == "function" then
		ok = pcall(sensor.rawValue, sensor, value)
	end
	if not ok and type(sensor.value) == "function" then
		pcall(sensor.value, sensor, value)
	end
end

local function updatePercentSensor(sensorState, value)
	local percent = clampPercent(value)
	if percent == nil then
		return
	end

	local sensor = ensurePercentSensor(sensorState)
	local now = getTime()
	if sensorState.lastValue ~= percent or (now - sensorState.lastPush) >= PERCENT_SENSOR_REFRESH_INTERVAL then
		pushPercentSensorValue(sensor, percent)
		sensorState.lastValue = percent
		sensorState.lastPush = now
	end
end
local function sourceNameOrNil(source)
	if source == nil then
		return nil
	end

	if type(source) == "string" then
		return source
	end
	if type(source) ~= "table" and type(source) ~= "userdata" then
		return nil
	end

	local ok, name = pcall(source.name, source)

	if ok and name ~= nil then
		return name
	end

	return nil
end

local function sourceObjectOrNil(source)
	if source == nil or type(source) == "string" then
		return nil
	end
	if type(source) ~= "table" and type(source) ~= "userdata" then
		return nil
	end

	local ok = pcall(source.value, source)

	if ok then
		return source
	end

	return nil
end

local function resolveSource(source, sourceName)
	local sourceObject = sourceObjectOrNil(source)
	if sourceObject ~= nil then
		return sourceObject
	end

	if sourceName == nil then
		return nil
	end

	local ok, resolved = pcall(getSource, sourceName)
	if ok then
		return resolved
	end

	return nil
end

local function sourceNameContains(source, pattern)
	local sourceName = sourceNameOrNil(source)
	if sourceName == nil then
		return false
	end
	return string.find(string.lower(sourceName), pattern, 1, true) ~= nil
end

local function repairShiftedSourceFields(widget)
	if widget.BATVsource ~= nil or widget.BATAsource == nil then
		return
	end

	if not sourceNameContains(widget.BATAsource, "volt") then
		return
	end

	widget.BATVsource = widget.BATAsource
	widget.BATAsource = widget.BATCsource
	widget.BATCsource = widget.BATRSSI1source
	widget.BATRSSI1source = widget.BATRSSI2source
	widget.BATRSSI2source = widget.BATRxbatt1source
	widget.BATRxbatt1source = widget.BATRxbatt2source
	widget.BATRxbatt2source = nil
end

local function ensureWidgetDefaults(widget)
	widget.Batt_Type = numberOrDefault(widget.Batt_Type, widgetDefaults.Batt_Type, 0, 3)
	widget.BATBattCapacity = numberOrDefault(widget.BATBattCapacity, widgetDefaults.BATBattCapacity, 1, 50000)
	widget.BATLowBattAlert = numberOrDefault(widget.BATLowBattAlert, widgetDefaults.BATLowBattAlert, 1, 50000)
	widget.BATBattAlertOnOff = valueOrDefault(widget.BATBattAlertOnOff, widgetDefaults.BATBattAlertOnOff)
	widget.BATLowBattCycleTime = numberOrDefault(widget.BATLowBattCycleTime, widgetDefaults.BATLowBattCycleTime, 1, 10)
	widget.BAT_Num_Of_Cells = numberOrDefault(widget.BAT_Num_Of_Cells, widgetDefaults.BAT_Num_Of_Cells, 1, 14)
end

--===================================================
local function updateBatteryPercentSensorFromTelemetry()
	if BATC == nil or BATBattCapacity == nil or BATBattCapacity <= 0 then
		return
	end

	local consumed = getSensorValue(BATC)
	updatePercentSensor(percentSensors[1], ((BATBattCapacity - consumed) / BATBattCapacity) * 100)
end
-- Draw the Top Bar
--===================================================
local function draw_Top_Bar(Me)

	if screenSize == "X20fullScreenWithTitle" or screenSize == "X20fullScreen" then
	lcd.font(FONT_L)
	drawText(360,10,"RSSI")
	drawText(463,10,"RxBatt")
	drawText(570,10,"TxBatt")
	lcd.font(FONT_L)

		if BATRSSI1sensor ~= nil then
			if BATRSSI1sensor_old ~= BATRSSI1sensor then
				RSSI1 = system.getSource (BATRSSI1sensor)
				BATRSSI1sensor_old = BATRSSI1sensor
			end
		else
			RSSI1 = nil
		end

		if (RSSI1 == nil) then
		lcd.font(FONT_S)
		drawText (360, 35, "No RSSI1")
		else
		RSSI1Value = getSensorValue(RSSI1)
		drawNumber (360, 35, RSSI1Value,UNIT_DB)
		end

		if BATRSSI2sensor ~= nil then
			if BATRSSI2sensor_old ~= BATRSSI2sensor then
				RSSI2 = system.getSource (BATRSSI2sensor)
				BATRSSI2sensor_old = BATRSSI2sensor
			end
		else
			RSSI2 = nil

		end
		if (RSSI2 == nil) then
		lcd.font(FONT_S)
		--drawText (360, 59, "No RSSI2")
		else
		RSSI2Value = getSensorValue(RSSI2)
		drawNumber (360, 59, RSSI2Value,UNIT_DB)
		end

		if BATRxbatt1sensor ~= nil then
			if BATRxbatt1sensor_old ~= BATRxbatt1sensor then
				RxBatt1 = system.getSource (BATRxbatt1sensor)
				BATRxbatt1sensor_old = BATRxbatt1sensor
			end
		else
			RxBatt1 = nil
		end

		if BATRxbatt2sensor ~= nil then
			if BATRxbatt2sensor_old ~= BATRxbatt2sensor then
				RxBatt2 = system.getSource (BATRxbatt2sensor)
				BATRxbatt2sensor_old = BATRxbatt2sensor
			end
		else
			RxBatt2 = nil
		end

		if (RxBatt1 == nil) then
		lcd.font(FONT_S)
		drawText (463, 35, "No RxBt")
		else
		RxBatt1Value = getSensorValue(RxBatt1)
		lcd.font(FONT_L)
		drawText(463, 35,(string.format("%.1f", (RxBatt1Value))).."V")
		end

		if (RxBatt2 == nil) then
		--d0 nothing
		else
		RxBatt2Value = getSensorValue(RxBatt2)
		lcd.font(FONT_L)
		drawText(463, 59,(string.format("%.1f", (RxBatt2Value))).."V")
		end




		if (TxBatt == nil) then
		lcd.font(FONT_S)
		drawText(570,35,"No TxBt")
		else
		TxBattValue = getSensorValue(TxBatt)
		lcd.font(FONT_L)
		drawText(570, 35, getSensorValue(TxBatt).."V")
		end

		elseif  screenSize == "X10fullScreen" or screenSize == "X18fullScreen" or screenSize == "X14fullScreen" then --X10 X18 X14
		local rssiX = 215
		local rxBattX = 278
		local txBattX = 330
		if screenSize == "X14fullScreen" then
			rssiX = 250
			rxBattX = 335
			txBattX = 430
		end
		lcd.font(FONT_S)
		drawText(rssiX,10,"RSSI")
		drawText(rxBattX,10,"RxBatt")
		drawText(txBattX,10,"TxBatt")
		lcd.font(FONT_L)

		if BATRSSI1sensor ~= nil then
			if BATRSSI1sensor_old ~= BATRSSI1sensor then
				RSSI1 = system.getSource (BATRSSI1sensor)
				BATRSSI1sensor_old = BATRSSI1sensor
			end
		else
			RSSI1 = nil
		end

		if (RSSI1 == nil) then
		lcd.font(FONT_S)
		drawText (rssiX, 29, "No RSSI1")
		else
		RSSI1Value = getSensorValue(RSSI1)
		drawNumber (rssiX, 29, RSSI1Value,UNIT_DB)
		end

		if BATRSSI2sensor ~= nil then
			if BATRSSI2sensor_old ~= BATRSSI2sensor then
				RSSI2 = system.getSource (BATRSSI2sensor)
				BATRSSI2sensor_old = BATRSSI2sensor
			end
		else
			RSSI2 = nil

		end		if (RSSI2 == nil) then
		lcd.font(FONT_S)
		--drawText (360, 53, "No RSSI2")
		else
		RSSI2Value = getSensorValue(RSSI2)
		drawNumber (rssiX, 48, (string.format("%.0f", (RSSI2Value))),UNIT_DB)
		end

		if BATRxbatt1sensor ~= nil then
			if BATRxbatt1sensor_old ~= BATRxbatt1sensor then
				RxBatt1 = system.getSource (BATRxbatt1sensor)
				BATRxbatt1sensor_old = BATRxbatt1sensor
			end
		else
			RxBatt1 = nil
		end

		if BATRxbatt2sensor ~= nil then
			if BATRxbatt2sensor_old ~= BATRxbatt2sensor then
				RxBatt2 = system.getSource (BATRxbatt2sensor)
				BATRxbatt2sensor_old = BATRxbatt2sensor
			end
		else
			RxBatt2 = nil
		end

		if (RxBatt1 == nil) then
		lcd.font(FONT_S)
		drawText (rxBattX, 29, "No RxBt")
		else
		RxBatt1Value = getSensorValue(RxBatt1)
		lcd.font(FONT_L)
		drawText(rxBattX, 29,(string.format("%.1f", (RxBatt1Value))).."V")
		end

		if (RxBatt2 == nil) then
		--do nothing
		else
		RxBatt2Value = getSensorValue(RxBatt2)
		lcd.font(FONT_L)
		drawText(rxBattX, 48,(string.format("%.1f", (RxBatt2Value))).."V")
		end

		if (TxBatt == nil) then
		lcd.font(FONT_S)
		drawText(txBattX,29,"No TxBt")
		else
		TxBattValue = getSensorValue(TxBatt)
		lcd.font(FONT_L)
		drawText(txBattX, 29, getSensorValue(TxBatt).."V")
		end
	end
end

--===================================================
-- Draw Model Name
--===================================================
local function draw_Model_Name(Me)
	if  screenSize == "X20fullScreen" then
	lcd.font(FONT_XXL)
	drawText(25,10,model.name())
	model_name = (model.name())
	elseif  screenSize == "X10fullScreen" or screenSize == "X18fullScreen" or screenSize == "X14fullScreen" then --X10 X18
	lcd.font(FONT_XXL)
	drawText(25,10,model.name())
	model_name = (model.name())
	end
end

--===================================================
-- Draw Background
--===================================================
local function draw_Background(Me)

	BATbgcount = BATbgcount + 1

	if (screenSize == "X20fullScreen") then
		-- draw wallpaper
		--drawBitmap(0, 0, BAT_wallpaper_mask)
		drawBitmap(0, 0, wallpaper_mask)  drawBitmap(89, 0, wallpaper_mask)   drawBitmap(179, 0, wallpaper_mask)  drawBitmap(269, 0, wallpaper_mask)   drawBitmap(359, 0, wallpaper_mask)   drawBitmap(449, 0, wallpaper_mask)   drawBitmap(539, 0, wallpaper_mask)   drawBitmap(629, 0, wallpaper_mask) drawBitmap(719, 0, wallpaper_mask)
		drawBitmap(-77, 122,wallpaper_mask)drawBitmap(13, 122,wallpaper_mask) drawBitmap(103, 122, wallpaper_mask) drawBitmap(193, 122, wallpaper_mask) drawBitmap(283, 122, wallpaper_mask) drawBitmap(373, 122, wallpaper_mask) drawBitmap(463, 122, wallpaper_mask) drawBitmap(553, 122, wallpaper_mask) drawBitmap(643, 122, wallpaper_mask) drawBitmap(733, 122, wallpaper_mask)
		drawBitmap(-64, 244,wallpaper_mask) drawBitmap(26, 244,wallpaper_mask) drawBitmap(116, 244, wallpaper_mask) drawBitmap(206, 244, wallpaper_mask) drawBitmap(296, 244, wallpaper_mask) drawBitmap(386, 244, wallpaper_mask) drawBitmap(476, 244, wallpaper_mask) drawBitmap(566, 244, wallpaper_mask) drawBitmap(656, 244, wallpaper_mask) drawBitmap(746, 244, wallpaper_mask)
		drawBitmap(-51, 366,wallpaper_mask) drawBitmap(39, 366,wallpaper_mask) drawBitmap(129, 366, wallpaper_mask) drawBitmap(219, 366, wallpaper_mask) drawBitmap(309, 366, wallpaper_mask) drawBitmap(399, 366, wallpaper_mask) drawBitmap(489, 366, wallpaper_mask) drawBitmap(579, 366, wallpaper_mask) drawBitmap(669, 366, wallpaper_mask) drawBitmap(759, 366, wallpaper_mask)
		drawBitmap(270, 380, Zavionix)
		drawBitmap(440, 6, Batt_Icon)
		drawBitmap(552, 6, Batt_Icon)
		drawBitmap(305, 7, RSSI_Icon)
		--draw model image frame
		--model image is at 35,97
		drawBitmap(34, 94,X20_image_frame)
		--draw timer frame
		--lcd.color(lcd.RGB(40, 40, 40)) --  dark grey
		--drawFilledRectangle	(timer_x_x20-4,timer_y_x20-3,145,58)
		lcd.color(WHITE)
	elseif (screenSize == "X10fullScreen") then
		-- draw wallpaper
		--drawBitmap(0, 0, BAT_wallpaper_mask)
		drawBitmap(0, 0, wallpaper_mask)  drawBitmap(89, 0, wallpaper_mask)   drawBitmap(179, 0, wallpaper_mask)  drawBitmap(269, 0, wallpaper_mask)   drawBitmap(359, 0, wallpaper_mask)   drawBitmap(449, 0, wallpaper_mask)   drawBitmap(539, 0, wallpaper_mask)   drawBitmap(629, 0, wallpaper_mask) drawBitmap(719, 0, wallpaper_mask)
		drawBitmap(-77, 122,wallpaper_mask)drawBitmap(13, 122,wallpaper_mask) drawBitmap(103, 122, wallpaper_mask) drawBitmap(193, 122, wallpaper_mask) drawBitmap(283, 122, wallpaper_mask) drawBitmap(373, 122, wallpaper_mask) drawBitmap(463, 122, wallpaper_mask) drawBitmap(553, 122, wallpaper_mask) drawBitmap(643, 122, wallpaper_mask) drawBitmap(733, 122, wallpaper_mask)
		drawBitmap(-64, 244,wallpaper_mask) drawBitmap(26, 244,wallpaper_mask) drawBitmap(116, 244, wallpaper_mask) drawBitmap(206, 244, wallpaper_mask) drawBitmap(296, 244, wallpaper_mask) drawBitmap(386, 244, wallpaper_mask) drawBitmap(476, 244, wallpaper_mask) drawBitmap(566, 244, wallpaper_mask) drawBitmap(656, 244, wallpaper_mask) drawBitmap(746, 244, wallpaper_mask)
		drawBitmap(150, 200, Zavionix)
		drawBitmap(265, 6, Batt_Icon)
		drawBitmap(190, 7, RSSI_Icon)
		--model image is at 20,50
		drawBitmap(19, 47,X18_image_frame)
		lcd.color(WHITE)
	elseif (screenSize == "X18fullScreen") or (screenSize == "X14fullScreen") then
		-- draw wallpaper
		--drawBitmap(0, 0, BAT_wallpaper_mask)
		drawBitmap(0, 0, wallpaper_mask)  drawBitmap(89, 0, wallpaper_mask)   drawBitmap(179, 0, wallpaper_mask)  drawBitmap(269, 0, wallpaper_mask)   drawBitmap(359, 0, wallpaper_mask)   drawBitmap(449, 0, wallpaper_mask)   drawBitmap(539, 0, wallpaper_mask)   drawBitmap(629, 0, wallpaper_mask) drawBitmap(719, 0, wallpaper_mask)
		drawBitmap(-77, 122,wallpaper_mask)drawBitmap(13, 122,wallpaper_mask) drawBitmap(103, 122, wallpaper_mask) drawBitmap(193, 122, wallpaper_mask) drawBitmap(283, 122, wallpaper_mask) drawBitmap(373, 122, wallpaper_mask) drawBitmap(463, 122, wallpaper_mask) drawBitmap(553, 122, wallpaper_mask) drawBitmap(643, 122, wallpaper_mask) drawBitmap(733, 122, wallpaper_mask)
		drawBitmap(-64, 244,wallpaper_mask) drawBitmap(26, 244,wallpaper_mask) drawBitmap(116, 244, wallpaper_mask) drawBitmap(206, 244, wallpaper_mask) drawBitmap(296, 244, wallpaper_mask) drawBitmap(386, 244, wallpaper_mask) drawBitmap(476, 244, wallpaper_mask) drawBitmap(566, 244, wallpaper_mask) drawBitmap(656, 244, wallpaper_mask) drawBitmap(746, 244, wallpaper_mask)
		if screenSize == "X14fullScreen" then
		drawBitmap(425, 280, Zavionix)
		drawBitmap(320, 6, Batt_Icon)
		drawBitmap(415, 6, Batt_Icon)
		drawBitmap(220, 7, RSSI_Icon)
		else
		drawBitmap(150, 220, Zavionix)
		drawBitmap(265, 6, Batt_Icon)
		drawBitmap(190, 7, RSSI_Icon)
		end
		if screenSize == "X14fullScreen" then
		--model image is at 20,80
		drawBitmap(19, 77,X18_image_frame)
		else
		--model image is at 20,50
		drawBitmap(19, 47,X18_image_frame)
		end
		lcd.color(WHITE)
		end
end

--===================================================
-- Draw the Timer
--===================================================
local function draw_Timer(Me)
if  screenSize == "X20fullScreen" then

    if (getSensorValue(timer) == nil) then
	drawBitmap(timer_x_x20,timer_y_x20,digits_blue[0])
	drawBitmap(timer_x_x20+32,timer_y_x20,digits_blue[0])
	drawBitmap(timer_x_x20+62,timer_y_x20,digits_blue[11])
	drawBitmap(timer_x_x20+72,timer_y_x20,digits_blue[0])
	drawBitmap(timer_x_x20+104,timer_y_x20,digits_blue[0])
	elseif (getSensorValue(timer) > 0) and (getSensorValue(timer) < 3600) then
	timer_Secs =  getSensorValue(timer) % 60
	timer_Mins = ((getSensorValue(timer) - timer_Secs) / 60)
	TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	TimerDigit2 = timer_Mins - (TimerDigit1*10)
	TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	TimerDigit4 = timer_Secs - (TimerDigit3*10)

	drawBitmap(timer_x_x20,timer_y_x20,digits_blue[TimerDigit1])
	drawBitmap(timer_x_x20+32,timer_y_x20,digits_blue[TimerDigit2])
	drawBitmap(timer_x_x20+62,timer_y_x20,digits_blue[11])
	drawBitmap(timer_x_x20+72,timer_y_x20,digits_blue[TimerDigit3])
	drawBitmap(timer_x_x20+104,timer_y_x20,digits_blue[TimerDigit4])
	elseif (getSensorValue(timer) <= 0) and (getSensorValue(timer) > -3599) then
	timer_Secs =  (getSensorValue(timer) * (-1)) % 60
	timer_Mins =  ((getSensorValue(timer)*(-1) - timer_Secs) / 60)
	TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	TimerDigit2 = timer_Mins - (TimerDigit1*10)
	TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	TimerDigit4 = timer_Secs - (TimerDigit3*10)
	drawBitmap(timer_x_x20,timer_y_x20,digits_red[TimerDigit1])
	drawBitmap(timer_x_x20+32,timer_y_x20,digits_red[TimerDigit2])
	drawBitmap(timer_x_x20+62,timer_y_x20,digits_red[11])
	drawBitmap(timer_x_x20+72,timer_y_x20,digits_red[TimerDigit3])
	drawBitmap(timer_x_x20+104,timer_y_x20,digits_red[TimerDigit4])
	else
	drawBitmap(timer_x_x20,timer_y_x20,digits_blue[10])
	drawBitmap(timer_x_x20+32,timer_y_x20,digits_blue[10])
	drawBitmap(timer_x_x20+62,timer_y_x20,digits_blue[11])
	drawBitmap(timer_x_x20+72,timer_y_x20,digits_blue[10])
	drawBitmap(timer_x_x20+104,timer_y_x20,digits_blue[10])
	end

	elseif  screenSize == "X10fullScreen" or screenSize == "X18fullScreen" or screenSize == "X14fullScreen"  then --X10 X18 X14
	local timerX = timer_x_x18
	local timerY = timer_y_x18
	if screenSize == "X14fullScreen" then
		timerX = 520
	end

    if (getSensorValue(timer) == nil) then
	drawBitmap(timerX,timerY,digits_blue[0])
	drawBitmap(timerX+19,timerY,digits_blue[0])
	drawBitmap(timerX+36,timerY,digits_blue[11])
	drawBitmap(timerX+46,timerY,digits_blue[0])
	drawBitmap(timerX+64,timerY,digits_blue[0])
	elseif (getSensorValue(timer) > 0) and (getSensorValue(timer) < 3600) then
	timer_Secs =  getSensorValue(timer) % 60
	timer_Mins = ((getSensorValue(timer) - timer_Secs) / 60)
	TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	TimerDigit2 = timer_Mins - (TimerDigit1*10)
	TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	TimerDigit4 = timer_Secs - (TimerDigit3*10)

	drawBitmap(timerX,timerY,digits_blue[TimerDigit1])
	drawBitmap(timerX+19,timerY,digits_blue[TimerDigit2])
	drawBitmap(timerX+36,timerY,digits_blue[11])
	drawBitmap(timerX+46,timerY,digits_blue[TimerDigit3])
	drawBitmap(timerX+64,timerY,digits_blue[TimerDigit4])
	elseif (getSensorValue(timer) <= 0) and (getSensorValue(timer) > -3599) then
	timer_Secs =  (getSensorValue(timer) * (-1)) % 60
	timer_Mins =  ((getSensorValue(timer)*(-1) - timer_Secs) / 60)
	TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	TimerDigit2 = timer_Mins - (TimerDigit1*10)
	TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	TimerDigit4 = timer_Secs - (TimerDigit3*10)
	drawBitmap(timerX,timerY,digits_red[TimerDigit1])
	drawBitmap(timerX+19,timerY,digits_red[TimerDigit2])
	drawBitmap(timerX+36,timerY,digits_red[11])
	drawBitmap(timerX+46,timerY,digits_red[TimerDigit3])
	drawBitmap(timerX+64,timerY,digits_red[TimerDigit4])
	else
	drawBitmap(timerX,timerY,digits_blue[10])
	drawBitmap(timerX+19,timerY,digits_blue[10])
	drawBitmap(timerX+36,timerY,digits_blue[11])
	drawBitmap(timerX+46,timerY,digits_blue[10])
	drawBitmap(timerX+64,timerY,digits_blue[10])
	end

end
end

--===================================================
-- Draw Battery Data
--===================================================
local function BATdraw_Battery_Data(Me)


if  screenSize == "X20fullScreen" then
		lcd.color(WHITE)
		lcd.font(FONT_XXL)
		drawText(380,105,"Battery:")
		if BATVsensor ~= nil then
			if BATVsensor_old ~= BATVsensor then
				BATV = system.getSource (BATVsensor)
				BATVsensor_old = BATVsensor
			end
		else
			BATV = nil
		end

			lcd.color(WHITE)
			lcd.font(FONT_L)
			drawText(30,400,"Voltage Percentage:")

			if (BATV == nil) then
			BATVvalue = 0
			--lcd.font(FONT_L)
			--drawText(360,100,"No Volt Percentage")
			lcd.color(WHITE)
			lcd.font(FONT_L)
			drawText(360,160,"No Voltage")
			lcd.font(FONT_XL)
			else
			BATVvalue = getSensorValue(BATV)
			LipoPackVoltage = BATVvalue
			if (MaxCellVoltage ~= nil) and (MinCellVoltage ~= nil) and ((BATVvalue <= BAT_Num_Of_Cells * MaxCellVoltage) and (BATVvalue >= BAT_Num_Of_Cells * MinCellVoltage)) then
				for i, v in ipairs(myArrayPercentList) do
				  if v[1] * BAT_Num_Of_Cells  >= LipoPackVoltage then
				  Voltage_Percentage = v[2]
				  break
				  end
				end

			lcd.font(FONT_XL)
			drawText(125,430,(string.format("%.0f", Voltage_Percentage).."%"))
			elseif (BATVvalue == 0) then -- voltage 0
			lcd.font(FONT_XL)
			lcd.color(RED)
			drawText(125,430,"0%")
			lcd.color(WHITE)
			elseif (MaxCellVoltage ~= nil) and  (BATVvalue >= BAT_Num_Of_Cells * MaxCellVoltage) then -- battery over voltage
			lcd.font(FONT_XL)
			lcd.color(WHITE)
			drawText(125,430,">100%")
			lcd.color(WHITE)
			elseif (MinCellVoltage ~= nil) and  (BATVvalue < BAT_Num_Of_Cells * MinCellVoltage) then -- battery under voltage
			lcd.font(FONT_XL)
			lcd.color(WHITE)
			drawText(125,430,"<0%")
			lcd.color(WHITE)
			else-- voltage out of scope
			lcd.font(FONT_L)
			drawText(55,435,"Out Of Range")
			end

			lcd.font(FONT_XXL)
				if BATVvalue < 3 then
				lcd.color(RED)
				drawText(380,160,(string.format("%.1f",BATVvalue).."v"))
				lcd.color(WHITE)
				else
				lcd.color(WHITE)
				drawText(380,160,(string.format("%.1f",BATVvalue).."v"))
				end
			end

		if BATAsensor ~= nil then
			if BATAsensor_old ~= BATAsensor then
				BATA = system.getSource (BATAsensor)
				BATAsensor_old = BATAsensor
			end
		else
			BATA = nil
		end
			if (BATA == nil) then
			lcd.color(WHITE)
			lcd.font(FONT_L)
			drawText(360,210,("No Current"))
			lcd.font(FONT_XL)
			else
			lcd.color(WHITE)
			BATAvalue = getSensorValue(BATA)
			lcd.font(FONT_XXL)
			drawText(380,210,(string.format("%.1f", BATAvalue).."A"))
			end

		if BATCsensor ~= nil then
			if BATCsensor_old ~= BATCsensor then
				BATC = system.getSource (BATCsensor)
				BATCsensor_old = BATCsensor
			end
		else
			BATC = nil
		end
		if (BATC == nil) then
			lcd.font(FONT_L)
			lcd.color(RED)
			drawText(600,230,"          No ")
			drawText(600,260,"Consumption")
			drawText(600,290,"       Sensor")
			lcd.color(WHITE)
			lcd.font(FONT_L)
			drawText(360,260,("No Consumption"))
			lcd.font(FONT_XL)
			else
			BATCvalue = getSensorValue(BATC)
			lcd.font(FONT_XXL)
				if (Batt_warning == true) then
				--drawFilledRectangle(375,260,195,90,1) -- red square around capacity
				lcd.color(lcd.RGB(255, 255, 204,0.2))
				drawFilledRectangle(375,260,195,42,1) -- red square around capacity
				--drawRectangle(370,173,205,105,5) -- red square around capacity
				--lcd.color(WHITE)
				lcd.color(RED)
				drawText(380,260,(string.format("%.0f", BATCvalue).."mAh"))
				lcd.color(WHITE)
				else
				lcd.color(WHITE)
				drawText(380,260,(string.format("%.0f", BATCvalue).."mAh"))
				end

			--============================
			--Battery icon
			--============================
			mah_level = BATBattCapacity - BATCvalue
			if mah_level < 0 then mah_level = 0 end
			local Batt_Percentage = ((mah_level / BATBattCapacity) * 100)
			local Batt_color = (Batt_Percentage - Batt_Percentage %10) /10
			if Batt_color < 0 then Batt_color = 0 end
			lcd.color(batt_color[(math.floor(Batt_color+0.5))])
				if (BATV ~= nil) and (BATVvalue > 0) then
				drawFilledRectangle	(580,130 + (100-Batt_Percentage) * 0.01 * 303 ,190,303 - (100-Batt_Percentage) * 0.01 * 303,1)	--165 Y = 1--% battery
				end
			lcd.color(WHITE)
				if (mah_level < BATLowBattAlert) then
				Batt_warning = true
				else
				Batt_warning = false
				end
			-- Draw capacity percentage
			if (Batt_warning == true) then
			lcd.color(lcd.RGB(255, 255, 204,0.2))
			drawFilledRectangle(375,310,100,42,1) -- red square around capacity
			lcd.color(RED)
			drawText(380,310,(string.format("%.0f", Batt_Percentage).."%"))
			lcd.color(WHITE)
			else
			drawText(380,310,(string.format("%.0f", Batt_Percentage).."%"))
			end
		end



	--============================
	--Draw Battery Overlay
	--============================
		drawBitmap(577, 100, battimage) -- batt overlay image

	--===================================================
	-- Draw Version
	--===================================================
		--[[
		lcd.font(FONT_S)
		drawText (Screen_width-90, Screen_height-20,BATversion)
		--]]
		lcd.font(FONT_L)

		elseif screenSize == "X10fullScreen" or screenSize == "X18fullScreen" or screenSize == "X14fullScreen" then --X10 X18 X14
		local titleX = 240
		local valueX = 220
		local voltageY = 100
		local currentY = 130
		local consumptionY = 160
		local capacityY = 190
		local percentLabelX = 10
		local percentLabelY = 217
		local percentValueX = 80
		local percentValueY = 242
		local noConsumptionX = 355
		local noConsumptionY1 = 120
		local noConsumptionY2 = 140
		local noConsumptionY3 = 160
		local batteryFillX = 351
		local batteryFillY = 60
		local batteryOverlayX = 350
		local batteryOverlayY = 51
		if screenSize == "X14fullScreen" then
			titleX = 245
			valueX = 220
			voltageY = 122
			currentY = 172
			consumptionY = 222
			capacityY = 262
			percentLabelX = 62
			percentLabelY = 300
			percentValueX = 155
			percentValueY = 325
			noConsumptionX = 410
			noConsumptionY1 = 150
			noConsumptionY2 = 170
			noConsumptionY3 = 190
			batteryFillX = 431
			batteryFillY = 82
			batteryOverlayX = 430
			batteryOverlayY = 73
		elseif screenSize == "X18fullScreen" then
			percentLabelY = 270
			percentValueY = 295
		end

		lcd.color(WHITE)
		lcd.font(FONT_L)
		drawText(titleX,70,"Battery:")
		if BATVsensor ~= nil then
			if BATVsensor_old ~= BATVsensor then
				BATV = system.getSource (BATVsensor)
				BATVsensor_old = BATVsensor
			end
		Battery_connected_Flag = true
		else
		BATV = nil
		BATVvalue = 0
		end
			if ((BATV == nil) or (BATV == "---")) then
			lcd.color(WHITE)
			lcd.font(FONT_L)
			drawText(valueX,voltageY,("No Voltage"))
			--drawText(10,240,("No Volt Percentage"))
			--lcd.font(FONT_L)
			else
			BATVvalue = getSensorValue(BATV)
			LipoPackVoltage = BATVvalue

				drawText(percentLabelX, percentLabelY, "Voltage Percentage:")

			if (MaxCellVoltage ~= nil) and (MinCellVoltage ~= nil) and((BATVvalue <= BAT_Num_Of_Cells * MaxCellVoltage) and (BATVvalue >= BAT_Num_Of_Cells * MinCellVoltage)) then
				for i, v in ipairs(myArrayPercentList) do
				  if v[1] * BAT_Num_Of_Cells  >= LipoPackVoltage then
				  Voltage_Percentage = v[2]
				  break
				end
			end

			drawText(percentValueX, percentValueY,(string.format("%.0f", Voltage_Percentage).."%"))

			elseif (BATVvalue == 0) then -- voltage 0
			lcd.font(FONT_L)
			lcd.color(RED)
			drawText(percentValueX, percentValueY,"0%")
			lcd.color(WHITE)
			elseif (MaxCellVoltage ~= nil) and (BATVvalue >= BAT_Num_Of_Cells* MaxCellVoltage) then -- battery over voltage
			drawText(percentValueX - 50, percentValueY,">100%")
			elseif(MinCellVoltage ~= nil) and (BATVvalue < BAT_Num_Of_Cells * MinCellVoltage) then -- battery under voltage
			drawText(percentValueX - 50, percentValueY,"<0%")
			else-- voltage out of scope
			lcd.font(FONT_L)
			drawText(percentValueX - 70, percentValueY,"Out Of Range")
			end

			lcd.font(FONT_L)
				if BATVvalue < 3 then
				lcd.color(RED)
				drawText(valueX,voltageY,(string.format("%.1f",BATVvalue).."v"))
				lcd.color(WHITE)
				else
				lcd.color(WHITE)
				drawText(valueX,voltageY,(string.format("%.1f",BATVvalue).."v"))
				end
			end


		if BATAsensor ~= nil then
			if BATAsensor_old ~= BATAsensor then
				BATA = system.getSource (BATAsensor)
				BATAsensor_old = BATAsensor
			end
		else
			BATA = nil
		end

			if ((BATA == nil) or (BATA == "---")) then
			lcd.color(WHITE)
			lcd.font(FONT_L)
			drawText(valueX,currentY,("No Current"))
			lcd.font(FONT_L)
			else
			lcd.color(WHITE)
			BATAvalue = getSensorValue(BATA)
			lcd.font(FONT_L)
			drawText(valueX,currentY,(string.format("%.1f", BATAvalue).."A"))
			end

		if BATCsensor ~= nil then
			if BATCsensor_old ~= BATCsensor then
				BATC = system.getSource (BATCsensor)
				BATCsensor_old = BATCsensor
			end
		else
			BATC = nil
		end
		if ((BATC == nil) or (BATC == "---")) then
			lcd.font(FONT_S)
			lcd.color(RED)
			drawText(noConsumptionX,noConsumptionY1,"        No ")
			drawText(noConsumptionX,noConsumptionY2,"  Consumption")
			drawText(noConsumptionX - 5,noConsumptionY3,"       Sensor")
			lcd.color(WHITE)
			lcd.font(FONT_L)
			drawText(valueX,consumptionY,("No Consumption"))
			--drawText(220,190,("No Capacity"))
			lcd.font(FONT_L)
		else
		lcd.color(WHITE)
			BATCvalue = getSensorValue(BATC)
			lcd.font(FONT_L)
				if (Batt_warning == true) then
				lcd.color(lcd.RGB(255, 255, 204,0.2))
				drawFilledRectangle(valueX - 2,consumptionY - 2,75,21,1) -- red square around capacity
				lcd.color(RED)
				drawText(valueX,consumptionY,(string.format("%.0f", BATCvalue).."mAh"))
				else
				drawText(valueX,consumptionY,(string.format("%.0f", BATCvalue).."mAh"))
				end

			--============================
			--Battery Icon
			--============================
			mah_level = BATBattCapacity - BATCvalue
			if mah_level < 0 then mah_level = 0 end
			local Batt_Percentage = ((mah_level / BATBattCapacity) * 100)
			local Batt_color = (Batt_Percentage - Batt_Percentage %10) /10
			if Batt_color < 0 then Batt_color = 0 end
			lcd.color(batt_color[(math.floor(Batt_color+0.5))])
				if (BATV ~= nil) and (BATVvalue > 0) then
				drawFilledRectangle	(batteryFillX,batteryFillY + (100-Batt_Percentage) * 0.01 * 186 ,110,186 - (100-Batt_Percentage) * 0.01 * 186,1)	--165 Y = 1--% battery
				end
			lcd.color(WHITE)
				if (mah_level < BATLowBattAlert) then
				Batt_warning = true
				else
				Batt_warning = false
				end
			-- Draw capacity percentage
			if (Batt_warning == true) then
			lcd.color(lcd.RGB(255, 255, 204,0.2))
			drawFilledRectangle(valueX - 2,capacityY - 2,35,21,1) -- red square around capacity
			lcd.color(RED)
			drawText(valueX,capacityY,(string.format("%.0f", Batt_Percentage).."%"))
			lcd.color(WHITE)
			else
			drawText(valueX,capacityY,(string.format("%.0f", Batt_Percentage).."%"))
			end
		end
	--============================
	--Draw Battery Overlay
	--============================
		drawBitmap(batteryOverlayX,batteryOverlayY, battimage) -- batt overlay image

	--===================================================
	-- Draw Version
	--===================================================
		--lcd.font(FONT_S)
		--drawText (Screen_width-90, Screen_height-20,BATversion)
		--lcd.font(FONT_M)

else--if screenSize == "NotFullScreen" then
		-- dont print widget
		lcd.font(FONT_S)
		lcd.color(RED)
		drawText(window_width/3,window_height/2.5,"Please Choose Full Screen")
		lcd.color(WHITE)
end


end

local function draw_Model_Image(Me)

	if mdlimage ~= nil then
		if  (screenSize == "X20fullScreen") then
		drawBitmap(35, 97, mdlimage)
		elseif screenSize == "X14fullScreen" then
		drawBitmap(20, 80, mdlimage)
		elseif screenSize == "X10fullScreen" or screenSize == "X18fullScreen" then --X10 X18
		drawBitmap(20, 50, mdlimage)
	end
	end
end

local function screenSizeForDimensions(width, height)
	if width == 800 and height == 480 then
		return "X20fullScreen"
	elseif width == 480 and height == 272 then
		return "X10fullScreen"
	elseif width == 480 and height == 320 then
		return "X18fullScreen"
	elseif width == 640 and (height == 360 or height == 320) then  -- X14
		return "X14fullScreen"
	end
	return "NotFullScreen"
end

local function loadScreenAssets()
	if screenAssetSize == screenSize then
		return
	end

	digits_blue = nil
	digits_red = nil
	screenAssetSize = screenSize

	if (screenSize == "X20fullScreen") then
		battimage = lcd.loadBitmap(imagePath.."/empty800480.png")
		if (wallpaper_mask == nil) then wallpaper_mask = lcd.loadBitmap(imagePath.."/wallpaper_mask.png") end
		if (X20_image_frame == nil) then X20_image_frame = lcd.loadBitmap(imagePath.."/X20_image_frame.png") end
		Zavionix = lcd.loadBitmap(imagePath.."/Zavionix.png")
		Batt_Icon = lcd.loadBitmap(imagePath.."/Batt.png")
		RSSI_Icon = lcd.loadBitmap(imagePath.."/RSSI.png")
	elseif (screenSize == "X10fullScreen") then
		battimage = lcd.loadBitmap(imagePath.."/empty480320.png")
		if (wallpaper_mask == nil) then wallpaper_mask = lcd.loadBitmap(imagePath.."/wallpaper_mask.png") end
		if (X18_image_frame == nil) then X18_image_frame = lcd.loadBitmap(imagePath.."/X18_image_frame.png") end
		Zavionix = lcd.loadBitmap(imagePath.."/Zavionix480320.png")
		Batt_Icon = lcd.loadBitmap(imagePath.."/Batt_30.png")
		RSSI_Icon = lcd.loadBitmap(imagePath.."/RSSI_30.png")
	elseif (screenSize == "X18fullScreen") or (screenSize == "X14fullScreen") then
		battimage = lcd.loadBitmap(imagePath.."/empty480320.png")
		if (wallpaper_mask == nil) then wallpaper_mask = lcd.loadBitmap(imagePath.."/wallpaper_mask.png") end
		if (X18_image_frame == nil) then X18_image_frame = lcd.loadBitmap(imagePath.."/X18_image_frame.png") end
		Zavionix = lcd.loadBitmap(imagePath.."/Zavionix480320.png")
		Batt_Icon = lcd.loadBitmap(imagePath.."/Batt_30.png")
		RSSI_Icon = lcd.loadBitmap(imagePath.."/RSSI_30.png")
	else
		battimage = nil
		return
	end

	if (screenSize == "X20fullScreen") then
		digits_blue =
		{
			[0]  = lcd.loadBitmap(imagePath.."/blue/0.png"),
			[1]  = lcd.loadBitmap(imagePath.."/blue/1.png"),
			[2]  = lcd.loadBitmap(imagePath.."/blue/2.png"),
			[3]  = lcd.loadBitmap(imagePath.."/blue/3.png"),
			[4]  = lcd.loadBitmap(imagePath.."/blue/4.png"),
			[5]  = lcd.loadBitmap(imagePath.."/blue/5.png"),
			[6]  = lcd.loadBitmap(imagePath.."/blue/6.png"),
			[7]  = lcd.loadBitmap(imagePath.."/blue/7.png"),
			[8]  = lcd.loadBitmap(imagePath.."/blue/8.png"),
			[9]  = lcd.loadBitmap(imagePath.."/blue/9.png"),
			[10] = lcd.loadBitmap(imagePath.."/blue/nil.png"),
			[11] = lcd.loadBitmap(imagePath.."/blue/col.png")
		}
		digits_red =
		{
			[0]  = lcd.loadBitmap(imagePath.."/red/0.png"),
			[1]  = lcd.loadBitmap(imagePath.."/red/1.png"),
			[2]  = lcd.loadBitmap(imagePath.."/red/2.png"),
			[3]  = lcd.loadBitmap(imagePath.."/red/3.png"),
			[4]  = lcd.loadBitmap(imagePath.."/red/4.png"),
			[5]  = lcd.loadBitmap(imagePath.."/red/5.png"),
			[6]  = lcd.loadBitmap(imagePath.."/red/6.png"),
			[7]  = lcd.loadBitmap(imagePath.."/red/7.png"),
			[8]  = lcd.loadBitmap(imagePath.."/red/8.png"),
			[9]  = lcd.loadBitmap(imagePath.."/red/9.png"),
			[10] = lcd.loadBitmap(imagePath.."/red/nil.png"),
			[11] = lcd.loadBitmap(imagePath.."/red/col.png")
		}
	else
		digits_blue =
		{
			[0]  = lcd.loadBitmap(imagePath.."/blue/0_30.png"),
			[1]  = lcd.loadBitmap(imagePath.."/blue/1_30.png"),
			[2]  = lcd.loadBitmap(imagePath.."/blue/2_30.png"),
			[3]  = lcd.loadBitmap(imagePath.."/blue/3_30.png"),
			[4]  = lcd.loadBitmap(imagePath.."/blue/4_30.png"),
			[5]  = lcd.loadBitmap(imagePath.."/blue/5_30.png"),
			[6]  = lcd.loadBitmap(imagePath.."/blue/6_30.png"),
			[7]  = lcd.loadBitmap(imagePath.."/blue/7_30.png"),
			[8]  = lcd.loadBitmap(imagePath.."/blue/8_30.png"),
			[9]  = lcd.loadBitmap(imagePath.."/blue/9_30.png"),
			[10] = lcd.loadBitmap(imagePath.."/blue/nil_30.png"),
			[11] = lcd.loadBitmap(imagePath.."/blue/col_30.png")
		}
		digits_red =
		{
			[0]  = lcd.loadBitmap(imagePath.."/red/0_30.png"),
			[1]  = lcd.loadBitmap(imagePath.."/red/1_30.png"),
			[2]  = lcd.loadBitmap(imagePath.."/red/2_30.png"),
			[3]  = lcd.loadBitmap(imagePath.."/red/3_30.png"),
			[4]  = lcd.loadBitmap(imagePath.."/red/4_30.png"),
			[5]  = lcd.loadBitmap(imagePath.."/red/5_30.png"),
			[6]  = lcd.loadBitmap(imagePath.."/red/6_30.png"),
			[7]  = lcd.loadBitmap(imagePath.."/red/7_30.png"),
			[8]  = lcd.loadBitmap(imagePath.."/red/8_30.png"),
			[9]  = lcd.loadBitmap(imagePath.."/red/9_30.png"),
			[10] = lcd.loadBitmap(imagePath.."/red/nil_30.png"),
			[11] = lcd.loadBitmap(imagePath.."/red/col_30.png")
		}
	end
end

local function refreshScreenSize(force)
	local now = os.clock()
	if not force and now < screenCheckTime + screenCheckPeriod then
		return false
	end
	screenCheckTime = now

	local width, height = lcd.getWindowSize()
	if width == nil or height == nil then
		width = system:getVersion().lcdWidth
		height = system:getVersion().lcdHeight
	end

	window_width = width
	window_height = height
	Screen_width = width
	Screen_height = height

	local newScreenSize = screenSizeForDimensions(width, height)
	if newScreenSize ~= screenSize then
		screenSize = newScreenSize
		BATCyclesCounter = 0
		BATbgcount = 0
		loadScreenAssets()
		lcd.invalidate()
		return true
	end

	loadScreenAssets()
	return false
end

local function create()

	TxBatt = system.getSource({category=CATEGORY_SYSTEM, member=MAIN_VOLTAGE})
	mdlimage = lcd.loadBitmap(model.bitmap())
	timer = system.getSource({category=CATEGORY_TIMER, member=0, options=0}) -- Timer 1
	--if (LowBattSound == nil) then LowBattSound = "/scripts/Batt/LowBat.wav" end -- audio file for fuel alert, change as neccessary
	if (LowBattSound == nil) then LowBattSound = "LowBat.wav" end -- audio file for fuel alert, change as neccessary

	refreshScreenSize(true)

    return {r=255,
			g=255,
			b=255,
			OnOff=false,
			source=nil,
			min=-1024,
			max=1024,
			value=0,
			Batt_Type = widgetDefaults.Batt_Type,
			BATBattCapacity = widgetDefaults.BATBattCapacity,
			BATLowBattAlert = widgetDefaults.BATLowBattAlert,
			BATBattAlertOnOff = widgetDefaults.BATBattAlertOnOff,
			BATLowBattCycleTime = widgetDefaults.BATLowBattCycleTime,
			BAT_Num_Of_Cells = widgetDefaults.BAT_Num_Of_Cells}
end

local function wakeup(widget)
			newValue = os.clock()

			if newValue > Time_Temp + 1 / paint_rate_Hz then  -- paint every X hz
			ensureWidgetDefaults(widget)
			-- Read widget params
			BATVsensor = sourceNameOrNil(widget.BATVsource)
			BATAsensor = sourceNameOrNil(widget.BATAsource)
			BATCsensor = sourceNameOrNil(widget.BATCsource)
			BATRSSI1sensor = sourceNameOrNil(widget.BATRSSI1source)
			BATRSSI2sensor = sourceNameOrNil(widget.BATRSSI2source)
			BATRxbatt1sensor = sourceNameOrNil(widget.BATRxbatt1source)
			BATRxbatt2sensor = sourceNameOrNil(widget.BATRxbatt2source)
			BATV = resolveSource(widget.BATVsource, BATVsensor)
			BATA = resolveSource(widget.BATAsource, BATAsensor)
			BATC = resolveSource(widget.BATCsource, BATCsensor)
			RSSI1 = resolveSource(widget.BATRSSI1source, BATRSSI1sensor)
			RSSI2 = resolveSource(widget.BATRSSI2source, BATRSSI2sensor)
			RxBatt1 = resolveSource(widget.BATRxbatt1source, BATRxbatt1sensor)
			RxBatt2 = resolveSource(widget.BATRxbatt2source, BATRxbatt2sensor)
			BATVsensor_old = BATVsensor or ''
			BATAsensor_old = BATAsensor or ''
			BATCsensor_old = BATCsensor or ''
			BATRSSI1sensor_old = BATRSSI1sensor or ''
			BATRSSI2sensor_old = BATRSSI2sensor or ''
			BATRxbatt1sensor_old = BATRxbatt1sensor or ''
			BATRxbatt2sensor_old = BATRxbatt2sensor or ''
			Batt_Type      		 = widget.Batt_Type
			BATBattCapacity      = widget.BATBattCapacity
			BATBattAlertOnOff    = widget.BATBattAlertOnOff
			BATLowBattAlert   	 = widget.BATLowBattAlert
			BATLowBattCycleTime  = widget.BATLowBattCycleTime
			BAT_Num_Of_Cells     = widget.BAT_Num_Of_Cells
			updateBatteryPercentSensorFromTelemetry()
			-- Low Battery Alert
			BATcount = BATcount + 1
				if BATcount >BATLowBattCycleTime*3.3 then
					if (BATBattAlertOnOff == true) and (Batt_warning == true) then
					print("Battery alert")
					--system.playFile	(LowBattSound)
					system.playFile('./LowBat.wav')
					system.playHaptic("- - -")
					end
				BATcount = 0
				end

			Time_Temp = newValue
				--if BATDone_Painting then
				lcd.invalidate()
				--BATDone_Painting = false
				--end
			end
end

local function paint(widget)
	ensureWidgetDefaults(widget)
	if (os.clock() > BATwidgetTime + 1) then -- if widget not running for 2s
	BATbgcount = 0
	end
	refreshScreenSize(false)


	draw_Background(Me)
	draw_Model_Image(Me)
	if BATCyclesCounter >= 0 then BATdraw_Battery_Data(Me) end
	draw_Top_Bar(Me)
	draw_Model_Name(Me)

	if BATCyclesCounter >= 0 then draw_Timer(Me) end

	-- Check if battery type has been changed
	if (Batt_Type) ~= Batt_Type_old then
	-- Check battery Type
	if (Batt_Type == 0) then --lipo
	print("LIPO")
	myArrayPercentList = {{ 3, 0 }, { 3.093, 1 }, { 3.196, 2 }, { 3.301, 3 }, { 3.401, 4 }, { 3.477, 5 }, { 3.544, 6 }, { 3.601, 7 }, { 3.637, 8 }, { 3.664, 9 }, { 3.679, 10 }, { 3.683, 11 }, { 3.689, 12 }, { 3.692, 13 }, { 3.705, 14 }, { 3.71, 15 }, { 3.713, 16 }, { 3.715, 17 }, { 3.72, 18 }, { 3.731, 19 }, { 3.735, 20 }, { 3.744, 21 }, { 3.753, 22 }, { 3.756, 23 }, { 3.758, 24 }, { 3.762, 25 }, { 3.767, 26 }, { 3.774, 27 }, { 3.78, 28 }, { 3.783, 29 }, { 3.786, 30 }, { 3.789, 31 }, { 3.794, 32 }, { 3.797, 33 }, { 3.8, 34 }, { 3.802, 35 }, { 3.805, 36 }, { 3.808, 37 }, { 3.811, 38 }, { 3.815, 39 }, { 3.818, 40 }, { 3.822, 41 }, { 3.825, 42 }, { 3.829, 43 }, { 3.833, 44 }, { 3.836, 45 }, { 3.84, 46 }, { 3.843, 47 }, { 3.847, 48 }, { 3.85, 49 }, { 3.854, 50 }, { 3.857, 51 }, { 3.86, 52 }, { 3.863, 53 }, { 3.866, 54 }, { 3.87, 55 }, { 3.874, 56 }, { 3.879, 57 }, { 3.888, 58 }, { 3.893, 59 }, { 3.897, 60 }, { 3.902, 61 }, { 3.906, 62 }, { 3.911, 63 }, { 3.918, 64 }, { 3.923, 65 }, { 3.928, 66 }, { 3.939, 67 }, { 3.943, 68 }, { 3.949, 69 }, { 3.955, 70 }, { 3.961, 71 }, { 3.968, 72 }, { 3.974, 73 }, { 3.981, 74 }, { 3.987, 75 }, { 3.994, 76 }, { 4.001, 77 }, { 4.007, 78 }, { 4.014, 79 }, { 4.021, 80 }, { 4.029, 81 }, { 4.036, 82 }, { 4.044, 83 }, { 4.052, 84 }, { 4.062, 85 }, { 4.074, 86 }, { 4.085, 87 }, { 4.095, 88 }, { 4.105, 89 }, { 4.111, 90 }, { 4.116, 91 }, { 4.12, 92 }, { 4.125, 93 }, { 4.129, 94 }, { 4.135, 95 }, { 4.145, 96 }, { 4.176, 97 }, { 4.179, 98 }, { 4.193, 99 }, { 4.2, 100 }, { 5, 100 }, { 10, 100 }}
	MaxCellVoltage = 4.2
	MinCellVoltage = 3
	Batt_Type_old = Batt_Type
	elseif (Batt_Type == 1) then -- HV lipo
	print("HV LIPO")
	myArrayPercentList = {{3.2,0},{3.284,1},{3.369,3},{3.454,2},{3.539,4},{3.624,5},{3.633,6},{3.642,7},{3.651,8},{3.66,9},{3.669,10},{3.674,11},{3.679,12},{3.684,13},{3.689,14},{3.694,15},{3.7,16},{3.705,17},{3.71,18},{3.715,19},{3.72,20},{3.722,21},{3.725,22},{3.727,23},{3.729,24},{3.732,25},{3.734,26},{3.737,27},{3.74,28},{3.743,29},{3.746,30},{3.748,31},{3.751,32},{3.754,33},{3.757,34},{3.76,35},{3.765,36},{3.768,37},{3.771,38},{3.774,39},{3.777,40},{3.78,41},{3.785,42},{3.789,43},{3.793,44},{3.798,45},{3.803,46},{3.807,47},{3.812,48},{3.816,49},{3.821,50},{3.829,51},{3.834,52},{3.84,53},{3.845,54},{3.85,55},{3.86,56},{3.865,57},{3.87,58},{3.875,59},{3.88,60},{3.89,61},{3.898,62},{3.906,63},{3.914,64},{3.922,65},{3.93,66},{3.938,67},{3.946,68},{3.954,69},{3.962,70},{3.975,71},{3.989,72},{4.003,73},{4.017,74},{4.031,75},{4.042,76},{4.05,77},{4.059,78},{4.067,79},{4.075,80},{4.085,81},{4.096,82},{4.107,83},{4.118,84},{4.129,85},{4.14,86},{4.151,87},{4.162,88},{4.173,89},{4.184,90},{4.197,91},{4.209,92},{4.221,93},{4.233,94},{4.245,95},{4.27,96},{4.29,97},{4.31,98},{4.33,99},{4.35,100}, { 5, 100 }, { 10, 100 }}
	MaxCellVoltage = 4.35
	MinCellVoltage = 3.2
	Batt_Type_old = Batt_Type
	elseif (Batt_Type == 2) then -- Lion
	print("LION")
	myArrayPercentList = {{2.90,01},{2.95,02},{3.00,03},{3.05 ,04},{3.10 ,05},{3.15 ,06},{3.20 ,07},{3.25 ,08},{3.30,09},{3.35,10},{3.40,11},{3.45,12},{3.50,13},{3.55,14},{3.60,15},{3.617,16},{3.62,17},{3.63,18},{3.635,19},{3.64,20},{3.645,21},{3.65,22},{3.655,23},{3.662,24},{3.667,25},{3.672,26},{3.676,27},{3.68,28},{3.685,29},{3.69,30},{3.694,31},{3.697,32},{3.70,33},{3.705,34},{3.71,35},{3.712,36},{3.715,37},{3.718,38},{ 3.72,39},{3.723,40},{3.727,41},{3.73,42},{3.733,43},{3.735,44},{3.738,45},{ 3.74,46},{3.745,47},{ 3.75,48},{3.755,49},{3.758,50},{3.76,51},{3.765,52},{3.77,53},{3.775,54},{3.778,55},{3.78,56},{3.785,57},{3.79,58},{3.795,59},{3.80,60},{3.81,61},{3.815,62},{3.82,63},{3.825,64},{3.83,65},{3.84,66},{3.845,67},{3.85,68},{3.855,69},{3.86,70},{3.865,71},{3.872,72},{3.875,73},{3.88,74},{3.89,75},{3.90,76},{3.905,77},{3.915,78},{3.92,79},{3.93,80},{3.935,81},{3.94,82},{3.95,83},{3.96,84},{3.965,85},{3.975,86},{3.98,87},{3.99,88},{4.00,89},{4.01,90},{4.01,91},{4.02,92},{4.03,93},{4.035,94},{ 4.05,95},{ 4.09,96},{4.12,97},{4.15,98},{4.18,99},{ 4.20,100}, { 5, 100 }, { 10, 100 }}
	MaxCellVoltage = 4.2
	MinCellVoltage = 2.9
	Batt_Type_old = Batt_Type
	else -- liFe
	print("LIFE")
    myArrayPercentList = {{2.5,0},{2.6,1},{2.7,3},{2.65,2},{2.75,4},{2.8,5},{2.84,6},{2.88,7},{2.92,8},{2.96,9},{3,10},{3.15,11},{3.156,12},{3.1615,13},{3.167,14},{3.1725,15},{3.178,16},{3.1835,17},{3.189,18},{3.1945,19},{3.2,20},{3.203,21},{3.206,22},{3.209,23},{3.212,24},{3.215,25},{3.218,26},{3.221,27},{3.224,28},{3.227,29},{3.23,30},{3.232,31},{3.234,32},{3.236,33},{3.238,34},{3.24,35},{3.242,36},{3.244,37},{3.246,38},{3.248,39},{3.25,40},{3.251,41},{3.252,42},{3.253,43},{3.254,44},{3.255,45},{3.256,46},{3.257,47},{3.258,48},{3.259,49},{3.26,50},{3.262,51},{3.264,52},{3.266,53},{3.268,54},{3.27,55},{3.272,56},{3.274,57},{3.276,58},{3.278,59},{3.28,60},{3.282,61},{3.284,62},{3.286,63},{3.288,64},{3.29,65},{3.292,66},{3.294,67},{3.296,68},{3.298,69},{3.3,70},{3.303,71},{3.306,72},{3.309,73},{3.312,74},{3.315,75},{3.318,76},{3.321,77},{3.324,78},{3.327,79},{3.33,80},{3.3338,81},{3.3356,82},{3.3374,83},{3.3392,84},{3.4,85},{3.3428,86},{3.3446,87},{3.3464,88},{3.3482,89},{3.35,90},{3.3544,91},{3.3576,92},{3.3608,93},{3.364,94},{3.3672,95},{3.3704,96},{3.3736,97},{3.3768,98},{3.38,99},{3.65,100}, { 5, 100 }, { 10, 100 }}
	MaxCellVoltage = 3.65
	MinCellVoltage = 2.5
	Batt_Type_old = Batt_Type
end
	end

	BATCyclesCounter = BATCyclesCounter + 1
	BATwidgetTime = os.clock()
	--BATDone_Painting = true
	--end

end

local function configure(widget)
	ensureWidgetDefaults(widget)

	local line = form.addLine("Zavionix Batt ".. BATversion)
	line = form.addLine("Battery Type")
	form.addChoiceField(line, nil, {{"Lipo", 0}, {"HV Lipo", 1}, {"Lion", 2}, {"LiFe", 3}}, function()
		widget.Batt_Type = numberOrDefault(widget.Batt_Type, widgetDefaults.Batt_Type, 0, 3)
		return widget.Batt_Type
	end, function(value)
		widget.Batt_Type = numberOrDefault(value, widgetDefaults.Batt_Type, 0, 3)
	end)
	line = form.addLine("Battery Capacity")
	local slots = form.getFieldSlots(line, {0})
	form.addNumberField(line, slots[1], 1, 50000, function()
		widget.BATBattCapacity = numberOrDefault(widget.BATBattCapacity, widgetDefaults.BATBattCapacity, 1, 50000)
		return widget.BATBattCapacity
	end, function(value)
		widget.BATBattCapacity = numberOrDefault(value, widgetDefaults.BATBattCapacity, 1, 50000)
	end);
	line = form.addLine("Low Battery Alert parameters:")
	line = form.addLine("Low Battery Alert")	-- Batt Alert OnOff
    form.addBooleanField(line, form.getFieldSlots(line)[0], function() return widget.BATBattAlertOnOff end, function(value) widget.BATBattAlertOnOff = value end)
	line = form.addLine("Batt Alert (mAh)")
	slots = form.getFieldSlots(line, {0})
	local field = form.addNumberField(line, slots[1], 1, 50000, function() return widget.BATLowBattAlert end, function(value) widget.BATLowBattAlert = value end);
	setFieldDefault(field, widgetDefaults.BATLowBattAlert)
	line = form.addLine("Low Battery Alert Rate (s)")
	slots = form.getFieldSlots(line, {0}) -- Batt Alert Rate
	field = form.addNumberField(line, slots[1], 1, 10, function() return widget.BATLowBattCycleTime end, function(value) widget.BATLowBattCycleTime = value end);
	setFieldDefault(field, widgetDefaults.BATLowBattCycleTime)
	line = form.addLine("Number Of Cells")
	slots = form.getFieldSlots(line, {0}) -- Batt Alert Rate
	field = form.addNumberField(line, slots[1], 1, 14, function() return widget.BAT_Num_Of_Cells end, function(value) widget.BAT_Num_Of_Cells = value end);
	setFieldDefault(field, widgetDefaults.BAT_Num_Of_Cells)
	-- Source choice
    line = form.addLine("Voltage Sensor")
    form.addSourceField(line, nil, function() return widget.BATVsource end, function(value) widget.BATVsource = value end)
    line = form.addLine("Current Sensor")
    form.addSourceField(line, nil, function() return widget.BATAsource end, function(value) widget.BATAsource = value end)
    line = form.addLine("Consumption Sensor")
    form.addSourceField(line, nil, function() return widget.BATCsource end, function(value) widget.BATCsource = value end)
    line = form.addLine("RSSI 1 Sensor")
    form.addSourceField(line, nil, function() return widget.BATRSSI1source end, function(value) widget.BATRSSI1source = value end)
	line = form.addLine("RSSI 2 Sensor")
    form.addSourceField(line, nil, function() return widget.BATRSSI2source end, function(value) widget.BATRSSI2source = value end)
    line = form.addLine("Rx Batt 1 Sensor")
    form.addSourceField(line, nil, function() return widget.BATRxbatt1source end, function(value) widget.BATRxbatt1source = value end)
    line = form.addLine("Rx Batt 2 Sensor")
    form.addSourceField(line, nil, function() return widget.BATRxbatt2source end, function(value) widget.BATRxbatt2source = value end)

end

local function read(widget)
	widget.Batt_Type 			= storage.read ("Batt_Type")
	widget.BATBattCapacity  	= storage.read ("BATBattCapacity")
	if widget.BATBattCapacity == nil then
		widget.BATBattCapacity = storage.read ("Battcap")
	end
	widget.BATBattAlertOnOff    = storage.read ("BATBattAlertOnOff")
	widget.BATLowBattAlert 	    = storage.read ("BATLowBattAlert")
	widget.BATLowBattCycleTime  = storage.read ("BATLowBattCycleTime")
	widget.BAT_Num_Of_Cells     = storage.read ("BAT_Num_Of_Cells")
	widget.BATVsource			= storage.read ("BATVsource")
	widget.BATAsource			= storage.read ("BATAsource")
	widget.BATCsource			= storage.read ("BATCsource")
	widget.BATRSSI1source		= storage.read ("BATRSSI1source")
	widget.BATRSSI2source		= storage.read ("BATRSSI2source")
	widget.BATRxbatt1source		= storage.read ("BATRxbatt1source")
	widget.BATRxbatt2source		= storage.read ("BATRxbatt2source")
	repairShiftedSourceFields(widget)
	ensureWidgetDefaults(widget)
end

local function write(widget)
	ensureWidgetDefaults(widget)
	storage.write("Batt_Type"		    ,widget.Batt_Type)
	storage.write("BATBattCapacity"		,widget.BATBattCapacity)
	storage.write("BATBattAlertOnOff"   ,widget.BATBattAlertOnOff)
	storage.write("BATLowBattAlert"	    ,widget.BATLowBattAlert)
	storage.write("BATLowBattCycleTime" ,widget.BATLowBattCycleTime)
	storage.write("BAT_Num_Of_Cells"	,widget.BAT_Num_Of_Cells)
	storage.write("BATVsource"	 	    ,widget.BATVsource)
	storage.write("BATAsource"	  	    ,widget.BATAsource)
	storage.write("BATCsource"	  		,widget.BATCsource)
	storage.write("BATRSSI1source"  	,widget.BATRSSI1source)
	storage.write("BATRSSI2source"  	,widget.BATRSSI2source)
	storage.write("BATRxbatt1source"	,widget.BATRxbatt1source)
	storage.write("BATRxbatt2source"	,widget.BATRxbatt2source)
end

return {
	create = create,
	paint = paint,
	configure = configure,
	read = read,
	write = write,
	wakeup = wakeup,
}
