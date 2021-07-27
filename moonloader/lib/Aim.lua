local memory =	require"memory"

Aim = {}
function Aim.GetAngleBeetweenTwoPoints(x1,y1,x2,y2)
	local plus = 0.0
    local mode = 1
    if x1 < x2 and y1 > y2 then plus = math.pi/2 mode = 2 end
    if x1 < x2 and y1 < y2 then plus = math.pi end
    if x1 > x2 and y1 < y2 then plus = math.pi*1.5 mode = 2 end
    local lx = x2 - x1
    local ly = y2 - y1
    lx = math.abs(lx)
    ly = math.abs(ly)
    if mode == 1 then ly = ly/lx
	else ly = lx/ly end
    ly = math.atan(ly)
    ly = ly + plus
    return ly
end

function Aim.getCamera()
	return 0x00B6F028
end

function Aim.getActiveCamMode()
	local activeCamId = memory.getint8(Aim.getCamera() + 0x59)
	return Aim.getCamMode(activeCamId)
end

function Aim.getCamMode(id)
	local cams = Aim.getCamera() + 0x174
	local cam = cams + id * 0x238
	return memory.getint16(cam + 0x0C)
end
function Aim.LoSCheck(FinAngleX,FinAngleY)
	local CurAngleX = memory.getfloat(0xB6F258,false)
	local CurAngleY = memory.getfloat(0xB6F248,false)

	if FinAngleY > math.pi then
		FinAngleY = FinAngleY-math.pi*2
	end
	if FinAngleY > math.pi then
		FinAngleY = FinAngleY-math.pi*2
	end

	local CalcX = FinAngleY - CurAngleY
	local CalcY = FinAngleX - CurAngleX
	if CalcY < 0 then CalcY = CalcY * -1 end
	if CalcX < 0 then CalcX = CalcX * -1 end
	if CalcY > math.pi then CalcY = math.pi*2 - CalcY end
	if CalcX > math.pi then CalcX = math.pi*2 - CalcX end
	return CalcX,CalcY
end

function Aim.MaxDist(gunID) 
	if gunID == 24 or gunID == 25 then return 35 end 
	if gunID == 34 then return 300 end
	return 35
end

function Aim.GetDist(WepID)
	if WepID == 34 or WepID == 35 then return 0 end
	return 0.059
end

function Aim.GetDistH(WepID)
	if WepID == 34 or WepID == 35 then return 0 end
	return 0.106
end

function Aim.At(VAngle,HAngle)
	setCameraPositionUnfixed(VAngle,HAngle)
end

return Aim