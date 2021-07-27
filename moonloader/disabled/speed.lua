local KEY = require"lib.vkeys"
local memory = require"memory"
Distance = 5
xXx,yYy = 0,0
ScreenX,ScreenY = getScreenResolution()
x,y,z = 0,0,0

table.Count = function(Table)
	local Count = 0
	for k,v in pairs(Table) do
		Count = Count + 1
	end
	return Count
end

function SetCarPos(vehicle,x,y,z)
	local Addr = memory.getint32(getCarPointer(vehicle)+20)
	memory.setfloat(Addr+48, x, false)
	memory.setfloat(Addr+52, y, false)
	memory.setfloat(Addr+56, z, false)
	
end
function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do
		wait(200)
	end
	if sampGetCurrentServerAddress() == "37.187.111.39" then print"no" return end
	while true do
		wait(25)
		
		yaw = memory.getfloat(0xB6F258,false) - 0.04
		pitch = memory.getfloat(0xB6F248,false) + 0.1
		x,y,z = getCharCoordinates(PLAYER_PED)
		xx = (math.cos(yaw)*math.cos(pitch)) *-Distance
		yy = (math.sin(yaw)*math.cos(pitch)) *-Distance
		zz = math.sin(pitch) * Distance
		x = x + xx
		y = y + yy
		z = z + zz 
		
		if isKeyDown(KEY.VK_Q) then
			Distance = Distance - 1
		end		
		if isKeyDown(KEY.VK_E) then
			Distance = Distance + 1
		end
		if x and y then
			if isKeyDown(KEY.VK_R) then
				if not isCharInAnyCar(PLAYER_PED) then
					if not sampIsChatInputActive() then
						if table.Count(getAllVehicles()) ~= 0 then
							
							_,xXx,yYy = convert3DCoordsToScreenEx(x,y,z,true,true)
							--renderDrawLine(xXx,yYy,ScreenX,ScreenY/2,2,0xFFFF0000)
							SetCarPos(getAllVehicles()[1],x,y,z)
						end
					end
				end
			end
		end
	end
end