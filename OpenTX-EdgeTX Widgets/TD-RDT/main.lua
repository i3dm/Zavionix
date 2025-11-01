-------------------------------------------------------------------------------
--  /WIDGETS/MY_WIDGET/main.lua
-------------------------------------------------------------------------------
--print('/WIDGETS/TD-RDT/main.lua')
--return loadScript('/WIDGETS/TD-RDT/TD-RDT.luac','Tx') ()

--return loadScript(FP..AP..'COLOR/WIDGET/loader',SLM)(FP,AP,WNAME,SLM)
local s = loadScript("/WIDGETS/TD-RDT/TD-RDT.luac")
print("Loaded TD-RDT:", s)

if s then
    return s()
else
    return { refresh=function() lcd.drawText(0,0,"**** Load ERROR ****") end }
end