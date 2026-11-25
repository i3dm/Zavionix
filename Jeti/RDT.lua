-- Zavionix RDT for Jeti. Values are already scaled by the EX decoder.
local S, renderer, menu, mode
local APP_VERSION="1.1"
local TELEMETRY_FULL_SCREEN=4
local function load(name)
  local path="Apps/RDT/"..name
  local loader=loadfile(path..".lc")
  if not loader then loader=assert(loadfile(path..".lua")) end
  return loader()
end
local function draw(w,h,detail)
  if menu then return end
  local color=S.cfg.theme==2 or (S.cfg.theme==1 and S.color)
  local nextMode=color and not detail and w>=300 and h>=145 and "draw" or "mono"
  if mode~=nextMode then renderer=nil; collectgarbage("collect"); mode=nextMode end
  if not renderer then renderer=load(mode) end
  local r,g,b=lcd.getFgColor()
  renderer(S,w,h,detail)
  lcd.setColor(r,g,b)
end
local function close()
  menu=nil
  S.scanAt=0
  collectgarbage("collect")
end
local function init()
  S=load("core")
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
