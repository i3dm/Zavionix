-- ********************************************************************************
-- **  Zavionix® LZRDT Widget Screen (LZ-RDT)                                    **
-- ********************************************************************************
-- **  Author: Lior Zahavi (i3dm)®  February 2022, Email: zavionixrc@gmail.com   **
-- **  1. Widget is free to use for personal use, and its not allowed to         **
-- **  distribute or forward it to anyone else. If anyone else needs it, please  **
-- **  give him my email address and ask him to contact me.                      **
-- **  2. Widgets are given for FREE as a gift from me to the RC community which **
-- **  I love so much. If you do like to send a donation to cover some of the    **
-- **  huge amount of hours put into the development, it is always very          **
-- **  appreciated and you may do so via paypal:   i3dm@hotmail.com              **
-- ********************************************************************************
local RDTversion = "V1.1.04"
local imagePath = "/scripts/RDTtwin/img"
local Time_Temp = 0
local SticksMode
local ecu_type
local RDT_Tmp1source_R
local RDT_Tmp1source_L
local EGT_R
local EGT_L
local RDT_RPMsource_R
local RDT_RPMsource_L
local RPM_R
local RPM_L
local RDT_Tmp2source_R
local RDT_ADC3source_R
local RDT_ADC4source_R
local RDT_Tmp2source_L
local RDT_ADC3source_L
local RDT_ADC4source_L
local Pump_R
local Pump_R_Value
local Pump_L
local Pump_L_Value
local Turbine_Status_R
local Turbine_Status_L
local screenSize
local RDT_RSSI1source
local RSSI1Value
local RDT_RSSI2source
local RSSI2Value
local RSSI1
local RSSI2
local RDT_RXbattsource
local RXbatt
local TxBatt
local timer
local timer_Secs
local timer_Mins
local TimerDigit1
local TimerDigit2
local TimerDigit3
local TimerDigit4
local screenSize
local Trimvalue0
local Trimvalue1
local Trimvalue2
local Trimvalue3
local SticksMode
local EcuV_R
local EcuV_L
local RDT_Currsource_R
local RDT_Drawsource_R
local RDT_Currsource_L
local RDT_Drawsource_L
local Current_R
local Current_L
local RDT_0A10source_R
local RDT_0A20source_R
local RDT_0A30source_R
local RDT_0A10source_L
local RDT_0A20source_L
local RDT_0A30source_L
local Thro_R
local mAh_R
local CurrentFuelCapacity_R
local Thro_L
local mAh_L
local CurrentFuelCapacity_L
local FuelFactor_R
local FuelFactor_L
local AnalogThrottle_R
local Throttlepercentage_R
local AnalogThrottle_L
local Throttlepercentage_L
local RDT_RPMsource_R
local RDT_RPMsource_L
local LowFuelSound = "/scripts/RDTtwin/LowFul.wav" -- audio file for fuel alert, change as neccessary 
local RDTcount = 0
local RDTcycleCounter = 0
local RDTbgroundCounter = 0
local RDTwidgetTime = 0
local Pressure = 0
local RDT_Pressuresource = 0
local SW_Mode_Status_R = 0
local SW_Mode_Status_L = 0
local paint_rate_Hz = 3 -- invalidate / paint LCD every paint_rate_Hz
local invalidateme = 0

digit =
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
red =
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
	local Trim_C = lcd.loadBitmap(imagePath.."/trim-c.png")
	local Trim_U = lcd.loadBitmap(imagePath.."/trim-u.png")
	local Trim_D = lcd.loadBitmap(imagePath.."/trim-d.png")
	local Trim_L = lcd.loadBitmap(imagePath.."/trim-l.png")
	local Trim_R = lcd.loadBitmap(imagePath.."/trim-r.png")
	local Trim_Red = lcd.loadBitmap(imagePath.."/trimRed.png")
	local Trim_Green = lcd.loadBitmap(imagePath.."/trimGreen.png")	 


--===================================================
-- Setup the Status_R message table based on ECU type
--===================================================
local function initECU_Status(Me)
	ECU_Status = {}
	 for i=0, 100 do
      ECU_Status[i] = i
    end
	Switch_Status_R = {}
	 for i=0, 100 do
      Switch_Status_R[i] = i
    end	
	
		if ecu_type == 2 then
		-- 	ProJet
		ECU_Status[0]  = "Off"
		ECU_Status[1]  = "Standby"
		ECU_Status[2]  = "Auto"
		ECU_Status[5]  = "Fuel Ignite"
		ECU_Status[7]  = "Ramp Up"
		ECU_Status[8]  = "Fuel Heat"
		ECU_Status[9]  = "Slow Down"
		ECU_Status[10] = "Cool Down"
		ECU_Status[11] = "Calibrate"
		ECU_Status[12] = "Cal Idle"
		ECU_Status[13] = "Go Idle"
		ECU_Status[15] = "Burner On"
		ECU_Status[16] = "Auto HC"
		ECU_Status[18] = "Wait ACC"
		ECU_Status[23] = "Preheat"
		ECU_Status[25] = "Burn Out"
		ECU_Status[26] = "Steady"	
		A4Mult = 1
		ECU_Name = "ProJet"
	elseif ecu_type == 3 then
		-- Xicoy	
		ECU_Status[0]  = "No Status"
		ECU_Status[1]  = "No RC Signal"
		ECU_Status[2]  = "Trim Low"
		ECU_Status[4]  = "Ready"
		ECU_Status[5]  = "StickLow"
		ECU_Status[6]  = "Glow test"
		ECU_Status[7]  = "Glow Bad"
		ECU_Status[8]  = "Start On"
		ECU_Status[9]  = "Cooling"
		ECU_Status[10] = "Burner on"
		ECU_Status[11] = "Pre Heat"
		ECU_Status[12] = "Switch Over"
		ECU_Status[13] = "Start On"
		ECU_Status[14] = "Ignition"
		ECU_Status[15] = "Fuel Ramp"
		ECU_Status[16] = "Running"
		ECU_Status[17] = "Stop"
		ECU_Status[18] = "Start Bad"
		ECU_Status[19] = "Low RPM_R"
		ECU_Status[20] = "High Temp"
		ECU_Status[21] = "Flame Out"
		ECU_Status[22] = "Speed Low"
		A4Mult = 100
		ECU_Name = "Xicoy"
	elseif ecu_type == 4 then
		-- KingTech G2-G4
		ECU_Status[0]  = "No Status"
		ECU_Status[1]  = "No RC Signal"
		ECU_Status[2]  = "Trim Low"
		ECU_Status[4]  = "Ready"
		ECU_Status[5]  = "StickLow"
		ECU_Status[6]  = "Glow test"
		ECU_Status[7]  = "Glow Bad"
		ECU_Status[8]  = "Start On"
		ECU_Status[9]  = "Cooling"
		ECU_Status[10] = "Burner on"
		ECU_Status[11] = "Pre Heat"
		ECU_Status[12] = "Switch Over"
		ECU_Status[13] = "Start On"
		ECU_Status[14] = "Ignition"
		ECU_Status[15] = "Fuel Ramp"
		ECU_Status[16] = "Running"
		ECU_Status[17] = "Stop"
		ECU_Status[18] = "Start Bad"
		ECU_Status[19] = "Low RPM_R"
		ECU_Status[20] = "High Temp"
		ECU_Status[21] = "Flame Out"
		ECU_Status[22] = "Low Batt"
		ECU_Status[23] = "PrimeVap"
		ECU_Status[24] = "Stage1"
		ECU_Status[25] = "Stage2"
		ECU_Status[26] = "Stage3"
		A4Mult = 100
		ECU_Name = "KingTech"
	elseif ecu_type == 5 then
		-- JetCentral
		ECU_Status[0]  = "No Status"
		ECU_Status[10] = "Stop"
		ECU_Status[20] = "Glow Test"
		ECU_Status[30] = "Starter Test"
		ECU_Status[31] = "Prime Fuel"
		ECU_Status[32] = "Prime Burner"
		ECU_Status[40] = "Manual Cool"
		ECU_Status[41] = "Auto cooling"
		ECU_Status[51] = "Igniter Heat"
		ECU_Status[52] = "Ignition"
		ECU_Status[53] = "Pre Heat"
		ECU_Status[54] = "Switch Over"
		ECU_Status[55] = "To Idle"
		ECU_Status[56] = "Running"
		ECU_Status[62] = "Stop-Error"
		A4Mult = 1000
		ECU_Name = "JetCentral"
	elseif ecu_type == 6 then
		-- Linton V1
		ECU_Status[0]  = "Ready"
		ECU_Status[1]  = "Start"
		ECU_Status[2]  = "Burner"
		ECU_Status[3]  = "Ignition Success"
		ECU_Status[4]  = "Pre-Heat (1)"
		ECU_Status[5]  = "Pre-Heat (2)"
		ECU_Status[6]  = "Pre-Heat (3)"
		ECU_Status[7]  = "Pre-Heat (4)"
		ECU_Status[8]  = "Pre-Heat (5)"
		ECU_Status[9]  = "Running"
		ECU_Status[10] = "Idling"
		ECU_Status[11] = "Accelleration"
		ECU_Status[12] = "Deceleration"
		ECU_Status[13] = "Uniform Speed"
		ECU_Status[14] = "Uniform Speed"
		ECU_Status[15] = "RC Learning"
		ECU_Status[16] = "Idling(1)"
		ECU_Status[17] = "Cooling"
		ECU_Status[18] = "Cooling"
		ECU_Status[19] = "Cooling"
		ECU_Status[20] = "Cooling"
		ECU_Status[21] = "idling"
		ECU_Status[22] = "Power Limit"
		ECU_Status[23] = "RC Lost"
		ECU_Status[24] = "Ready to Start"
		ECU_Status[25] = "Uniform Speed"
		ECU_Status[26] = "Uniform Speed"
		ECU_Status[27] = "Successful"
		ECU_Status[28] = "Max Throttle"
		ECU_Status[29] = "Restart"
		A4Mult = 100
		ECU_Name = "Linton V1"
	elseif ecu_type == 7 then
		-- Swiwin
		ECU_Status[0]   = "Stop"
		ECU_Status[1]   = "Ready"
		ECU_Status[2]   = "Ign(StickDown)"
		ECU_Status[3]   = "Ignition"
		ECU_Status[4]   = "Preheat"
		ECU_Status[5]   = "Fuelramp"
		ECU_Status[6]   = "LearnStickMax"
		ECU_Status[7]   = "LearnStickMin"
		ECU_Status[8]   = "Learn Rc..."
		ECU_Status[9]   = "Run(StickMin)"
		ECU_Status[10]  = "Run(Pump_RLimit)"
		ECU_Status[11]  = "Running"
		ECU_Status[12]  = "Cooling"
		ECU_Status[13]  = "Restart"
		ECU_Status[14]  = "TestGlowPlug"
		ECU_Status[15]  = "TestFuelValve"
		ECU_Status[16]  = "TestGasValve"
		ECU_Status[17]  = "Testpump"
		ECU_Status[18]  = "TestStarter"
		ECU_Status[19]  = "ExhaustAir"
		ECU_Status[-1]  = "Time Out"
		ECU_Status[-2]  = "Low Battery"
		ECU_Status[-3]  = "GlowPlug Bad"
		ECU_Status[-4]  = "Fuel Anomaly"
		ECU_Status[-5]  = "Starter failure"
		ECU_Status[-6]  = "RPM_R Low"
		ECU_Status[-7]  = "RPM_R Instability"
		ECU_Status[-8]  = "High Temperature"
		ECU_Status[-9]  = "Low Temperature"
		ECU_Status[-10] = "Temp Sensor failure"
		ECU_Status[-11] = "Gas Valve Bad"
		ECU_Status[-12] = "Fuel Valve Bad"
		ECU_Status[-13] = "Lost Signal"
		ECU_Status[-14] = "Starter Temp High"
		ECU_Status[-15] = "Pump_R Temp High"
		ECU_Status[-16] = "Clutch failure"
		ECU_Status[-17] = "Current_R overload"
		ECU_Status[-18] = "Engine Offline"
		A4Mult = 100
		ECU_Name = "Swiwin"
	elseif ecu_type == 8 then
		-- Xicoy X
		ECU_Status[0]  = "HighTemp"
		ECU_Status[1]  = "Trim Low"
		ECU_Status[2]  = "SetIdle!"
		ECU_Status[3]  = "Ready"
		ECU_Status[4]  = "Ignition"
		ECU_Status[5]  = "FuelRamp"
		ECU_Status[6]  = "Glow Test"
		ECU_Status[7]  = "Running"
		ECU_Status[8]  = "Stop"
		ECU_Status[9]  = "FlameOut"
		ECU_Status[10] = "SpeedLow"
		ECU_Status[11] = "Cooling"
		ECU_Status[12] = "Ignit.Bad"
		ECU_Status[13] = "Start.Fail"
		ECU_Status[14] = "AccelFail"
		ECU_Status[15] = "Start On"
		ECU_Status[16] = "UserOff"
		ECU_Status[17] = "Failsafe"
		ECU_Status[18] = "Low RPM_R"
		ECU_Status[19] = "Reset"
		ECU_Status[20] = "RXPwFail"
		ECU_Status[21] = "PreHeat"
		ECU_Status[22] = "Battery!"
		ECU_Status[23] = "Time Out"
		ECU_Status[24] = "Overload"
		ECU_Status[25] = "Ign.Fail"
		ECU_Status[26] = "Burner On"
		ECU_Status[27] = "Starting"
		ECU_Status[28] = "SwitchOv"
		ECU_Status[29] = "Cal.pump"
		ECU_Status[30] = "Pump_RLimi"
		ECU_Status[31] = "NoEngine"
		ECU_Status[32] = "PwrBoost"
		ECU_Status[33] = "Run-Idle"
		ECU_Status[34] = "Run-Max "
		ECU_Status[35] = "Restart "
		ECU_Status[36] = "No Status"
		A4Mult = 100
		ECU_Name = "Xicoy X"
	elseif ecu_type == 9 then
		-- Orbit
		ECU_Status[0]  = "No Status"
		ECU_Status[1]  = "Stop"
		ECU_Status[2]  = "Lock"
		ECU_Status[3]  = "Rel"
		ECU_Status[4]  = "Glow On"
		ECU_Status[5]  = "Spinning"
		ECU_Status[6]  = "Ignition"
		ECU_Status[7]  = "Heating"
		ECU_Status[8]  = "Acceleration"
		ECU_Status[9]  = "Calibrating"
		ECU_Status[10] = "Idle"
		ECU_Status[11] = "Run"
		ECU_Status[12] = "Stop"
		ECU_Status[13] = "No ID"
		ECU_Status[14] = "Off"
		ECU_Status[15] = "Running" --this is for when Thr% is displayed
		ECU_Status[99] = "Unknown"
		A4Mult = 1
		ECU_Name = "Orbit"
	elseif ecu_type == 10 then
		-- Linton V2
		ECU_Status[0]="Ready"
		ECU_Status[1]="Ready start"
		ECU_Status[2]="Start"
		ECU_Status[3]="Burner "
		ECU_Status[4]="Success"
		ECU_Status[5]="Heating1 "
		ECU_Status[6]="Heating2 "
		ECU_Status[7]="Heating3 "
		ECU_Status[8]="Heating4 "
		ECU_Status[9]="Heating5 "
		ECU_Status[10]="Heating6 "
		ECU_Status[11]="Pump_R Acc "
		ECU_Status[12]="CTH "
		ECU_Status[13]="Idling(1)"
		ECU_Status[14]="Idling(2)"
		ECU_Status[15]="Acc"
		ECU_Status[16]="Dec"
		ECU_Status[17]="Speed"
		ECU_Status[18]="Max Speed"
		ECU_Status[19]="RC learn"
		ECU_Status[20]="RC learning"
		ECU_Status[21]="RC Successful"
		ECU_Status[22]="Cooling(1)"
		ECU_Status[23]="Cooling(2)"
		ECU_Status[24]="Restart(1)"
		ECU_Status[25]="Restart(2)"
		ECU_Status[26]="RC lost"
		ECU_Status[27]="Power limit!"
		ECU_Status[28]="Speed"
		ECU_Status[29]="Idling1"
		ECU_Status[30]="Idling2"
		ECU_Status[31]="Cooling1"
		ECU_Status[32]="Cooling2"
		ECU_Status[33]="Speed1"
		ECU_Status[34]="Speed2"
		-- Fault Status_R
		ECU_Status[35]="Volt Low"
		ECU_Status[36]="Volt High"
		ECU_Status[37]="TT Open "
		ECU_Status[38]="TT GND "
		ECU_Status[39]="TT VCC "
		ECU_Status[40]="RPM_R Low"
		ECU_Status[41]="HEGT1  "
		ECU_Status[42]="HEGT2"
		ECU_Status[43]="HEGT3"
		ECU_Status[44]="HEGT4"
		ECU_Status[45]="CTH Time"
		ECU_Status[46]="Idle Time"
		ECU_Status[47]="Idle21"
		ECU_Status[48]="Acc22"
		ECU_Status[49]="Dec23"
		ECU_Status[50]="Restart Err"
		ECU_Status[51]="EGT_R Warn"
		ECU_Status[52]="RC Lost Off"
		ECU_Status[53]="RPM_R Err"
		ECU_Status[54]="Motor Err "
		ECU_Status[55]="Pump_R Err "
		ECU_Status[56]="Temp high"
		ECU_Status[57]="IGT Err1 "
		ECU_Status[58]="IGT Err2 "
		ECU_Status[59]="OveRCurrent"
		ECU_Status[60]="Motor Err1"
		ECU_Status[61]="Motor Err2"
		ECU_Status[62]="Fuel Err"
		A4Mult = 100
		ECU_Name = "Linton V2"	
	elseif ecu_type == 11 then
		-- Orbit
		ECU_Status[0]  = "Unknown"
		ECU_Status[1]  = "Start Clr"
		ECU_Status[2]  = "Starting"
		ECU_Status[3]  = "StartedUp"
		ECU_Status[4]  = "IdleCalib"
		ECU_Status[5]  = "Max RPM_R"
		ECU_Status[99] = "Unknown"
		Switch_Status_R[0]  = "N/A"
		Switch_Status_R[1]  = "Off"
		Switch_Status_R[2]  = "Stop"
		Switch_Status_R[3]  = "On"
		Switch_Status_R[99] = "Unknown"
		A4Mult = 100
		ECU_Name = "AMT"
	else -- ECU type 1
		-- JetCat	
		ECU_Status[0]  = "OFF"
		ECU_Status[1]  = "Wait for RPM_R"
		ECU_Status[2]  = "Ignition"
		ECU_Status[3]  = "Accelerate"
		ECU_Status[4]  = "Stabilize"
		ECU_Status[5]  = "Learn High!"
		ECU_Status[6]  = "Learn Low"
		ECU_Status[8]  = "Slow Down"
		ECU_Status[9]  = "Not Used"
		ECU_Status[10] = "Auto Off"
		ECU_Status[11] = "Running"
		ECU_Status[12] = "Accel Delay"
		ECU_Status[13] = "Speed Reg"
		ECU_Status[14] = "2 Shaft Reg"
		ECU_Status[15] = "Preheat 1"
		ECU_Status[16] = "Preheat 2"
		ECU_Status[17] = "Main FStrt"
		ECU_Status[18] = "Not Used"
		ECU_Status[19] = "Kero Full"
		A4Mult = 1
		ECU_Name = "JetCat"
	end	
end

--===================================================
-- Draw the trims
--===================================================
local function draw_Trims(Me)
lcd.font(FONT_S)
--Analog6 = system.getSource({category=CATEGORY_ANALOG, member=6, options=0}) -- red slider
Analog6 = system.getSource({category=CATEGORY_ANALOG, member=ANALOG_FIRST_SLIDER, options=0}) -- red slider
Analogvalue6 = Analog6:value()
Trim0 = system.getSource({category=CATEGORY_TRIM, member=0, options=0}) -- rudder trim 
Trimvalue0 = Trim0:value()
Trim1 = system.getSource({category=CATEGORY_TRIM, member=1, options=0}) -- elevator trim
Trimvalue1 = Trim1:value()
Trim2 = system.getSource({category=CATEGORY_TRIM, member=2, options=0}) -- throttle trim
Trimvalue2 = Trim2:value()
Trim3 = system.getSource({category=CATEGORY_TRIM, member=3, options=0}) -- aileron trim
Trimvalue3 = Trim3:value()

if (screenSize == "X20fullScreenWithTitle") or (screenSize == "X20fullScreenWithOutTitle") then
if (SticksMode == 1) then -- mode 1
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(135,380  ,Trim_C)	-- center trim rudder
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(135+ Trimvalue0/14,380  ,Trim_R)
		else
		lcd.drawBitmap(135+ Trimvalue0/14,380  ,Trim_L)
		end
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(310,380  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(310+ Trimvalue3/14,380  ,Trim_R)
		else
		lcd.drawBitmap(310+ Trimvalue3/14,380  ,Trim_L)
		end
	if (Trimvalue2 ==0) then
		lcd.drawBitmap(414,227  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(414,227- Trimvalue2/14  ,Trim_U)
		else
		lcd.drawBitmap(414,227- Trimvalue2/14  ,Trim_D)
		end
	if (Trimvalue1 ==0) then
		lcd.drawBitmap(33,227  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(33,227- Trimvalue1/14  ,Trim_U)
		else
		lcd.drawBitmap(33,227- Trimvalue1/14  ,Trim_D)
		end
elseif (SticksMode == 2) then -- mode 2
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(135,380  ,Trim_C)	-- center trim rudder
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(135+ Trimvalue0/14,380  ,Trim_R)
		else
		lcd.drawBitmap(135+ Trimvalue0/14,380  ,Trim_L)
		end
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(310,380  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(310+ Trimvalue3/14,380  ,Trim_R)
		else
		lcd.drawBitmap(310+ Trimvalue3/14,380  ,Trim_L)
		end
	if (Trimvalue1 ==0) then
		lcd.drawBitmap(414,227  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(414,227- Trimvalue1/14  ,Trim_U)
		else
		lcd.drawBitmap(414,227- Trimvalue1/14  ,Trim_D)
		end
	if (Trimvalue2 ==0) then
		lcd.drawBitmap(33,227  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(33,227- Trimvalue2/14  ,Trim_U)
		else
		lcd.drawBitmap(33,227- Trimvalue2/14  ,Trim_D)
		end
elseif (SticksMode == 3) then-- mode 3
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(310,380  ,Trim_C)	-- center trim rudder
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(310+ Trimvalue3/14,380  ,Trim_R)
		else
		lcd.drawBitmap(310+ Trimvalue3/14,380  ,Trim_L)
		end
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(135,380  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(135+ Trimvalue0/14,380  ,Trim_R)
		else
		lcd.drawBitmap(135+ Trimvalue0/14,380  ,Trim_L)
		end
	if (Trimvalue2 ==0) then
		lcd.drawBitmap(33,227  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(33,227- Trimvalue2/14  ,Trim_U)
		else
		lcd.drawBitmap(33,227- Trimvalue2/14  ,Trim_D)
		end

	if (Trimvalue1 ==0) then
		lcd.drawBitmap(414,227  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(414,227- Trimvalue1/14  ,Trim_U)
		else
		lcd.drawBitmap(414,227- Trimvalue1/14  ,Trim_D)
		end
else -- mode 4
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(310,380  ,Trim_C)	-- center trim rudder
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(310+ Trimvalue3/14,380  ,Trim_R)
		else
		lcd.drawBitmap(310+ Trimvalue3/14,380  ,Trim_L)
		end
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(135,380  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(135+ Trimvalue0/14,380  ,Trim_R)
		else
		lcd.drawBitmap(135+ Trimvalue0/14,380  ,Trim_L)
		end
	if (Trimvalue1 ==0) then
		lcd.drawBitmap(414,227  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(414,227- Trimvalue1/14  ,Trim_U)
		else
		lcd.drawBitmap(414,227- Trimvalue1/14  ,Trim_D)
		end
	if (Trimvalue2 ==0) then
		lcd.drawBitmap(33,227  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(33,227- Trimvalue2/14  ,Trim_U)
		else
		lcd.drawBitmap(33,227- Trimvalue2/14  ,Trim_D)
		end
end

	if (Analogvalue6 > 1020) then -- max is 1024
	lcd.drawBitmap(457,227- Analogvalue6/14   ,Trim_Green)	-- Red slider
	else
	lcd.drawBitmap(457,227- Analogvalue6/14   ,Trim_Red)	-- Red slider
	end
	--=====================================--
	                 -- X10/X18 --
	--=====================================--			   
	elseif ((screenSize == "X10fullScreenWithOutTitle") or (screenSize == "X18fullScreenWithTitle") or (screenSize == "X18fullScreenWithOutTitle")) then  -- X10 / X18         
	Trim4 = system.getSource({category=CATEGORY_TRIM, member=4, options=0}) -- throttle trim
	Trimvalue4 = Trim4:value()
	Trim5 = system.getSource({category=CATEGORY_TRIM, member=5, options=0}) -- aileron trim
	Trimvalue5 = Trim5:value()

if (SticksMode == 1) then -- mode 1
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(75,213  ,Trim_C)	-- center trim rudder
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(75+ Trimvalue0/23,213  ,Trim_R)
		else
		lcd.drawBitmap(75+ Trimvalue0/23,213  ,Trim_L)
		end
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(183,213  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(183+ Trimvalue3/23,213  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue3/23,213  ,Trim_L)
		end
	if (Trimvalue2 ==0) then
		lcd.drawBitmap(246,127  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(246,127- Trimvalue2/23  ,Trim_U)
		else
		lcd.drawBitmap(246,127- Trimvalue2/23  ,Trim_D)
		end
	if (Trimvalue1 ==0) then
		lcd.drawBitmap(17,127  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(17,127- Trimvalue1/23  ,Trim_U)
		else
		lcd.drawBitmap(17,127- Trimvalue1/23  ,Trim_D)
		end
		if (Trimvalue4 ==0) then
		lcd.drawBitmap(75,285  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue4 > 0) then
		lcd.drawBitmap(75+ Trimvalue4/23,285  ,Trim_R)
		else
		lcd.drawBitmap(75+ Trimvalue4/23,285  ,Trim_L)
		end
		if (Trimvalue5 ==0) then
		lcd.drawBitmap(183,285  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue5 > 0) then
		lcd.drawBitmap(183+ Trimvalue5/23,285  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue5/23,285  ,Trim_L)
		end
elseif (SticksMode == 2) then -- mode 2
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(75,213  ,Trim_C)	-- center trim rudder
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(75+ Trimvalue0/23,213  ,Trim_R)
		else
		lcd.drawBitmap(75+ Trimvalue0/23,213  ,Trim_L)
		end
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(183,213  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(183+ Trimvalue3/23,213  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue3/23,213  ,Trim_L)
		end
	if (Trimvalue1 ==0) then
		lcd.drawBitmap(246,127  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(246,127- Trimvalue1/23  ,Trim_U)
		else
		lcd.drawBitmap(246,127- Trimvalue1/23  ,Trim_D)
		end
	if (Trimvalue2 ==0) then
		lcd.drawBitmap(17,127  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(17,127- Trimvalue2/23  ,Trim_U)
		else
		lcd.drawBitmap(17,127- Trimvalue2/23  ,Trim_D)
		end
	if (Trimvalue4 ==0) then
		lcd.drawBitmap(75,285  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue4 > 0) then
		lcd.drawBitmap(75+ Trimvalue4/23,285  ,Trim_R)
		else
		lcd.drawBitmap(75+ Trimvalue4/23,285  ,Trim_L)
		end
		if (Trimvalue5 ==0) then
		lcd.drawBitmap(183,285  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue5 > 0) then
		lcd.drawBitmap(183+ Trimvalue5/23,285  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue5/23,285  ,Trim_L)
		end
elseif (SticksMode == 3) then-- mode 3
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(183,213  ,Trim_C)	-- center trim rudder
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(183+ Trimvalue3/23,213  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue3/23,213  ,Trim_L)
		end
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(135,213  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(135+ Trimvalue0/23,213  ,Trim_R)
		else
		lcd.drawBitmap(135+ Trimvalue0/23,213  ,Trim_L)
		end
	if (Trimvalue2 ==0) then
		lcd.drawBitmap(17,127  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(17,127- Trimvalue2/23  ,Trim_U)
		else
		lcd.drawBitmap(17,127- Trimvalue2/23  ,Trim_D)
		end

	if (Trimvalue1 ==0) then
		lcd.drawBitmap(246,127  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(246,127- Trimvalue1/23  ,Trim_U)
		else
		lcd.drawBitmap(246,127- Trimvalue1/23  ,Trim_D)
		end
	if (Trimvalue4 ==0) then
		lcd.drawBitmap(75,285  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue4 > 0) then
		lcd.drawBitmap(75+ Trimvalue4/23,285  ,Trim_R)
		else
		lcd.drawBitmap(75+ Trimvalue4/23,285  ,Trim_L)
		end
	if (Trimvalue5 ==0) then
		lcd.drawBitmap(183,285  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue5 > 0) then
		lcd.drawBitmap(183+ Trimvalue5/23,285  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue5/23,285  ,Trim_L)
		end
else -- mode 4
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(183,213  ,Trim_C)	-- center trim rudder
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(183+ Trimvalue3/23,213  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue3/23,213  ,Trim_L)
		end
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(135,213  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(135+ Trimvalue0/23,213  ,Trim_R)
		else
		lcd.drawBitmap(135+ Trimvalue0/23,213  ,Trim_L)
		end
	if (Trimvalue1 ==0) then
		lcd.drawBitmap(246,127  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(246,127- Trimvalue1/23  ,Trim_U)
		else
		lcd.drawBitmap(246,127- Trimvalue1/23  ,Trim_D)
		end
	if (Trimvalue2 ==0) then
		lcd.drawBitmap(17,127  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(17,127- Trimvalue2/23  ,Trim_U)
		else
		lcd.drawBitmap(17,127- Trimvalue2/23  ,Trim_D)
		end
	if (Trimvalue4 ==0) then
		lcd.drawBitmap(75,285  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue4 > 0) then
		lcd.drawBitmap(75+ Trimvalue4/23,285  ,Trim_R)
		else
		lcd.drawBitmap(75+ Trimvalue4/23,285  ,Trim_L)
		end
	if (Trimvalue5 ==0) then
		lcd.drawBitmap(183,285  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue5 > 0) then
		lcd.drawBitmap(183+ Trimvalue5/23,285  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue5/23,285  ,Trim_L)
		end
	end

	end
end

--===================================================
-- Draw the Status
--===================================================
local function draw_Status_R(Me)
-- RIGHT turbine
lcd.font(FONT_L)
if (screenSize == "X20fullScreenWithTitle") or (screenSize == "X20fullScreenWithOutTitle") then
	lcd.drawText(410,432,ECU_Name)
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 3 or ecu_type == 4 or ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then
	if RDT_Tmp2source_R ~= nil then Status_R = system.getSource (RDT_Tmp2source_R) else Status_R = nil end	
	end
	lcd.font(FONT_XXL)
		if (Status_R == nil) then 
		lcd.drawText(540,170,"No Status")
		else 
		Turbine_Status_R = math.floor(Status_R:value())
			if (Turbine_Status_R < 0) or (Turbine_Status_R > 100) then -- Status_R is negative or > 100
			lcd.drawText(540,170,"No Status")
			else
			lcd.drawText(540,175,ECU_Status[Turbine_Status_R])
			end
		end
		
		
		if ecu_type == 11 then --AMT only
		if RDT_0A20source_R ~= nil then SWMode_Status_R = system.getSource (RDT_0A20source_R) else SWMode_Status_R = nil end	
		lcd.font(FONT_L)
		if (SWMode_Status_R == nil) then 
		lcd.drawText(538,360,"Switch Status: ")
		lcd.drawText(708,360,"N/A")
		else 
		SW_Mode_Status_R = math.floor(SWMode_Status_R:value())
			if (SW_Mode_Status_R < 0) or (SW_Mode_Status_R > 100) then -- SW_Mode_Status_R is negative or > 100
			lcd.drawText(538,360,"Switch Status: ")
			lcd.drawText(708,360,"N/A")
			else
			lcd.drawText(538,360,"Switch Status: ")
			lcd.drawText(708,360,Switch_Status_R[SW_Mode_Status_R])
			end
		end
		end

	elseif (screenSize == "X10fullScreenWithOutTitle") then  -- X10         
	lcd.drawText(233,243,ECU_Name)
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 3 or ecu_type == 4 or ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then
	if RDT_Tmp2source_R ~= nil then Status_R = system.getSource (RDT_Tmp2source_R) else Status_R = nil end	
	end
	lcd.font(FONT_XXL)
		if (Status_R == nil) then 
		lcd.drawText(315,90,"No Status")
		else 
		Turbine_Status_R = math.floor(Status_R:value())
			if (Turbine_Status_R < 0) or (Turbine_Status_R > 100) then -- Status_R is negative or > 100
			lcd.drawText(315,90,"No Status")
			else
			lcd.drawText(315,90,ECU_Status[Turbine_Status_R])
			end
		end
		
	elseif ((screenSize == "X18fullScreenWithTitle") or (screenSize == "X18fullScreenWithOutTitle")) then  -- X18         
	lcd.drawText(233,243,ECU_Name)
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 3 or ecu_type == 4 or ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then
	if RDT_Tmp2source_R ~= nil then Status_R = system.getSource (RDT_Tmp2source_R) else Status_R = nil end	
	end
	lcd.font(FONT_XXL)
		if (Status_R == nil) then 
		lcd.drawText(315,90,"No Status")
		else 
		Turbine_Status_R = math.floor(Status_R:value())
			if (Turbine_Status_R < 0) or (Turbine_Status_R > 100) then -- Status_R is negative or > 100
			lcd.drawText(315,90,"No Status")
			else
			lcd.drawText(315,90,ECU_Status[Turbine_Status_R])
			end
		end
	end
	end
	
	
-- LEFT turbine
		local function draw_Status_L(Me)
lcd.font(FONT_L)
if (screenSize == "X20fullScreenWithTitle") or (screenSize == "X20fullScreenWithOutTitle") then
	--lcd.drawText(410,432,ECU_Name)
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 3 or ecu_type == 4 or ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then
	if RDT_Tmp2source_L ~= nil then Status_L = system.getSource (RDT_Tmp2source_L) else Status_L = nil end	
	end
	lcd.font(FONT_XXL)
		if (Status_L == nil) then 
		lcd.drawText(040,170,"No Status")
		else 
		Turbine_Status_L = math.floor(Status_L:value())
			if (Turbine_Status_L < 0) or (Turbine_Status_L > 100) then -- Status_L is negative or > 100
			lcd.drawText(040,170,"No Status")
			else
			lcd.drawText(040,175,ECU_Status[Turbine_Status_L])
			end
		end
		
		
		if ecu_type == 11 then --AMT only
		if RDT_0A20source_L ~= nil then SWMode_Status_L = system.getSource (RDT_0A20source_L) else SWMode_Status_L = nil end	
		lcd.font(FONT_L)
		if (SWMode_Status_L == nil) then 
		lcd.drawText(038,360,"Switch Status: ")
		lcd.drawText(208,360,"N/A")
		else 
		SW_Mode_Status_L = math.floor(SWMode_Status_L:value())
			if (SW_Mode_Status_L < 0) or (SW_Mode_Status_L > 100) then -- SW_Mode_Status_L is negative or > 100
			lcd.drawText(038,360,"Switch Status: ")
			lcd.drawText(208,360,"N/A")
			else
			lcd.drawText(038,360,"Switch Status: ")
			lcd.drawText(208,360,Switch_Status_L[SW_Mode_Status_L])
			end
		end
		end

	elseif (screenSize == "X10fullScreenWithOutTitle") then  -- X10         -- TBDLZ
	--lcd.drawText(363,243,ECU_Name)
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 3 or ecu_type == 4 or ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then
	if RDT_Tmp2source_L ~= nil then Status_L = system.getSource (RDT_Tmp2source_L) else Status_L = nil end	
	end
	lcd.font(FONT_XXL)
		if (Status_L == nil) then 
		lcd.drawText(040,90,"No Status")
		else 
		Turbine_Status_L = math.floor(Status_L:value())
			if (Turbine_Status_L < 0) or (Turbine_Status_L > 100) then -- Status_L is negative or > 100
			lcd.drawText(040,90,"No Status")
			else
			lcd.drawText(040,90,ECU_Status[Turbine_Status_L])
			end
		end
		
	elseif ((screenSize == "X18fullScreenWithTitle") or (screenSize == "X18fullScreenWithOutTitle")) then  -- X18         
	lcd.drawText(363,243,ECU_Name)
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 3 or ecu_type == 4 or ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then
	if RDT_Tmp2source_L ~= nil then Status_L = system.getSource (RDT_Tmp2source_L) else Status_L = nil end	
	end
	lcd.font(FONT_XXL)
		if (Status_L == nil) then 
		lcd.drawText(040,90,"No Status")
		else 
		Turbine_Status_L = math.floor(Status_L:value())
			if (Turbine_Status_L < 0) or (Turbine_Status_L > 100) then -- Status_L is negative or > 100
			lcd.drawText(040,90,"No Status")
			else
			lcd.drawText(040,90,ECU_Status[Turbine_Status_L])
			end
		end
	end
	end
	
--===================================================
-- Draw the Top Bar
--===================================================
local function draw_Top_Bar(Me)
	
	if (screenSize == "X20fullScreenWithTitle") or (screenSize == "X20fullScreenWithOutTitle") then
	lcd.font(FONT_L)
	lcd.drawText(515,6,"RSSI")
	lcd.drawText(608,6,"RxBatt")
	lcd.drawText(715,6,"TxBatt")
	
	lcd.font(FONT_L)
	if RDT_RSSI1source ~= nil then RSSI1 = system.getSource (RDT_RSSI1source) 	else RSSI1 = nil end
		if (RSSI1 == nil) then
		lcd.font(FONT_S)
		lcd.drawText (515, 34, "No RSSI")
		lcd.font(FONT_L)
		else
		RSSI1Value = RSSI1:value()
		lcd.drawNumber (515, 34, (string.format("%.0f", RSSI1Value)),UNIT_DB)
		end
	if RDT_RSSI2source ~= nil then RSSI2 = system.getSource (RDT_RSSI2source) 	else RSSI2 = nil end
		if (RSSI2 == nil) then
		lcd.font(FONT_L)
		else
		RSSI2Value = RSSI2:value()
		lcd.drawNumber (515, 59, (string.format("%.0f", RSSI2Value)),UNIT_DB)
		end
		
	if RDT_RXbattsource ~= nil then RXbatt = system.getSource (RDT_RXbattsource) 	else RXbatt = nil end
		if (RXbatt == nil) then
		lcd.font(FONT_S)
		lcd.drawText (608, 34, "No RxBt")
		lcd.font(FONT_L)
		else
		RxBattValue = RXbatt:value()
		lcd.drawText(608, 34,(string.format("%.1f", (RxBattValue))).."V")
		end
	TxBatt = system.getSource({category=CATEGORY_SYSTEM, member=MAIN_VOLTAGE})
		if (TxBatt == nil) then 
		lcd.font(FONT_S)
		lcd.drawText(716,34,"Err")
		lcd.font(FONT_L)
		else 
		TxBattValue = TxBatt:value()
		lcd.drawText(716, 34, TxBatt:value().."V")
		end
	if RDT_Pressuresource ~= nil then Pressure = system.getSource (RDT_Pressuresource) 	else RXbatt = nil end
		if (Pressure == nil) then 
		--do nothing
		else 
		lcd.font(FONT_L)
		lcd.drawText(690,93,"Pressure:")
		TxBattValue = Pressure:value()
		--lcd.drawText(700,120, Pressure:value().."PSI")
		lcd.drawText(700, 120,(string.format("%.0f", (Pressure:value()))).." PSI")
		lcd.font(FONT_L)
		end
		
	
		
	elseif ((screenSize == "X10fullScreenWithOutTitle") or (screenSize == "X18fullScreenWithTitle") or (screenSize == "X18fullScreenWithOutTitle")) then   -- X10 / X18        
	lcd.font(FONT_S)
	lcd.drawText(305,6,"RSSI")
	lcd.drawText(362,6,"RxBatt")
	lcd.drawText(430,6,"TxBatt")
	lcd.font(FONT_S)
	if RDT_RSSI1source ~= nil then RSSI1 = system.getSource (RDT_RSSI1source) 	else RSSI1 = nil end
		if (RSSI1 == nil) then
		lcd.font(FONT_S)
		lcd.drawText (305, 22, "No RSSI")
		lcd.font(FONT_S)
		else
		RSSI1Value = RSSI1:value()
		lcd.drawNumber (305, 22, (string.format("%.0f", RSSI1Value)),UNIT_DB)
		end
		
	if RDT_RSSI2source ~= nil then RSSI2 = system.getSource (RDT_RSSI2source) 	else RSSI2 = nil end
		if (RSSI2 == nil) then
		lcd.font(FONT_L)
		else
		RSSI2Value = RSSI2:value()
		lcd.drawNumber (305, 35, (string.format("%.0f", RSSI2Value)),UNIT_DB)
		end

	if RDT_RXbattsource ~= nil then RXbatt = system.getSource (RDT_RXbattsource) 	else RXbatt = nil end
		if (RXbatt == nil) then
		lcd.font(FONT_S)
		lcd.drawText (362, 22, "No RxBt")
		lcd.font(FONT_S)
		else
		RxBattValue = RXbatt:value()
		lcd.drawText(362, 22,(string.format("%.1f", (RxBattValue))).."V")
		end
	TxBatt = system.getSource({category=CATEGORY_SYSTEM, member=MAIN_VOLTAGE})
		if (TxBatt == nil) then 
		lcd.font(FONT_S)
		lcd.drawText(430,22,"Err")
		lcd.font(FONT_S)
		else 
		TxBattValue = TxBatt:value()
		lcd.drawText(430, 22, TxBatt:value().."V")
		end
		end
end

--===================================================
-- Draw Model Name
--===================================================
local function draw_Model_Name(Me)
lcd.font(FONT_XXL)
lcd.drawText(30,3,model.name())
model_name = (model.name())
end

--===================================================
-- Draw Model Image
--===================================================
local function draw_Model_Image(Me)
	if mdlimage ~= nil then
		if (screenSize == "X20fullScreenWithTitle") or (screenSize == "X20fullScreenWithOutTitle") then
		lcd.drawBitmap(328, 185, mdlimage,150,140) 
		elseif (screenSize == "X10fullScreenWithOutTitle") then  -- X10         
		lcd.drawBitmap(177, 107, mdlimage,90,80) 
		elseif (screenSize == "X18fullScreenWithTitle") or (screenSize == "X18fullScreenWithOutTitle") then --X18
		lcd.drawBitmap(177, 107, mdlimage,90,80) 
	end
	end
end

--===================================================
-- Draw the Timer
--===================================================
local function draw_Timer(Me)
	if (screenSize == "X20fullScreenWithTitle") or (screenSize == "X20fullScreenWithOutTitle") then -- X20
	timer = system.getSource({category=CATEGORY_TIMER, member=0, options=0}) -- Timer 1
    if (timer:value() == nil) then
	lcd.drawBitmap(333,96,digit[0],0,0)
	lcd.drawBitmap(365,96,digit[0],0,0)
	lcd.drawBitmap(395,96,digit[11],0,0)
	lcd.drawBitmap(407,96,digit[0],0,0)
	lcd.drawBitmap(439,96,digit[0],0,0)
	elseif (timer:value() >= 0) and (timer:value() < 3600) then
	timer_Secs =  timer:value() % 60
	--timer_Mins = (timer:value() - timer_Secs) / 60
	timer_Mins = (timer:value() - (timer:value() % 60))/60
	local TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	local TimerDigit2 = timer_Mins - (TimerDigit1*10) 
	local TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	local TimerDigit4 = timer_Secs - (TimerDigit3*10) 
		if TimerDigit1 >= 0 and TimerDigit1 <= 9 and TimerDigit2 >= 0 and TimerDigit2 <= 9 and TimerDigit3 >= 0 and TimerDigit3 <= 9 and TimerDigit4 >= 0 and TimerDigit4 <= 9 then
		lcd.drawBitmap(333,96,digit[TimerDigit1],0,0)
		lcd.drawBitmap(365,96,digit[TimerDigit2],0,0)
		lcd.drawBitmap(395,96,digit[11],0,0)
		lcd.drawBitmap(407,96,digit[TimerDigit3],0,0)
		lcd.drawBitmap(439,96,digit[TimerDigit4],0,0)
		else print (TimerDigit1.. " "..TimerDigit2.. " "..TimerDigit3.." "..TimerDigit4.. " ".. timer:value())
		end
	elseif (timer:value() < 0) and (timer:value() > -3600) then
	timer_Secs =  (timer:value() * (-1)) % 60
	timer_Mins =  ((timer:value()*(-1) - timer_Secs) / 60)
	local TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	local TimerDigit2 = timer_Mins - (TimerDigit1*10) 
	local TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	local TimerDigit4 = timer_Secs - (TimerDigit3*10) 
		if TimerDigit1 >= 0 and TimerDigit1 <= 9 and TimerDigit2 >= 0 and TimerDigit2 <= 9 and TimerDigit3 >= 0 and TimerDigit3 <= 9 and TimerDigit4 >= 0 and TimerDigit4 <= 9 then
		lcd.drawBitmap(333,96,red[TimerDigit1],0,0)
		lcd.drawBitmap(365,96,red[TimerDigit2],0,0)
		lcd.drawBitmap(395,96,red[11],0,0)
		lcd.drawBitmap(407,96,red[TimerDigit3],0,0)
		lcd.drawBitmap(439,96,red[TimerDigit4],0,0)
		else print (TimerDigit1.. " "..TimerDigit2.. " "..TimerDigit3.." "..TimerDigit4.. " ".. timer:value())
		end
	else
	lcd.drawBitmap(333,96,digit[10],0,0)
	lcd.drawBitmap(365,96,digit[10],0,0)
	lcd.drawBitmap(395,96,digit[11],0,0)
	lcd.drawBitmap(407,96,digit[10],0,0)
	lcd.drawBitmap(439,96,digit[10],0,0)
	end
	
	elseif ((screenSize == "X10fullScreenWithOutTitle") or (screenSize == "X18fullScreenWithTitle") or (screenSize == "X18fullScreenWithOutTitle")) then   --X10 / X18        
	timer = system.getSource({category=CATEGORY_TIMER, member=0, options=0}) -- Timer 1
    if (timer:value() == nil) then
	lcd.drawBitmap(186,54,digit[0],28,28)
	lcd.drawBitmap(204,54,digit[0],28,28)
	lcd.drawBitmap(217,54,digit[11],28,28)
	lcd.drawBitmap(230,54,digit[0],28,28)
	lcd.drawBitmap(248,54,digit[0],28,28)
	elseif (timer:value() >= 0) and (timer:value() < 3600) then
	timer_Secs =  timer:value() % 60
	timer_Mins = ((timer:value() - timer_Secs) / 60)
	local TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	local TimerDigit2 = timer_Mins - (TimerDigit1*10) 
	local TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	local TimerDigit4 = timer_Secs - (TimerDigit3*10) 
		if TimerDigit1 >= 0 and TimerDigit1 <= 9 and TimerDigit2 >= 0 and TimerDigit2 <= 9 and TimerDigit3 >= 0 and TimerDigit3 <= 9 and TimerDigit4 >= 0 and TimerDigit4 <= 9 then
		lcd.drawBitmap(186,54,digit[TimerDigit1],28,28)
		lcd.drawBitmap(204,54,digit[TimerDigit2],28,28)
		lcd.drawBitmap(217,54,digit[11],28,28)
		lcd.drawBitmap(230,54,digit[TimerDigit3],28,28)
		lcd.drawBitmap(248,54,digit[TimerDigit4],28,28)
		else print (TimerDigit1.. " "..TimerDigit2.. " "..TimerDigit3.." "..TimerDigit4.. " ".. timer:value())
		end
	elseif (timer:value() < 0) and (timer:value() > -3600) then
	timer_Secs =  (timer:value() * (-1)) % 60
	timer_Mins =  ((timer:value()*(-1) - timer_Secs) / 60)
	local TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	local TimerDigit2 = timer_Mins - (TimerDigit1*10) 
	local TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	local TimerDigit4 = timer_Secs - (TimerDigit3*10) 
		if TimerDigit1 >= 0 and TimerDigit1 <= 9 and TimerDigit2 >= 0 and TimerDigit2 <= 9 and TimerDigit3 >= 0 and TimerDigit3 <= 9 and TimerDigit4 >= 0 and TimerDigit4 <= 9 then
		lcd.drawBitmap(186,54,red[TimerDigit1],28,28)
		lcd.drawBitmap(204,54,red[TimerDigit2],28,28)
		lcd.drawBitmap(217,54,red[11],28,28)
		lcd.drawBitmap(230,54,red[TimerDigit3],28,28)
		lcd.drawBitmap(248,54,red[TimerDigit4],28,28)
		else print (TimerDigit1.. " "..TimerDigit2.. " "..TimerDigit3.." "..TimerDigit4.. " ".. timer:value())
		end
	else
	lcd.drawBitmap(186,54,digit[10],28,28)
	lcd.drawBitmap(204,54,digit[10],28,28)
	lcd.drawBitmap(217,54,digit[11],28,28)
	lcd.drawBitmap(230,54,digit[10],28,28)
	lcd.drawBitmap(248,54,digit[10],28,28)
	end
end
end
--===================================================
-- Draw background
--===================================================
local function draw_background(Me)
	local w2_old = w2
	local h2_old = h2
	w2, h2 = lcd.getWindowSize()
	if w2~= w2_old or h2 ~= h2_old then -- screen size changed
	RDTbgroundCounter = 0
	end
	
	-- determine screen size
	if w2 == 800 and h2 == 458 then 
	screenSize = "X20fullScreenWithTitle"
	elseif w2 == 800 and h2 == 480 then 
	screenSize = "X20fullScreenWithOutTitle"
	elseif w2 == 480 and h2 == 272 then 
	screenSize = "X10fullScreenWithOutTitle"
	elseif w2 == 480 and h2 == 256 then 
	screenSize = "X10fullScreenWithTitle"
	elseif w2 == 480 and h2 == 320 then 
	screenSize = "X18fullScreenWithOutTitle"
	elseif w2 == 480 and h2 == 304 then
	screenSize = "X18fullScreenWithTitle"
	else
	screenSize = "NotFullScreen"
	end
		
	if RDTbgroundCounter == 0 then -- load images once
	wallpaper_mask = lcd.loadBitmap(imagePath.."/wallpaper_mask.png")
	Zavionix = lcd.loadBitmap(imagePath.."/Zavionix.png")
	RDT_Text = lcd.loadBitmap(imagePath.."/RDT.png")
	Batt_Icon = lcd.loadBitmap(imagePath.."/Batt.png")
	RSSI_Icon = lcd.loadBitmap(imagePath.."/RSSI.png")
	end	

RDTbgroundCounter = RDTbgroundCounter+ 1

		if (screenSize == "X20fullScreenWithTitle") then
		-- draw wallpaper
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
		lcd.drawBitmap(-51, 366,wallpaper_mask) lcd.drawBitmap(39, 366,wallpaper_mask) lcd.drawBitmap(129, 366, wallpaper_mask) lcd.drawBitmap(219, 366, wallpaper_mask) lcd.drawBitmap(309, 366, wallpaper_mask) lcd.drawBitmap(399, 366, wallpaper_mask) lcd.drawBitmap(489, 366, wallpaper_mask) lcd.drawBitmap(579, 366, wallpaper_mask) lcd.drawBitmap(669, 366, wallpaper_mask) lcd.drawBitmap(759, 366, wallpaper_mask)
		
		--model image is at 78,85
		lcd.color(lcd.RGB(80, 80, 80,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(328,185,150,140,1)
		lcd.color(lcd.RGB(0, 0, 0,0.5)) -- black frame edge
		lcd.drawRectangle(326,183,152,142,3)
		lcd.color(lcd.RGB(10, 10, 10,0.5)) -- nearly black shade depth
		lcd.drawFilledRectangle	(328,175,155,10,1)
		--lcd.drawFilledRectangle	(378,80,10,155,1)
		--[[
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255,0.8)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(67,382,146,9,1) -- T4
		lcd.drawText(35,380,"T4")
		lcd.drawFilledRectangle	(239,382,146,9,1) -- T1
		lcd.drawText(390,380,"T1")
		lcd.drawFilledRectangle	(416,158,9,146,1) -- T2
		lcd.drawText(410,315,"T2")
		lcd.drawFilledRectangle	(36,158,9,146,1) -- T3
		lcd.drawText(30,315,"T3")
		lcd.drawFilledRectangle	(458,158,9,146,1) -- Red Slider
		-- draw trim line frames
		lcd.color(lcd.RGB(0, 0, 0,0.7)) -- trim  outline
		lcd.drawRectangle	(67,382,146,9,2) -- T4
		lcd.drawRectangle	(239,382,146,9,2) -- T1
		lcd.drawRectangle	(416,158,9,146,2) -- T2
		lcd.drawRectangle	(36,158,9,146,2) -- T3
		lcd.drawRectangle	(458,158,9,146,2) -- Red Slider
		]]--
		--draw timer frame
		lcd.color(lcd.RGB(255, 255, 255,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(333,96,137,50,1)
		lcd.color(lcd.RGB(155, 155, 155,0.2))
		lcd.drawFilledRectangle	(328,91,147,60,1)
		--draw logos
		lcd.drawBitmap(260, 343, Zavionix)
		lcd.drawBitmap(323, 425, RDT_Text)
		lcd.drawBitmap(585, 6, Batt_Icon)
		lcd.drawBitmap(695, 6, Batt_Icon)
		lcd.drawBitmap(465, 7, RSSI_Icon)
		lcd.color(WHITE)
		elseif (screenSize == "X20fullScreenWithOutTitle") then		
		-- draw wallpaper
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
		lcd.drawBitmap(-51, 366,wallpaper_mask) lcd.drawBitmap(39, 366,wallpaper_mask) lcd.drawBitmap(129, 366, wallpaper_mask) lcd.drawBitmap(219, 366, wallpaper_mask) lcd.drawBitmap(309, 366, wallpaper_mask) lcd.drawBitmap(399, 366, wallpaper_mask) lcd.drawBitmap(489, 366, wallpaper_mask) lcd.drawBitmap(579, 366, wallpaper_mask) lcd.drawBitmap(669, 366, wallpaper_mask) lcd.drawBitmap(759, 366, wallpaper_mask)
		--model image is at 78,85
		lcd.color(lcd.RGB(80, 80, 80,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(328,185,150,140,1)
		lcd.color(lcd.RGB(0, 0, 0,0.5)) -- black frame edge
		lcd.drawRectangle(326,183,152,142,3)
		lcd.color(lcd.RGB(10, 10, 10,0.5)) -- nearly black shade depth
		lcd.drawFilledRectangle	(328,175,155,10,1)
		--lcd.drawFilledRectangle	(378,80,10,155,1)
		--[[
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255,0.8)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(67,382,146,9,1) -- T4
		lcd.drawText(35,380,"T4")
		lcd.drawFilledRectangle	(239,382,146,9,1) -- T1
		lcd.drawText(390,380,"T1")
		lcd.drawFilledRectangle	(416,158,9,146,1) -- T2
		lcd.drawText(410,315,"T2")
		lcd.drawFilledRectangle	(36,158,9,146,1) -- T3
		lcd.drawText(30,315,"T3")
		lcd.drawFilledRectangle	(458,158,9,146,1) -- Red Slider
		-- draw trim line frames
		lcd.color(lcd.RGB(0, 0, 0,0.7)) -- trim  outline
		lcd.drawRectangle	(67,382,146,9,2) -- T4
		lcd.drawRectangle	(239,382,146,9,2) -- T1
		lcd.drawRectangle	(416,158,9,146,2) -- T2
		lcd.drawRectangle	(36,158,9,146,2) -- T3
		lcd.drawRectangle	(458,158,9,146,2) -- Red Slider
		]]--
		--draw timer frame
		lcd.color(lcd.RGB(255, 255, 255,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(333,96,137,50,1)
		lcd.color(lcd.RGB(155, 155, 155,0.2))
		lcd.drawFilledRectangle	(328,91,147,60,1)
		--draw logos
		lcd.drawBitmap(260, 343, Zavionix)
		lcd.drawBitmap(323, 425, RDT_Text)
		lcd.drawBitmap(585, 6, Batt_Icon)
		lcd.drawBitmap(695, 6, Batt_Icon)
		lcd.drawBitmap(465, 7, RSSI_Icon)
		lcd.color(WHITE)
		elseif (screenSize == "X10fullScreenWithOutTitle") then
		-- draw wallpaper
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
	
		--model image is at 47,47
		lcd.color(lcd.RGB(80, 80, 80,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(177,107,90,80,1)
		lcd.color(lcd.RGB(0, 0, 0,0.5)) -- black frame edge
		lcd.drawRectangle(175,105,92,82,3)
		lcd.color(lcd.RGB(10, 10, 10,0.5)) -- nearly black shade depth
		lcd.drawFilledRectangle	(177,97,95,10,1)
		--lcd.drawFilledRectangle	(227,44,10,165,1)
		--[[
		--draw timer frame
		lcd.color(lcd.RGB(255, 255, 255,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(322,54,78,29,1)
		lcd.color(lcd.RGB(155, 155, 155,0.2))
		lcd.drawFilledRectangle	(318,50,86,37,1)
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255,0.8)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(35,217,90,4,1) -- T4
		lcd.drawText(10,213,"T4")
		lcd.drawFilledRectangle	(145,217,90,4,1) -- T1
		lcd.drawText(245,213,"T1")
		lcd.drawFilledRectangle	(250,87,4,90,1) -- T2
		lcd.drawText(246,185,"T2")
		lcd.drawFilledRectangle	(22,87,4,90,1) -- T3
		lcd.drawText(15,185,"T3")
		-- draw trim line frames
		lcd.color(lcd.RGB(0, 0, 0,0.7)) -- trim  outline
		lcd.drawRectangle	(35,217,90,4,1) -- T4
		lcd.drawRectangle	(145,217,90,4,1) -- T1
		lcd.drawRectangle	(250,87,4,90,1) -- T2
		lcd.drawRectangle	(22,87,4,90,1) -- T3
		]]--
		--draw logos
		lcd.drawBitmap(155, 200, Zavionix,150,40)
		lcd.drawBitmap(185, 238, RDT_Text,50,20)
		lcd.drawBitmap(325, 6, Batt_Icon,60,30)
		lcd.drawBitmap(395, 6, Batt_Icon,60,30)
		lcd.drawBitmap(265, 7, RSSI_Icon,50,25)
		lcd.color(WHITE)
		elseif (screenSize == "X10fullScreenWithTitle") then
				-- draw wallpaper
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
		--model image is at 47,47
		lcd.color(lcd.RGB(80, 80, 80,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(177,107,90,80,1)
		lcd.color(lcd.RGB(0, 0, 0,0.5)) -- black frame edge
		lcd.drawRectangle(175,105,92,82,3)
		lcd.color(lcd.RGB(10, 10, 10,0.5)) -- nearly black shade depth
		lcd.drawFilledRectangle	(177,97,95,10,1)
		--lcd.drawFilledRectangle	(227,44,10,165,1)
		--[[
		--draw timer frame
		lcd.color(lcd.RGB(255, 255, 255,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(322,54,78,29,1)
		lcd.color(lcd.RGB(155, 155, 155,0.2))
		lcd.drawFilledRectangle	(318,50,86,37,1)
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255,0.8)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(35,217,90,4,1) -- T4
		lcd.drawText(10,213,"T4")
		lcd.drawFilledRectangle	(145,217,90,4,1) -- T1
		lcd.drawText(245,213,"T1")
		lcd.drawFilledRectangle	(250,87,4,90,1) -- T2
		lcd.drawText(246,185,"T2")
		lcd.drawFilledRectangle	(22,87,4,90,1) -- T3
		lcd.drawText(15,185,"T3")
		-- draw trim line frames
		lcd.color(lcd.RGB(0, 0, 0,0.7)) -- trim  outline
		lcd.drawRectangle	(35,217,90,4,1) -- T4
		lcd.drawRectangle	(145,217,90,4,1) -- T1
		lcd.drawRectangle	(250,87,4,90,1) -- T2
		lcd.drawRectangle	(22,87,4,90,1) -- T3
		]]--
		--draw logos
		lcd.drawBitmap(155, 200, Zavionix,150,40)
		lcd.drawBitmap(185, 238, RDT_Text,50,20)
		lcd.drawBitmap(325, 6, Batt_Icon,60,30)
		lcd.drawBitmap(395, 6, Batt_Icon,60,30)
		lcd.drawBitmap(265, 7, RSSI_Icon,50,25)
		lcd.color(WHITE)
		elseif (screenSize == "X18fullScreenWithOutTitle") then
		-- draw wallpaper
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
		--model image is at 47,47
		lcd.color(lcd.RGB(80, 80, 80,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(177,107,90,80,1)
		lcd.color(lcd.RGB(0, 0, 0,0.5)) -- black frame edge
		lcd.drawRectangle(175,105,92,82,3)
		lcd.color(lcd.RGB(10, 10, 10,0.5)) -- nearly black shade depth
		lcd.drawFilledRectangle	(177,97,95,10,1)
		--lcd.drawFilledRectangle	(227,44,10,165,1)
		--[[
		--draw timer frame
		lcd.color(lcd.RGB(255, 255, 255,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(322,54,78,29,1)
		lcd.color(lcd.RGB(155, 155, 155,0.2))
		lcd.drawFilledRectangle	(318,50,86,37,1)
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255,0.8)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(35,217,90,4,1) -- T4
		lcd.drawText(10,213,"T4")
		lcd.drawFilledRectangle	(145,217,90,4,1) -- T1
		lcd.drawText(245,213,"T1")
		lcd.drawFilledRectangle	(250,87,4,90,1) -- T2
		lcd.drawText(246,185,"T2")
		lcd.drawFilledRectangle	(22,87,4,90,1) -- T3
		lcd.drawText(15,185,"T3")
		lcd.drawFilledRectangle	(35,289,90,4,1) -- T6
		lcd.drawText(10,285,"T6")
		lcd.drawFilledRectangle	(145,289,90,4,1) -- T5
		lcd.drawText(245,285,"T5")
		-- draw trim line frames
		lcd.color(lcd.RGB(0, 0, 0,0.7)) -- trim  outline
		lcd.drawRectangle	(35,217,90,4,1) -- T4
		lcd.drawRectangle	(145,217,90,4,1) -- T1
		lcd.drawRectangle	(250,87,4,90,1) -- T2
		lcd.drawRectangle	(22,87,4,90,1) -- T3
		lcd.drawRectangle	(35,289,90,4,1) -- T6
		lcd.drawRectangle	(145,289,90,4,1) -- T2
		]]--
		--draw logos
		lcd.drawBitmap(155, 200, Zavionix,150,40)
		lcd.drawBitmap(185, 238, RDT_Text,50,20)
		lcd.drawBitmap(325, 6, Batt_Icon,60,30)
		lcd.drawBitmap(395, 6, Batt_Icon,60,30)
		lcd.drawBitmap(265, 7, RSSI_Icon,50,25)
		lcd.color(WHITE)
		elseif (screenSize == "X18fullScreenWithTitle") then
				-- draw wallpaper
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
		--model image is at 47,47
		lcd.color(lcd.RGB(80, 80, 80,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(177,107,90,80,1)
		lcd.color(lcd.RGB(0, 0, 0,0.5)) -- black frame edge
		lcd.drawRectangle(175,105,92,82,3)
		lcd.color(lcd.RGB(10, 10, 10,0.5)) -- nearly black shade depth
		lcd.drawFilledRectangle	(177,97,95,10,1)
		--lcd.drawFilledRectangle	(227,44,10,165,1)
		--[[
		--draw timer frame
		lcd.color(lcd.RGB(255, 255, 255,0.15)) -- photo frame shade
		lcd.drawFilledRectangle	(322,54,78,29,1)
		lcd.color(lcd.RGB(155, 155, 155,0.2))
		lcd.drawFilledRectangle	(318,50,86,37,1)
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255,0.8)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(35,217,90,4,1) -- T4
		lcd.drawText(10,213,"T4")
		lcd.drawFilledRectangle	(145,217,90,4,1) -- T1
		lcd.drawText(245,213,"T1")
		lcd.drawFilledRectangle	(250,87,4,90,1) -- T2
		lcd.drawText(246,185,"T2")
		lcd.drawFilledRectangle	(22,87,4,90,1) -- T3
		lcd.drawText(15,185,"T3")
		lcd.drawFilledRectangle	(35,289,90,4,1) -- T6
		lcd.drawText(10,285,"T6")
		lcd.drawFilledRectangle	(145,289,90,4,1) -- T5
		lcd.drawText(245,285,"T5")
		-- draw trim line frames
		lcd.color(lcd.RGB(0, 0, 0,0.7)) -- trim  outline
		lcd.drawRectangle	(35,217,90,4,1) -- T4
		lcd.drawRectangle	(145,217,90,4,1) -- T1
		lcd.drawRectangle	(250,87,4,90,1) -- T2
		lcd.drawRectangle	(22,87,4,90,1) -- T3
		lcd.drawRectangle	(35,289,90,4,1) -- T6
		lcd.drawRectangle	(145,289,90,4,1) -- T5
		]]--
		--draw logos
		lcd.drawBitmap(155, 200, Zavionix,150,40)
		lcd.drawBitmap(185, 238, RDT_Text,50,20)
		lcd.drawBitmap(325, 6, Batt_Icon,60,30)
		lcd.drawBitmap(395, 6, Batt_Icon,60,30)
		lcd.drawBitmap(265, 7, RSSI_Icon,50,25)
		lcd.color(WHITE)
		else
		-- "NotFullScreen" -- do nothing
		end
end
--===================================================
-- Draw Turbine Data
--===================================================
-- RIGHT turbine
local function draw_Turbine_Data_R(Me)
lcd.font(FONT_L)

if (screenSize == "X20fullScreenWithTitle") or (screenSize == "X20fullScreenWithOutTitle") then
--===================================================
-- Draw RPM_R
--===================================================
	lcd.font(FONT_L)
	if RDT_RPMsource_R ~= nil then RPM_R = system.getSource (RDT_RPMsource_R) 	else RPM_R = nil end
	if (RPM_R == nil) then 
	lcd.font(FONT_XL)
	lcd.drawText(540,220,"RPM:")
	lcd.font(FONT_L)
	lcd.drawText(640,220,"No RPM")
	else 
	RPMValue_R = RPM_R:value()
	lcd.font(FONT_XL)
	lcd.drawText(540,220,"RPM:")
		if ecu_type == 7 then
		lcd.drawNumber (640, 220, (string.format("%.0f", RPMValue_R))*1)
		else
		lcd.drawNumber (640, 220, (string.format("%.0f", RPMValue_R))*100)
		end
	end
--===================================================
-- Draw Turbo Prop RPM_R
--===================================================	
--[[
	lcd.font(FONT_L)
	if RDT_0A30source_R ~= nil then TP_RPM = system.getSource (RDT_0A30source_R) else TP_RPM = nil end -- kingtech TP RPM_R
	if (TP_RPM == nil) then 
	-- do nothing
	else 
	TP_RPMValue_R = TP_RPM:value()
	lcd.drawText(360,405,"TP RPM:")
	lcd.drawNumber (360, 433, (string.format("%.0f", TP_RPMValue_R))*100)
	end
]]--

--===================================================
-- Draw EGT_R
--===================================================
	if RDT_Tmp1source_R ~= nil then EGT_R = system.getSource (RDT_Tmp1source_R) 	else EGT_R = nil end
	if (EGT_R == nil) then 
	lcd.font(FONT_XL)
	lcd.drawText(540,252,"EGT:")
	lcd.font(FONT_L)
	lcd.drawText(640,252,"No Temp1")
	else 
	EGTValue = EGT_R:value()
	lcd.font(FONT_XL)
	lcd.drawText(540,252,"EGT:")
	lcd.drawNumber (640, 252, (string.format("%.0f", EGTValue)),UNIT_CELSIUS) 
	end


--===================================================
-- Draw Pump_R Power
--===================================================
lcd.font(FONT_L)
if RDT_ADC4source_R ~= nil then Pump_R = system.getSource (RDT_ADC4source_R) 	else Pump_R = nil end
	if (Pump_R == nil) then 
	Pump_R_Value = 0
	lcd.font(FONT_XL)
	lcd.drawText (540, 285,"Pump:")
	lcd.font(FONT_L)
	lcd.drawText (640, 285,"No ADC4") 
	else 
	Pump_R_Value = Pump_R:value()
	lcd.font(FONT_XL)
	lcd.drawText (540, 285, "Pump:")
		if ((ecu_type < 3) or (ecu_type == 9)) then
		lcd.drawText(640, 285,(string.format("%.2f", Pump_R_Value)).."V") -- *A4Mult
		elseif ecu_type == 7 then
		Pump_R_Value = Pump_R:value()*100
			if Turbine_Status_R == 11 then -- is ECU in running state?
			lcd.drawText(640, 285,(string.format("%.0f", (Pump_R_Value))))
			else -- ECU not in running state
			lcd.drawText(540, 285,"Pump_R:  0")
			end
		else 
		lcd.drawText(640, 285,(string.format("%.0f", (Pump_R_Value*A4Mult)))) -- **A4Mult
		end
	end

--===================================================
-- Draw ECU Voltage
--===================================================
	if RDT_ADC3source_R ~= nil then EcuV_R = system.getSource (RDT_ADC3source_R) 	else EcuV_R = nil end
	if (EcuV_R == nil) then 
	lcd.font(FONT_XL)
	lcd.drawText (540, 320,"ECU: ")
	lcd.font(FONT_L)
	lcd.drawText (640,320, "No ADC3") 
	else 
	lcd.font(FONT_XL)
	lcd.drawText (540, 320, "ECU: ")
	EcuV_R_Value = EcuV_R:value() 
	lcd.drawText (640, 320,(string.format("%.2f", (EcuV_R_Value))).."V")
	end

--===================================================
-- Draw Current_R
--===================================================
--[[
if ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 10 then
lcd.font(FONT_L)
lcd.drawText(30,405,"Current:")
lcd.font(FONT_L)
if RDT_Currsource_R ~= nil then Current_R = system.getSource (RDT_Currsource_R) 	else Current_R = nil end
	if (Current_R == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (30, 433, "No Current") 
	else 
	Current_R_Value = Current_R:value() 
	lcd.drawText(30,433,(string.format("%.1f", (Current_R_Value))).."A")
	end
elseif ecu_type == 3 then
if RDT_Currsource_R ~= nil then Current_R = system.getSource (RDT_Currsource_R) 	else Current_R = nil end
		if (Current_R == nil) then -- do nothing
		else 
		lcd.font(FONT_L)
		lcd.drawText(30,405,"Current:")
		Current_R_Value = Current_R:value() 
		lcd.drawText(30,433,(string.format("%.1f", (Current_R_Value))).."A")
		end
end
]]--
--===================================================
-- Draw mAh_R
--===================================================
--[[
if ecu_type == 5 or ecu_type == 6 or ecu_type == 10 then --Linton V1 V2, Jetcentral, swiwin, Xicoy
lcd.font(FONT_L)
lcd.drawText(355,405,"Batt Draw:")
if RDT_Drawsource_R ~= nil then mAh_R = system.getSource (RDT_Drawsource_R) 	else mAh_R = nil end
	if (mAh_R == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (355, 433, "No mAh") 
	else 
	lcd.font(FONT_L)
	mAhValue = mAh_R:value() 
	lcd.drawText(355,433,(string.format("%.0f", (mAhValue))).."mAh")
	end
elseif ecu_type == 3 or ecu_type == 7  then
if RDT_Drawsource_R ~= nil then mAh_R = system.getSource (RDT_Drawsource_R) 	else mAh_R = nil end
	if (mAh_R == nil) then -- do nothing
	else 
	lcd.font(FONT_L)
	lcd.drawText(355,405,"Batt Draw:")
	mAhValue = mAh_R:value() 
	lcd.drawText(355,433,(string.format("%.0f", (mAhValue))).."mAh")
	end
end
]]--
--===================================================
-- Draw Fuel
--===================================================
RDTcount = RDTcount + 1
lcd.font(FONT_L)
lcd.drawText(535,405,"Fuel:")
lcd.font(FONT_L)
if ecu_type == 3 or ecu_type == 4 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then -- fuel is calculated from Pump_R 
if ecu_type == 3 or ecu_type == 4 or ecu_type == 6 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 then -- fuel is calculated from ADC4 (Pump_R)
CurrentFuelCapacity_R = CurrentFuelCapacity_R - (Pump_R_Value) * 0.001 * FuelFactor_R 
elseif ecu_type == 7 and Turbine_Status_R == 11  then -- swiwin and ECU in running state
CurrentFuelCapacity_R = CurrentFuelCapacity_R - (Pump_R_Value) * 0.0001 * FuelFactor_R 
elseif ecu_type == 11 then -- AMT
CurrentFuelCapacity_R = CurrentFuelCapacity_R - (Pump_R_Value) * 0.001 * FuelFactor_R 
end
	if (CurrentFuelCapacity_R < FuelAlert) then-- fuel alert is triggered 
	lcd.color(RED) -- RED
	lcd.drawText (535, 433,(string.format("%.0f", (CurrentFuelCapacity_R))).."ml") -- RED Text
	lcd.color(WHITE) -- White
		if RDTcount >FuelLowCycle*3.3 then 
			if (FuelAlertOnOff == true) then 
			system.playFile	(LowFuelSound)	
			system.playHaptic("- - -")	
			end
		RDTcount = 0
		end
	lcd.color(WHITE) -- White
	else
	lcd.drawText (535, 433,(string.format("%.0f", (CurrentFuelCapacity_R))).."ml")
	end

else -- all other ECUs
if RDT_0A10source_R ~= nil then FuelCapacity_R = system.getSource (RDT_0A10source_R) 	else FuelCapacity_R = nil end
	if (FuelCapacity_R == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (535, 433, "No DIY1")
	else
		if ((FuelCapacity_R:value() < FuelAlert) and ((FuelCapacity_R:value() ~= 0))) then-- fuel alert is triggered 
		lcd.color(RED) 
		--lcd.drawNumber (135, 433, FuelCapacity_R:value(),UNIT_MILLILITER)
		lcd.drawText (535, 433,(string.format("%.0f", (FuelCapacity_R:value()))).."ml")
			if RDTcount >FuelLowCycle*3.3 then 
			if (FuelAlertOnOff == true) then 
			system.playFile	(LowFuelSound)	
			system.playHaptic("- - -")		
			end
			RDTcount = 0
			end
		lcd.color(WHITE) 
		else
		--lcd.drawNumber (135, 433, FuelCapacity_R:value(),UNIT_MILLILITER)
		lcd.drawText (535, 433,(string.format("%.0f", (FuelCapacity_R:value()))).."ml")
		end
	end
end

--===================================================
-- Draw Throttle_R
--===================================================
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 5 or ecu_type == 6 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 then
	if RDT_0A20source_R ~= nil then Thro_R = system.getSource (RDT_0A20source_R) 	else Thro_R = nil end
	lcd.font(FONT_L)
	lcd.drawText(640,405,"Throttle:")
	lcd.font(FONT_L)
		if (Thro_R == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (640, 433, "No DIY2")
		else 
		lcd.drawNumber (640, 433,(string.format("%.0f", Thro_R:value())) ,UNIT_PERCENT)
		end	
	elseif ecu_type == 3 or ecu_type == 4 or ecu_type == 11  then
	if RDT_0A10source_R ~= nil then Thro_R = system.getSource (RDT_0A10source_R) 	else Thro_R = nil end
		lcd.font(FONT_L)
	lcd.drawText(640,405,"Throttle:")
	lcd.font(FONT_L)
		if (Thro_R == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (640, 433, "No DIY1")
		else 
		lcd.drawNumber (640, 433, (string.format("%.0f", Thro_R:value()/100)),UNIT_PERCENT)
		end	
	elseif ecu_type == 7 then -- Swiwin
	AnalogThrottle_R = system.getSource({category=CATEGORY_ANALOG, member=2, options=0}) -- throttle stick 
	Throttlepercentage_R = (AnalogThrottle_R:value() + 1024)/20.48 -- throttle values mormalized to 0-100%
	lcd.font(FONT_L)
	lcd.drawText(640,405,"Throttle:")
	lcd.font(FONT_L)
	lcd.drawText (640, 433,(string.format("%.0f", (Throttlepercentage_R))).."%")
	end
	
	--===================================================
	-- Draw Version
	--===================================================
	--[[
	lcd.font(FONT_XS)
	lcd.color(lcd.RGB(255, 255, 255,0.5))
	--lcd.drawFilledRectangle	(740,442,20,20,1)
	lcd.drawText (740, 442,RDTversion)
	lcd.font(FONT_L)
	lcd.color(WHITE)
	--]]
	
	elseif ((screenSize == "X10fullScreenWithOutTitle") or (screenSize == "X18fullScreenWithTitle") or (screenSize == "X18fullScreenWithOutTitle")) then  -- X10 / X18         
--===================================================
-- Draw RPM_R
--===================================================
	lcd.font(FONT_L)
	if RDT_RPMsource_R ~= nil then RPM_R = system.getSource (RDT_RPMsource_R) 	else RPM_R = nil end
	if (RPM_R == nil) then 
	lcd.font(FONT_L)
	lcd.drawText(310,127,"RPM:") --540 225 -- -230 -100
	lcd.drawText(370,127,"No RPM")
	else 
	RPMValue_R = RPM_R:value()
	lcd.font(FONT_L)
	lcd.drawText(310,127,"RPM:")
		if ecu_type == 7 then
		lcd.drawNumber (370, 127, (string.format("%.0f", RPMValue_R))*1)
		else
		lcd.drawNumber (370, 127, (string.format("%.0f", RPMValue_R))*100)
		end
	
	end


--===================================================
-- Draw EGT_R
--===================================================
	if RDT_Tmp1source_R ~= nil then EGT_R = system.getSource (RDT_Tmp1source_R) 	else EGT_R = nil end
	if (EGT_R == nil) then 
	lcd.font(FONT_L)
	lcd.drawText(310,145,"EGT:")
	lcd.drawText(370,145,"No Temp1")
	else 
	EGTValue = EGT_R:value()
	lcd.font(FONT_L)
	lcd.drawText(310,145,"EGT:")
	lcd.drawNumber (370, 145, (string.format("%.0f", EGTValue)),UNIT_CELSIUS) 
	end


--===================================================
-- Draw Pump_R Power
--===================================================
lcd.font(FONT_L)
if RDT_ADC4source_R ~= nil then Pump_R = system.getSource (RDT_ADC4source_R) 	else Pump_R = nil end
	if (Pump_R == nil) then 
	Pump_R_Value = 0
	lcd.drawText (310, 163, "Pump: ")
	lcd.drawText (370, 163, "No ADC4") 
	else 
	Pump_R_Value = Pump_R:value()
	lcd.font(FONT_L)
	lcd.drawText (310, 163, "Pump: ")
		if ((ecu_type < 3) or (ecu_type == 9)) then
		lcd.drawText(310, 163,"Pump: "..(string.format("%.2f", Pump_R_Value)).."V") -- *A4Mult
		elseif ecu_type == 7 then
		Pump_R_Value = Pump_R:value()*100
			if Turbine_Status_R == 11 then -- is ECU in running state?
			lcd.drawText(370, 163,(string.format("%.0f", (Pump_R_Value))))
			else -- ECU not in running state
			lcd.drawText(370, 163,"0")
			end
		else 
		lcd.drawText(370, 163,(string.format("%.0f", (Pump_R_Value*A4Mult)))) -- **A4Mult
		end
	end

--===================================================
-- Draw ECU Voltage
--===================================================
	if RDT_ADC3source_R ~= nil then EcuV_R = system.getSource (RDT_ADC3source_R) 	else EcuV_R = nil end
	if (EcuV_R == nil) then 
	lcd.font(FONT_L)
	lcd.drawText (310, 182, "ECU: ")
	lcd.drawText (370,182, "No ADC3") 
	else 
	lcd.font(FONT_L)
	lcd.drawText (310, 182, "ECU: ")
	EcuV_R_Value = EcuV_R:value() 
	lcd.drawText (370, 182,(string.format("%.2f", (EcuV_R_Value))).."V")
	end

--===================================================
-- Draw Current_R
--===================================================
--[[
if ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 10 then
		lcd.font(FONT_L)
		lcd.drawText(2,230,"Current:")
		if (RDT_Currsource_R ~= nil) and (RDT_Currsource_R ~= "---") then Current_R = system.getSource (RDT_Currsource_R) else Current_R = nil end
		if (Current_R == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (2, 253, "No Current") 
		else 
		Current_R_Value = Current_R:value() 
		lcd.drawText(2,253,(string.format("%.1f", (Current_R_Value))).."A")
		end
elseif ecu_type == 3 then
		if (RDT_Currsource_R ~= nil) and (RDT_Currsource_R ~= "---") then Current_R = system.getSource (RDT_Currsource_R) else Current_R = nil end
		if (Current_R == nil) then -- do nothing
		else 
		lcd.font(FONT_L)
		lcd.drawText(2,230,"Current:")
		Current_R_Value = Current_R:value() 
		lcd.drawText(2,253,(string.format("%.1f", (Current_R_Value))).."A")
		end
end
]]--
--===================================================
-- Draw mAh_R
--===================================================
--[[
if ecu_type == 5 or ecu_type == 6 or ecu_type == 10 then --Linton and Jetcentral
	lcd.font(FONT_L)
	lcd.drawText(145,230,"Batt Draw:")
	if (RDT_Drawsource_R ~= nil) and (RDT_Drawsource_R ~= "---") then mAh_R = system.getSource (RDT_Drawsource_R) 	else mAh_R = nil end
	if (mAh_R == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (145, 253, "No mAh") 
	else 
	lcd.font(FONT_L)
	mAhValue = mAh_R:value() 
	lcd.drawText(145,253,(string.format("%.0f", (mAhValue))).."mAh")
	end
elseif ecu_type == 3 or ecu_type == 7  then
	if (RDT_Drawsource_R ~= nil) and (RDT_Drawsource_R ~= "---") then mAh_R = system.getSource (RDT_Drawsource_R) 	else mAh_R = nil end
	if (mAh_R == nil) then -- do nothing
	else 
	lcd.font(FONT_L)
	lcd.drawText(145,230,"Batt Draw:")
	mAhValue = mAh_R:value() 
	lcd.drawText(145,253,(string.format("%.0f", (mAhValue))).."mAh")
	end
end
]]--
--===================================================
-- Draw Fuel
--===================================================
RDTcount = RDTcount + 1
lcd.font(FONT_L)
lcd.drawText(310,230,"Fuel:")
lcd.font(FONT_L)
if ecu_type == 3 or ecu_type == 4 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then -- fuel is calculated from Pump_R 
if ecu_type == 3 or ecu_type == 4 or ecu_type == 6 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10  then -- fuel is calculated from ADC4 (Pump_R)
CurrentFuelCapacity_R = CurrentFuelCapacity_R - (Pump_R_Value) * 0.001 * FuelFactor_R 
elseif ecu_type == 7 and Turbine_Status_R == 11 then -- swiwin and ECU in running state
CurrentFuelCapacity_R = CurrentFuelCapacity_R - (Pump_R_Value) * 0.0001 * FuelFactor_R 
elseif ecu_type == 11 then -- AMT
CurrentFuelCapacity_R = CurrentFuelCapacity_R - (Pump_R_Value) * 0.001 * FuelFactor_R
end
	if (CurrentFuelCapacity_R < FuelAlert) then-- fuel alert is triggered 
	lcd.color(RED) -- RED
	lcd.drawText (310, 255,(string.format("%.0f", (CurrentFuelCapacity_R))).."ml") -- RED Text
	lcd.color(WHITE) -- White
		if RDTcount >FuelLowCycle*3.3 then 
			if (FuelAlertOnOff == true) then 
			system.playFile	(LowFuelSound)	
			system.playHaptic("- - -")	
			end
		RDTcount = 0
		end
	lcd.color(WHITE) -- White
	else
	lcd.drawText (310, 255,(string.format("%.0f", (CurrentFuelCapacity_R))).."ml")
	end

else -- all other ECUs
if RDT_0A10source_R ~= nil then FuelCapacity_R = system.getSource (RDT_0A10source_R) 	else FuelCapacity_R = nil end
	if (FuelCapacity_R == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (310, 255, "No DIY1")
	else
		if ((FuelCapacity_R:value() < FuelAlert) and ((FuelCapacity_R:value() ~= 0))) then-- fuel alert is triggered 
		lcd.color(RED) 
		--lcd.drawNumber (310, 255, FuelCapacity_R:value(),UNIT_MILLILITER)
		lcd.drawText (310, 255,(string.format("%.0f", (FuelCapacity_R:value()))).."ml")
			if RDTcount >FuelLowCycle*3.3 then 
			if (FuelAlertOnOff == true) then 
			system.playFile	(LowFuelSound)	
			system.playHaptic("- - -")		
			end
			RDTcount = 0
			end
		lcd.color(WHITE) 
		else
		--lcd.drawNumber (310, 255, FuelCapacity_R:value(),UNIT_MILLILITER)
		lcd.drawText (310, 255,(string.format("%.0f", (FuelCapacity_R:value()))).."ml")
		end
	end
end

--===================================================
-- Draw Throttle
--===================================================
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 5 or ecu_type == 6 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 then
	if RDT_0A20source_R ~= nil then Thro_R = system.getSource (RDT_0A20source_R) 	else Thro_R = nil end
	lcd.font(FONT_L)
	lcd.drawText(370,230,"Throttle:")
	lcd.font(FONT_L)
		if (Thro_R == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (370, 255, "No DIY2")
		else 
		lcd.drawNumber (370, 255, (string.format("%.0f", Thro_R:value())),UNIT_PERCENT)
		end	
	elseif ecu_type == 3 or ecu_type == 4 or ecu_type == 11 then
	if RDT_0A10source_R ~= nil then Thro_R = system.getSource (RDT_0A10source_R) else Thro_R = nil end
		lcd.font(FONT_L)
		lcd.drawText(370,230,"Throttle:")
		lcd.font(FONT_L)
		if (Thro_R == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (370, 255, "No DIY1")
		else 
		lcd.drawNumber (370, 255, (string.format("%.0f", Thro_R:value()/100)),UNIT_PERCENT)
		end	
	elseif ecu_type == 7 then -- Swiwin
	AnalogThrottle_R = system.getSource({category=CATEGORY_ANALOG, member=2, options=0}) -- throttle stick 
	Throttlepercentage_R = (AnalogThrottle_R:value() + 1024)/20.48 -- throttle values mormalized to 0-100%
	lcd.font(FONT_L)
	lcd.drawText(370,230,"Throttle:")
	lcd.font(FONT_L)
	lcd.drawText (370, 255,(string.format("%.0f", (Throttlepercentage_R))).."%")
	end
	--[[
	--===================================================
	-- Draw Version
	--===================================================
	lcd.font(FONT_S)
	lcd.drawText (710, 440 - Zoffset,RDTversion)
	--]]
	lcd.font(FONT_L)
	elseif (screenSize == "X10fullScreenWithTitle") then -- X10 With Title
	-- alert user to shut title off
	lcd.color(YELLOW)
	lcd.drawFilledRectangle(w2/7-10,h2/3-10,405,105)
	lcd.color(RED)
	lcd.drawRectangle(w2/7-10,h2/3-10,405,105,3)
	lcd.font(FONT_XXL)
	lcd.drawText (w2/7-5,h2/3,"PLEASE CHOOSE TITLE: OFF")
	lcd.drawText (w2/5,h2/3+50,"IN CONFIGURE WIDGET")
	end
end


-- LEFT turbine
local function draw_Turbine_Data_L(Me)
lcd.font(FONT_L)

if (screenSize == "X20fullScreenWithTitle") or (screenSize == "X20fullScreenWithOutTitle") then
--===================================================
-- Draw RPM_L
--===================================================
	lcd.font(FONT_L)
	if RDT_RPMsource_L ~= nil then RPM_L = system.getSource (RDT_RPMsource_L) 	else RPM_L = nil end
	if (RPM_L == nil) then 
	lcd.font(FONT_XL)
	lcd.drawText(040,220,"RPM:")
	lcd.font(FONT_L)
	lcd.drawText(140,220,"No RPM")
	else 
	RPMValue_L = RPM_L:value()
	lcd.font(FONT_XL)
	lcd.drawText(040,220,"RPM:")
		if ecu_type == 7 then
		lcd.drawNumber (140, 220, (string.format("%.0f", RPMValue_L))*1)
		else
		lcd.drawNumber (140, 220, (string.format("%.0f", RPMValue_L))*100)
		end
	end
	--[[
--===================================================
-- Draw Turbo Prop RPM_L
--===================================================	
--TBDLZ
	lcd.font(FONT_L)
	if RDT_0A30source_L ~= nil then TP_LPM = system.getSource (RDT_0A30source_L) else TP_LPM = nil end -- kingtech TP RPM_L
	if (TP_LPM == nil) then 
	-- do nothing
	else 
	TP_LPMValue_L = TP_LPM:value()
	lcd.drawText(360,405,"TP RPM:")
	lcd.drawNumber (360, 433, (string.format("%.0f", TP_LPMValue_L))*100)
	end
]]--

--===================================================
-- Draw EGT_L
--===================================================
	if RDT_Tmp1source_L ~= nil then EGT_L = system.getSource (RDT_Tmp1source_L) 	else EGT_L = nil end
	if (EGT_L == nil) then 
	lcd.font(FONT_XL)
	lcd.drawText(040,252,"EGT:")
	lcd.font(FONT_L)
	lcd.drawText(140,252,"No Temp1")
	else 
	EGTValue = EGT_L:value()
	lcd.font(FONT_XL)
	lcd.drawText(040,252,"EGT:")
	lcd.drawNumber (140, 252, (string.format("%.0f", EGTValue)),UNIT_CELSIUS) 
	end


--===================================================
-- Draw Pump_L Power
--===================================================
lcd.font(FONT_L)
if RDT_ADC4source_L ~= nil then Pump_L = system.getSource (RDT_ADC4source_L) 	else Pump_L = nil end
	if (Pump_L == nil) then 
	Pump_L_Value = 0
	lcd.font(FONT_XL)
	lcd.drawText (040, 285,"Pump:")
	lcd.font(FONT_L)
	lcd.drawText (140, 285,"No ADC4") 
	else 
	Pump_L_Value = Pump_L:value()
	lcd.font(FONT_XL)
	lcd.drawText (040, 285, "Pump:")
		if ((ecu_type < 3) or (ecu_type == 9)) then
		lcd.drawText(140, 285,(string.format("%.2f", Pump_L_Value)).."V") -- *A4Mult
		elseif ecu_type == 7 then
		Pump_L_Value = Pump_L:value()*100
			if Turbine_Status_L == 11 then -- is ECU in running state?
			lcd.drawText(140, 285,(string.format("%.0f", (Pump_L_Value))))
			else -- ECU not in running state
			lcd.drawText(040, 285,"Pump_L:  0")
			end
		else 
		lcd.drawText(140, 285,(string.format("%.0f", (Pump_L_Value*A4Mult)))) -- **A4Mult
		end
	end

--===================================================
-- Draw ECU Voltage
--===================================================
	if RDT_ADC3source_L ~= nil then EcuV_L = system.getSource (RDT_ADC3source_L) 	else EcuV_L = nil end
	if (EcuV_L == nil) then 
	lcd.font(FONT_XL)
	lcd.drawText (040, 320,"ECU: ")
	lcd.font(FONT_L)
	lcd.drawText (140,320, "No ADC3") 
	else 
	lcd.font(FONT_XL)
	lcd.drawText (040, 320, "ECU: ")
	EcuV_L_Value = EcuV_L:value() 
	lcd.drawText (140, 320,(string.format("%.2f", (EcuV_L_Value))).."V")
	end

--===================================================
-- Draw Current_L
--===================================================
-- TBDLZ
--[[
if ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 10 then
lcd.font(FONT_L)
lcd.drawText(30,405,"Current:")
lcd.font(FONT_L)
if RDT_Currsource_L ~= nil then Current_L = system.getSource (RDT_Currsource_L) 	else Current_L = nil end
	if (Current_L == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (30, 433, "No Current") 
	else 
	Current_L_Value = Current_L:value() 
	lcd.drawText(30,433,(string.format("%.1f", (Current_L_Value))).."A")
	end
elseif ecu_type == 3 then
if RDT_Currsource_L ~= nil then Current_L = system.getSource (RDT_Currsource_L) 	else Current_L = nil end
		if (Current_L == nil) then -- do nothing
		else 
		lcd.font(FONT_L)
		lcd.drawText(30,405,"Current:")
		Current_L_Value = Current_L:value() 
		lcd.drawText(30,433,(string.format("%.1f", (Current_L_Value))).."A")
		end
end
]]--

--===================================================
-- Draw mAh_L
--===================================================
--TBDLZ
--[[
if ecu_type == 5 or ecu_type == 6 or ecu_type == 10 then --Linton V1 V2, Jetcentral, swiwin, Xicoy
lcd.font(FONT_L)
lcd.drawText(355,405,"Batt Draw:")
if RDT_Drawsource_L ~= nil then mAh_L = system.getSource (RDT_Drawsource_L) 	else mAh_L = nil end
	if (mAh_L == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (355, 433, "No mAh") 
	else 
	lcd.font(FONT_L)
	mAhValue = mAh_L:value() 
	lcd.drawText(355,433,(string.format("%.0f", (mAhValue))).."mAh")
	end
elseif ecu_type == 3 or ecu_type == 7  then
if RDT_Drawsource_L ~= nil then mAh_L = system.getSource (RDT_Drawsource_L) 	else mAh_L = nil end
	if (mAh_L == nil) then -- do nothing
	else 
	lcd.font(FONT_L)
	lcd.drawText(355,405,"Batt Draw:")
	mAhValue = mAh_L:value() 
	lcd.drawText(355,433,(string.format("%.0f", (mAhValue))).."mAh")
	end
end
]]--
--===================================================
-- Draw Fuel
--===================================================
RDTcount = RDTcount + 1
lcd.font(FONT_L)
lcd.drawText(45,405,"Fuel:")
lcd.font(FONT_L)
if ecu_type == 3 or ecu_type == 4 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then -- fuel is calculated from Pump_L 
if ecu_type == 3 or ecu_type == 4 or ecu_type == 6 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 then -- fuel is calculated from ADC4 (Pump_L)
CurrentFuelCapacity_L = CurrentFuelCapacity_L - (Pump_L_Value) * 0.001 * FuelFactor_L 
elseif ecu_type == 7 and Turbine_Status_L == 11  then -- swiwin and ECU in running state
CurrentFuelCapacity_L = CurrentFuelCapacity_L - (Pump_L_Value) * 0.0001 * FuelFactor_L 
elseif ecu_type == 11 then -- AMT
CurrentFuelCapacity_L = CurrentFuelCapacity_L - (Pump_L_Value) * 0.001 * FuelFactor_L 
end
	if (CurrentFuelCapacity_L < FuelAlert) then-- fuel alert is triggered 
	lcd.color(RED) -- RED
	lcd.drawText (45, 433,(string.format("%.0f", (CurrentFuelCapacity_L))).."ml") -- RED Text
	lcd.color(WHITE) -- White
		if RDTcount >FuelLowCycle*3.3 then 
			if (FuelAlertOnOff == true) then 
			system.playFile	(LowFuelSound)	
			system.playHaptic("- - -")	
			end
		RDTcount = 0
		end
	lcd.color(WHITE) -- White
	else
	lcd.drawText (45, 433,(string.format("%.0f", (CurrentFuelCapacity_L))).."ml")
	end

else -- all other ECUs
if RDT_0A10source_L ~= nil then FuelCapacity_L = system.getSource (RDT_0A10source_L) 	else FuelCapacity_L = nil end
	if (FuelCapacity_L == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (45, 433, "No DIY1")
	else
		if ((FuelCapacity_L:value() < FuelAlert) and ((FuelCapacity_L:value() ~= 0))) then-- fuel alert is triggered 
		lcd.color(RED) 
		--lcd.drawNumber (45, 433, FuelCapacity_L:value(),UNIT_MILLILITER)
		lcd.drawText (45, 433,(string.format("%.0f", (FuelCapacity_L:value()))).."ml")
			if RDTcount >FuelLowCycle*3.3 then 
			if (FuelAlertOnOff == true) then 
			system.playFile	(LowFuelSound)	
			system.playHaptic("- - -")		
			end
			RDTcount = 0
			end
		lcd.color(WHITE) 
		else
		--lcd.drawNumber (45, 433, FuelCapacity_L:value(),UNIT_MILLILITER)
		lcd.drawText (45, 433,(string.format("%.0f", (FuelCapacity_L:value()))).."ml")
		end
	end
end

--===================================================
-- Draw Throttle
--===================================================
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 5 or ecu_type == 6 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 then
	if RDT_0A20source_L ~= nil then Thro_L = system.getSource (RDT_0A20source_L) 	else Thro_L = nil end
	lcd.font(FONT_L)
	lcd.drawText(140,405,"Throttle:")
	lcd.font(FONT_L)
		if (Thro_L == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (140, 433, "No DIY2")
		else 
		lcd.drawNumber (140, 433,(string.format("%.0f", Thro_L:value())) ,UNIT_PERCENT)
		end	
	elseif ecu_type == 3 or ecu_type == 4 or ecu_type == 11  then
	if RDT_0A10source_L ~= nil then Thro_L = system.getSource (RDT_0A10source_L) 	else Thro_L = nil end
		lcd.font(FONT_L)
	lcd.drawText(140,405,"Throttle:")
	lcd.font(FONT_L)
		if (Thro_L == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (140, 433, "No DIY11")
		print(RDT_0A20source_L)
		else 
		lcd.drawNumber (140, 433, (string.format("%.0f", Thro_L:value()/100)),UNIT_PERCENT)
		end	
	elseif ecu_type == 7 then -- Swiwin
	AnalogThrottle_L = system.getSource({category=CATEGORY_ANALOG, member=2, options=0}) -- throttle stick 
	Throttlepercentage_L = (AnalogThrottle_L:value() + 1024)/20.48 -- throttle values mormalized to 0-100%
	lcd.font(FONT_L)
	lcd.drawText(140,405,"Throttle:")
	lcd.font(FONT_L)
	lcd.drawText (140, 433,(string.format("%.0f", (Throttlepercentage_L))).."%")
	end
	
	--===================================================
	-- Draw Version
	--===================================================
	--[[
	lcd.font(FONT_XS)
	lcd.color(lcd.RGB(255, 255, 255,0.5))
	--lcd.drawFilledRectangle	(740,442,20,20,1)
	lcd.drawText (740, 442,RDTversion)
	lcd.font(FONT_L)
	lcd.color(WHITE)
	--]]
	
	elseif ((screenSize == "X10fullScreenWithOutTitle") or (screenSize == "X18fullScreenWithTitle") or (screenSize == "X18fullScreenWithOutTitle")) then  -- X10 / X18         
--===================================================
-- Draw RPM_L
--===================================================
	lcd.font(FONT_L)
	if RDT_LPMsource_L ~= nil then RPM_L = system.getSource (RDT_LPMsource_L) 	else RPM_L = nil end
	if (RPM_L == nil) then 
	lcd.font(FONT_L)
	lcd.drawText(30,127,"RPM:") --540 225 -- -230 -100
	lcd.drawText(90,127,"No RPM")
	else 
	RPMValue_L = RPM_L:value()
	lcd.font(FONT_L)
	lcd.drawText(30,127,"RPM:")
		if ecu_type == 7 then
		lcd.drawNumber (90, 127, (string.format("%.0f", RPMValue_L))*1)
		else
		lcd.drawNumber (90, 127, (string.format("%.0f", RPMValue_L))*100)
		end
	
	end


--===================================================
-- Draw EGT_L
--===================================================
	if RDT_Tmp1source_L ~= nil then EGT_L = system.getSource (RDT_Tmp1source_L) 	else EGT_L = nil end
	if (EGT_L == nil) then 
	lcd.font(FONT_L)
	lcd.drawText(30,145,"EGT:")
	lcd.drawText(90,145,"No Temp1")
	else 
	EGTValue = EGT_L:value()
	lcd.font(FONT_L)
	lcd.drawText(30,145,"EGT:")
	lcd.drawNumber (90, 145, (string.format("%.0f", EGTValue)),UNIT_CELSIUS) 
	end


--===================================================
-- Draw Pump_L Power
--===================================================
lcd.font(FONT_L)
if RDT_ADC4source_L ~= nil then Pump_L = system.getSource (RDT_ADC4source_L) 	else Pump_L = nil end
	if (Pump_L == nil) then 
	Pump_L_Value = 0
	lcd.drawText (30, 163, "Pump: ")
	lcd.drawText (90, 163, "No ADC4") 
	else 
	Pump_L_Value = Pump_L:value()
	lcd.font(FONT_L)
	lcd.drawText (30, 163, "Pump: ")
		if ((ecu_type < 3) or (ecu_type == 9)) then
		lcd.drawText(30, 163,"Pump: "..(string.format("%.2f", Pump_L_Value)).."V") -- *A4Mult
		elseif ecu_type == 7 then
		Pump_L_Value = Pump_L:value()*100
			if Turbine_Status_L == 11 then -- is ECU in running state?
			lcd.drawText(90, 163,(string.format("%.0f", (Pump_L_Value))))
			else -- ECU not in running state
			lcd.drawText(90, 163,"0")
			end
		else 
		lcd.drawText(90, 163,(string.format("%.0f", (Pump_L_Value*A4Mult)))) -- **A4Mult
		end
	end

--===================================================
-- Draw ECU Voltage
--===================================================
	if RDT_ADC3source_L ~= nil then EcuV_L = system.getSource (RDT_ADC3source_L) 	else EcuV_L = nil end
	if (EcuV_L == nil) then 
	lcd.font(FONT_L)
	lcd.drawText (30, 182, "ECU: ")
	lcd.drawText (90,182, "No ADC3") 
	else 
	lcd.font(FONT_L)
	lcd.drawText (30, 182, "ECU: ")
	EcuV_L_Value = EcuV_L:value() 
	lcd.drawText (90, 182,(string.format("%.2f", (EcuV_L_Value))).."V")
	end

--===================================================
-- Draw Current_L
--===================================================
--[[
if ecu_type == 5 or ecu_type == 6 or ecu_type == 7 or ecu_type == 10 then
		lcd.font(FONT_L)
		lcd.drawText(2,230,"Current:")
		if (RDT_Currsource_L ~= nil) and (RDT_Currsource_L ~= "---") then Current_L = system.getSource (RDT_Currsource_L) else Current_L = nil end
		if (Current_L == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (2, 253, "No Current") 
		else 
		Current_L_Value = Current_L:value() 
		lcd.drawText(2,253,(string.format("%.1f", (Current_L_Value))).."A")
		end
elseif ecu_type == 3 then
		if (RDT_Currsource_L ~= nil) and (RDT_Currsource_L ~= "---") then Current_L = system.getSource (RDT_Currsource_L) else Current_L = nil end
		if (Current_L == nil) then -- do nothing
		else 
		lcd.font(FONT_L)
		lcd.drawText(2,230,"Current:")
		Current_L_Value = Current_L:value() 
		lcd.drawText(2,253,(string.format("%.1f", (Current_L_Value))).."A")
		end
end
]]--
--===================================================
-- Draw mAh_L
--===================================================
--[[
if ecu_type == 5 or ecu_type == 6 or ecu_type == 10 then --Linton and Jetcentral
	lcd.font(FONT_L)
	lcd.drawText(145,230,"Batt Draw:")
	if (RDT_Drawsource_L ~= nil) and (RDT_Drawsource_L ~= "---") then mAh_L = system.getSource (RDT_Drawsource_L) 	else mAh_L = nil end
	if (mAh_L == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (145, 253, "No mAh") 
	else 
	lcd.font(FONT_L)
	mAhValue = mAh_L:value() 
	lcd.drawText(145,253,(string.format("%.0f", (mAhValue))).."mAh")
	end
elseif ecu_type == 3 or ecu_type == 7  then
	if (RDT_Drawsource_L ~= nil) and (RDT_Drawsource_L ~= "---") then mAh_L = system.getSource (RDT_Drawsource_L) 	else mAh_L = nil end
	if (mAh_L == nil) then -- do nothing
	else 
	lcd.font(FONT_L)
	lcd.drawText(145,230,"Batt Draw:")
	mAhValue = mAh_L:value() 
	lcd.drawText(145,253,(string.format("%.0f", (mAhValue))).."mAh")
	end
end
]]--
--===================================================
-- Draw Fuel
--===================================================
RDTcount = RDTcount + 1
lcd.font(FONT_L)
lcd.drawText(30,230,"Fuel:")
lcd.font(FONT_L)
if ecu_type == 3 or ecu_type == 4 or ecu_type == 6 or ecu_type == 7 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 or ecu_type == 11  then -- fuel is calculated from Pump_L 
if ecu_type == 3 or ecu_type == 4 or ecu_type == 6 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10  then -- fuel is calculated from ADC4 (Pump_L)
CurrentFuelCapacity_L = CurrentFuelCapacity_L - (Pump_L_Value) * 0.001 * FuelFactor_L 
elseif ecu_type == 7 and Turbine_Status_L == 11 then -- swiwin and ECU in running state
CurrentFuelCapacity_L = CurrentFuelCapacity_L - (Pump_L_Value) * 0.0001 * FuelFactor_L 
elseif ecu_type == 11 then -- AMT
CurrentFuelCapacity_L = CurrentFuelCapacity_L - (Pump_L_Value) * 0.001 * FuelFactor_L
end
	if (CurrentFuelCapacity_L < FuelAlert) then-- fuel alert is triggered 
	lcd.color(RED) -- RED
	lcd.drawText (30, 255,(string.format("%.0f", (CurrentFuelCapacity_L))).."ml") -- RED Text
	lcd.color(WHITE) -- White
		if RDTcount >FuelLowCycle*3.3 then 
			if (FuelAlertOnOff == true) then 
			system.playFile	(LowFuelSound)	
			system.playHaptic("- - -")	
			end
		RDTcount = 0
		end
	lcd.color(WHITE) -- White
	else
	lcd.drawText (30, 255,(string.format("%.0f", (CurrentFuelCapacity_L))).."ml")
	end

else -- all other ECUs
if RDT_0A10source_L ~= nil then FuelCapacity_L = system.getSource (RDT_0A10source_L) 	else FuelCapacity_L = nil end
	if (FuelCapacity_L == nil) then 
	lcd.font(FONT_S)
	lcd.drawText (30, 255, "No DIY1")
	else
		if ((FuelCapacity_L:value() < FuelAlert) and ((FuelCapacity_L:value() ~= 0))) then-- fuel alert is triggered 
		lcd.color(RED) 
		--lcd.drawNumber (30, 255, FuelCapacity_L:value(),UNIT_MILLILITER)
		lcd.drawText (30, 255,(string.format("%.0f", (FuelCapacity_L:value()))).."ml")
			if RDTcount >FuelLowCycle*3.3 then 
			if (FuelAlertOnOff == true) then 
			system.playFile	(LowFuelSound)	
			system.playHaptic("- - -")		
			end
			RDTcount = 0
			end
		lcd.color(WHITE) 
		else
		--lcd.drawNumber (30, 255, FuelCapacity_L:value(),UNIT_MILLILITER)
		lcd.drawText (30, 255,(string.format("%.0f", (FuelCapacity_L:value()))).."ml")
		end
	end
end

--===================================================
-- Draw Throttle
--===================================================
	if ecu_type == 1 or ecu_type == 2 or ecu_type == 5 or ecu_type == 6 or ecu_type == 8 or ecu_type == 9 or ecu_type == 10 then
	if RDT_0A20source_L ~= nil then Thro_L = system.getSource (RDT_0A20source_L) 	else Thro_L = nil end
	lcd.font(FONT_L)
	lcd.drawText(90,230,"Throttle:")
	lcd.font(FONT_L)
		if (Thro_L == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (90, 255, "No DIY2")
		else 
		lcd.drawNumber (90, 255, (string.format("%.0f", Thro_L:value())),UNIT_PERCENT)
		end	
	elseif ecu_type == 3 or ecu_type == 4 or ecu_type == 11 then
	if RDT_0A10source_L ~= nil then Thro_L = system.getSource (RDT_0A10source_L) else Thro_L = nil end
		lcd.font(FONT_L)
		lcd.drawText(90,230,"Throttle:")
		lcd.font(FONT_L)
		if (Thro_L == nil) then 
		lcd.font(FONT_S)
		lcd.drawText (90, 255, "No DIY1")
		else 
		lcd.drawNumber (90, 255, (string.format("%.0f", Thro_L:value()/100)),UNIT_PERCENT)
		end	
	elseif ecu_type == 7 then -- Swiwin
	AnalogThrottle_L = system.getSource({category=CATEGORY_ANALOG, member=2, options=0}) -- throttle stick 
	Throttlepercentage_L = (AnalogThrottle_L:value() + 1024)/20.48 -- throttle values mormalized to 0-100%
	lcd.font(FONT_L)
	lcd.drawText(90,230,"Throttle:")
	lcd.font(FONT_L)
	lcd.drawText (90, 255,(string.format("%.0f", (Throttlepercentage_L))).."%")
	end
	--[[
	--===================================================
	-- Draw Version
	--===================================================
	lcd.font(FONT_S)
	lcd.drawText (710, 440 - Zoffset,RDTversion)
	--]]
	lcd.font(FONT_L)
	elseif (screenSize == "X10fullScreenWithTitle") then -- X10 With Title
	-- alert user to shut title off
	lcd.color(YELLOW)
	lcd.drawFilledRectangle(w2/7-10,h2/3-10,405,105)
	lcd.color(RED)
	lcd.drawRectangle(w2/7-10,h2/3-10,405,105,3)
	lcd.font(FONT_XXL)
	lcd.drawText (w2/7-5,h2/3,"PLEASE CHOOSE TITLE: OFF")
	lcd.drawText (w2/5,h2/3+50,"IN CONFIGURE WIDGET")
	end
end
-- end draw_turbine_data_L

local function create()
    return {r=255,
			g=255, 
			b=255, 
			OnOff=false, 
			source=nil, 
			min=-1024, 
			max=1024, 
			value=0,
			FuelTankSize = 3000, 
			FuelLowCycleTime=5, 
			FuelAlertOnOff = true,
			StickMode = 2, 
			FuelFactor_R = 100, 
			FuelFactor_L = 100, 
			FuelTankAlert = 1000, 
			FuelAlert = 1000,
			ECU = 1}
end

local function wakeup(widget)
			newValue = os.clock() 
			invalidateme = 1
			if newValue > Time_Temp + 1 / paint_rate_Hz then -- paint every X hz
			Time_Temp = newValue 
				if RDTDone_Painting then 
				lcd.invalidate() 
				RDTDone_Painting = false 
				end 
			end 
end

local function paint(widget)
	if (invalidateme == 1) then
	--invalidateme = 0
	
	--local mem = {}
	--mem = system.getMemoryUsage()
	--print("Main Stack: "..mem["mainStackAvailable"])
	--print("RAM Avail: "..mem["ramAvailable"])
	--print("LUA RAM Avail: "..mem["luaRamAvailable"])
	--print("LUA BMP Avail: "..mem["luaBitmapsRamAvailable"])
	--print("=========================")
	
	if model_name ~= (model.name()) then mdlimage = lcd.loadBitmap(model.bitmap()) end -- Load model Image from memory
	
	if RDTcycleCounter == 0 then
	--mdlimage = lcd.loadBitmap(model.bitmap())-- Load model Image from memory
	CurrentFuelCapacity_R = widget.FuelTankSize -- read fuel tank size from memory
	CurrentFuelCapacity_L = widget.FuelTankSize -- read fuel tank size from memory
	print("INIT DONE")
	end

	FuelLowCycle   = widget.FuelLowCycleTime
	FuelAlertOnOff = widget.FuelAlertOnOff
	SticksMode 	   = widget.StickMode
	FuelFactor_R   = widget.FuelFactor_R
	FuelFactor_L   = widget.FuelFactor_L
	FuelAlert      = widget.FuelTankAlert
	ecu_type       = widget.ECU
	--RIGHT turbine
	if widget.RDT_RPMsource_R ~= nil then RDT_RPMsource_R   = widget.RDT_RPMsource_R:name () end
	if widget.RDT_Tmp1source_R ~= nil then RDT_Tmp1source_R = widget.RDT_Tmp1source_R:name() end
	if widget.RDT_Tmp2source_R ~= nil then RDT_Tmp2source_R = widget.RDT_Tmp2source_R:name() end
	if widget.RDT_ADC3source_R ~= nil then RDT_ADC3source_R = widget.RDT_ADC3source_R:name() end
	if widget.RDT_ADC4source_R ~= nil then RDT_ADC4source_R = widget.RDT_ADC4source_R:name() end
	if widget.RDT_0A10source_R  ~= nil then RDT_0A10source_R   = widget.RDT_0A10source_R:name () end
	if widget.RDT_0A20source_R ~= nil then RDT_0A20source_R = widget.RDT_0A20source_R:name () end
	if widget.RDT_0A30source_R ~= nil then RDT_0A30source_R = widget.RDT_0A30source_R:name () end
	if widget.RDT_Currsource_R ~= nil then RDT_Currsource_R = widget.RDT_Currsource_R:name() end
	if widget.RDT_Drawsource_R ~= nil then RDT_Drawsource_R = widget.RDT_Drawsource_R:name() end
		--LEFT turbine
	if widget.RDT_RPMsource_L ~= nil then RDT_RPMsource_L   = widget.RDT_RPMsource_L:name () end
	if widget.RDT_Tmp1source_L ~= nil then RDT_Tmp1source_L = widget.RDT_Tmp1source_L:name() end
	if widget.RDT_Tmp2source_L ~= nil then RDT_Tmp2source_L = widget.RDT_Tmp2source_L:name() end
	if widget.RDT_ADC3source_L ~= nil then RDT_ADC3source_L = widget.RDT_ADC3source_L:name() end
	if widget.RDT_ADC4source_L ~= nil then RDT_ADC4source_L = widget.RDT_ADC4source_L:name() end
	if widget.RDT_0A10source_L  ~= nil then RDT_0A10source_L   = widget.RDT_0A10source_L:name () end
	if widget.RDT_0A20source_L ~= nil then RDT_0A20source_L = widget.RDT_0A20source_L:name () end
	if widget.RDT_0A30source_L ~= nil then RDT_0A30source_L = widget.RDT_0A30source_L:name () end
	if widget.RDT_Currsource_L ~= nil then RDT_Currsource_L = widget.RDT_Currsource_L:name() end
	if widget.RDT_Drawsource_L ~= nil then RDT_Drawsource_L = widget.RDT_Drawsource_L:name() end
	-- General parameters
	if widget.RDT_RSSI1source ~= nil then RDT_RSSI1source = widget.RDT_RSSI1source:name() end
	if widget.RDT_RSSI2source ~= nil then RDT_RSSI2source = widget.RDT_RSSI2source:name() end
	if widget.RDT_RXbattsource ~= nil then RDT_RXbattsource = widget.RDT_RXbattsource:name() end
	if widget.RDT_Pressuresource ~= nil then RDT_Pressuresource = widget.RDT_Pressuresource:name() end	
	
	if (os.clock()-RDTwidgetTime > 1) then -- if widget not running for 2s
	RDTbgroundCounter = 0
	end 
	
	initECU_Status(Me)
	draw_background(Me)
	draw_Top_Bar(Me)
	draw_Model_Name(Me)
	if RDTcycleCounter >= 0 then draw_Model_Image(Me)end
	if RDTcycleCounter >= 0 then 
	--draw_Trims(Me)	
	draw_Turbine_Data_R(Me) 
	draw_Turbine_Data_L(Me) 
	draw_Status_R(Me)
	draw_Status_L(Me)
	end
	if RDTcycleCounter >=0 then draw_Timer(Me) end
	RDTcycleCounter = RDTcycleCounter + 1
	RDTwidgetTime = os.clock()
	RDTDone_Painting = true 
	end
end

local function configure(widget)
	line = form.addLine("ECU Type")
	form.addChoiceField(line, nil, {{"Jetcat", 1}, {"Projet", 2}, {"Xicoy V6-V10", 3}, {"Kingtech G2-G4", 4}, {"Jetcentral", 5}, {"Linton V1", 6}, {"Swiwin", 7}, {"Xicoy X", 8}, {"Orbit", 9},{"Linton V2", 10},{"AMT", 11}}, function() return widget.ECU end, function(value) print(value) widget.ECU = value end)
	line = form.addLine("Stick Mode")
	form.addChoiceField(line, nil, {{"Mode 1", 1}, {"Mode 2", 2}, {"Mode 3", 3}, {"Mode 4", 4}}, function() return widget.StickMode end, function(value) print(value) widget.StickMode = value end)
	line = form.addLine("Fuel Tank parameters:")
	line = form.addLine("Fuel Factor R")
	local slots = form.getFieldSlots(line, {0})
	widget.FuelFactor_field_R = form.addNumberField(line, slots[1], 1, 10000, function() return widget.FuelFactor_R end, function(value) widget.FuelFactor_R = value end);
	widget.FuelFactor_field_R:default(100)
	line = form.addLine("Fuel Factor L")
	local slots = form.getFieldSlots(line, {0})
	widget.FuelFactor_field_L = form.addNumberField(line, slots[1], 1, 10000, function() return widget.FuelFactor_L end, function(value) widget.FuelFactor_L = value end);
	widget.FuelFactor_field_L:default(100)
	line = form.addLine("Fuel Tank Size (ml)")
	local slots = form.getFieldSlots(line, {0})
	widget.FuelTankSize_field = form.addNumberField(line, slots[1], 1, 10000, function() return widget.FuelTankSize end, function(value) widget.FuelTankSize = value end);
	widget.FuelTankSize_field:default(3000)
	line = form.addLine("Low Fuel Alert parameters:")
	line = form.addLine("Fuel Alert")	-- Fuel Alert OnOff
    form.addBooleanField(line, form.getFieldSlots(line)[0], function() return widget.FuelAlertOnOff end, function(value) widget.FuelAlertOnOff = value end)
	line = form.addLine("Fuel Alert (ml)")
	local slots = form.getFieldSlots(line, {0})
	widget.FuelTankAlert_field = form.addNumberField(line, slots[1], 1, 10000, function() return widget.FuelTankAlert end, function(value) widget.FuelTankAlert = value end);
	widget.FuelTankAlert_field:default(1000)
	line = form.addLine("Fuel Alert Rate (s)")
	local slots = form.getFieldSlots(line, {0}) -- Fuel Alert Rate
	widget.FuelLowCycleTime_field = form.addNumberField(line, slots[1], 1, 10, function() return widget.FuelLowCycleTime end, function(value) widget.FuelLowCycleTime = value end);
    widget.FuelLowCycleTime_field:default(5)
	-- Sensor Source configuration
	line = form.addLine("Sensor Configuration:")
	line = form.addLine("Right Turbine:")
	-- RIGHT turbine
    line = form.addLine("RPM Sensor R")
    form.addSourceField(line, nil, function() return widget.RDT_RPMsource_R end, function(value) widget.RDT_RPMsource_R = value end)
    line = form.addLine("Temp 1 Sensor (EGT) R")
    form.addSourceField(line, nil, function() return widget.RDT_Tmp1source_R end, function(value) widget.RDT_Tmp1source_R = value end)
    line = form.addLine("Temp 2 Sensor (Status) R")
    form.addSourceField(line, nil, function() return widget.RDT_Tmp2source_R end, function(value) widget.RDT_Tmp2source_R = value end)
    line = form.addLine("ADC3 Sensor (ECU V) R")
    form.addSourceField(line, nil, function() return widget.RDT_ADC3source_R end, function(value) widget.RDT_ADC3source_R = value end)
    line = form.addLine("ADC4 Sensor (Pump PW) R")
    form.addSourceField(line, nil, function() return widget.RDT_ADC4source_R end, function(value) widget.RDT_ADC4source_R = value end)
    line = form.addLine("DIY 1 Sensor R")
    form.addSourceField(line, nil, function() return widget.RDT_0A10source_R end, function(value) widget.RDT_0A10source_R = value end)
    line = form.addLine("DIY 2 Sensor R")
    form.addSourceField(line, nil, function() return widget.RDT_0A20source_R end, function(value) widget.RDT_0A20source_R = value end)
	line = form.addLine("DIY 3 Sensor R")
    form.addSourceField(line, nil, function() return widget.RDT_0A30source_R end, function(value) widget.RDT_0A30source_R = value end)
    line = form.addLine("Current Sensor R")
    form.addSourceField(line, nil, function() return widget.RDT_Currsource_R end, function(value) widget.RDT_Currsource_R = value end)
    line = form.addLine("Consumption Sensor R")
    form.addSourceField(line, nil, function() return widget.RDT_Drawsource_R end, function(value) widget.RDT_Drawsource_R = value end)
	
	-- LEFT turbine
	line = form.addLine("Left Turbine:")
    line = form.addLine("RPM Sensor L")
    form.addSourceField(line, nil, function() return widget.RDT_RPMsource_L end, function(value) widget.RDT_RPMsource_L = value end)
    line = form.addLine("Temp 1 Sensor (EGT) L")
    form.addSourceField(line, nil, function() return widget.RDT_Tmp1source_L end, function(value) widget.RDT_Tmp1source_L = value end)
    line = form.addLine("Temp 2 Sensor (Status) L")
    form.addSourceField(line, nil, function() return widget.RDT_Tmp2source_L end, function(value) widget.RDT_Tmp2source_L = value end)
    line = form.addLine("ADC3 Sensor (ECU V) L")
    form.addSourceField(line, nil, function() return widget.RDT_ADC3source_L end, function(value) widget.RDT_ADC3source_L = value end)
    line = form.addLine("ADC4 Sensor (Pump PW) L")
    form.addSourceField(line, nil, function() return widget.RDT_ADC4source_L end, function(value) widget.RDT_ADC4source_L = value end)
    line = form.addLine("DIY 1 Sensor L")
    form.addSourceField(line, nil, function() return widget.RDT_0A10source_L end, function(value) widget.RDT_0A10source_L = value end)
    line = form.addLine("DIY 2 Sensor L")
    form.addSourceField(line, nil, function() return widget.RDT_0A20source_L end, function(value) widget.RDT_0A20source_L = value end)
	line = form.addLine("DIY 3 Sensor L")
    form.addSourceField(line, nil, function() return widget.RDT_0A30source_L end, function(value) widget.RDT_0A30source_L = value end)
    line = form.addLine("Current Sensor L")
    form.addSourceField(line, nil, function() return widget.RDT_Currsource_L end, function(value) widget.RDT_Currsource_L = value end)
    line = form.addLine("Consumption Sensor L")
    form.addSourceField(line, nil, function() return widget.RDT_Drawsource_L end, function(value) widget.RDT_Drawsource_L = value end)
	
	-- general parameters
	line = form.addLine("General Sensors:")
    line = form.addLine("RSSI 1 Sensor")
    form.addSourceField(line, nil, function() return widget.RDT_RSSI1source end, function(value) widget.RDT_RSSI1source = value end)
	line = form.addLine("RSSI 2 Sensor")
    form.addSourceField(line, nil, function() return widget.RDT_RSSI2source end, function(value) widget.RDT_RSSI2source = value end)
    line = form.addLine("Rxbatt Sensor")
    form.addSourceField(line, nil, function() return widget.RDT_RXbattsource end, function(value) widget.RDT_RXbattsource = value end)
    line = form.addLine("Air Pressure Sensor")
    form.addSourceField(line, nil, function() return widget.RDT_Pressuresource end, function(value) widget.RDT_Pressuresource = value end)

end

local function read(widget)
    widget.ECU 			 	    = storage.read ("ECU")
	widget.StickMode 	 	    = storage.read ("StickMode")
	widget.FuelFactor_R	 	    = storage.read ("FuelFactor_R")
	widget.FuelFactor_L	 	    = storage.read ("FuelFactor_L")
	widget.FuelTankSize  		= storage.read ("FuelTankSize")
	widget.FuelAlertOnOff  		= storage.read ("FuelAlertOnOff")
	widget.FuelTankAlert 		= storage.read ("FuelTankAlert")
	widget.FuelLowCycleTime		= storage.read ("FuelLowCycleTime")
	
	-- RIGHT turbine
	widget.RDT_RPMsource_R	    = storage.read ("RDT_RPMsource_R")
	widget.RDT_Tmp1source_R	    = storage.read ("RDT_Tmp1source_R")
	widget.RDT_Tmp2source_R	    = storage.read ("RDT_Tmp2source_R")
	widget.RDT_ADC3source_R	    = storage.read ("RDT_ADC3source_R")
	widget.RDT_ADC4source_R	    = storage.read ("RDT_ADC4source_R")
	widget.RDT_0A10source_R	    = storage.read ("RDT_0A10source_R")
	widget.RDT_0A20source_R	    = storage.read ("RDT_0A20source_R")
	widget.RDT_0A30source_R	    = storage.read ("RDT_0A30source_R")
	widget.RDT_Currsource_R	    = storage.read ("RDT_Currsource_R")
	widget.RDT_Drawsource_R	    = storage.read ("RDT_Drawsource_R")
	
	-- LEFT turbine
	widget.RDT_RPMsource_L	    = storage.read ("RDT_RPMsource_L")
	widget.RDT_Tmp1source_L	    = storage.read ("RDT_Tmp1source_L")
	widget.RDT_Tmp2source_L	    = storage.read ("RDT_Tmp2source_L")
	widget.RDT_ADC3source_L	    = storage.read ("RDT_ADC3source_L")
	widget.RDT_ADC4source_L	    = storage.read ("RDT_ADC4source_L")
	widget.RDT_0A10source_L	    = storage.read ("RDT_0A10source_L")
	widget.RDT_0A20source_L	    = storage.read ("RDT_0A20source_L")
	widget.RDT_0A30source_L	    = storage.read ("RDT_0A30source_L")
	widget.RDT_Currsource_L	    = storage.read ("RDT_Currsource_L")
	widget.RDT_Drawsource_L	    = storage.read ("RDT_Drawsource_L")	
	
	--general sensors
	widget.RDT_RSSI1source	    = storage.read ("RDT_RSSI1source")
	widget.RDT_RSSI2source	    = storage.read ("RDT_RSSI2source")
	widget.RDT_RXbattsource	    = storage.read ("RDT_RXbattsource")
	widget.RDT_Pressuresource	= storage.read ("RDT_Pressuresource")
end

local function write(widget)
    storage.write("ECU"					, widget.ECU)
	storage.write("StickMode"			, widget.StickMode)
	storage.write("FuelFactor_R"			, widget.FuelFactor_R)
	storage.write("FuelFactor_L"			, widget.FuelFactor_L)
	storage.write("FuelTankSize"		, widget.FuelTankSize)
	storage.write("FuelAlertOnOff"		, widget.FuelAlertOnOff)
	storage.write("FuelTankAlert"		, widget.FuelTankAlert)
	storage.write("FuelLowCycleTime"	, widget.FuelLowCycleTime)
	
	--RIGHT turbine
	storage.write("RDT_RPMsource_R"		, widget.RDT_RPMsource_R)
	storage.write("RDT_Tmp1source_R"		, widget.RDT_Tmp1source_R)
	storage.write("RDT_Tmp2source_R"		, widget.RDT_Tmp2source_R)
	storage.write("RDT_ADC3source_R"		, widget.RDT_ADC3source_R)
	storage.write("RDT_ADC4source_R"		, widget.RDT_ADC4source_R)
	storage.write("RDT_0A10source_R"		, widget.RDT_0A10source_R)
	storage.write("RDT_0A20source_R"		, widget.RDT_0A20source_R)
	storage.write("RDT_0A30source_R"		, widget.RDT_0A30source_R)
	storage.write("RDT_Currsource_R"		, widget.RDT_Currsource_R)
	storage.write("RDT_Drawsource_R"		, widget.RDT_Drawsource_R)
	
	-- LEFT turbine
	storage.write("RDT_RPMsource_L"		, widget.RDT_RPMsource_L)
	storage.write("RDT_Tmp1source_L"		, widget.RDT_Tmp1source_L)
	storage.write("RDT_Tmp2source_L"		, widget.RDT_Tmp2source_L)
	storage.write("RDT_ADC3source_L"		, widget.RDT_ADC3source_L)
	storage.write("RDT_ADC4source_L"		, widget.RDT_ADC4source_L)
	storage.write("RDT_0A10source_L"		, widget.RDT_0A10source_L)
	storage.write("RDT_0A20source_L"		, widget.RDT_0A20source_L)
	storage.write("RDT_0A30source_L"		, widget.RDT_0A30source_L)
	storage.write("RDT_Currsource_L"		, widget.RDT_Currsource_L)
	storage.write("RDT_Drawsource_L"		, widget.RDT_Drawsource_L)
	
	--general sensors
	storage.write("RDT_RSSI1source"		, widget.RDT_RSSI1source)
	storage.write("RDT_RSSI2source"		, widget.RDT_RSSI2source)
	storage.write("RDT_RXbattsource"	, widget.RDT_RXbattsource)
	storage.write("RDT_RXbattsource"	, widget.RDT_Pressuresource)
end

local function init()
system.registerWidget({key="lzrdttw", name="Zavionix RDT twin", create=create, paint=paint, configure=configure, read=read, write=write, wakeup=wakeup, title = false})
Init = false
end

return {init=init}
