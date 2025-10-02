-- ********************************************************************************
-- **  Zavionix® LZBigTimer Widget Screen (LZ-Bigtimer)                                    **
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

--[[

V1.1.1 - First release, for 800x480 screen radios and uses Timer1 only
]]--

local BigTimerversion = "V2.1.5"

--local RDTDone_Painting = false
local Time_Temp = 0
local newValue = 0
local imagePath = "img"
local wallpaper_mask
local Zavionix
local Batt_Icon
local RSSI_Icon
local digits_blue
local Time_Temp = 0
local SticksMode
local Turbine_Status
local screenSize
local RSSI1Value = 0
local RSSI2Value = 0
local RSSI1
local RSSI2
local Timersource
local Timersource_old = ''
local RXbatt1
local RXbatt2
local TxBatt
local Timer
local timer_Secs
local timer_Mins
local TimerDigit1
local TimerDigit2
local TimerDigit3
local TimerDigit4
local screenSize
local Trimvalue0 = 0
local Trimvalue1 = 0
local Trimvalue2 = 0
local Trimvalue3 = 0
local SticksMode
local BigTimer_cycleCounter = 0
local BigTimerbgroundCounter = 0
local paint_rate_Hz = 3 -- invalidate / paint LCD every paint_rate_Hz
local High_RSSI_Value = 1

-- Screen coordinates
local RDT_timer_x_x20 = 445 -- was 534
local RDT_timer_y_x20 = 170
local RDT_RSSI_icon_x_x20 = 465
local RDT_RSSI_icon_y_x20 = 7
local RDT_timer_x_x18 = 320
local RDT_timer_y_x18 = 53
local RDT_RSSI_icon_x_x18 = 265
local RDT_RSSI_icon_y_x18 = 7
local RDT_RSSI_icon_x_x10 = 265
local RDT_RSSI_icon_y_x10 = 7

-- Tx batt params
local Txbatt_min = 7.0
local Txbatt_max = 8.4
local Txbatt_percentage = 0

-- Model Name
local model_path = ''

-- RSSI
RSSI_5bar = 90
RSSI_4bar = 75
RSSI_3bar = 55
RSSI_2bar = 45
RSSI_1bar = 32
RSSI_0bar = 0

-- Fuel percentage
local RDT_Fuel_Percentage = 100

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

--===================================================
-- Draw the trims
--===================================================
local function draw_Trims(Me)
lcd.font(FONT_S)
Analogvalue6 = getSensorValue(Analog6)
Trimvalue0 = getSensorValue(Trim0)
Trimvalue1 = getSensorValue(Trim1)
Trimvalue2 = getSensorValue(Trim2)
Trimvalue3 = getSensorValue(Trim3)

if (screenSize == "X20fullScreen") then
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
		lcd.drawBitmap(384,227  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue2 > 0) then
		lcd.drawBitmap(384,227- Trimvalue2/14  ,Trim_U)
		else
		lcd.drawBitmap(384,227- Trimvalue2/14  ,Trim_D)
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
		lcd.drawBitmap(384,227  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(384,227- Trimvalue1/14  ,Trim_U)
		else
		lcd.drawBitmap(384,227- Trimvalue1/14  ,Trim_D)
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
		lcd.drawBitmap(384,227  ,Trim_C)	-- center trim Throttle
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(384,227- Trimvalue1/14  ,Trim_U)
		else
		lcd.drawBitmap(384,227- Trimvalue1/14  ,Trim_D)
		end
else -- mode 4
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(135,380  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(135+ Trimvalue3/14,380  ,Trim_R)
		else
		lcd.drawBitmap(135+ Trimvalue3/14,380  ,Trim_L)
		end
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(310,380  ,Trim_C)	-- center trim Rudder
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(310+ Trimvalue0/14,380  ,Trim_R)
		else
		lcd.drawBitmap(310+ Trimvalue0/14,380  ,Trim_L)
		end
	if (Trimvalue1 ==0) then
		lcd.drawBitmap(384,227  ,Trim_C)	-- center trim Elevator
		elseif (Trimvalue1 > 0) then
		lcd.drawBitmap(384,227- Trimvalue1/14  ,Trim_U)
		else
		lcd.drawBitmap(384,227- Trimvalue1/14  ,Trim_D)
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
	lcd.drawBitmap(427,227- Analogvalue6/14   ,Trim_Green)	-- Red slider
	else
	lcd.drawBitmap(427,227- Analogvalue6/14   ,Trim_Red)	-- Red slider
	end
	--=====================================--
	                 -- X10/X18 --
	--=====================================--			   
	elseif (screenSize == "X18fullScreen") then  --  X18         
	Trimvalue4 = getSensorValue(Trim4)
	Trimvalue5 = getSensorValue(Trim5)

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
		lcd.drawBitmap(75,213  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(75+ Trimvalue3/23,213  ,Trim_R)
		else
		lcd.drawBitmap(75+ Trimvalue3/23,213  ,Trim_L)
		end
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(183,213  ,Trim_C)	-- center trim Rudder
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(183+ Trimvalue0/23,213  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue0/23,213  ,Trim_L)
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

elseif (screenSize == "X10fullScreen") then -- X10 X14
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
else -- mode 4
	if (Trimvalue3 ==0) then
		lcd.drawBitmap(75,213  ,Trim_C)	-- center trim Aileron
		elseif (Trimvalue3 > 0) then
		lcd.drawBitmap(75+ Trimvalue3/23,213  ,Trim_R)
		else
		lcd.drawBitmap(75+ Trimvalue3/23,213  ,Trim_L)
		end
	if (Trimvalue0 ==0) then
		lcd.drawBitmap(183,213  ,Trim_C)	-- center trim Rudder
		elseif (Trimvalue0 > 0) then
		lcd.drawBitmap(183+ Trimvalue0/23,213  ,Trim_R)
		else
		lcd.drawBitmap(183+ Trimvalue0/23,213  ,Trim_L)
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
	end
	end
end




--===================================================
-- Draw the Top Bar
--===================================================
local function draw_Top_Bar(Me)
	
	if  (screenSize == "X20fullScreen") then
	lcd.font(FONT_L)
	lcd.drawText(515,6,"RSSI")
	lcd.drawText(608,6,"Rxbatt")
	lcd.drawText(715,6,"TxBatt")
	
	lcd.font(FONT_L)
	--if RDT_RSSI1source ~= nil then RSSI1 = system.getSource (RDT_RSSI1source) 	else RSSI1 = nil end
				if RDT_RSSI1source ~= nil then 
				if RDT_RSSI1source_old ~= RDT_RSSI1source then
				RSSI1 = system.getSource (RDT_RSSI1source) 	
				RDT_RSSI1source_old = RDT_RSSI1source
				end
				else RSSI1 = nil end
		if (RSSI1 == nil) then
		lcd.font(FONT_S)
		lcd.drawText (515, 34, "No RSSI")
		lcd.font(FONT_L)
		else
		RSSI1Value = getSensorValue(RSSI1)
		lcd.drawNumber(515, 34, RSSI1Value,UNIT_DB, 0)
		end
		
	--if RDT_RSSI2source ~= nil then RSSI2 = system.getSource (RDT_RSSI2source) 	else RSSI2 = nil end
				if RDT_RSSI2source ~= nil then 
				if RDT_RSSI2source_old ~= RDT_RSSI2source then
				RSSI2 = system.getSource (RDT_RSSI2source) 	
				RDT_RSSI2source_old = RDT_RSSI2source
				end
				else RSSI2 = nil end
		if (RSSI2 == nil) then
		lcd.font(FONT_L)
		else
		RSSI2Value = getSensorValue(RSSI2)
		lcd.drawNumber(515, 59, RSSI2Value,UNIT_DB, 0)
		end
		
	--if RDT_RXbatt1source ~= nil then RXbatt1 = system.getSource (RDT_RXbatt1source) 	else RXbatt1 = nil end
				if RDT_RXbatt1source ~= nil then 
				if RDT_RXbatt1source_old ~= RDT_RXbatt1source then
				RXbatt1 = system.getSource (RDT_RXbatt1source) 	
				RDT_RXbatt1source_old = RDT_RXbatt1source
				end
				else RXbatt1 = nil end
		if (RXbatt1 == nil) then
		lcd.font(FONT_S)
		lcd.drawText (608, 34, "No RxBt")
		lcd.font(FONT_L)
		else
		RXbatt1Value = getSensorValue(RXbatt1)
		lcd.drawNumber(608, 34, RXbatt1Value,UNIT_VOLT, 1)
		end
		
	--if RDT_RXbatt2source ~= nil then RXbatt2 = system.getSource (RDT_RXbatt2source) 	else RXbatt2 = nil end
			if RDT_RXbatt2source ~= nil then 
				if RDT_RXbatt2source_old ~= RDT_RXbatt2source then
				RXbatt2 = system.getSource (RDT_RXbatt2source) 	
				RDT_RXbatt2source_old = RDT_RXbatt2source
				end
				else RXbatt2 = nil end
		if (RXbatt2 == nil) then
		-- do nothing
		lcd.font(FONT_L)
		else
		RXbatt2Value = getSensorValue(RXbatt2)
		lcd.drawNumber(608, 59, RXbatt2Value,UNIT_VOLT, 1)
		end		
		
		if (TxBatt == nil) then 
		lcd.font(FONT_S)
		lcd.drawText(716,34,"Err")
		lcd.font(FONT_L)
		else 
		TxBattValue = getSensorValue(TxBatt)
		lcd.drawNumber(716, 34, getSensorValue(TxBatt),UNIT_VOLT, 1)
		end
		
	--if RDT_pressuresource ~= nil then pressure = system.getSource (RDT_pressuresource) 	else pressure = nil end
		if RDT_pressuresource ~= nil then 
				if RDT_pressuresource_old ~= RDT_pressuresource then
				pressure = system.getSource (RDT_pressuresource) 	
				RDT_pressuresource_old = RDT_pressuresource
				end
		else pressure = nil end
		if (pressure == nil) then 
		--do nothing
		else 
		lcd.font(FONT_L)
		lcd.drawText(690,93,"Pressure:")
		pressureValue = getSensorValue(pressure)
		lcd.drawNumber(700, 120, getSensorValue(pressure),UNIT_PSI, 0)
		lcd.font(FONT_L)
		end
				
	elseif ((screenSize == "X10fullScreen") or (screenSize == "X18fullScreen")) then   -- X10 / X18        
	lcd.font(FONT_S)
	lcd.drawText(293,6,"RSSI")
	lcd.drawText(362,6,"Rxbatt")
	lcd.drawText(430,6,"TxBatt")
	lcd.font(FONT_S)
	--if RDT_RSSI1source ~= nil then RSSI1 = system.getSource (RDT_RSSI1source) 	else RSSI1 = nil end
				if RDT_RSSI1source ~= nil then 
				if RDT_RSSI1source_old ~= RDT_RSSI1source then
				RSSI1 = system.getSource (RDT_RSSI1source) 	
				RDT_RSSI1source_old = RDT_RSSI1source
				end
				else RSSI1 = nil end
		if (RSSI1 == nil) then
		lcd.font(FONT_S)
		lcd.drawText (293, 22, "No RSSI")
		lcd.font(FONT_S)
		else
		RSSI1Value = getSensorValue(RSSI1)
		lcd.drawNumber(305, 22, RSSI1Value,UNIT_DB, 0)
		end
		
	--if RDT_RSSI2source ~= nil then RSSI2 = system.getSource (RDT_RSSI2source) 	else RSSI2 = nil end
				if RDT_RSSI2source ~= nil then 
				if RDT_RSSI2source_old ~= RDT_RSSI2source then
				RSSI2 = system.getSource (RDT_RSSI2source) 	
				RDT_RSSI2source_old = RDT_RSSI2source
				end
				else RSSI2 = nil end
		if (RSSI2 == nil) then
		lcd.font(FONT_S)
		else
		RSSI2Value = getSensorValue(RSSI2)
		lcd.drawNumber(305, 35, RSSI2Value,UNIT_DB, 0)
		end
		
	--if RDT_RXbatt1source ~= nil then RXbatt1 = system.getSource (RDT_RXbatt1source) 	else RXbatt1 = nil end
				if RDT_RXbatt1source ~= nil then 
				if RDT_RXbatt1source_old ~= RDT_RXbatt1source then
				RXbatt1 = system.getSource (RDT_RXbatt1source) 	
				RDT_RXbatt1source_old = RDT_RXbatt1source
				end
				else RXbatt1 = nil end
		if (RXbatt1 == nil) then
		lcd.font(FONT_S)
		lcd.drawText (362, 22, "No RxBt")
		lcd.font(FONT_S)
		else
		RXbatt1Value = getSensorValue(RXbatt1)
		lcd.drawNumber(362, 22, RXbatt1Value,UNIT_VOLT, 1)
		end
		
	--if RDT_RXbatt2source ~= nil then RXbatt2 = system.getSource (RDT_RXbatt2source) 	else RXbatt2 = nil end
				if RDT_RXbatt2source ~= nil then 
				if RDT_RXbatt2source_old ~= RDT_RXbatt2source then
				RXbatt2 = system.getSource (RDT_RXbatt2source) 	
				RDT_RXbatt2source_old = RDT_RXbatt2source
				end
				else RXbatt2 = nil end
		if (RXbatt2 == nil) then
		-- do nothing
		lcd.font(FONT_S)
		else
		RXbatt2Value = getSensorValue(RXbatt2)
		lcd.drawNumber(362, 35, RXbatt2Value,UNIT_VOLT, 1)
		end
		if (TxBatt == nil) then 
		lcd.font(FONT_S)
		lcd.drawText(430,22,"Err")
		lcd.font(FONT_S)
		else 
		TxBattValue = getSensorValue(TxBatt)
		lcd.drawNumber(430, 22, getSensorValue(TxBatt),UNIT_VOLT, 1)
		end
		end
end

--===================================================
-- Draw Model Name
--===================================================
local function draw_RDT_model_path(Me)
lcd.font(FONT_XXL)
lcd.drawText(30,3,model.name())
end

--===================================================
-- Draw Model Image
--===================================================
local function draw_Model_Image(Me)
	if BigTimer_mdlimage ~= nil then
		if (screenSize == "X20fullScreen") then
		lcd.drawBitmap(78, 85, BigTimer_mdlimage) 
		elseif (screenSize == "X10fullScreen") then  -- X10         
		lcd.drawBitmap(47, 47, BigTimer_mdlimage) 
		elseif (screenSize == "X18fullScreen") then --X18
		lcd.drawBitmap(47, 47, BigTimer_mdlimage) 
	end
	end
end

--===================================================
-- Draw the Timer
--===================================================
local function draw_Timer(Me)
if screenSize == "X20fullScreen" then
	print("NewTimer name is ", Timersource)
	print("NewTimer is: ", Newtimer) -- this is a source
	print("NewTimer value is: ", Newtimer:value())

	print("Timer is ", Timer) -- this is a source
	print("Timer value is: ", Timer:value())
	
    if (getSensorValue(Timer) == nil) then
	lcd.drawBitmap(RDT_timer_x_x20,RDT_timer_y_x20,digits_blue[0])
	lcd.drawBitmap(RDT_timer_x_x20+80,RDT_timer_y_x20,digits_blue[0])
	lcd.drawBitmap(RDT_timer_x_x20+160,RDT_timer_y_x20,digits_blue[11])
	lcd.drawBitmap(RDT_timer_x_x20+192,RDT_timer_y_x20,digits_blue[0])
	lcd.drawBitmap(RDT_timer_x_x20+272,RDT_timer_y_x20,digits_blue[0])
	elseif (getSensorValue(Timer) > 0) and (getSensorValue(Timer) < 3600) then
	timer_Secs =  getSensorValue(Timer) % 60
	timer_Mins = ((getSensorValue(Timer) - timer_Secs) / 60)
	 TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	 TimerDigit2 = timer_Mins - (TimerDigit1*10) 
	 TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	 TimerDigit4 = timer_Secs - (TimerDigit3*10) 

	lcd.drawBitmap(RDT_timer_x_x20,RDT_timer_y_x20,digits_blue[TimerDigit1])
	lcd.drawBitmap(RDT_timer_x_x20+80,RDT_timer_y_x20,digits_blue[TimerDigit2])
	lcd.drawBitmap(RDT_timer_x_x20+160,RDT_timer_y_x20,digits_blue[11])
	lcd.drawBitmap(RDT_timer_x_x20+192,RDT_timer_y_x20,digits_blue[TimerDigit3])
	lcd.drawBitmap(RDT_timer_x_x20+272,RDT_timer_y_x20,digits_blue[TimerDigit4])
	elseif (getSensorValue(Timer) <= 0) and (getSensorValue(Timer) > -3599) then
	timer_Secs =  (getSensorValue(Timer) * (-1)) % 60
	timer_Mins =  ((getSensorValue(Timer)*(-1) - timer_Secs) / 60)
	 TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	 TimerDigit2 = timer_Mins - (TimerDigit1*10) 
	 TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	 TimerDigit4 = timer_Secs - (TimerDigit3*10) 
	 
	lcd.drawBitmap(RDT_timer_x_x20,RDT_timer_y_x20,digits_red[TimerDigit1])
	lcd.drawBitmap(RDT_timer_x_x20+80,RDT_timer_y_x20,digits_red[TimerDigit2])
	lcd.drawBitmap(RDT_timer_x_x20+160,RDT_timer_y_x20,digits_red[11])
	lcd.drawBitmap(RDT_timer_x_x20+192,RDT_timer_y_x20,digits_red[TimerDigit3])
	lcd.drawBitmap(RDT_timer_x_x20+272,RDT_timer_y_x20,digits_red[TimerDigit4])
	else
	lcd.drawBitmap(RDT_timer_x_x20,RDT_timer_y_x20,digits_blue[10])
	lcd.drawBitmap(RDT_timer_x_x20+80,RDT_timer_y_x20,digits_blue[10])
	lcd.drawBitmap(RDT_timer_x_x20+160,RDT_timer_y_x20,digits_blue[11])
	lcd.drawBitmap(RDT_timer_x_x20+192,RDT_timer_y_x20,digits_blue[10])
	lcd.drawBitmap(RDT_timer_x_x20+272,RDT_timer_y_x20,digits_blue[10])
	end
	
	elseif screenSize == "X10fullScreen" or screenSize == "X18fullScreen" then --X10 X18

    if (getSensorValue(Timer) == nil) then
	lcd.drawBitmap(RDT_timer_x_x18,RDT_timer_y_x18,digits_blue[0])
	lcd.drawBitmap(RDT_timer_x_x18+19,RDT_timer_y_x18,digits_blue[0])
	lcd.drawBitmap(RDT_timer_x_x18+36,RDT_timer_y_x18,digits_blue[11])
	lcd.drawBitmap(RDT_timer_x_x18+46,RDT_timer_y_x18,digits_blue[0])
	lcd.drawBitmap(RDT_timer_x_x18+64,RDT_timer_y_x18,digits_blue[0])
	elseif (getSensorValue(Timer) > 0) and (getSensorValue(Timer) < 3600) then
	timer_Secs =  getSensorValue(Timer) % 60
	timer_Mins = ((getSensorValue(Timer) - timer_Secs) / 60)
	 TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	 TimerDigit2 = timer_Mins - (TimerDigit1*10) 
	 TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	 TimerDigit4 = timer_Secs - (TimerDigit3*10) 

	lcd.drawBitmap(RDT_timer_x_x18,RDT_timer_y_x18,digits_blue[TimerDigit1])
	lcd.drawBitmap(RDT_timer_x_x18+19,RDT_timer_y_x18,digits_blue[TimerDigit2])
	lcd.drawBitmap(RDT_timer_x_x18+36,RDT_timer_y_x18,digits_blue[11])
	lcd.drawBitmap(RDT_timer_x_x18+46,RDT_timer_y_x18,digits_blue[TimerDigit3])
	lcd.drawBitmap(RDT_timer_x_x18+64,RDT_timer_y_x18,digits_blue[TimerDigit4])
	elseif (getSensorValue(Timer) <= 0) and (getSensorValue(Timer) > -3599) then
	timer_Secs =  (getSensorValue(Timer) * (-1)) % 60
	timer_Mins =  ((getSensorValue(Timer)*(-1) - timer_Secs) / 60)
	 TimerDigit1 = (timer_Mins - timer_Mins%10)/10
	 TimerDigit2 = timer_Mins - (TimerDigit1*10) 
	 TimerDigit3 = (timer_Secs - timer_Secs%10)/10
	 TimerDigit4 = timer_Secs - (TimerDigit3*10) 
	lcd.drawBitmap(RDT_timer_x_x18,RDT_timer_y_x18,digits_red[TimerDigit1])
	lcd.drawBitmap(RDT_timer_x_x18+19,RDT_timer_y_x18,digits_red[TimerDigit2])
	lcd.drawBitmap(RDT_timer_x_x18+36,RDT_timer_y_x18,digits_red[11])
	lcd.drawBitmap(RDT_timer_x_x18+46,RDT_timer_y_x18,digits_red[TimerDigit3])
	lcd.drawBitmap(RDT_timer_x_x18+64,RDT_timer_y_x18,digits_red[TimerDigit4])
	else
	lcd.drawBitmap(RDT_timer_x_x18,RDT_timer_y_x18,digits_blue[10])
	lcd.drawBitmap(RDT_timer_x_x18+19,RDT_timer_y_x18,digits_blue[10])
	lcd.drawBitmap(RDT_timer_x_x18+36,RDT_timer_y_x18,digits_blue[11])
	lcd.drawBitmap(RDT_timer_x_x18+46,RDT_timer_y_x18,digits_blue[10])
	lcd.drawBitmap(RDT_timer_x_x18+64,RDT_timer_y_x18,digits_blue[10])
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
	BigTimerbgroundCounter = 0
	end
	
	-- determine screen size
	if w2 == 800 and h2 == 480 then 
	screenSize = "X20fullScreen"
	elseif w2 == 480 and h2 == 272 then 
	screenSize = "X10fullScreen"
	elseif w2 == 480 and h2 == 320 then 
	screenSize = "X18fullScreen"
	elseif w2 == 640 and h2 == 360 then  -- X14
	screenSize = "X10fullScreen"
	else
	screenSize = "NotFullScreen"
	end

BigTimerbgroundCounter = BigTimerbgroundCounter+ 1

		if (screenSize == "X20fullScreen") then		
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
		lcd.drawBitmap(-51, 366,wallpaper_mask) lcd.drawBitmap(39, 366,wallpaper_mask) lcd.drawBitmap(129, 366, wallpaper_mask) lcd.drawBitmap(219, 366, wallpaper_mask) lcd.drawBitmap(309, 366, wallpaper_mask) lcd.drawBitmap(399, 366, wallpaper_mask) lcd.drawBitmap(489, 366, wallpaper_mask) lcd.drawBitmap(579, 366, wallpaper_mask) lcd.drawBitmap(669, 366, wallpaper_mask) lcd.drawBitmap(759, 366, wallpaper_mask) 
		--draw model image frame
		lcd.drawBitmap(77, 82,X20_image_frame)
		lcd.font(FONT_L)
		lcd.color(WHITE)
		--draw logos
		lcd.drawBitmap(585, 6, Batt_Icon)
		lcd.drawBitmap(695, 6, Batt_Icon)
		lcd.color(BLACK)
		lcd.drawFilledRectangle(697,17,10,30*Txbatt_percentage)
		--lcd.drawBitmap(465, 7, RSSI_Icon)
		lcd.drawBitmap(RDT_RSSI_icon_x_x20, RDT_RSSI_icon_y_x20, RSSI_Icon) -- 465,7
		-- paint RSSI bars grey according to RSSI value
		lcd.color(lcd.RGB(20, 20, 20))
		--lcd.color(WHITE)
		if (High_RSSI_Value > RSSI_0bar) and (High_RSSI_Value < RSSI_1bar) then -- cover all 5 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20,RDT_RSSI_icon_y_x20+25,8,14)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+8,RDT_RSSI_icon_y_x20+21,8,18)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+15,RDT_RSSI_icon_y_x20+17,8,22)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+23,RDT_RSSI_icon_y_x20+13,9,26)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+32,RDT_RSSI_icon_y_x20+9,8,30)
		elseif (High_RSSI_Value > RSSI_1bar) and (High_RSSI_Value <= RSSI_2bar) then -- cover 4 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+8,RDT_RSSI_icon_y_x20+21,8,18)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+15,RDT_RSSI_icon_y_x20+17,8,22)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+23,RDT_RSSI_icon_y_x20+13,9,26)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+32,RDT_RSSI_icon_y_x20+9,8,30)
		elseif (High_RSSI_Value > RSSI_2bar) and (High_RSSI_Value <= RSSI_3bar) then -- cover 3 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+15,RDT_RSSI_icon_y_x20+17,8,22)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+23,RDT_RSSI_icon_y_x20+13,9,26)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+32,RDT_RSSI_icon_y_x20+9,8,30)
		elseif (High_RSSI_Value > RSSI_3bar) and (High_RSSI_Value <= RSSI_4bar) then -- cover 2 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+23,RDT_RSSI_icon_y_x20+13,9,26)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+32,RDT_RSSI_icon_y_x20+9,8,30)
		elseif (High_RSSI_Value > RSSI_4bar) and (High_RSSI_Value <= RSSI_5bar) then -- cover 1 bar
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x20+32,RDT_RSSI_icon_y_x20+9,8,30)
		elseif (High_RSSI_Value > RSSI_5bar)  then -- max RSSI dont cover bars
		-- dont paint
		end
		lcd.drawBitmap(500, 343, Zavionix)
		--lcd.drawBitmap(523, 425, RDT_Text)
		lcd.color(WHITE)
		--lcd.drawText(610,432,RDT_ECU_Name)
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(67,382,146,9) -- T4
		lcd.drawText(35,380,"T4")
		lcd.drawFilledRectangle	(239,382,146,9) -- T1
		lcd.drawText(390,380,"T1")
		lcd.drawFilledRectangle	(386,158,9,146) -- T2  -- was 416
		lcd.drawText(380,315,"T2")
		lcd.drawFilledRectangle	(36,158,9,146) -- T3
		lcd.drawText(30,315,"T3")
		lcd.drawFilledRectangle	(428,158,9,146) -- Red Slider -- was 458
		-- draw trim line frames
		lcd.color(lcd.RGB(30, 30, 30)) -- trim  outline
		lcd.drawRectangle	(67,382,146,9,2) -- T4
		lcd.drawRectangle	(239,382,146,9,2) -- T1
		lcd.drawRectangle	(386,158,9,146,2) -- T2 -- was 416
		lcd.drawRectangle	(36,158,9,146,2) -- T3
		lcd.drawRectangle	(428,158,9,146,2) -- Red Slider -- was 458
		--draw Timer frame TBD
		--lcd.color(lcd.RGB(40, 40, 40)) --  dark grey
		--lcd.drawFilledRectangle	(529,92,145,58)
		lcd.color(WHITE)
				
		elseif (screenSize == "X10fullScreen") then
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
		--model image is at 47,47
		lcd.drawBitmap(45, 42,X18_image_frame)
		--draw logos
		lcd.drawBitmap(320, 200, Double_Battery_Zavionix)
		lcd.drawBitmap(330, 243, RDT_Text)
		--lcd.drawBitmap(265, 7, RSSI_Icon)
		lcd.drawBitmap(RDT_RSSI_icon_x_x10, RDT_RSSI_icon_y_x10, RSSI_Icon) -- 265,7
		-- paint RSSI bars grey according to RSSI value
		lcd.color(lcd.RGB(20, 20, 20))
		--lcd.color(GREEN)
		if (High_RSSI_Value > RSSI_0bar) and (High_RSSI_Value < RSSI_1bar) then -- cover all 5 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10,RDT_RSSI_icon_y_x10+16,4,4)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+4,RDT_RSSI_icon_y_x10+12,5,8)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+8,RDT_RSSI_icon_y_x10+8,5,12)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+12,RDT_RSSI_icon_y_x10+4,6,16)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_1bar) and (High_RSSI_Value <= RSSI_2bar) then -- cover 4 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+4,RDT_RSSI_icon_y_x10+12,5,8)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+8,RDT_RSSI_icon_y_x10+8,5,12)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+12,RDT_RSSI_icon_y_x10+4,6,16)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_2bar) and (High_RSSI_Value <= RSSI_3bar) then -- cover 3 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+8,RDT_RSSI_icon_y_x10+8,5,12)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+12,RDT_RSSI_icon_y_x10+4,6,16)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_3bar) and (High_RSSI_Value <= RSSI_4bar) then -- cover 2 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+12,RDT_RSSI_icon_y_x10+4,6,16)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_4bar) and (High_RSSI_Value <= RSSI_5bar) then -- cover 1 bar
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_5bar)  then -- max RSSI dont cover bars
		-- dont paint
		end
		lcd.drawBitmap(350, 6, Batt_Icon)
		lcd.drawBitmap(420, 6, Batt_Icon)
		lcd.color(BLACK)
		lcd.drawFilledRectangle(421,13,6,17*Txbatt_percentage)
		lcd.font(FONT_M)
		lcd.color(WHITE)
		--lcd.drawText(383,250,RDT_ECU_Name)
		lcd.font(FONT_L)
		lcd.color(WHITE)
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(35,217,90,4) -- T4
		lcd.drawText(10,213,"T4")
		lcd.drawFilledRectangle	(145,217,90,4) -- T1
		lcd.drawText(245,213,"T1")
		lcd.drawFilledRectangle	(250,87,4,90) -- T2
		lcd.drawText(246,185,"T2")
		lcd.drawFilledRectangle	(22,87,4,90) -- T3
		lcd.drawText(15,185,"T3")
		-- draw trim line frames
		lcd.color(lcd.RGB(30, 30, 30)) -- trim  outline
		lcd.drawRectangle	(35,217,90,4,1) -- T4
		lcd.drawRectangle	(145,217,90,4,1) -- T1
		lcd.drawRectangle	(250,87,4,90,1) -- T2
		lcd.drawRectangle	(22,87,4,90,1) -- T3
		--draw Timer frame
		--lcd.color(lcd.RGB(40, 40, 40))
		--lcd.drawFilledRectangle	(318,50,86,37,1)
		lcd.color(WHITE)
		
		elseif (screenSize == "X18fullScreen") then
		lcd.drawBitmap(0, 0, wallpaper_mask)  lcd.drawBitmap(89, 0, wallpaper_mask)   lcd.drawBitmap(179, 0, wallpaper_mask)  lcd.drawBitmap(269, 0, wallpaper_mask)   lcd.drawBitmap(359, 0, wallpaper_mask)   lcd.drawBitmap(449, 0, wallpaper_mask)   lcd.drawBitmap(539, 0, wallpaper_mask)   lcd.drawBitmap(629, 0, wallpaper_mask) lcd.drawBitmap(719, 0, wallpaper_mask)
		lcd.drawBitmap(-77, 122,wallpaper_mask)lcd.drawBitmap(13, 122,wallpaper_mask) lcd.drawBitmap(103, 122, wallpaper_mask) lcd.drawBitmap(193, 122, wallpaper_mask) lcd.drawBitmap(283, 122, wallpaper_mask) lcd.drawBitmap(373, 122, wallpaper_mask) lcd.drawBitmap(463, 122, wallpaper_mask) lcd.drawBitmap(553, 122, wallpaper_mask) lcd.drawBitmap(643, 122, wallpaper_mask) lcd.drawBitmap(733, 122, wallpaper_mask)
		lcd.drawBitmap(-64, 244,wallpaper_mask) lcd.drawBitmap(26, 244,wallpaper_mask) lcd.drawBitmap(116, 244, wallpaper_mask) lcd.drawBitmap(206, 244, wallpaper_mask) lcd.drawBitmap(296, 244, wallpaper_mask) lcd.drawBitmap(386, 244, wallpaper_mask) lcd.drawBitmap(476, 244, wallpaper_mask) lcd.drawBitmap(566, 244, wallpaper_mask) lcd.drawBitmap(656, 244, wallpaper_mask) lcd.drawBitmap(746, 244, wallpaper_mask)
		--model image is at 47,47
		lcd.drawBitmap(45, 42,X18_image_frame)
		--draw logos
		lcd.drawBitmap(320, 220, Double_Battery_Zavionix)
		lcd.drawBitmap(320, 275, RDT_Text)
		--lcd.drawBitmap(265, 7, RSSI_Icon)
		lcd.drawBitmap(RDT_RSSI_icon_x_x10, RDT_RSSI_icon_y_x10, RSSI_Icon) -- 275,7
		-- paint RSSI bars grey according to RSSI value
		lcd.color(lcd.RGB(20, 20, 20))
		--lcd.color(GREEN)
		if (High_RSSI_Value > RSSI_0bar) and (High_RSSI_Value < RSSI_1bar) then -- cover all 5 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10,RDT_RSSI_icon_y_x10+16,4,4)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+4,RDT_RSSI_icon_y_x10+12,5,8)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+8,RDT_RSSI_icon_y_x10+8,5,12)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+12,RDT_RSSI_icon_y_x10+4,6,16)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_1bar) and (High_RSSI_Value <= RSSI_2bar) then -- cover 4 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+4,RDT_RSSI_icon_y_x10+12,5,8)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+8,RDT_RSSI_icon_y_x10+8,5,12)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+12,RDT_RSSI_icon_y_x10+4,6,16)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_2bar) and (High_RSSI_Value <= RSSI_3bar) then -- cover 3 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+8,RDT_RSSI_icon_y_x10+8,5,12)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+12,RDT_RSSI_icon_y_x10+4,6,16)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_3bar) and (High_RSSI_Value <= RSSI_4bar) then -- cover 2 bars
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+12,RDT_RSSI_icon_y_x10+4,6,16)
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_4bar) and (High_RSSI_Value <= RSSI_5bar) then -- cover 1 bar
		lcd.drawFilledRectangle(RDT_RSSI_icon_x_x10+18,RDT_RSSI_icon_y_x10+0,4,20)
		elseif (High_RSSI_Value > RSSI_5bar)  then -- max RSSI dont cover bars
		-- dont paint
		end
		lcd.drawBitmap(350, 6, Batt_Icon)
		lcd.drawBitmap(420, 6, Batt_Icon)
		lcd.color(BLACK)
		lcd.drawFilledRectangle(421,13,6,17*Txbatt_percentage)
		lcd.font(FONT_M)
		lcd.color(WHITE)
		--lcd.drawText(373,280,RDT_ECU_Name)
		lcd.font(FONT_L)
		lcd.color(WHITE)
		-- draw trim lines
		lcd.color(lcd.RGB(255, 255, 255)) -- photo frame shade
		lcd.font(FONT_S)
		lcd.drawFilledRectangle	(35,217,90,4) -- T4
		lcd.drawText(10,213,"T4")
		lcd.drawFilledRectangle	(145,217,90,4) -- T1
		lcd.drawText(245,213,"T1")
		lcd.drawFilledRectangle	(250,87,4,90) -- T2
		lcd.drawText(246,185,"T2")
		lcd.drawFilledRectangle	(22,87,4,90) -- T3
		lcd.drawText(15,185,"T3")
		lcd.drawFilledRectangle	(35,289,90,4,1) -- T6
		lcd.drawText(10,285,"T6")
		lcd.drawFilledRectangle	(145,289,90,4,1) -- T5
		lcd.drawText(245,285,"T5")
		-- draw trim line frames
		lcd.color(lcd.RGB(30, 30, 30)) -- trim  outline
		lcd.drawRectangle	(35,217,90,4,1) -- T4
		lcd.drawRectangle	(145,217,90,4,1) -- T1
		lcd.drawRectangle	(250,87,4,90,1) -- T2
		lcd.drawRectangle	(22,87,4,90,1) -- T3
		lcd.drawRectangle	(35,289,90,4,1) -- T6
		lcd.drawRectangle	(145,289,90,4,1) -- T5
		--draw Timer frame
		lcd.color(lcd.RGB(40, 40, 40))
		lcd.drawFilledRectangle	(318,50,86,37,1)
		lcd.color(WHITE)
		else
		-- "NotFullScreen" -- do nothing
		end
end


local function create()
	-- check radio type and version
    print(system:getVersion().board) -- gives ~ X10EXPRESS
    print(system:getVersion().version) --gives ~ 1.5.12
	-- Getsource for hardware analogs and Timer
	if (Trim0 == nil) then Trim0 = system.getSource({category=CATEGORY_TRIM, member=0, options=0}) end -- rudder trim 
	if (Trim1 == nil) then Trim1 = system.getSource({category=CATEGORY_TRIM, member=1, options=0}) end -- elevator trim
	if (Trim2 == nil) then Trim2 = system.getSource({category=CATEGORY_TRIM, member=2, options=0}) end -- throttle trim
	if (Trim3 == nil) then Trim3 = system.getSource({category=CATEGORY_TRIM, member=3, options=0}) end -- aileron trim
	if (Trim4 == nil) then Trim4 = system.getSource({category=CATEGORY_TRIM, member=4, options=0}) end -- throttle trim
	if (Trim5 == nil) then Trim5 = system.getSource({category=CATEGORY_TRIM, member=5, options=0}) end -- aileron trim
	if (Analog6 == nil) then Analog6 = system.getSource({category=CATEGORY_ANALOG, member=ANALOG_FIRST_SLIDER, options=0}) end -- red slider
	if (AnalogThrottle == nil) then AnalogThrottle = system.getSource({category=CATEGORY_ANALOG, member=2, options=0}) end -- throttle stick 
	if (Timer == nil) then Timer = system.getSource({category=CATEGORY_TIMER, member=0, options=0}) end -- Timer 1 -- LZ
	if (Newtimer == nil) then Newtimer = system.getSource(Timersource) end -- Timer source
	if (TxBatt == nil) then TxBatt = system.getSource({category=CATEGORY_SYSTEM, member=MAIN_VOLTAGE}) end

	-- Fuel Percentage Sensor
  if system.getSource("RDT Fuel %")== nil then
				  sensor = model.createSensor()
				  sensor:name("RDT Fuel %")
				  sensor:unit(UNIT_PERCENT)
				  sensor:decimals(0)
				  sensor:appId(0x0111)
				  sensor:physId(0x20)
				  sensor:value(100)         
	end       
	RDT_fuel_percentage_sensor = system.getSource("RDT Fuel %")
			
if (screenSize == nil) then
	Screen_width = system:getVersion().lcdWidth
	Screen_height = system:getVersion().lcdHeight
	-- determine screen size
	if Screen_width == 800 and Screen_height == 480 then 
	screenSize = "X20fullScreen"
	elseif Screen_width == 480 and Screen_height == 272 then 
	screenSize = "X10fullScreen"
	elseif Screen_width == 480 and Screen_height == 320 then 
	screenSize = "X18fullScreen"
	elseif Screen_width == 640 and Screen_height == 360 then  -- X14
	screenSize = "X10fullScreen"
	else
	screenSize = "NotFullScreen"
	end
end
	
		 if (Trim_C == nil) then Trim_C = lcd.loadBitmap(imagePath.."/trim-c.png") end
		 if (Trim_U == nil) then Trim_U = lcd.loadBitmap(imagePath.."/trim-u.png") end
		 if (Trim_D == nil) then Trim_D = lcd.loadBitmap(imagePath.."/trim-d.png") end
		 if (Trim_L == nil) then Trim_L = lcd.loadBitmap(imagePath.."/trim-l.png") end
		 if (Trim_R == nil) then Trim_R = lcd.loadBitmap(imagePath.."/trim-r.png") end
		 if (Trim_Red == nil) then Trim_Red = lcd.loadBitmap(imagePath.."/trimRed.png") end
		 if (Trim_Green == nil) then Trim_Green = lcd.loadBitmap(imagePath.."/trimGreen.png") end
	if (screenSize == "X20fullScreen") then
		if (wallpaper_mask == nil) then wallpaper_mask = lcd.loadBitmap(imagePath.."/wallpaper_mask.png") end
		--if (wallpaper_mask == nil) then wallpaper_mask = lcd.loadBitmap("img/wallpaper_mask.png") end
		if (X20_image_frame == nil) then X20_image_frame = lcd.loadBitmap(imagePath.."/X20_image_frame.png") end
		if (Zavionix == nil) then Zavionix = lcd.loadBitmap(imagePath.."/Zavionix.png") end
		if (Batt_Icon == nil) then Batt_Icon = lcd.loadBitmap(imagePath.."/Batt.png") end
		if (RSSI_Icon == nil) then RSSI_Icon = lcd.loadBitmap(imagePath.."/RSSI.png") end
		if (RDT_Text == nil) then RDT_Text = lcd.loadBitmap(imagePath.."/RDT.png") end
	elseif (screenSize == "X10fullScreen") then
		if (wallpaper_mask == nil) then wallpaper_mask = lcd.loadBitmap(imagePath.."/wallpaper_mask.png") end
		if (X18_image_frame == nil) then X18_image_frame = lcd.loadBitmap(imagePath.."/X18_image_frame.png") end
		if (Double_Battery_Zavionix == nil) then Double_Battery_Zavionix = lcd.loadBitmap(imagePath.."/Zavionix_30.png") end
		if (Batt_Icon == nil) then Batt_Icon = lcd.loadBitmap(imagePath.."/Batt_30.png") end
		if (RSSI_Icon == nil) then RSSI_Icon = lcd.loadBitmap(imagePath.."/RSSI_30.png") end	
		if (RDT_Text == nil) then RDT_Text = lcd.loadBitmap(imagePath.."/RDT_30.png") end
	elseif (screenSize == "X18fullScreen") then	
		if (wallpaper_mask == nil) then wallpaper_mask = lcd.loadBitmap(imagePath.."/wallpaper_mask.png") end
		if (X18_image_frame == nil) then X18_image_frame = lcd.loadBitmap(imagePath.."/X18_image_frame.png") end
		if (Double_Battery_Zavionix == nil) then Double_Battery_Zavionix = lcd.loadBitmap(imagePath.."/Zavionix_30.png") end
		if (Batt_Icon == nil) then Batt_Icon = lcd.loadBitmap(imagePath.."/Batt_30.png") end
		if (RSSI_Icon == nil) then RSSI_Icon = lcd.loadBitmap(imagePath.."/RSSI_30.png") end	
		if (RDT_Text == nil) then RDT_Text = lcd.loadBitmap(imagePath.."/RDT_30.png") end
	else -- any other screen size
	-- do nothing
	end


if (screenSize == "X20fullScreen") then
if (digits_blue == nil) then digits_blue =
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
	} end
if (digits_red == nil) then digits_red =
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
	} end
    
end 


if (screenSize == "X18fullScreen" or screenSize == "X10fullScreen") then
if (digits_blue == nil) then digits_blue =
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
	} end
if (digits_red == nil) then digits_red =
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
	} end
    
end 
	
    return {r=255,
			g=255, 
			b=255, 
			OnOff=false, 
			source=nil, 
			min=-1024, 
			max=1024, 
			value=0,
			FuelTankSize = 3000, 
			EngineCutRPM = 500,
			FuelLowCycleTime=5, 
			EngineCutCycleTime = 5,
			FuelAlertOnOff = true,
			EngineCutAlertOnOff = false,
			StickMode = 2, 
}
end

local function wakeup(widget)
			newValue = os.clock() 
			if newValue > Time_Temp + 1 / paint_rate_Hz then -- do every X hz
			-- check if a model memory was changed
			if model_path ~= (model.path()) then 
			-- Zero out source names 
			Timersource_old = ''
			print("Sensor sources zeroed")
			BigTimer_mdlimage = lcd.loadBitmap(model.bitmap())  -- Load model Image from memory
			model_path = (model.path())
			BigTimer_cycleCounter = 0
			end
			-- Read widget menus
			
			if widget.Timersource ~= nil then Timersource   = widget.Timersource:name () end

		--Calculate Tx battery percentae
		Txbatt_percentage = 1 - (getSensorValue(TxBatt) - Txbatt_min) / (Txbatt_max - Txbatt_min)
				Time_Temp = newValue 
				--if (RDTDone_Painting == true) then print("Done painting True ") else print("Done painting FALSE ") end
				--if RDTDone_Painting then 
				lcd.invalidate() 
				--RDTDone_Painting = false 
				--end
			end 
	BigTimer_cycleCounter = BigTimer_cycleCounter + 1	
end

local function paint(widget)

	--[[
	local mem = {}
	mem = system.getMemoryUsage()
	print("Main Stack: "..mem["mainStackAvailable"])
	print("RAM Avail: "..mem["ramAvailable"])
	print("LUA RAM Avail: "..mem["luaRamAvailable"])
	print("LUA BMP Avail: "..mem["luaBitmapsRamAvailable"])
	print("=========================")
	print(os.clock())
	]]--
	
	--initECU_Status(Me)
	draw_background(Me)
	draw_Top_Bar(Me)
	draw_RDT_model_path(Me)
	if BigTimer_cycleCounter >= 0 then draw_Model_Image(Me)end
	if BigTimer_cycleCounter >= 0 then 
	draw_Trims(Me)	
	--draw_Turbine_Data(Me) 
	--draw_Status(Me)
	draw_Timer(Me) 
	end
	--RDTDone_Painting = true 
end

local function configure(widget)
	line = form.addLine("Zavionix BigTimer Version ".. BigTimerversion)
	-- Sensor Source configuration
	line = form.addLine("Timer Configuration:")
    line = form.addLine("Timer Selection")
    form.addSourceField(line, nil, function() return widget.Timersource end, function(value) widget.Timersource = value end)
end

local function read(widget)
	widget.Timersource	    = storage.read ("Timersource")
end

local function write(widget)
	storage.write("Timersource"		, widget.Timersource)
end

local function init()
system.registerWidget({key="lzbtmr", name="Zavionix BigTimer", create=create, paint=paint, configure=configure, read=read, write=write, wakeup=wakeup, title = false})
Init = false
end

return {init=init}
