-- Zavionix RDT for Jeti. Values are already scaled by the EX decoder.
local S, renderer, menu, mode
local APP_VERSION="1.3.2"
local TELEMETRY_FULL_SCREEN=4
local modelImages, missingModelImages = {}, {}
local function load(name)
  local path="Apps/RDT/"..name
  local loader=loadfile(path..".lc")
  if not loader then loader=assert(loadfile(path..".lua")) end
  return loader()
end
local function assignedModelImagePath()
  local modelFile=system.getProperty("ModelFile")
  if type(modelFile)~="string" then
    print("RDT: ModelFile property unavailable")
    return nil
  end
  modelFile=modelFile:gsub("\\","/"):gsub("^%./",""):gsub("^/","")
  if modelFile:sub(1,6):lower()=="model/" then modelFile=modelFile:sub(7) end
  if modelFile=="" or modelFile=="." or modelFile==".." or modelFile:find("/",1,true) or modelFile:find("%c") then
    print("RDT: invalid ModelFile property")
    return nil
  end
  local contents
  for _,path in ipairs({"Model/"..modelFile,"/Model/"..modelFile}) do
    contents=io.readall(path)
    if contents then break end
  end
  if not contents then
    print("RDT: cannot read model file "..modelFile)
    return nil
  end
  local ok,config=pcall(json.decode,contents)
  if not ok then
    print("RDT: cannot decode model file "..modelFile..": "..tostring(config))
    return nil
  end
  local image=config and config.Global and config.Global.Img
  if type(image)~="string" or image=="" then
    print("RDT: active model has no Global.Img selection")
    return nil
  end
  image=image:gsub("\\","/"):gsub("^%./",""):gsub("^/","")
  if image:sub(1,4):lower()~="img/" then
    print("RDT: invalid model image path")
    return nil
  end
  local filename=image:sub(5)
  if filename=="" or filename:find("/",1,true) or filename:find("%c") then
    print("RDT: invalid model image filename")
    return nil
  end
  local extension=filename and filename:match("%.([%w]+)$")
  if not extension or not ({bmp=true,jpg=true,jpeg=true,png=true})[extension:lower()] then
    print("RDT: unsupported model image format")
    return nil
  end
  return "Img/"..filename
end
local function selectedModelImage(path)
  if not path then return nil end
  for _,candidate in ipairs({path,"./"..path,"/"..path}) do
    if modelImages[candidate]==nil then
      modelImages[candidate]=lcd.loadImage(candidate) or false
    end
    if modelImages[candidate] then return modelImages[candidate] end
  end
  if not missingModelImages[path] then
    print("RDT: assigned model image not found: "..path)
    missingModelImages[path]=true
  end
end
local function drawPhotoMessage(x,y,w,h,lines)
  local lineHeight=lcd.getTextHeight(FONT_MINI)
  local totalHeight=#lines*lineHeight
  local firstY=y+math.floor((h-totalHeight)/2)
  for index,line in ipairs(lines) do
    while #line>0 and lcd.getTextWidth(FONT_MINI,line)>w-4 do
      line=line:sub(1,-2)
    end
    if #line>0 then
      local textWidth=lcd.getTextWidth(FONT_MINI,line)
      lcd.drawText(x+math.floor((w-textWidth)/2),firstY+(index-1)*lineHeight,line,FONT_MINI)
    end
  end
end
local function drawAssignedModelImage(path,w,h)
  local size=w>=480 and h>=272 and "480x272" or w>=320 and h>=240 and "320x240" or
    w>=320 and h>=160 and "320x160" or "310x150"
  local bw,bh=size:match("(%d+)x(%d+)")
  bw,bh=tonumber(bw),tonumber(bh)
  local sx,sy=bw/320,bh/160
  local photoBoxH=math.floor(78*sy+0.5)
  local photoScaleY=(size=="320x240" or size=="480x272") and sx or sy
  local photoW=math.floor(120*sx+0.5)
  local photoH=math.floor(78*photoScaleY+0.5)
  local x=math.floor((w-bw)/2)+math.floor(25*sx)
  local y=math.floor((h-bh)/2)+math.floor(31*sy+(photoBoxH-photoH)/2)
  local image=selectedModelImage(path)

  lcd.setColor(100,100,100)
  lcd.drawFilledRectangle(x-2,y-2,photoW+4,photoH+4)
  lcd.setColor(0,0,0)
  lcd.drawFilledRectangle(x,y,photoW,photoH)
  if image and image.width<=photoW and image.height<=photoH then
    lcd.drawImage(x+math.floor((photoW-image.width)/2),
      y+math.floor((photoH-image.height)/2),image)
  else
    lcd.setColor(255,255,255)
    if image then
      drawPhotoMessage(x,y,photoW,photoH,{
        string.format("%dx%d photo too large",image.width,image.height),
        string.format("Resize to <=%dx%d",photoW,photoH)})
    elseif path then
      drawPhotoMessage(x,y,photoW,photoH,{"Model image","not found"})
    else
      drawPhotoMessage(x,y,photoW,photoH,{"Assign model image","in model settings"})
    end
  end
end
local function draw(w,h,detail)
  if menu then return end
  local color=S.cfg.theme==2 or (S.cfg.theme==1 and S.color)
  local nextMode=color and not detail and w>=300 and h>=145 and "draw" or "mono"
  if mode~=nextMode then renderer=nil; collectgarbage("collect"); mode=nextMode end
  if not renderer then renderer=load(mode) end
  local r,g,b=lcd.getFgColor()
  renderer(S,w,h,detail)
  if mode=="draw" then drawAssignedModelImage(S.modelImagePath,w,h) end
  lcd.setColor(r,g,b)
end
local function close()
  menu=nil
  S.scanAt=0
  collectgarbage("collect")
end
local function init()
  S=load("core")
  S.modelImagePath=assignedModelImagePath()
  S.version=APP_VERSION
  system.registerTelemetry(1,"Zavionix RDT",TELEMETRY_FULL_SCREEN,function(w,h) draw(w,h,false) end)
  system.registerTelemetry(2,"RDT details",2,function(w,h) draw(w,h,true) end)
  system.registerForm(1,MENU_APPS,"Zavionix RDT",function(page)
    renderer=nil
    collectgarbage("collect")
    if not menu then menu=load("menu") end
    menu(S,page or 1)
  end,nil,nil,close)
end
return {init=init,loop=function() if S then S.tick() end end,
  author="Zavionix",name="Zavionix RDT",version=APP_VERSION}
