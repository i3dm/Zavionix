-- ******************************************************************************
-- **  T3chDad®'s Jet RDT Screen (TD-RDT)                                      **
-- ******************************************************************************
-- **  This is a full screen widget. You must have topbar and trims turned off **
-- **  Author: Bob Templeton (T3chDad)®  December 2019 to March 2021           **
-- **  Created exclusively for Zavonix.  This widget and all associated images **
-- **  and files are distributed under the GPLv3 license.                      **
-- ******************************************************************************

--===================================================
-- Widget Options 
--===================================================
local defaultOptions  = {
	--AirCraft fuel capacity (ml)
	{"Tank_Size", VALUE, 3000, 0, 20000 },
	--Fuel alarm level (ml)
	{"Fuel_Alarm", VALUE, 1000, 1, 5000 },
	--Fuel calculation factor (ml)
	{"FuelFactor", VALUE, 100, 1, 10000 },
	-- Turbine Type:
	-- 1 = jetcat
	-- 2 = projet
	-- 3 = xicoy
	-- 4 = kingtech
	-- 5 = jetcentral
	-- 6 = Linton
	-- 7 = Swiwin
	-- 8 = Xicoy X
	-- 9 = Orbit 
	{"ECU_Type", VALUE, 1, 1, 9 },
	{"Stick_Mode", VALUE, 2, 1, 4 },
}
--===================================================
-- Thousands comma
--===================================================
local function format_thousand(v)
    local s = string.format("%d", math.floor(v))
    local pos = string.len(s) % 3
    if pos == 0 then pos = 3 end
    return string.sub(s, 1, pos) .. string.gsub(string.sub(s, pos+1), "(...)", ",%1")
end
--===================================================
-- Get telemetry ID from name
--===================================================
local function getTelemetryId(name)
    field = getFieldInfo(name)
    if field then
      return field.id
    else
      return -1
    end
end
--===================================================
-- Rounding function
--===================================================
local function round(num, numDecimalPlaces)
	return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
end
--===================================================
-- Format seconds to clock display
--===================================================
local function SecondsToClock(seconds)
	local seconds = tonumber(seconds)
  	if seconds == nil then
    	return "00:00";
  	else
		hours = string.format("%02.f", math.floor(seconds/3600));
		mins = string.format("%02.f", math.floor(seconds/60 - (hours*60)));
		secs = string.format("%02.f", math.floor(seconds - hours*3600 - mins *60));
		--return hours..":"..mins..":"..secs
	    return mins..":"..secs
  	end
end
--===================================================
-- Setup the status message table based on ECU type
--===================================================
local function initECU_Status(Me)
	if Me.options.ECU_Type == 2 then
		-- 	ProJet
		Me.ECU_Status[0]  = "Off"
		Me.ECU_Status[1]  = "Standby"
		Me.ECU_Status[2]  = "Auto"
		Me.ECU_Status[5]  = "Fuel Ignite"
		Me.ECU_Status[7]  = "Ramp Up"
		Me.ECU_Status[9]  = "Slow Down"
		Me.ECU_Status[10] = "Cool Down"
		Me.ECU_Status[11] = "Calibrate"
		Me.ECU_Status[12] = "Cal Idle"
		Me.ECU_Status[13] = "Go Idle"
		Me.ECU_Status[15] = "Burner On"
		Me.ECU_Status[16] = "Auto HC"
		Me.ECU_Status[18] = "Wait ACC"
		Me.ECU_Status[23] = "Preheat"
		Me.ECU_Status[25] = "Burn Out"
		Me.ECU_Status[26] = "Steady"	
		Me.A4Mult = 1
		Me.ECU_Name = "ProJet"
	elseif Me.options.ECU_Type == 3 then
		-- Xicoy	
		Me.ECU_Status[0]  = "No Status"
		Me.ECU_Status[1]  = "No RC Signal"
		Me.ECU_Status[2]  = "Trim Low"
		Me.ECU_Status[4]  = "Ready"
		Me.ECU_Status[5]  = "StickLow"
		Me.ECU_Status[6]  = "Glow test"
		Me.ECU_Status[7]  = "Glow Bad"
		Me.ECU_Status[8]  = "Start On"
		Me.ECU_Status[9]  = "Cooling"
		Me.ECU_Status[10] = "Burner on"
		Me.ECU_Status[11] = "Pre Heat"
		Me.ECU_Status[12] = "Switch Over"
		Me.ECU_Status[13] = "Start On"
		Me.ECU_Status[14] = "Ignition"
		Me.ECU_Status[15] = "Fuel Ramp"
		Me.ECU_Status[16] = "Running"
		Me.ECU_Status[17] = "Stop"
		Me.ECU_Status[18] = "Start Bad"
		Me.ECU_Status[19] = "Low RPM"
		Me.ECU_Status[20] = "High Temp"
		Me.ECU_Status[21] = "Flame Out"
		Me.ECU_Status[22] = "Speed Low"
		Me.A4Mult = 100
		Me.ECU_Name = "Xicoy"
	elseif Me.options.ECU_Type == 4 then
		-- KingTech
		Me.ECU_Status[0]  = "No Status"
		Me.ECU_Status[1]  = "No RC Signal"
		Me.ECU_Status[2]  = "Trim Low"
		Me.ECU_Status[4]  = "Ready"
		Me.ECU_Status[5]  = "StickLow"
		Me.ECU_Status[6]  = "Glow test"
		Me.ECU_Status[7]  = "Glow Bad"
		Me.ECU_Status[8]  = "Start On"
		Me.ECU_Status[9]  = "Cooling"
		Me.ECU_Status[10] = "Burner on"
		Me.ECU_Status[11] = "Pre Heat"
		Me.ECU_Status[12] = "Switch Over"
		Me.ECU_Status[13] = "Start On"
		Me.ECU_Status[14] = "Ignition"
		Me.ECU_Status[15] = "Fuel Ramp"
		Me.ECU_Status[16] = "Running"
		Me.ECU_Status[17] = "Stop"
		Me.ECU_Status[18] = "Start Bad"
		Me.ECU_Status[19] = "Low RPM"
		Me.ECU_Status[20] = "High Temp"
		Me.ECU_Status[21] = "Flame Out"
		Me.ECU_Status[22] = "Low Batt"
		Me.ECU_Status[23] = "PrimeVap"
		Me.ECU_Status[24] = "Stage1"
		Me.ECU_Status[25] = "Stage2"
		Me.ECU_Status[26] = "Stage3"
		Me.A4Mult = 100
		Me.ECU_Name = "KingTech"
	elseif Me.options.ECU_Type == 5 then
		-- JetCentral
		Me.ECU_Status[0]  = "No Status"
		Me.ECU_Status[10] = "Stop"
		Me.ECU_Status[20] = "Glow Test"
		Me.ECU_Status[30] = "Starter Test"
		Me.ECU_Status[31] = "Prime Fuel"
		Me.ECU_Status[32] = "Prime Burner"
		Me.ECU_Status[40] = "Manual Cool"
		Me.ECU_Status[41] = "Auto cooling"
		Me.ECU_Status[51] = "Igniter Heat"
		Me.ECU_Status[52] = "Ignition"
		Me.ECU_Status[53] = "Pre Heat"
		Me.ECU_Status[54] = "Switch Over"
		Me.ECU_Status[55] = "To Idle"
		Me.ECU_Status[56] = "Running"
		Me.ECU_Status[62] = "Stop-Error"
		Me.A4Mult = 100
		Me.ECU_Name = "JetCentral"
	elseif Me.options.ECU_Type == 6 then
		-- Linton
		Me.ECU_Status[0]  = "Ready"
		Me.ECU_Status[1]  = "Start"
		Me.ECU_Status[2]  = "Burner"
		Me.ECU_Status[3]  = "Ignition Success"
		Me.ECU_Status[4]  = "Pre-Heat (1)"
		Me.ECU_Status[5]  = "Pre-Heat (2)"
		Me.ECU_Status[6]  = "Pre-Heat (3)"
		Me.ECU_Status[7]  = "Pre-Heat (4)"
		Me.ECU_Status[8]  = "Pre-Heat (5)"
		Me.ECU_Status[9]  = "Running"
		Me.ECU_Status[10] = "Idling"
		Me.ECU_Status[11] = "Accelleration"
		Me.ECU_Status[12] = "Deceleration"
		Me.ECU_Status[13] = "Uniform Speed"
		Me.ECU_Status[14] = "Uniform Speed"
		Me.ECU_Status[15] = "RC Learning"
		Me.ECU_Status[16] = "Idling(1)"
		Me.ECU_Status[17] = "Cooling"
		Me.ECU_Status[18] = "Cooling"
		Me.ECU_Status[19] = "Cooling"
		Me.ECU_Status[20] = "Cooling"
		Me.ECU_Status[21] = "idling"
		Me.ECU_Status[22] = "Power Limit"
		Me.ECU_Status[23] = "RC Lost"
		Me.ECU_Status[24] = "Ready to Start"
		Me.ECU_Status[25] = "Uniform Speed"
		Me.ECU_Status[26] = "Uniform Speed"
		Me.ECU_Status[27] = "Successful"
		Me.ECU_Status[28] = "Max Throttle"
		Me.ECU_Status[29] = "Restart"
		Me.A4Mult = 100
		Me.ECU_Name = "Linton"
	elseif Me.options.ECU_Type == 7 then
		-- Swiwin
		Me.ECU_Status[0]   = "Stop"
		Me.ECU_Status[1]   = "Ready"
		Me.ECU_Status[2]   = "Ign(StickDown)"
		Me.ECU_Status[3]   = "Ignition"
		Me.ECU_Status[4]   = "Preheat"
		Me.ECU_Status[5]   = "Fuelramp"
		Me.ECU_Status[6]   = "LearnStickMax"
		Me.ECU_Status[7]   = "LearnStickMin"
		Me.ECU_Status[8]   = "Learn Rc..."
		Me.ECU_Status[9]   = "Run(StickMin)"
		Me.ECU_Status[10]  = "Run(PumpLimit)"
		Me.ECU_Status[11]  = "Running"
		Me.ECU_Status[12]  = "Cooling"
		Me.ECU_Status[13]  = "Restart"
		Me.ECU_Status[14]  = "TestGlowPlug"
		Me.ECU_Status[15]  = "TestFuelValve"
		Me.ECU_Status[16]  = "TestGasValve"
		Me.ECU_Status[17]  = "TestPump"
		Me.ECU_Status[18]  = "TestStarter"
		Me.ECU_Status[19]  = "ExhaustAir"
		Me.ECU_Status[-1]  = "Time Out"
		Me.ECU_Status[-2]  = "Low Battery"
		Me.ECU_Status[-3]  = "GlowPlug Bad"
		Me.ECU_Status[-4]  = "Fuel Anomaly"
		Me.ECU_Status[-5]  = "Starter failure"
		Me.ECU_Status[-6]  = "RPM Low"
		Me.ECU_Status[-7]  = "RPM Instability"
		Me.ECU_Status[-8]  = "High Temperature"
		Me.ECU_Status[-9]  = "Low Temperature"
		Me.ECU_Status[-10] = "Temp Sensor failure"
		Me.ECU_Status[-11] = "Gas Valve Bad"
		Me.ECU_Status[-12] = "Fuel Valve Bad"
		Me.ECU_Status[-13] = "Lost Signal"
		Me.ECU_Status[-14] = "Starter Temp High"
		Me.ECU_Status[-15] = "Pump Temp High"
		Me.ECU_Status[-16] = "Clutch failure"
		Me.ECU_Status[-17] = "Current overload"
		Me.ECU_Status[-18] = "Engine Offline"
		Me.A4Mult = 100
		Me.ECU_Name = "Swiwin"
	elseif Me.options.ECU_Type == 8 then
		-- Xicoy X
		Me.ECU_Status[0]  = "HighTemp"
		Me.ECU_Status[1]  = "Trim Low"
		Me.ECU_Status[2]  = "SetIdle!"
		Me.ECU_Status[3]  = "Ready"
		Me.ECU_Status[4]  = "Ignition"
		Me.ECU_Status[5]  = "FuelRamp"
		Me.ECU_Status[6]  = "Glow Test"
		Me.ECU_Status[7]  = "Running"
		Me.ECU_Status[8]  = "Stop"
		Me.ECU_Status[9]  = "FlameOut"
		Me.ECU_Status[10] = "SpeedLow"
		Me.ECU_Status[11] = "Cooling"
		Me.ECU_Status[12] = "Ignit.Bad"
		Me.ECU_Status[13] = "Start.Fail"
		Me.ECU_Status[14] = "AccelFail"
		Me.ECU_Status[15] = "Start On"
		Me.ECU_Status[16] = "UserOff"
		Me.ECU_Status[17] = "Failsafe"
		Me.ECU_Status[18] = "Low RPM"
		Me.ECU_Status[19] = "Reset"
		Me.ECU_Status[20] = "RXPwFail"
		Me.ECU_Status[21] = "PreHeat"
		Me.ECU_Status[22] = "Battery!"
		Me.ECU_Status[23] = "Time Out"
		Me.ECU_Status[24] = "Overload"
		Me.ECU_Status[25] = "Ign.Fail"
		Me.ECU_Status[26] = "Burner On"
		Me.ECU_Status[27] = "Starting"
		Me.ECU_Status[28] = "SwitchOv"
		Me.ECU_Status[29] = "Cal.Pump"
		Me.ECU_Status[30] = "PumpLimi"
		Me.ECU_Status[31] = "NoEngine"
		Me.ECU_Status[32] = "PwrBoost"
		Me.ECU_Status[33] = "Run-Idle"
		Me.ECU_Status[34] = "Run-Max "
		Me.ECU_Status[35] = "Restart "
		Me.ECU_Status[36] = "No Status"
		Me.A4Mult = 1
		Me.ECU_Name = "Xicoy X"
	elseif Me.options.ECU_Type == 9 then
		-- Orbit
		Me.ECU_Status[0]  = "No Status"
		Me.ECU_Status[1]  = "Stop"
		Me.ECU_Status[2]  = "Lock"
		Me.ECU_Status[3]  = "Rel-"
		Me.ECU_Status[4]  = "Glow On"
		Me.ECU_Status[5]  = "Spinning"
		Me.ECU_Status[6]  = "Ignition"
		Me.ECU_Status[7]  = "Heating"
		Me.ECU_Status[8]  = "Acceleration"
		Me.ECU_Status[9]  = "Calibrating"
		Me.ECU_Status[10] = "Idle"
		Me.ECU_Status[99] = "Unknown"
		Me.A4Mult = 1
		Me.ECU_Name = "Orbit"
	else
		-- JetCat	
		Me.ECU_Status[0]  = "OFF"
		Me.ECU_Status[1]  = "Wait for RPM"
		Me.ECU_Status[2]  = "Ignition"
		Me.ECU_Status[3]  = "Accelerate"
		Me.ECU_Status[4]  = "Stabilize"
		Me.ECU_Status[5]  = "Learn High!"
		Me.ECU_Status[6]  = "Learn Low"
		Me.ECU_Status[8]  = "Slow Down"
		Me.ECU_Status[9]  = "Not Used"
		Me.ECU_Status[10] = "Auto Off"
		Me.ECU_Status[11] = "Running"
		Me.ECU_Status[12] = "Accel Delay"
		Me.ECU_Status[13] = "Speed Reg"
		Me.ECU_Status[14] = "2 Shaft Reg"
		Me.ECU_Status[15] = "Preheat 1"
		Me.ECU_Status[16] = "Preheat 2"
		Me.ECU_Status[17] = "Main FStrt"
		Me.ECU_Status[18] = "Not Used"
		Me.ECU_Status[19] = "Kero Full"
		Me.A4Mult = 1
		Me.ECU_Name = "JetCat"
	end	
end

--===================================================
-- Widget Creation
--===================================================
local function createWidget(zone, options)
	local imagePath = "/WIDGETS/TD-RDT/img"
	local Img_BG = Bitmap.open(imagePath.."/RDT_bg.jpg")
	local Img_Aircraft = Bitmap.open("/IMAGES/"..model.getInfo().bitmap)
	local Img_Aircraft_Path = model.getInfo().bitmap
	local TankRemaining = options.Tank_Size
	local LastTime = 0
	local ECU_Name = ""
	local A4Mult = 1
	-- ECU Status table
	local ECU_Status = {}
	-- Initialize with number strings "0" to "100"
	for i=0, 100 do
		ECU_Status[i] = tostring(i)
	end
	-- Detect language for Sensor Battery Name
	local settings = getGeneralSettings()
	if settings['voice'] == "fr" then
		RxBt_Name = 'BtRx'
	else 
		RxBt_Name = 'RxBt'
	end
	--===================================================
	-- LED display images
	--===================================================
	local digit ={
		[0]  = Bitmap.open(imagePath.."/blue/0.png"),
		[1]  = Bitmap.open(imagePath.."/blue/1.png"),
		[2]  = Bitmap.open(imagePath.."/blue/2.png"),
		[3]  = Bitmap.open(imagePath.."/blue/3.png"),
		[4]  = Bitmap.open(imagePath.."/blue/4.png"),
		[5]  = Bitmap.open(imagePath.."/blue/5.png"),
		[6]  = Bitmap.open(imagePath.."/blue/6.png"),
		[7]  = Bitmap.open(imagePath.."/blue/7.png"),
		[8]  = Bitmap.open(imagePath.."/blue/8.png"),
		[9]  = Bitmap.open(imagePath.."/blue/9.png"),
		[10] = Bitmap.open(imagePath.."/blue/nil.png"),
		[11] = Bitmap.open(imagePath.."/blue/col.png")
	}
	local red ={
		[0]  = Bitmap.open(imagePath.."/red/0.png"),
		[1]  = Bitmap.open(imagePath.."/red/1.png"),
		[2]  = Bitmap.open(imagePath.."/red/2.png"),
		[3]  = Bitmap.open(imagePath.."/red/3.png"),
		[4]  = Bitmap.open(imagePath.."/red/4.png"),
		[5]  = Bitmap.open(imagePath.."/red/5.png"),
		[6]  = Bitmap.open(imagePath.."/red/6.png"),
		[7]  = Bitmap.open(imagePath.."/red/7.png"),
		[8]  = Bitmap.open(imagePath.."/red/8.png"),
		[9]  = Bitmap.open(imagePath.."/red/9.png"),
		[10] = Bitmap.open(imagePath.."/red/nil.png"),
		[11] = Bitmap.open(imagePath.."/red/col.png")
	}
	--===================================================
	-- Trim images
	--===================================================
	local Trim_C = Bitmap.open(imagePath.."/trim-c.png")
	local Trim_U = Bitmap.open(imagePath.."/trim-u.png")
	local Trim_D = Bitmap.open(imagePath.."/trim-d.png")
	local Trim_L = Bitmap.open(imagePath.."/trim-l.png")
	local Trim_R = Bitmap.open(imagePath.."/trim-r.png")	
	local Me = { 
		zone=zone, options=options, TankRemaining=TankRemaining, ECU_Name=ECU_Name, A4Mult=A4Mult, LastTime=LastTime, imagePath=imagePath, TopSpeed=TopSpeed, Img_BG = Img_BG, Img_Aircraft = Img_Aircraft, Img_Aircraft_Path = Img_Aircraft_Path,
		rpm=rpm, egt=egt, status=status, batecu=batecu, pump=pump, thr=thr, ECU_Status=ECU_Status, Units=Units, digit=digit, red=red, 
		Trim_C=Trim_C, Trim_U=Trim_U, Trim_D=Trim_D, Trim_L=Trim_L, Trim_R=Trim_R, param={}
	}
	initECU_Status(Me)
	if Me.options.ECU_Type == 7 then 
		-- Swiwin
		--Me.param.Fuel = getTelemetryId("Fuel") --Not valid for Swiwin
		--Me.param.Thro = getTelemetryId("0A20") --Not valid for Swiwin
		--Me.param.A4   = getTelemetryId("A4")   --Not valid for Swiwin
		Me.param.A3   = getTelemetryId("VFAS")
		Me.param.Tmp1 = getTelemetryId("FF02")
		Me.param.RPM  = getTelemetryId("FF01")
		Me.param.Tmp2 = getTelemetryId("FF03")
	elseif Me.options.ECU_Type == 8 then 
		-- Xicoy X
		--Me.param.Fuel = getTelemetryId("0Axx") --4405 fuel
		Me.param.Thro = getTelemetryId("0A22") --4402 throttle
		Me.param.A4   = getTelemetryId("0A24") --4404 pump
		Me.param.A3   = getTelemetryId("0A23") --4403 v ECU
		Me.param.Tmp1 = getTelemetryId("0A20") --4400 EGT
		Me.param.RPM  = getTelemetryId("0A21") --4401 RPM1 (main
		Me.param.Tmp2 = getTelemetryId("0A26") --4406 Status
		--Me.param.Rpm2 = getTelemetryId("0A27") --4414 RPM2
		--Me.param.Temp2 = getTelemetryId("0A28") --441x Temp2

	else
		Me.param.A3   = getTelemetryId("A3")
	end
	Me.param.Curr = getTelemetryId("Curr")
	Me.param.Fuel = getTelemetryId("Fuel")
	Me.param.Thro = getTelemetryId("0A20")
	Me.param.TxV  = getTelemetryId('tx-voltage')
	Me.param.RxBt = getTelemetryId(RxBt_Name)
	Me.param.A4   = getTelemetryId("A4")
	--Me.param.A3   = getTelemetryId("A3")
	Me.param.Tmp1 = getTelemetryId("Tmp1")
	Me.param.RPM  = getTelemetryId("RPM")
	Me.param.Tmp2 = getTelemetryId("Tmp2")
	Me.param.T5   = getTelemetryId('trim-t5')
	Me.param.T6   = getTelemetryId('trim-t6')
	Me.param.TAil = getTelemetryId('trim-ail')
	Me.param.TEle = getTelemetryId('trim-ele')
	Me.param.TThr = getTelemetryId('trim-thr')
	Me.param.TRud = getTelemetryId('trim-rud')
	return Me
end
--===================================================
-- Update the widget
--===================================================
local function updateWidget(Me, newOptions)
	Me.options = newOptions
  	initECU_Status(Me)
end
--===================================================
-- Draw the LED timer display
--===================================================
local function drawTimer(Me,x,y)
	local timeleft = model.getTimer(0).value
	
	local index = 0
    local basewidth = 0
	local clockstr = ""
	if timeleft <= 0 then 
			clockstr = SecondsToClock(-timeleft)
	else
			clockstr = SecondsToClock(timeleft)
	end
	for value in string.gmatch(clockstr, ".") do 
		if index > 2 then
			basewidth = (x + 32 * index) - 17
		else
			basewidth = x + 32 * index
		end
		if string.byte(value) == 58 then
			if timeleft <= 0 then
				lcd.drawBitmap(Me.red[11], basewidth, y)
			else
				lcd.drawBitmap(Me.digit[11], basewidth, y)
			end
		else
			if timeleft <= 0 then
				lcd.drawBitmap(Me.red[string.byte(value) - 48], basewidth, y)
			else
				lcd.drawBitmap(Me.digit[string.byte(value) - 48], basewidth, y)
			end
		end
		index = index + 1
	end
end
--===================================================
-- Draw the trims
--===================================================
local function draw_Trims(Me)
	--Mode 2 designations
	--Center coordinates    --Top/Left coordinates		--Bottom/Right coordinates
	--Ail 155,185			--Ail 115,185				--Ail 202,185
	--Ele 217,117			--Ele 217,72				--Ele 217,162
	--Rud  61,182			--Rud  20,182				--Rud 105,182
	--Thr   2,117			--Thr   3,72				--Thr   3,162
	--T_5  91,48			--T_5  67,48				--T_5 116,48
	--T_6 149,48			--T_6 125,48				--T_6 174,48

	if Me.options.Stick_Mode == 1 then
		--Mode 1
		T1 = round(((getValue(Me.param.TAil))/10.32)/2.7,0)
		T2 = round(-((getValue(Me.param.TThr))/10.32)/2.7,0)
		T3 = round(-((getValue(Me.param.TEle))/10.32)/2.7,0)
		T4 = round(((getValue(Me.param.TRud))/10.32)/2.7,0)
	elseif Me.options.Stick_Mode == 3 then
		--Mode 3
		T1 = round(((getValue(Me.param.TRud))/10.32)/2.7,0)
		T2 = round(-((getValue(Me.param.TThr))/10.32)/2.7,0)
		T3 = round(-((getValue(Me.param.TEle))/10.32)/2.7,0)
		T4 = round(((getValue(Me.param.TAil))/10.32)/2.7,0)
	elseif Me.options.Stick_Mode == 4 then
		--Mode 4
		T1 = round(((getValue(Me.param.TRud))/10.32)/2.7,0)
		T2 = round(-((getValue(Me.param.TEle))/10.32)/2.7,0)
		T3 = round(-((getValue(Me.param.TThr))/10.32)/2.7,0)
		T4 = round(((getValue(Me.param.TAil))/10.32)/2.7,0)
	else
		--Mode 2
		T1 = round(((getValue(Me.param.TAil))/10.32)/2.7,0)
		T2 = round(-((getValue(Me.param.TEle))/10.32)/2.7,0)
		T3 = round(-((getValue(Me.param.TThr))/10.32)/2.7,0)
		T4 = round(((getValue(Me.param.TRud))/10.32)/2.7,0)
	end
	T5 = round(((getValue(Me.param.T5))/10.32)/4.75,0)
	T6 = round(((getValue(Me.param.T6))/10.32)/4.75,0)

	--T1
	if T1 > 0 then
		lcd.drawBitmap(Me.Trim_R,155+T1,183)	
	elseif T1 < 0 then
		lcd.drawBitmap(Me.Trim_L,155+T1,183)	
	else
		lcd.drawBitmap(Me.Trim_C,155+T1,183)	
	end
	--T2
	if T2 > 0 then
		lcd.drawBitmap(Me.Trim_D,217,116+T2)
	elseif T2 < 0 then
		lcd.drawBitmap(Me.Trim_U,217,116+T2)
	else
		lcd.drawBitmap(Me.Trim_C,217,116+T2)
	end
	--T3
	if T3 > 0 then
		lcd.drawBitmap(Me.Trim_D,2,116+T3)
	elseif T3 < 0 then
		lcd.drawBitmap(Me.Trim_U,2,116+T3)
	else
		lcd.drawBitmap(Me.Trim_C,2,116+T3)
	end
	--T4
	if T4 > 0 then
		lcd.drawBitmap(Me.Trim_R,61+T4,183)	
	elseif T4 < 0 then
		lcd.drawBitmap(Me.Trim_L,61+T4,183)	
	else
		lcd.drawBitmap(Me.Trim_C,61+T4,183)	
	end
	--T5
	if T5 > 0 then
		lcd.drawBitmap(Me.Trim_R,80+T5,48)	
	elseif T5 < 0 then
		lcd.drawBitmap(Me.Trim_L,80+T5,48)	
	else
		lcd.drawBitmap(Me.Trim_C,80+T5,48)	
	end
	--T6
	if T6 > 0 then
		lcd.drawBitmap(Me.Trim_R,137+T6,48)	
	elseif T6 < 0 then
		lcd.drawBitmap(Me.Trim_L,137+T6,48)	
	else
		lcd.drawBitmap(Me.Trim_C,137+T6,48)	
	end
end
--===================================================
-- Draw the Turbine Status
--===================================================
local function drawTurbine(Me,x,y)
	if getValue(Me.param.Tmp2) > 100 then
		lcd.drawText(x,y-10,"No Status",MIDSIZE)
	else
		lcd.drawText(x,y-10,Me.ECU_Status[getValue(Me.param.Tmp2)],MIDSIZE)
	end
	lcd.drawText(x,y+33,"RPM:")
	if Me.options.ECU_Type == 7 or Me.options.ECU_Type == 8 then
		lcd.drawText(x+52,y+26,format_thousand(getValue(Me.param.RPM)),MIDSIZE)
	else
		lcd.drawText(x+52,y+26,format_thousand(getValue(Me.param.RPM)*100),MIDSIZE)
	end
	lcd.drawText(x,y+58,"EGT:")
	lcd.drawText(x+52,y+51,getValue(Me.param.Tmp1).."c",MIDSIZE)
	lcd.drawText(x,y+83,"Pump:")
	if Me.options.ECU_Type < 3 then
		lcd.drawText(x+52,y+76,round(getValue(Me.param.A4)*Me.A4Mult,2).."v",MIDSIZE)
	elseif Me.options.ECU_Type == 7 then
		if getValue(Me.param.Tmp2) == 11 then -- is ECU in running state?
			lcd.drawText(x+52,y+76,round(getValue(Me.param.Curr)*100,2),MIDSIZE)
		end
	else
		lcd.drawText(x+52,y+76,round(getValue(Me.param.A4)*Me.A4Mult,2),MIDSIZE)
	end
	lcd.drawText(x,y+108,"ECU:")
	if Me.options.ECU_Type == 8 then
		lcd.drawText(x+52,y+101,round(getValue(Me.param.A3)*0.1,2).."v",MIDSIZE)
	else
		lcd.drawText(x+52,y+101,round(getValue(Me.param.A3),2).."v",MIDSIZE)
	end
end

--===================================================
-- Update Fuel Data
--===================================================
local function updateTank(Me)
	local time = getTime()
	local pump = 0
	if time > Me.LastTime + 100 then
		if Me.options.ECU_Type == 3 or Me.options.ECU_Type == 4 or Me.options.ECU_Type == 6 or Me.options.ECU_Type == 8 or Me.options.ECU_Type == 9 or Me.options.ECU_Type == 7 then
			--Xicoy X, KT, Linton, Swiwin (calculated value)
			if Me.options.ECU_Type == 7 then
				pump = getValue(Me.param.Curr) * Me.A4Mult
			else
				pump = getValue(Me.param.A4) * Me.A4Mult
			end
			--Adjust pump value for Linton
			if Me.options.ECU_Type == 6 then
				pump = pump / 10
			end
			if pump > 0 then
				if Me.options.ECU_Type == 7 then -- is Swiwin?
					if getValue(Me.param.Tmp2) == 11 then -- is ECU in running state?
						Me.TankRemaining = Me.TankRemaining - pump * Me.options.FuelFactor * 0.0001
					end
				elseif Me.options.ECU_Type == 9 then 
				        Me.TankRemaining = Me.TankRemaining - pump * Me.options.FuelFactor * 0.001
				else
					Me.TankRemaining = Me.TankRemaining - pump * Me.options.FuelFactor * 0.0001
				end
			end
		else
			--Others (actual value from telemetry)
			Me.TankRemaining = getValue(Me.param.Fuel)
		end
		if Me.TankRemaining < Me.options.Fuel_Alarm then
			--Alarm triggered, set GV9 to a value of 1
			model.setGlobalVariable(8,getFlightMode(),1)
		else
			--Alarm NOT triggered, set GV9 to a value of 0
			model.setGlobalVariable(8,getFlightMode(),0)
		end
		--update the LastTime with current time
		Me.LastTime = time
 	end
end

--===================================================
-- Refresh the widget
--===================================================
local function refreshWidget(Me)
	--save the original text color
	ORIG_COLOR = TEXT_COLOR
	--set the text color to white
	lcd.setColor(TEXT_COLOR,WHITE)
	--Update fuel data
	updateTank(Me)
	--Background image
	lcd.drawBitmap(Me.Img_BG, 0, 0)
	--Aircraft image
	if Me.Img_Aircraft_Path ~= model.getInfo().bitmap then
		Me.Img_Aircraft_Path = model.getInfo().bitmap
		Me.Img_Aircraft = Bitmap.open("/IMAGES/"..model.getInfo().bitmap)
	end
	lcd.drawBitmap(Me.Img_Aircraft, 18, 63)
	--Trims
	draw_Trims(Me)
	--Timer
	drawTimer(Me,293,65)
	--Turbine Info
	drawTurbine(Me,292,135)
	--Aircraft Name
	lcd.drawText(7,3,model.getInfo().name,DBLSIZE)
	--RSSI
	lcd.drawText(300,3,"RSSI",SMLSIZE)
	lcd.drawText(300,15,getRSSI(),MIDSIZE)
	--Rx Battery voltage
	lcd.drawText(363,3,"RxBatt",SMLSIZE+BLACK)	
	lcd.drawText(363,15,round(getValue(Me.param.RxBt),1).."v",MIDSIZE)
	--Tx Battery voltage
	lcd.drawText(422,3,"TxBatt",SMLSIZE+BLACK)
	lcd.drawText(422,15,round(getValue(Me.param.TxV),1).."v",MIDSIZE)
	--Display based on ECU type
	-- 1 = jetcat
	-- 2 = projet
	-- 3 = xicoy
	-- 4 = kingtech
	-- 5 = jetcentral
	-- 6 = Linton
	-- 7 = Swiwin
	-- 8 = Xicoy X
	-- 9 = Orbit 
	if Me.options.ECU_Type == 3 or Me.options.ECU_Type == 4 or Me.options.ECU_Type == 7 then
		--Xicoy, KingTech, Swiwin, Orbit
		thr_val = round(getValue(Me.param.Fuel) * 1 ,1)
		fuel_val = round(Me.TankRemaining, 0)
	elseif Me.options.ECU_Type == 9 then
		--Linton
		thr_val = round(getValue(Me.param.Thro) * 1 ,1)
		fuel_val = round(Me.TankRemaining, 0)
	elseif Me.options.ECU_Type == 6 then
		--Linton
		thr_val = round(getValue(Me.param.Thro) * 1 ,1)
		fuel_val = round(Me.TankRemaining, 0)
	elseif Me.options.ECU_Type == 8 then
		--Xicoy X
		thr_val = round(getValue(Me.param.Thro),1)
		fuel_val = round(Me.TankRemaining, 0)
	else
		--ProJet, JetCat, JetCentral
		thr_val = round(getValue(Me.param.Thro),1)
		fuel_val = round(getValue(Me.param.Fuel),1)
	end
	if Me.options.ECU_Type == 5 or Me.options.ECU_Type == 6 or Me.options.ECU_Type == 7  then
		--JetCentral, Linton, Swiwin Current
		lcd.drawText(168,199,"Current:", SMLSIZE )
		lcd.drawText(168,212, round(getValue(Me.param.Curr),1).."A",MIDSIZE )
	end
	if Me.options.ECU_Type == 6 then
		--Lintom mAh
		lcd.drawText(227,199,"Batt mAh:", SMLSIZE )
		--lcd.drawText(230,212, round(getValue(Me.param.Fuel),1).."mAh",MIDSIZE )
		lcd.drawText(227,212, round(getValue(Me.param.Fuel),1),MIDSIZE )
	end
	--Throttle
	lcd.drawText(14,199,"Throttle:", SMLSIZE )
	if Me.options.ECU_Type == 7 then
		lcd.drawText(14,212, round((getValue("thr") + 1024)/20.48).."%",MIDSIZE )
	else
		if thr_val >= 0 and thr_val <= 100 then
			lcd.drawText(14,212, thr_val.."%",MIDSIZE )
		end
	end
	--Fuel
	lcd.drawText(78,199,"Fuel:", SMLSIZE )
	--set the text to red if we are below the fuel warning level
	if model.getGlobalVariable(8, getFlightMode()) == 1 then
		lcd.setColor(TEXT_COLOR,RED)
	end		
	lcd.drawText(78,212, fuel_val.."ml",MIDSIZE )
	lcd.setColor(TEXT_COLOR,WHITE)
	--display the ECU type
	lcd.drawText(212,252,Me.ECU_Name, SMLSIZE )
	--display the widget version
	lcd.drawText(442,252,"1.0.1", SMLSIZE )	--debug output area-----------------------------------
	--lcd.drawText(212,239,Me.options.ECU_Type, SMLSIZE )
	------------------------------------------------------
	--set the text color back to the original
	lcd.setColor(TEXT_COLOR,ORIG_COLOR)
end

--===================================================
-- Background process (when widget not visible)
--===================================================
local function backgroundProcessWidget(Me)
	updateTank(Me)
end

--===================================================
-- Widget return fuctions
--===================================================
return { name="TD-RDT", options=defaultOptions, create=createWidget, update=updateWidget, background=backgroundProcessWidget, refresh=refreshWidget }