-- ********************************************************************************
-- **  Zavionix® LZCells Widget Screen (LZ-Cells)                                **
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
local CellsVersion = "V1.0.15"
local CellsLowBattSound = "/scripts/Cells/LowBat.wav" -- audio file for batt alert, change as neccessary 
local CellsLowCellSound = "/scripts/Cells/LowCel.wav" -- audio file for cell alert, change as neccessary 
local count = 0
local Time_Temp = 0
local FontSize = 0
local BattAlertOnOff = 0
local LowBattAlert = 0
local LowCellAlert = 0
local LowBattCycleTime  = 0
local count = 0
local NumOfCells = 0
local LipoPackVoltage = 0
local CellsDone_Painting = 0
local LipoSensorSource = 0
local factor = 100
local Batt1_color
local Batt2_color
local Batt3_color
local Batt4_color
local Batt5_color
local Batt6_color
local Pack_color 
local paint_rate_Hz = 3  -- paint every X hz
--local invalidateme = 0

local function create()
    return {r=255,
            g=255,
            b=255,
            OnOff=false,
            source=nil,
            min=-1024,
            max=1024,
            value=0,
            Batt1Capacity = 3000,
            Batt2Capacity = 3000,
            LowBattCycleTime=5,
            BattAlertOnOff = true,
            LowBattAlert = 100,
			CellAlertOnOff = false,
			LowCellAlert = 350,
            LipoSensor = nil,
            Cell1 = nil,
            Cell2 = nil,
            Cell3 = nil,
            Cell4 = nil,
            Cell5 = nil,
            Cell6 = nil,
            Rxbattsource = nil,
            FontSize = 3,
            Cell1Voltage = 0,
            Cell2Voltage = 0,
            Cell3Voltage = 0,
            Cell4Voltage = 0,
            Cell5Voltage = 0,
            Cell6Voltage = 0,
            battery_alert = false,
            }
end


--===================================================
-- Draw Battery Data
--===================================================
local function draw_Battery_Data(widget)
count = count + 1
  
	local screen_width, screen_height = lcd.getWindowSize()
	local Screen_gap = screen_width / 20
	local cell_width = screen_width* 0.265
	local cell_height = screen_height*0.20
	local screen_height_for_print = screen_height
	local screen_width_for_print = screen_width
	local Cell_Percentage1
	local Cell_Percentage2
	local Cell_Percentage3
	local Cell_Percentage4
	local Cell_Percentage5
	local Cell_Percentage6
	local Lipo_Percentage
  
  local batt_color = 
	{
		[0]  = lcd.RGB(210,9,9),
		[1]  = lcd.RGB(210,9,9),
		[2]  = lcd.RGB(210,9,9),
		[3]  = lcd.RGB(211,98,0),
		[4]  = lcd.RGB(211,98,0),
		[5]  = lcd.RGB(248,203,0),
		[6]  = lcd.RGB(248,203,0),
		[7]  = lcd.RGB(138,183,0),
		[8]  = lcd.RGB(138,183,0),
		[9]  = lcd.RGB(23, 207, 20),
		[10] = lcd.RGB(23, 207, 20)
	}

	local myArrayPercentList = { { 3, 0 }, { 3.093, 1 }, { 3.196, 2 }, { 3.301, 3 }, { 3.401, 4 }, { 3.477, 5 }, { 3.544, 6 }, { 3.601, 7 }, { 3.637, 8 }, { 3.664, 9 }, { 3.679, 10 }, { 3.683, 11 }, { 3.689, 12 }, { 3.692, 13 }, { 3.705, 14 }, { 3.71, 15 }, { 3.713, 16 }, { 3.715, 17 }, { 3.72, 18 }, { 3.731, 19 }, { 3.735, 20 }, { 3.744, 21 }, { 3.753, 22 }, { 3.756, 23 }, { 3.758, 24 }, { 3.762, 25 }, { 3.767, 26 }, { 3.774, 27 }, { 3.78, 28 }, { 3.783, 29 }, { 3.786, 30 }, { 3.789, 31 }, { 3.794, 32 }, { 3.797, 33 }, { 3.8, 34 }, { 3.802, 35 }, { 3.805, 36 }, { 3.808, 37 }, { 3.811, 38 }, { 3.815, 39 }, { 3.818, 40 }, { 3.822, 41 }, { 3.825, 42 }, { 3.829, 43 }, { 3.833, 44 }, { 3.836, 45 }, { 3.84, 46 }, { 3.843, 47 }, { 3.847, 48 }, { 3.85, 49 }, { 3.854, 50 }, { 3.857, 51 }, { 3.86, 52 }, { 3.863, 53 }, { 3.866, 54 }, { 3.87, 55 }, { 3.874, 56 }, { 3.879, 57 }, { 3.888, 58 }, { 3.893, 59 }, { 3.897, 60 }, { 3.902, 61 }, { 3.906, 62 }, { 3.911, 63 }, { 3.918, 64 }, { 3.923, 65 }, { 3.928, 66 }, { 3.939, 67 }, { 3.943, 68 }, { 3.949, 69 }, { 3.955, 70 }, { 3.961, 71 }, { 3.968, 72 }, { 3.974, 73 }, { 3.981, 74 }, { 3.987, 75 }, { 3.994, 76 }, { 4.001, 77 }, { 4.007, 78 }, { 4.014, 79 }, { 4.021, 80 }, { 4.029, 81 }, { 4.036, 82 }, { 4.044, 83 }, { 4.052, 84 }, { 4.062, 85 }, { 4.074, 86 }, { 4.085, 87 }, { 4.095, 88 }, { 4.105, 89 }, { 4.111, 90 }, { 4.116, 91 }, { 4.12, 92 }, { 4.125, 93 }, { 4.129, 94 }, { 4.135, 95 }, { 4.145, 96 }, { 4.176, 97 }, { 4.179, 98 }, { 4.193, 99 }, { 4.2, 100 }} 

	lcd.color(BLACK)
	lcd.drawFilledRectangle	(0,0,screen_width,screen_height,1)

if NumOfCells > 0 then
	for i, v in ipairs(myArrayPercentList) do
		  --if v[1] >= widget.Cell1Voltage then
		  if v[1] >= Cell1Voltage then
		  Cell_Percentage1 = v[2]
		  break
		  end
	end
	for i, v in ipairs(myArrayPercentList) do
		  if v[1] >= Cell2Voltage then
		  Cell_Percentage2 = v[2]
		  break
		  end
	end
	for i, v in ipairs(myArrayPercentList) do
		  if v[1] >= Cell3Voltage then
		  Cell_Percentage3 = v[2]
		  break
		  end
	end
	for i, v in ipairs(myArrayPercentList) do
		  if v[1] >= Cell4Voltage then
		  Cell_Percentage4 = v[2]
		  break
		  end
	end
	for i, v in ipairs(myArrayPercentList) do
		  if v[1] >= Cell5Voltage then
		  Cell_Percentage5 = v[2]
		  break
		  end
	end
	for i, v in ipairs(myArrayPercentList) do
		  if v[1] >= Cell6Voltage then
		  Cell_Percentage6 = v[2]
		  break
		  end
	end
	
	for i, v in ipairs(myArrayPercentList) do
		  if v[1] * NumOfCells  >= LipoPackVoltage then
		  Lipo_Percentage = v[2]
		  break
		  end
	end
	
	if LipoPackVoltage >= 4.2 * NumOfCells then
	Lipo_Percentage = 100
	elseif LipoPackVoltage <= 3.0 * NumOfCells then
	Lipo_Percentage = 0
	end	

	-- DEBUG
	--[[
	factor = factor -1
	if factor <1 then factor = 100 end
	Lipo_Percentage = 100 * factor * 0.01 
	LipoPackVoltage = 25.2 * factor * 0.01
	Cell1Voltage = 4.2* factor * 0.01
	Cell2Voltage = 4.1* factor * 0.01
	Cell3Voltage = 4.0* factor * 0.01
	Cell4Voltage = 3.9* factor * 0.01
	Cell5Voltage = 3.8* factor * 0.01
	Cell6Voltage = 3.7* factor * 0.01
	Cell_Percentage1 = 100* factor * 0.01
	Cell_Percentage2 = 100* factor * 0.01
	Cell_Percentage3 = 100* factor * 0.01
	Cell_Percentage4 = 100* factor * 0.01
	Cell_Percentage5 = 100* factor * 0.01
	Cell_Percentage6 = 100* factor * 0.01
	--]]
	
	if (Cell1Voltage < 3) then Batt1_color = 0 else Batt1_color = math.floor((1.2 - (4.2 - Cell1Voltage)) * 8.34) end
	if (Cell2Voltage < 3) then Batt2_color = 0 else Batt2_color = math.floor((1.2 - (4.2 - Cell2Voltage)) * 8.34) end
	if (Cell3Voltage < 3) then Batt3_color = 0 else Batt3_color = math.floor((1.2 - (4.2 - Cell3Voltage)) * 8.34) end
	if (Cell4Voltage < 3) then Batt4_color = 0 else Batt4_color = math.floor((1.2 - (4.2 - Cell4Voltage)) * 8.34) end
	if (Cell5Voltage < 3) then Batt5_color = 0 else Batt5_color = math.floor((1.2 - (4.2 - Cell5Voltage)) * 8.34) end
	if (Cell6Voltage < 3) then Batt6_color = 0 else Batt6_color = math.floor((1.2 - (4.2 - Cell6Voltage)) * 8.34) end
	Pack_color  = math.floor((1.2 - (4.2 * NumOfCells - LipoPackVoltage)/NumOfCells) * 8.34)

	-- draw cell backgrounds
	lcd.color(lcd.RGB(141,144,200,0.2)) --transparent light bluish grey
	if NumOfCells > 0 then lcd.drawFilledRectangle	(Screen_gap,screen_height_for_print*0.50,cell_width,cell_height,1) end
	if NumOfCells > 1 then lcd.drawFilledRectangle	(2*Screen_gap+ cell_width ,screen_height_for_print*0.50,cell_width,cell_height,1) end
	if NumOfCells > 2 then lcd.drawFilledRectangle	(3*Screen_gap+ 2*cell_width ,screen_height_for_print*0.50,cell_width,cell_height,1) end
	if NumOfCells > 3 then lcd.drawFilledRectangle	(Screen_gap,screen_height_for_print*0.72,cell_width,cell_height,1) end
	if NumOfCells > 4 then lcd.drawFilledRectangle	(2*Screen_gap+ cell_width ,screen_height_for_print*0.72,cell_width,cell_height,1) end
	if NumOfCells > 5 then lcd.drawFilledRectangle	(3*Screen_gap+ 2*cell_width ,screen_height_for_print*0.72,cell_width,cell_height,1) end
	lcd.drawFilledRectangle	(Screen_gap,screen_height_for_print*0.10,screen_width_for_print * 0.60, screen_height_for_print*0.35,1)
	
	-- first row
	lcd.color(batt_color[Batt1_color])
	if NumOfCells > 0 then
	lcd.drawFilledRectangle	(Screen_gap,screen_height_for_print*0.50,cell_width * Cell_Percentage1 * 0.01,cell_height,1)
	end
	lcd.color(batt_color[Batt2_color])
	if NumOfCells > 1 then
	lcd.drawFilledRectangle	(2*Screen_gap+ cell_width ,screen_height_for_print*0.50,cell_width * Cell_Percentage2 * 0.01,cell_height,1)
	end
	lcd.color(batt_color[Batt3_color])
	if NumOfCells > 2 then
	lcd.drawFilledRectangle	(3*Screen_gap+ 2*cell_width ,screen_height_for_print*0.50,cell_width * Cell_Percentage3 * 0.01,cell_height,1)
	end
	-- second row
	lcd.color(batt_color[Batt4_color])
	if NumOfCells > 3 then
	lcd.drawFilledRectangle	(Screen_gap,screen_height_for_print*0.72,cell_width * Cell_Percentage4 * 0.01,cell_height,1)
	end
	lcd.color(batt_color[Batt5_color])
	if NumOfCells > 4 then
	lcd.drawFilledRectangle	(2*Screen_gap+ cell_width ,screen_height_for_print*0.72,cell_width * Cell_Percentage5 * 0.01,cell_height,1)
	end
	lcd.color(batt_color[Batt6_color])
	if NumOfCells > 5 then
	lcd.drawFilledRectangle	(3*Screen_gap+ 2*cell_width ,screen_height_for_print*0.72,cell_width * Cell_Percentage6 * 0.01,cell_height,1)
	end
	lcd.color(batt_color[Pack_color])
	lcd.drawFilledRectangle	(Screen_gap,screen_height_for_print*0.10,screen_width_for_print * 0.60 * Lipo_Percentage * 0.01, screen_height_for_print*0.35,1)

	-- top row
	if BattAlertOnOff == true and LipoPackVoltage < LowBattAlert / 10 then lcd.color(RED) else lcd.color(lcd.RGB(128,128,128)) end -- top battery frame
	lcd.drawRectangle	(Screen_gap,screen_height_for_print*0.10,screen_width_for_print * 0.60, screen_height_for_print*0.35,screen_height/70)
	--lcd.color(lcd.RGB(128,128,128))
	lcd.drawFilledRectangle	(Screen_gap+screen_width_for_print * 0.60 ,screen_height_for_print*0.19,cell_width * 0.10,cell_height*0.8,1)	
	-- row 1
	if NumOfCells > 0 then 
	if (LowCellAlert > 0 and Cell1Voltage < LowCellAlert / 100 and CellAlertOnOff == true) then lcd.color(RED) else lcd.color(lcd.RGB(128,128,128)) end
	lcd.drawRectangle(Screen_gap,screen_height_for_print*0.50,cell_width,cell_height,screen_height/70)
	lcd.drawFilledRectangle	(Screen_gap+cell_width,screen_height_for_print*0.50 + cell_height * 0.25,cell_width * 0.05,cell_height*0.5,1)
	lcd.color(lcd.RGB(128,128,128))
	end
	if NumOfCells > 1 then
	if (LowCellAlert > 0 and Cell2Voltage < LowCellAlert / 100 and CellAlertOnOff == true) then lcd.color(RED) else lcd.color(lcd.RGB(128,128,128)) end
	lcd.drawRectangle(2*Screen_gap+ cell_width ,screen_height_for_print*0.50,cell_width,cell_height,screen_height/70) 
	lcd.drawFilledRectangle	(2*Screen_gap+2*cell_width,screen_height_for_print*0.50 + cell_height * 0.25,cell_width * 0.05,cell_height*0.5,1)
	lcd.color(lcd.RGB(128,128,128))
	end
	if NumOfCells > 2 then 
	if (LowCellAlert > 0 and Cell3Voltage < LowCellAlert / 100 and CellAlertOnOff == true) then lcd.color(RED) else lcd.color(lcd.RGB(128,128,128)) end
	lcd.drawRectangle(3*Screen_gap+ 2*cell_width ,screen_height_for_print*0.50,cell_width,cell_height,screen_height/70) 
	lcd.drawFilledRectangle	(3*Screen_gap+ 3*cell_width,screen_height_for_print*0.50 + cell_height * 0.25,cell_width * 0.05,cell_height*0.5,1)
	lcd.color(lcd.RGB(128,128,128))
	end
	-- row 2
	if NumOfCells > 3 then
	if (LowCellAlert > 0 and Cell4Voltage < LowCellAlert / 100 and CellAlertOnOff == true) then lcd.color(RED) else lcd.color(lcd.RGB(128,128,128)) end
	lcd.drawRectangle(Screen_gap,screen_height_for_print*0.72,cell_width,cell_height,screen_height/70) 
	lcd.drawFilledRectangle	(Screen_gap+cell_width,screen_height_for_print*0.72 + cell_height * 0.25,cell_width * 0.05,cell_height*0.5,1)
	lcd.color(lcd.RGB(128,128,128))
	end
	if NumOfCells > 4 then 
	if (LowCellAlert > 0 and Cell5Voltage < LowCellAlert / 100 and CellAlertOnOff == true) then lcd.color(RED) else lcd.color(lcd.RGB(128,128,128)) end
	lcd.drawRectangle(2*Screen_gap+ cell_width ,screen_height_for_print*0.72,cell_width,cell_height,screen_height/70)
	lcd.drawFilledRectangle	(2*Screen_gap+2*cell_width,screen_height_for_print*0.72 + cell_height * 0.25,cell_width * 0.05,cell_height*0.5,1)	
	lcd.color(lcd.RGB(128,128,128))
	end
	if NumOfCells > 5 then 
	if (LowCellAlert > 0 and Cell6Voltage < LowCellAlert / 100 and CellAlertOnOff == true) then lcd.color(RED) else lcd.color(lcd.RGB(128,128,128)) end
	lcd.drawRectangle(3*Screen_gap+ 2*cell_width ,screen_height_for_print*0.72,cell_width,cell_height,screen_height/70)
	lcd.drawFilledRectangle	(3*Screen_gap+ 3*cell_width,screen_height_for_print*0.72 + cell_height * 0.25,cell_width * 0.05,cell_height*0.5,1)	
	lcd.color(lcd.RGB(128,128,128))
	end

		if FontSize 	== 1 then
		lcd.font(FONT_S)
		elseif FontSize == 2 then
		lcd.font(FONT_M)
		elseif FontSize == 3 then
		lcd.font(FONT_L)
		elseif FontSize == 4 then
		lcd.font(FONT_XL)
		elseif FontSize == 5 then
		lcd.font(FONT_XXL)
		else
		lcd.font(FONT_S)
		end
		
	-- Draw cell Voltages
	lcd.color(WHITE)
	if NumOfCells > 0 then 
	lcd.drawText(screen_width_for_print * 0.13,screen_height_for_print*0.56,Cell1Voltage.."V") 
	lcd.color(WHITE)
	end
	if NumOfCells > 1 then 
	lcd.drawText(screen_width_for_print * 0.46,screen_height_for_print*0.56,Cell2Voltage.."V")  
	lcd.color(WHITE)
	end
	if NumOfCells > 2 then 
	lcd.drawText(screen_width_for_print * 0.78,screen_height_for_print*0.56,Cell3Voltage.."V") 
	lcd.color(WHITE)
	end
	if NumOfCells > 3 then 
	lcd.drawText(screen_width_for_print * 0.13,screen_height_for_print*0.77,Cell4Voltage.."V") 
	lcd.color(WHITE)
	end
	if NumOfCells > 4 then 
	lcd.drawText(screen_width_for_print * 0.46,screen_height_for_print*0.77,Cell5Voltage.."V")
	lcd.color(WHITE)
	end
	if NumOfCells > 5 then 
	lcd.drawText(screen_width_for_print * 0.78,screen_height_for_print*0.77,Cell6Voltage.."V")
	lcd.color(WHITE)
	end

	lcd.color(WHITE)
	lcd.drawText(screen_width_for_print * 0.33,screen_height_for_print*0.23,Lipo_Percentage.."%")
	lcd.drawText(screen_width_for_print * 0.73, screen_height_for_print*0.12,NumOfCells .. " cells")
	lcd.drawText(screen_width_for_print * 0.74,screen_height_for_print*0.27,LipoPackVoltage.."V")
	else
	lcd.color(WHITE)
	lcd.drawText(screen_width*0.35,screen_height*0.30,"PLEASE")
	lcd.drawText(screen_width*0.35,screen_height*0.45,"CONNECT")
	lcd.drawText(screen_width*0.35,screen_height*0.60,"BATTERY")
	end

		if count >LowBattCycleTime*3.3 then 
			if BattAlertOnOff == true and LipoPackVoltage < LowBattAlert / 10 then
			print("Battery alert")
			widget.battery_alert = true
			system.playFile	(CellsLowBattSound)	
			system.playHaptic("- - -")	
			elseif (CellAlertOnOff == true) and ((Cell1Voltage or Cell2Voltage or Cell3Voltage or Cell4Voltage or Cell5Voltage or Cell6Voltage) < LowCellAlert / 100) then
			print("Low Cell alert")
			widget.battery_alert = true
			system.playFile	(CellsLowCellSound)	
			system.playHaptic("- - -")	
			else
			widget.battery_alert = false
			end
		count = 0
		end


--===================================================
-- Draw Version
--===================================================
	--[[
	lcd.color(WHITE)
	lcd.font(FONT_S)
	lcd.drawText (screen_width - 80, screen_height - 20,CellsVersion)
	--]]
	lcd.font(FONT_L)
end
	
local function wakeup(widget)
			--invalidateme = 1
			newValue = os.clock() 
			if newValue > Time_Temp + 1 / paint_rate_Hz then  -- paint every X hz 
			Time_Temp = newValue 
				if CellsDone_Painting then 
				lcd.invalidate() 
				CellsDone_Painting = false 
				end 
			end 
end

local function Read_Sensor_Data(widget)
		--NumOfCells = widget.LipoSensor:stringValue(OPTION_CELL_COUNT)
		NumOfCells = widget.LipoSensor:value(OPTION_CELL_COUNT)
		NumOfCells = NumOfCells + 0
		LipoSensorSource  = system.getSource(LipoSensor)
		LipoPackVoltage = LipoSensorSource:value()
		
		widget.Cell1Voltage = widget.LipoSensor:value(OPTION_CELL_INDEX(1))
		widget.Cell2Voltage = widget.LipoSensor:value(OPTION_CELL_INDEX(2))
		widget.Cell3Voltage = widget.LipoSensor:value(OPTION_CELL_INDEX(3))
		widget.Cell4Voltage = widget.LipoSensor:value(OPTION_CELL_INDEX(4))
		widget.Cell5Voltage = widget.LipoSensor:value(OPTION_CELL_INDEX(5))
		widget.Cell6Voltage = widget.LipoSensor:value(OPTION_CELL_INDEX(6))
		
		--widget.Cell1Voltage = widget.Cell1Voltage:sub(1, -2)
		--widget.Cell2Voltage = widget.Cell2Voltage:sub(1, -2)
		--widget.Cell3Voltage = widget.Cell3Voltage:sub(1, -2)
		--widget.Cell4Voltage = widget.Cell4Voltage:sub(1, -2)
		--widget.Cell5Voltage = widget.Cell5Voltage:sub(1, -2)
		--widget.Cell6Voltage = widget.Cell6Voltage:sub(1, -2)
		
		Cell1Voltage = widget.Cell1Voltage + 0
		Cell2Voltage = widget.Cell2Voltage + 0
		Cell3Voltage = widget.Cell3Voltage + 0
		Cell4Voltage = widget.Cell4Voltage + 0
		Cell5Voltage = widget.Cell5Voltage + 0
		Cell6Voltage = widget.Cell6Voltage + 0
		return Cell1Voltage,Cell2Voltage,Cell3Voltage,Cell4Voltage,Cell5Voltage,Cell6Voltage
end

local function paint(widget)
	--if (invalidateme == 1) then
	--invalidateme = 0
---------------------------------------------
	if (Init == false) then -- Do Once / Init
	Init=true
	print("INIT DONE")
	end
---------------------------------------------
	FontSize 	  	  = widget.FontSize
	BattAlertOnOff    = widget.BattAlertOnOff
	LowBattAlert   	  = widget.LowBattAlert
	CellAlertOnOff    = widget.CellAlertOnOff
	LowCellAlert   	  = widget.LowCellAlert
	LowBattCycleTime  = widget.LowBattCycleTime

	if widget.LipoSensor ~= nil then -- no lipo sensor
		if widget.LipoSensor:name () ~= "---" then -- lipo sensor not "---"
		LipoSensor   = widget.LipoSensor:name () 
		local Cell1Voltage,Cell2Voltage,Cell3Voltage,Cell4Voltage,Cell5Voltage,Cell6Voltage = Read_Sensor_Data(widget)
		draw_Battery_Data(widget)
			else -- lipo sensor is "---"
			lcd.color(WHITE)
			local screen_width, screen_height = lcd.getWindowSize()
			lcd.drawText(screen_width*0.35,screen_height*0.30,"PLEASE")
			lcd.drawText(screen_width*0.35,screen_height*0.45,"CHOOSE")
			lcd.drawText(screen_width*0.35,screen_height*0.60,"LIPO SENSOR")
			end
		else -- no lipo sensor
		lcd.color(WHITE)
		local screen_width, screen_height = lcd.getWindowSize()
		lcd.drawText(screen_width*0.35,screen_height*0.30,"PLEASE")
		lcd.drawText(screen_width*0.35,screen_height*0.45,"CHOOSE")
		lcd.drawText(screen_width*0.35,screen_height*0.60,"LIPO SENSOR")
		end
    CellsDone_Painting = true
	--end
end

local function configure(widget)
	line = form.addLine("Low Battery Alert parameters:")
	line = form.addLine("Low Battery Alert")	-- Batt Alert OnOff
  form.addBooleanField(line, form.getFieldSlots(line)[0], function() return widget.BattAlertOnOff end, function(value) widget.BattAlertOnOff = value end)
	
 	line = form.addLine("Batt Alert (V)")
	local slots = form.getFieldSlots(line, {0})
	widget.LowBatt_field = form.addNumberField(line, slots[1], 1, 252, function() return widget.LowBattAlert end, function(value) widget.LowBattAlert = value end)
    widget.LowBatt_field:default(100)
    widget.LowBatt_field:decimals(1)
	
	line = form.addLine("Low Cell Alert")	-- Cell Alert OnOff
	form.addBooleanField(line, form.getFieldSlots(line)[0], function() return widget.CellAlertOnOff end, function(value) widget.CellAlertOnOff = value end)
	
	line = form.addLine("Low Cell Alert (V)")
	local slots = form.getFieldSlots(line, {0})
	widget.LowCell_field = form.addNumberField(line, slots[1], 200, 420, function() return widget.LowCellAlert end, function(value) widget.LowCellAlert = value end)
    widget.LowCell_field:default(350)
    widget.LowCell_field:decimals(2)

  line = form.addLine("Low Battery Alert Rate (s)")
	local slots = form.getFieldSlots(line, {0}) -- Batt Alert Rate
	widget.BATLowBattCycleTime_field = form.addNumberField(line, slots[1], 1, 10, function() return widget.LowBattCycleTime end, function(value) widget.LowBattCycleTime = value end);
    widget.BATLowBattCycleTime_field:default(5)
	line = form.addLine("Sensor Selection:")
	-- Source choice
  line = form.addLine("Lipo Sensor")
  form.addSourceField(line, nil, function() return widget.LipoSensor end, function(value) widget.LipoSensor = value end)
	
  line = form.addLine("Font Size")
	form.addChoiceField(line, nil, {{"S", 1}, {"M", 2}, {"L", 3}, {"XL", 4}, {"XXL", 5}}, function() return widget.FontSize end, function(value) print(value) widget.FontSize = value end)
end

local function read(widget)
	widget.BattAlertOnOff   = storage.read("BattAlertOnOff")
	widget.LowBattAlert     = storage.read("LowBattAlert")
	widget.CellAlertOnOff   = storage.read("CellAlertOnOff")
	widget.LowCellAlert     = storage.read("LowCellAlert")
	widget.LowBattCycleTime = storage.read("LowBattCycleTime")
	widget.LipoSensor		= storage.read("LipoSensor")
	widget.FontSize 	 	= storage.read("FontSize")
end

local function write(widget)
	storage.write("BattAlertOnOff"    ,widget.BattAlertOnOff)
	storage.write("LowBattAlert"      ,widget.LowBattAlert)
	storage.write("CellAlertOnOff"    ,widget.CellAlertOnOff)
	storage.write("LowCellAlert"      ,widget.LowCellAlert)
	storage.write("LowBattCycleTime"  ,widget.LowBattCycleTime)
	storage.write("LipoSensor"        ,widget.LipoSensor)
	storage.write("FontSize"          ,widget.FontSize)
end

local function init()
system.registerWidget({key="lzCells", name="Zavionix Cells", create=create, paint=paint, configure=configure, read=read, write=write, wakeup=wakeup})
Init = false
end

return {init=init}
