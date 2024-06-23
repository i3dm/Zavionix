-- ***************************************************************************
-- **
-- **  T3chDad®'s RDT Screen (TD-GAS) for gas Engines
-- **
-- **  This is a full screen widget. You must have topbar and trims turned off
-- **  Author: Bob Templeton (T3chDad)®  November 2019 / Lior Zahavi April 2021
-- **  Modified exclusively for Zavonix.
-- ***************************************************************************

local app_ver = "1.0.2"
--===================================================
-- Widget Options
--===================================================
local defaultOptions  = {
	--AirCraft fuel capacity (ml)
	{"TankSize", VALUE, 1000, 0, 20000 },
	--Fuel alarm level (ml)
	{"FuelAlarm", VALUE, 1000, 100, 5000 },
	--Fuel consumption multiplyer adjustment
	{"FuelCorrct", VALUE, 100, 80, 150 },
	--ECU Parameter: Value of the PW of the Pump at max power
	{"PumpPower", VALUE, 440, 0, 5000 },
	--Fuel Flow defined by the manufacturer (ml/min)
	{"FuelFlow", VALUE, 220, 00, 5000 },
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
	local imagePath = "/WIDGETS/TD-GAS/img"
	local Img_BG = Bitmap.open(imagePath.."/RDT_bg.jpg")
	local Img_Aircraft = Bitmap.open("/IMAGES/"..model.getInfo().bitmap)
	local Img_Aircraft_Path = model.getInfo().bitmap
	-- ECU Parameters, see in the beginning of the widget
	local FFmax = 260
	local PWmax = 440
	-- Turbine message table
	local msg_table = {
	[0]   = "OFF",
	[1]   = "Wait for RPM",
	[2]   = "Ignition",
	[3]   = "Accelerate",
	[4]   = "Stabilize",
	[5]   = "Learn High!",
	[6]   = "Learn Low",
	[7]   = "7",
	[8]   = "Slow Down",
	[9]   = "Not Used",
	[10]  = "Auto Off",
	[11]  = "Running",
	[12]  = "Accel Delay",
	[13]  = "Speed Reg",
	[14]  = "2 Shaft Reg",
	[15]  = "Preheat 1",
	[16]  = "Preheat 2",
	[17]  = "Main FStrt",
	[18]  = "Not Used",
	[19]  = "Kero Full",
	[20]  = "20",
	[21]  = "21",
	[22]  = "22",
    [23]  = "23",
	[24]  = "24",
    [25]  = "25",
    [26]  = "26",
	[27]  = "27",
	[28]  = "28",
	[29]  = "29",
 	[30]  = "30",
 	[31]  = "31",
 	[32]  = "32",
	[33]  = "33",
	[34]  = "34",
	[35]  = "35",
	[36]  = "36",
	[37]  = "37",
	[38]  = "38",
	[39]  = "39",
 	[40]  = "40",
 	[41]  = "41",
	[42]  = "42",
	[43]  = "43",
	[44]  = "44",
	[45]  = "45",
	[46]  = "46",
	[47]  = "47",
	[48]  = "48",
	[49]  = "49",
	[50]  = "50",
 	[51]  = "51",
 	[52]  = "52",
 	[53]  = "53",
	[54]  = "54",
	[55]  = "55",
	[56]  = "56",
	[57]  = "57",
	[58]  = "58",
	[59]  = "59",
	[60]  = "60",
	[61]  = "61",
	[62]  = "62",
	[63]  = "63",
	[64]  = "64",
	[65]  = "65",
	[66]  = "66",
	[67]  = "67",
	[68]  = "68",
	[69]  = "69",
 	[70]  = "70",
	[71]  = "71",
	[72]  = "72",
	[73]  = "73",
	[74]  = "74",
	[75]  = "75",
	[76]  = "76",
	[77]  = "77",
	[78]  = "78",
	[79]  = "79",
 	[80]  = "80",
	[81]  = "81",
	[82]  = "82",
	[83]  = "83",
	[84]  = "84",
	[85]  = "85",
	[86]  = "86",
	[87]  = "87",
	[88]  = "88",
	[89]  = "89",
 	[90]  = "80",
	[91]  = "91",
	[92]  = "92",
	[93]  = "93",
	[94]  = "94",
	[95]  = "95",
	[96]  = "96",
	[97]  = "97",
	[98]  = "98",
	[99]  = "99",
 	[100] = "100",
	}

		local block = 0
	--===================================================
	-- LED display images
	--===================================================
	local digit ={
		[0] = Bitmap.open(imagePath.."/blue/0.png"),
		[1] = Bitmap.open(imagePath.."/blue/1.png"),
		[2] = Bitmap.open(imagePath.."/blue/2.png"),
		[3] = Bitmap.open(imagePath.."/blue/3.png"),
		[4] = Bitmap.open(imagePath.."/blue/4.png"),
		[5] = Bitmap.open(imagePath.."/blue/5.png"),
		[6] = Bitmap.open(imagePath.."/blue/6.png"),
		[7] = Bitmap.open(imagePath.."/blue/7.png"),
		[8] = Bitmap.open(imagePath.."/blue/8.png"),
		[9] = Bitmap.open(imagePath.."/blue/9.png"),
		[10] = Bitmap.open(imagePath.."/blue/nil.png"),
		[11] = Bitmap.open(imagePath.."/blue/col.png")
	}
	local red ={
		[0] = Bitmap.open(imagePath.."/red/0.png"),
		[1] = Bitmap.open(imagePath.."/red/1.png"),
		[2] = Bitmap.open(imagePath.."/red/2.png"),
		[3] = Bitmap.open(imagePath.."/red/3.png"),
		[4] = Bitmap.open(imagePath.."/red/4.png"),
		[5] = Bitmap.open(imagePath.."/red/5.png"),
		[6] = Bitmap.open(imagePath.."/red/6.png"),
		[7] = Bitmap.open(imagePath.."/red/7.png"),
		[8] = Bitmap.open(imagePath.."/red/8.png"),
		[9] = Bitmap.open(imagePath.."/red/9.png"),
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
		zone=zone, options=options, imagePath=imagePath, TopSpeed=TopSpeed, Img_BG = Img_BG, Img_Aircraft = Img_Aircraft, Img_Aircraft_Path = Img_Aircraft_Path,
		rpm=rpm, egt=egt, status=status, batecu=batecu, pump=pump, thr=thr, FFmax=FFmax, PWmax=PWmax, msg_table=msg_table, Units=Units, block=block,
		digit=digit, red=red, Trim_C=Trim_C, Trim_U=Trim_U, Trim_D=Trim_D, Trim_L=Trim_L, Trim_R=Trim_R, param={}
	}
	--Fuel calculations
	--How many times the fuel low alarm will be annouced
	Me.param.counter = 3
	Me.param.tank_rem = Me.options.TankSize
	Me.param.alarm = Me.options.FuelAlarm
	Me.param.lastTime = 0
	Me.param.ff = (Me.options.FuelFlow / 60) / Me.options.PumpPower
	Me.param.adjust = Me.options.FuelCorrct / 100
	return Me
end
--===================================================
-- Update the widget
--===================================================
local function updateWidget(Me, newOptions)
  Me.options = newOptions
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
	--Center coordinates    --Top/Left coordinates		--Bottom/Right coordinates
	--Ail 155,179			--Ail 115,179				--Ail 202,179
	--Ele 218,112			--Ele 218,67				--Ele 218,157
	--Rud 62,179			--Rud 20,179				--Rud 105,179
	--Thr 3,112				--Thr 3,67					--Thr 3,157

	--Aileron
	local ta = round(((getValue('trim-ail'))/10.32)/2.35,0)
	if ta > 0 then
		lcd.drawBitmap(Me.Trim_R,157+ta,179)
	elseif ta < 0 then
		lcd.drawBitmap(Me.Trim_L,157+ta,179)
	else
		lcd.drawBitmap(Me.Trim_C,157+ta,179)
	end
	--Elevator
	local te = round(-((getValue('trim-ele'))/10.32)/2.22,0)
	if te > 0 then
		lcd.drawBitmap(Me.Trim_D,218,112+te)
	elseif te < 0 then
		lcd.drawBitmap(Me.Trim_U,218,112+te)
	else
		lcd.drawBitmap(Me.Trim_C,218,112+te)
	end
	--Rudder
	local tr = round(((getValue('trim-rud'))/10.32)/2.35,0)
	if tr > 0 then
		lcd.drawBitmap(Me.Trim_R,62+tr,179)
	elseif tr < 0 then
		lcd.drawBitmap(Me.Trim_L,62+tr,179)
	else
		lcd.drawBitmap(Me.Trim_C,62+tr,179)
	end
	--Throttle
	local tt = round(-((getValue('trim-thr'))/10.32)/2.22,0)
	if tt > 0 then
		lcd.drawBitmap(Me.Trim_D,2,112+tt)
	elseif tt < 0 then
		lcd.drawBitmap(Me.Trim_U,2,112+tt)
	else
		lcd.drawBitmap(Me.Trim_C,2,112+tt)
	end
end

--===================================================
-- Draw the Turbine Status
--===================================================
local function drawTurbine(Me,x,y)
	local status_num = getValue("Tmp2")
	local status_str = Me.msg_table[status_num]
	--Flash if not 16, 2, or 0
	--if status_num == 0 or status_num == 2 or status_num == 16 then
	--	lcd.drawText(x,y-10,status_str,DBLSIZE + WHITE)
	--else
	--	lcd.drawText(x,y-10,status_str,INVERS + DBLSIZE + WHITE)
	--end
	lcd.drawText(x,y+33,"RPM:", WHITE)
	lcd.drawText(x+52,y+26,format_thousand(getValue("RPM")*1),MIDSIZE + WHITE)
	lcd.drawText(x,y+58,"Temp 1:", WHITE)
	lcd.drawText(x+68,y+51,getValue("Tmp1").."c",MIDSIZE + WHITE)
	lcd.drawText(x,y+83,"Temp 2:", WHITE)
	lcd.drawText(x+68,y+76,getValue("Tmp2").."c",MIDSIZE + WHITE)
	--lcd.drawText(x,y+108,"ECU:", WHITE)
	--lcd.drawText(x+52,y+101,round(getValue("A3"),2).."v",MIDSIZE + WHITE)
end

--===================================================
-- Update Fule Data
--===================================================
local function updateTank(param)
	local time = getTime()
	local status = getValue("Tmp2")
	local pump = getValue("A4")*1000
	if time > param.lastTime + 100 then
	 if status == 16 then
			param.tank_rem = param.tank_rem - ((param.ff*pump)*param.adjust)
	 end
	 if param.tank_rem < param.alarm and param.counter > 0 then
		 playFile("/SOUNDS/en/fuelvl.wav")
		 param.counter = param.counter - 1
	 end
	 param.lastTime = time
 end
end
--===================================================
-- Draw the Throttle Status
--===================================================
local function drawThrottle(x,y,src)
  local thr = getValue(src)
  lcd.drawText(x+31,y+15,"Thro",SMLSIZE+CUSTOM_COLOR)
  lcd.drawNumber(x+110,y+10,thr,RIGHT+MIDSIZE+CUSTOM_COLOR)
  lcd.drawText(x+110,y+20,"%",SMLSIZE+CUSTOM_COLOR)
end

--===================================================
-- Refresh the widget
--===================================================
local function refreshWidget(Me)
	--Update fuel data
	--updateTank(Me.param)
	--Background image
	lcd.drawBitmap(Me.Img_BG, 0, 0)
	--Aircraft image
	if Me.Img_Aircraft_Path ~= model.getInfo().bitmap then
		Me.Img_Aircraft_Path = model.getInfo().bitmap
		Me.Img_Aircraft = Bitmap.open("/IMAGES/"..model.getInfo().bitmap)
	end
	lcd.drawBitmap(Me.Img_Aircraft, 18, 58)
	--Trims
	draw_Trims(Me)
	--Timer
	drawTimer(Me,293,65)
	--Engine Info
	drawTurbine(Me,292,135)
	--Aircraft Name
	lcd.drawText(7,3,model.getInfo().name,DBLSIZE + WHITE)
	--RSSI
	lcd.drawText(300,3,"RSSI",SMLSIZE + WHITE)
	lcd.drawText(300,15,getRSSI(),MIDSIZE + WHITE)
	--Rx Battery voltage
	lcd.drawText(363,3,"RxBatt",SMLSIZE+ WHITE)
	lcd.drawText(363,15,round(getValue(getTelemetryId('RxBt')),1).."v",MIDSIZE + WHITE)
	--Tx Battery voltage
	lcd.drawText(422,3,"TxBatt",SMLSIZE + WHITE)
	lcd.drawText(422,15,round(getValue('tx-voltage'),1).."v",MIDSIZE + WHITE)
	--Fuel
	--lcd.drawText(15,195,"FUEL:", SMLSIZE + WHITE)
	--lcd.drawText(15,208,round(Me.param.tank_rem, 0).."ml",MIDSIZE + WHITE)
	--Throttle
	lcd.drawText(100,195,"Fuel:", SMLSIZE + WHITE)
	lcd.drawText(100,208, round(getValue("Fuel"),1).."ml",MIDSIZE + WHITE)
	--lcd.drawText(30,195,"Current:", SMLSIZE + WHITE)
	--lcd.drawText(30,208, round(getValue("Curr"),1).."A",MIDSIZE + WHITE)
	lcd.drawText(210,195,"Throttle:", SMLSIZE + WHITE)
	lcd.drawText(210,208, round((getValue("thr") + 1024)/20.48).."%",MIDSIZE + WHITE)
	--lcd.drawText(210,208, round(getValue("VSpd"),1).."%",MIDSIZE + WHITE)

    --display the widget version
	lcd.drawText(442,252,app_ver, SMLSIZE + WHITE)	--debug output area-----------------------------------

end

--===================================================
-- Background process (when widget not visible)
--===================================================
local function backgroundProcessWidget(Me)
	updateTank(Me.param)
end

--===================================================
-- Widget return fuctions
--===================================================
return { name="TD-GAS", options=defaultOptions, create=createWidget, update=updateWidget, background=backgroundProcessWidget, refresh=refreshWidget }
