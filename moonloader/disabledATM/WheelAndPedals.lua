local Aim = require "lib.Aim"
local Vector = require"lib.vector3d"
local memory = require"memory"
local mad = 	require 'MoonAdditions'
local key = require"lib.vkeys"

function getAimVector()
	local yaw = memory.getfloat(0xB6F258,false)
	local pitch = memory.getfloat(0xB6F248,false)+0.1
	x = (math.cos(yaw)*math.cos(pitch))
	y = (math.sin(yaw)*math.cos(pitch))
	z = math.sin(pitch)
	return Vector(-x,-y,z)
end
function M1Held()
	if memory.getint8(0x0B7347A,false) == 255 then return true else return false end
end

table.Count = function(Table)
	local Count = 0
	for k,v in pairs(Table) do
		Count = Count + 1
	end
	return Count
end
LPrint = function(Table) for k,v in pairs(Table) do print(k,v) end end
function getVehicle()
	for k,v in pairs(getAllVehicles()) do
		if getCarModel(v) == 541 then
			return v
		end
	end
	return false
end

function calculateTrajectory(initialVelocity, gravityInY, time)
	local outDisplacement = Vector(0,0,0)
	local timeSquared = time * time
	
	outDisplacement.x = initialVelocity.x * time
	outDisplacement.y = initialVelocity.y * time
	outDisplacement.z = (initialVelocity.z * time) + 0.5*(gravityInY * timeSquared)
	return outDisplacement
end

function mainttttt()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(200)
	end
	if sampGetCurrentServerAddress() == "37.187.111.39" then print("okbye") return end
	
	while true do
		wait(8)
		if Aim.getActiveCamMode() == 53 then
			--local Veh = getVehicle()
			--if Veh then
			--	if M1Held() then
			OldX,OldY,LastVec = nil,nil,nil
			
			for i = 1,1000 do
				local Pos = Vector(getCharCoordinates(PLAYER_PED)) + Vector(0,0,0.8)
				local Vec =  calculateTrajectory(getAimVector()*500, -9.81^2, 0.01*i)
				local Calc = Pos+Vec
				--local _,x,y = convert3DCoordsToScreenEx(Pos.x+Vec.x, Pos.y+Vec.y, Pos.z+Vec.z+0.8,true,true)
				
				local x,y = convert3DCoordsToScreen(Pos.x+Vec.x, Pos.y+Vec.y, Pos.z+Vec.z)
				if LastVec then
					requestCollision(Pos.x+LastVec.x,Pos.y+LastVec.y)
					local HitTable = mad.get_collision_between_points(Pos.x+LastVec.x,Pos.y+LastVec.y,Pos.z+LastVec.z, Pos.x+Vec.x, Pos.y+Vec.y, Pos.z+Vec.z)
					if HitTable then
						printString("hit, ".. i,8)
						if wasKeyPressed(key.VK_E) then
							local zZ = getGroundZFor3dCoord(Pos.x+Vec.x, Pos.y+Vec.y, Pos.z+Vec.z)
							if zZ > Pos.z+Vec.z then 
								setCharCoordinates(PLAYER_PED,Pos.x+Vec.x, Pos.y+Vec.y, zZ+0.3)
								else
								setCharCoordinates(PLAYER_PED,Pos.x+Vec.x, Pos.y+Vec.y, Pos.z+Vec.z+0.3)
							end
						end
						break
					end
				end
				--print(Vec,_,x,y)
				if OldX and OldY then
					if x >= 0 and x <= 1920 then
						if y >= 0 and y <= 1080 then
							renderDrawLine(OldX,OldY,x,y, 2, 0xFFFFFFFF)
						end
					end
				end
				OldX,OldY,LastVec = x,y,Vec
			end
			--	end
			--	end
		end
	end
end
