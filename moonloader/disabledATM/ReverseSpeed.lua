local KEY = require"lib.vkeys"
local memory =	require"memory"
--local maf = require"maf"
----local Quat = maf.quat

function GetCarVelocity(vehicle)
	local Addr = getCarPointer(vehicle)
	local x = memory.getfloat(Addr+68,false)
	local y = memory.getfloat(Addr+72,false)
	local z = memory.getfloat(Addr+76,false)
	return x,y,z
end

function SetCarSpin(vehicle,x,y,z)
	local Addr = getCarPointer(vehicle)
	memory.setfloat(Addr+80, x, false)
	memory.setfloat(Addr+84, y, false)
	memory.setfloat(Addr+88, z, false)
	return x,y,z
end

function getEulerAnglesFromMatrix(x1,y1,z1,x2,y2,z2,x3,y3,z3)
	local nz1,nz2,nz3
	nz3 = math.sqrt(x2*x2+y2*y2)
	nz1 = -x2*z2/nz3
	nz2 = -y2*z2/nz3
	local vx = nz1*x1+nz2*y1+nz3*z1
	local vz = nz1*x3+nz2*y3+nz3*z3
	return math.deg(math.asin(z2)),-math.deg(math.atan2(vx,vz)),-math.deg(math.atan2(x2,y2))
end

function SetCarVelocity(vehicle,x,y,z)
	local Addr = getCarPointer(vehicle)
	memory.setfloat(Addr+68, x, false)
	memory.setfloat(Addr+72, y, false)
	memory.setfloat(Addr+76, z, false)
end
trash=[[
	function GetCarAngles(vehicle)
	local Addr = memory.getint32(getCarPointer(vehicle)+20)
	local xr = memory.getfloat(Addr,false)
	local yr = memory.getfloat(Addr+4,false)
	local zr = memory.getfloat(Addr+8,false)
	return xr,yr,zr
	end
	
	function SetCarAngles(vehicle,x,y,z)
	local Addr = memory.getint32(getCarPointer(vehicle)+20)
	memory.setfloat(Addr+0, x, false)
	memory.setfloat(Addr+4, y, false)
	memory.setfloat(Addr+8, z, false)
	end
]]

function maitn()
	while true do
		wait(5)
		if isCharInAnyCar(PLAYER_PED) then
			if not sampIsChatInputActive() then
				if wasKeyPressed(KEY.VK_R) then
					local car = storeCarCharIsInNoSave(PLAYER_PED)
					local x,y,z = GetCarVelocity(car)
					local xq,yq,zq,wq = getVehicleQuaternion(car)
					--print(Quat.angleAxis(Quat(xq,yq,zq,wq)))
					if z < -0.01 then 
						SetCarVelocity(car,-x,-y,-z*1.054)
						else
						SetCarVelocity(car,-x,-y,-z)
					end
					--SetCarAngles(car,0.1,0.1,0)
					--setVehicleQuaternion(car,wq,xq,yq,zq*zq)
					setCarHeading(car,getCarHeading(car)+180)
					SetCarSpin(car,0,0,0)
					--printString(tostring(xq.. " ".. yq.. " ".. zq.. " ".. wq),10000)
				end
			end
		end
	end
end