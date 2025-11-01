-- ******************************************************************************
-- **  T3chDad®'s Jet EDF Screen (TD-EDF)                                      **
-- ******************************************************************************
-- **  This is a full screen widget. You must have topbar and trims turned off **
-- **  Author: Bob Templeton (T3chDad)®  December 2019                         **
-- **  Created exclusively for Zavonix.                                        **
-- **  v1.0.0							                                       **
-- ******************************************************************************

--===================================================
-- Widget Options 
--===================================================
local defaultOptions  = {
	{"Sensor",     SOURCE, 0       },
	{"LowestCell", BOOL,   1       },
	{"Stick_Mode", VALUE,  2, 1, 4 },
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
-- Widget Creation
--===================================================
local function createWidget(zone, options)
	local no_telem_blink = 0
	local isDataAvailable = 0
	local cellDataLive = {0,0,0,0,0,0}
	local cellDataHistoryLowest = {0,0,0,0,0,0}
	local cellDataHistoryCellLowest = 5
	local cellMax = 0
	local cellMin = 0
	local cellAvg = 0
	local cellPercent = 0
	local cellCount = 0
	local cellSum = 0
	local mainValue = 0
	local secondaryValue = 0		
	local imagePath = "/WIDGETS/TD-EDF/img"
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
		no_telem_blink = no_telem_blink,
		isDataAvailable = isDataAvailable,
		cellDataLive = cellDataLive,
		cellDataHistoryLowest = cellDataHistoryLowest,
		cellDataHistoryCellLowest = cellDataHistoryCellLowest,
		cellMax = cellMax,
		cellMin = cellMin,
		cellAvg = cellAvg,
		cellPercent = cellPercent,
		cellCount = cellCount,
		cellSum = cellSum,
		mainValue = mainValue,
		secondaryValue = secondaryValue,		
		zone=zone, options=options, TankRemaining=TankRemaining, ECU_Name=ECU_Name, A4Mult=A4Mult, LastTime=LastTime, imagePath=imagePath, TopSpeed=TopSpeed, Img_BG = Img_BG, Img_Aircraft = Img_Aircraft, Img_Aircraft_Path = Img_Aircraft_Path,
		rpm=rpm, egt=egt, status=status, batecu=batecu, pump=pump, thr=thr, ECU_Status=ECU_Status, Units=Units, digit=digit, red=red, 
		Trim_C=Trim_C, Trim_U=Trim_U, Trim_D=Trim_D, Trim_L=Trim_L, Trim_R=Trim_R, param={}
	}
	-- use default if user did not set, So widget is operational on "select widget"
	if Me.options.Sensor == 0 then
		Me.options.Sensor = "Cels"
	end
	Me.options.LowestCell = Me.options.LowestCell % 2 -- modulo due to bug that cause the value to be other than 0|1
	Me.param.Curr = getTelemetryId("Curr")
	Me.param.Fuel = getTelemetryId("Fuel")
	Me.param.Thro = getTelemetryId("0A20")
	Me.param.TxV  = getTelemetryId('tx-voltage')
	Me.param.RxBt = getTelemetryId(RxBt_Name)
	Me.param.A4   = getTelemetryId("A4")
	Me.param.A3   = getTelemetryId("A3")
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
local function updateWidget(Me, options)
	Me.options = options
	-- use default if user did not set, So widget is operational on "select widget"
	if Me.options.Sensor == 0 then
		Me.options.Sensor = "Cels"
	end
	Me.options.LowestCell = Me.options.LowestCell % 2 -- modulo due to bug that cause the value to be other than 0|1
end

-- A quick and dirty check for empty table
local function isEmpty(self)
  for _, _ in pairs(self) do
    return false
  end
  return true
end
--- This function return the percentage remaining in a single Lipo cel
local function getCellPercent(cellValue)
	if cellValue == nil then
	  return 0
	end
	-- in case somehow voltage is higher, don't return nil
	if (cellValue > 4.2) then
	  return 100
	end
	-- Data gathered from commercial lipo sensors
	local myArrayPercentList = { {3,0},{3.093,1},{3.196,2},{3.301,3},{3.401,4},{3.477,5},{3.544,6},{3.601,7},{3.637,8},{3.664,9},{3.679,10},{3.683,11},{3.689,12},{3.692,13},{3.705,14},{3.71,15},{3.713,16},{3.715,17},{3.72,18},{3.731,19},{3.735,20},{3.744,21},{3.753,22},{3.756,23},{3.758,24},{3.762,25},{3.767,26},{3.774,27},{3.78,28},{3.783,29},{3.786,30},{3.789,31},{3.794,32},{3.797,33},{3.8,34},{3.802,35},{3.805,36},{3.808,37},{3.811,38},{3.815,39},{3.818,40},{3.822,41},{3.825,42},{3.829,43},{3.833,44},{3.836,45},{3.84,46},{3.843,47},{3.847,48},{3.85,49},{3.854,50},{3.857,51},{3.86,52},{3.863,53},{3.866,54},{3.87,55},{3.874,56},{3.879,57},{3.888,58},{3.893,59},{3.897,60},{3.902,61},{3.906,62},{3.911,63},{3.918,64},{3.923,65},{3.928,66},{3.939,67},{3.943,68},{3.949,69},{3.955,70},{3.961,71},{3.968,72},{3.974,73},{3.981,74},{3.987,75},{3.994,76},{4.001,77},{4.007,78},{4.014,79},{4.021,80},{4.029,81},{4.036,82},{4.044,83},{4.052,84},{4.062,85},{4.074,86},{4.085,87},{4.095,88},{4.105,89},{4.111,90},{4.116,91},{4.12,92},{4.125,93},{4.129,94},{4.135,95},{4.145,96},{4.176,97},{4.179,98},{4.193,99},{4.2,100} }
	for i, v in ipairs(myArrayPercentList) do
	  if v[1] >= cellValue then
		result = v[2]
		break
	  end
	end
	return result
end
--- This function returns a table with cels values
local function calculateBatteryData(Me)

	local newCellData = getValue(Me.options.Sensor)
  
	if type(newCellData) ~= "table" then
	  Me.isDataAvailable = false
	  return
	end
  
  
	-- this is necessary for simu where cell-count can change
	if #Me.cellDataHistoryLowest ~= #newCellData then
	  Me.cellDataHistoryLowest = {}
	  for k, v in pairs(newCellData) do
		Me.cellDataHistoryLowest[k] = v
	  end
	end
	-- stores the lowest cell values in historical table
	for k, v in pairs(newCellData) do
	  if v < Me.cellDataHistoryLowest[k] then
		Me.cellDataHistoryLowest[k] = v
	  end
	end
  
	--- calc highest of all cels
	local cellMax = 0
	for k, v in pairs(newCellData) do
	  if v > cellMax then
		cellMax = v
	  end
	end
	Me.cellMax = cellMax
  
	--- calc lowest of all cels
	local cellMin = 5
	for k, v in pairs(newCellData) do
	  if v < cellMin and v > 1 then -- >1 to ignore invalid values
		cellMin = v
	  end
	end
	Me.cellMin = cellMin
  
	--- calc history lowest of all cells
	if cellMin < Me.cellDataHistoryCellLowest and cellMin > 1 then -- >1 to ignore invalid values
	  Me.cellDataHistoryCellLowest = cellMin
	end
  
	Me.cellCount = #newCellData
  
	--- sum of all cells
	local cellSum = 0
	for k, v in pairs(newCellData) do
	  cellSum = cellSum + v
	end
	Me.cellSum = cellSum
  
	--- average of all cells
	Me.cellAvg = Me.cellSum / Me.cellCount
	Me.cellPercent = getCellPercent(Me.cellMin)
  
	Me.cellDataLive = newCellData
  
	-- mainValue
	if Me.options.LowestCell == 1 then
	  Me.mainValue = Me.cellMin
	elseif Me.options.LowestCell == 0 then
	  Me.mainValue = Me.cellSum
	else
	  Me.mainValue = "-1"
	end
  
	-- secondaryValue
	if Me.options.LowestCell == 1 then
	  Me.secondaryValue = Me.cellSum
	elseif Me.options.LowestCell == 0 then
	  Me.secondaryValue = Me.cellMin
	else
	  Me.secondaryValue = "-2"
	end 
  
	Me.isDataAvailable = true
end
-- color for cell
-- This function returns green at gvalue, red at rvalue and graduate in between
local function getRangeColor(value, green_value, red_value)
	local range = math.abs(green_value - red_value)
	if range==0 then return lcd.RGB(0, 0xdf, 0) end
  
	if green_value > red_value then
	  if value > green_value then return lcd.RGB(0, 0xdf, 0) end
	  if value < red_value   then return lcd.RGB(0xdf, 0, 0) end
	  g = math.floor(0xdf * (value - red_value) / range)
	  r = 0xdf - g
	  return lcd.RGB(r, g, 0)
	else
	  if value > green_value then return lcd.RGB(0, 0xdf, 0) end
	  if value < red_value   then return lcd.RGB(0xdf, 0, 0) end
	  r = math.floor(0xdf * (value - green_value) / range)
	  g = 0xdf - r
	  return lcd.RGB(r, g, 0)
	end
end
-- color for battery
-- This function returns green at 100%, red bellow 30% and graduate in between
local function getPercentColor(percent)
	if percent < 30 then
	  return lcd.RGB(0xff, 0, 0)
	else
	  g = math.floor(0xdf * percent / 100)
	  r = 0xdf - g
	  return lcd.RGB(r, g, 0)
	end
end
--- Zone size: 192x152 1/2
local function refreshZoneLarge(Me)
	local myBatt = { ["x"] = 0, ["y"] = 18, ["w"] = 60, ["h"] = 110, ["segments_h"] = 27, ["color"] = WHITE, ["cath_w"] = 30, ["cath_h"] = 10 }
	org_x = 246
	org_y = 128
	if Me.isDataAvailable then
	  lcd.setColor(CUSTOM_COLOR, WHITE)
	else
	  lcd.setColor(CUSTOM_COLOR, GREY)
	end
	posy = 128
	posx = 328
	lcd.drawText(posx, posy, Me.cellPercent .. "%", DBLSIZE + CUSTOM_COLOR)
	lcd.drawText(posx, posy + 30, string.format("%2.1fV", Me.mainValue), DBLSIZE + CUSTOM_COLOR)
	lcd.drawText(posx, posy + 62, string.format("%2.1fV %sS", Me.secondaryValue, Me.cellCount), SMLSIZE + CUSTOM_COLOR)
	-- lcd.drawText(Me.zone.x + Me.zone.w, Me.zone.y, Me.cellPercent .. "%", RIGHT + DBLSIZE + CUSTOM_COLOR)
	-- lcd.drawText(Me.zone.x + Me.zone.w, Me.zone.y + 30, string.format("%2.1fV", Me.mainValue), RIGHT + DBLSIZE + CUSTOM_COLOR)
	-- lcd.drawText(Me.zone.x + Me.zone.w, Me.zone.y + 70, string.format("%2.1fV %2.1fS", Me.secondaryValue, Me.cellCount), RIGHT + SMLSIZE + CUSTOM_COLOR)
  
	-- fill batt
	lcd.setColor(CUSTOM_COLOR, getPercentColor(Me.cellPercent))
	lcd.drawFilledRectangle(org_x + myBatt.x, org_y + myBatt.y + myBatt.h + myBatt.cath_h - math.floor(Me.cellPercent / 100 * myBatt.h), myBatt.w, math.floor(Me.cellPercent / 100 * myBatt.h), CUSTOM_COLOR)
  
	-- draw cells
	local pos = { { x = 80, y = 80 }, { x = 146, y = 80 }, { x = 80, y = 99 }, { x = 146, y = 99 }, { x = 80, y = 118 }, { x = 146, y = 118 } }
	for i = 1, Me.cellCount, 1 do
	  lcd.setColor(CUSTOM_COLOR, getRangeColor(Me.cellDataLive[i], Me.cellMax, Me.cellMax - 0.2))
	  lcd.drawFilledRectangle(org_x + pos[i].x, org_y + pos[i].y, 66, 20, CUSTOM_COLOR)
	  lcd.setColor(CUSTOM_COLOR, WHITE)
	  lcd.drawText(org_x + pos[i].x + 14, org_y + pos[i].y, string.format("%.2f", Me.cellDataLive[i]), CUSTOM_COLOR)
	  lcd.drawRectangle(org_x + pos[i].x, org_y + pos[i].y, 67, 20, CUSTOM_COLOR, 1)
	end
  
	-- draw bat
	lcd.setColor(CUSTOM_COLOR, WHITE)
	lcd.drawRectangle(org_x + myBatt.x, org_y + myBatt.y + myBatt.cath_h, myBatt.w, myBatt.h, CUSTOM_COLOR, 2)
	lcd.drawFilledRectangle(org_x + myBatt.x + myBatt.w / 2 - myBatt.cath_w / 2, org_y + myBatt.y, myBatt.cath_w, myBatt.cath_h, CUSTOM_COLOR)
	for i = 1, myBatt.h - myBatt.segments_h, myBatt.segments_h do
	  lcd.drawRectangle(org_x + myBatt.x, org_y + myBatt.y + myBatt.cath_h + i, myBatt.w, myBatt.segments_h, CUSTOM_COLOR, 1)
	end
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
-- Refresh the widget
--===================================================
local function refreshWidget(Me)
	--save the original text color
	ORIG_COLOR = TEXT_COLOR
	--set the text color to white
	lcd.setColor(TEXT_COLOR,WHITE)
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
	--debug output area-----------------------------------
	--lcd.drawText(212,239,Me.options.ECU_Type, SMLSIZE )
	------------------------------------------------------

	calculateBatteryData(Me)
	if Me.isDataAvailable then
	  Me.no_telem_blink = 0
	else
	  Me.no_telem_blink = INVERS + BLINK
	end
	refreshZoneLarge(Me)	
	--set the text color back to the original
	lcd.setColor(TEXT_COLOR,ORIG_COLOR)
end

--===================================================
-- Background process (when widget not visible)
--===================================================
local function backgroundProcessWidget(Me)
	if (Me == nil) then return end
	calculateBatteryData(Me)
end

--===================================================
-- Widget return fuctions
--===================================================
return { name="TD-EDF", options=defaultOptions, create=createWidget, update=updateWidget, background=backgroundProcessWidget, refresh=refreshWidget }
