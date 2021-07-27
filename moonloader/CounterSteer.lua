--Made by Jonni steamcommunity.com/id/jonniih
local memory =	require"memory"
local KEY =		require"lib.vkeys"
local Vector =	require"lib.vector3d"
local sampev = 0
--local ffb = require"ffb"
local Enabled = false
local TurnAddress = 7003425
local Bytes3 = {137, 142, 148, 4, 0 ,0}
local NOP = 144
local TurnRate = math.rad(2.3)
local Turn = 0
local AimAng = 0
local G_WheelAng = 0.0
local ElapsedTime = os.clock()
local KeyHeld = false
local MaxTurn = 0.7
local MaxAngle = math.deg(1.8)
local MaxAngleRad = math.rad(MaxAngle)
local SteerMult = 0.852
local SampEvFuncRan = false
local LastSendVal = 0
-- local SteerMult = 1
--local SteerMult = 0.5 



function GetCarVelocity(vehicle)
	local car = getCarPointer(vehicle)
	local x = memory.getfloat(car+68,true)
	local y = memory.getfloat(car+72,true)
	local z = memory.getfloat(car+76,true)
	return x,y,z
end

function sampevEvents()
	sampev =  require"lib.samp.events"
	sampev.onVehicleSync = function(playerid,vehicleid,bs)
		if Enabled then
			local yeah,car = sampGetCarHandleBySampVehicleId(vehicleid)
			if yeah then
				local WheelAngleAdress = getCarPointer(car)+1172
				local ang = bs.leftRightKeys
				if ang > 128 then
					ang = 65536 - ang
					ang = -ang
				end
				-- ang = (Lerp(0.6,ang / -166,memory.getfloat(WheelAngleAdress,true))) + 0.001
				memory.setfloat(WheelAngleAdress,ang+0.001,true)
			end
		end
	end
	sampev.onSendVehicleSync = function(bs)
		if Enabled and isCharInAnyCar(PLAYER_PED) then
			-- local temp = math.floor(-(G_WheelAng*256))
			local MyCar = storeCarCharIsInNoSave(PLAYER_PED)
			local WheelAngleAdress = getCarPointer(MyCar)+1172
			local temp = -math.floor(math.min(-1,math.max(G_WheelAng,1))*256) 
			if temp > 128 then temp = 128 end
			if temp < -128 then temp = -128 end
			-- bs.leftRightKeys = math.floor(Lerp(0.3,temp,LastSendVal))
			bs.leftRightKeys = temp
			-- LastSendVal = temp
		end
	end
	SampEvFuncRan = true
end
function sampevEvents()
	sampev =  require"lib.samp.events"
	sampev.onVehicleSync = function(playerid,vehicleid,bs)
		if Enabled then
			local yeah,car = sampGetCarHandleBySampVehicleId(vehicleid)
			if yeah then
				local WheelAngleAdress = getCarPointer(car)+1172
				local ang = bs.leftRightKeys
				if ang > 128 then
					ang = 65536 - ang
					ang = -ang
				end
				ang = ang / -166
				memory.setfloat(WheelAngleAdress,ang,true)
			end
		end
	end
	sampev.onSendVehicleSync = function(bs)
		if Enabled and isCharInAnyCar(PLAYER_PED) then
			local MyCar = storeCarCharIsInNoSave(PLAYER_PED)
			local WheelAngleAdress = getCarPointer(MyCar)+1172
			local temp = -math.floor(memory.getfloat(WheelAngleAdress,true)*256)
			if temp > 128 then temp = 128 end
			if temp < -128 then temp = -128 end
			bs.leftRightKeys = temp
			--bs.upDownKeys = math.random(-5235,250420)
		end
	end
	SampEvFuncRan = true
end
function PatchTurning(bool)
	if bool then
		for i = 1,6 do 
			memory.setint8(TurnAddress+i, NOP,true)
		end
		else 
		for i = 1,6 do 
			memory.setint8(TurnAddress+i, Bytes3[i],true)
		end
	end
	print("CounterSteering: "..tostring(Enabled))
end

function GetVehicleRotation(vehicle)
	local qx, qy, qz, qw = getVehicleQuaternion(vehicle)
	rx = math.asin(2*qy*qz-2*qx*qw)
	ry = -math.atan2(qx*qz+qy*qw,0.5-qx*qx-qy*qy)
	rz = -math.atan2(qx*qy+qz*qw,0.5-qx*qx-qz*qz)
	return rx,ry,rz
end

function getDistance(x1,y1,z1,x2,y2,z2)
	return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) + (z1 - z2)*(z1 - z2))
end

function normalizeAngle(angle)
    local newAngle = angle
    while (newAngle <= -180) do newAngle = newAngle + 360 end
    while (newAngle > 180) do newAngle = newAngle - 360 end
    return newAngle
end

function CalcAngle(src, dst)
    angles = Vector(0,0,0)
    angles.x = (-math.atan2(dst.x - src.x, dst.y - src.y)) / math.pi * 180.0 + 90.0
    angles.y = (-math.atan2(dst.z - src.z, getDistance(src.x, src.y, src.z, dst.x, dst.y, dst.z))) * 180.0 / math.pi
    angles.z = 0.0
    return angles
end

function Lerp( delta, from, to )
	if ( delta > 1 ) then return to end
	if ( delta < 0 ) then return from end
	return from + ( to - from ) * delta
end


function main()
	while not isOpcodesAvailable() do wait(100) end
	while true do
		wait(5)
		if Enabled then
			if isCharInAnyCar(PLAYER_PED) then
				local MyCar = storeCarCharIsInNoSave(PLAYER_PED)
				if getDriverOfCar(MyCar) == PLAYER_PED then
					local p1 = Vector(getCarCoordinates(MyCar))
					local vel = Vector(GetCarVelocity(MyCar))
					local A2 = CalcAngle(p1,p1-vel)
					local Rot = Vector(GetVehicleRotation(MyCar))
					AimAng = normalizeAngle(A2.x-normalizeAngle(-90-math.deg(Rot.z)))
					local MovingAngleVelocity = math.abs(AimAng)
					local WheelAngleAdress = getCarPointer(MyCar)+1172
					
					AimAng = math.rad(AimAng)
					AimAng = AimAng * SteerMult
					
					KeyHeld = false
					if isKeyDown(KEY.VK_A) and not sampIsChatInputActive() then
						if Turn + TurnRate > MaxTurn then
							Turn = MaxTurn
							else 
							Turn = Turn + TurnRate
						end
						KeyHeld = true
						
					end
					if isKeyDown(KEY.VK_D) and not sampIsChatInputActive() then
						if Turn - TurnRate < -MaxTurn then
							Turn = -MaxTurn
							else 
							Turn = Turn - TurnRate
						end
						KeyHeld = true
					end
					if not KeyHeld then
						Turn = Lerp(0.12,Turn,0)
					end
					AimAng = AimAng + Turn
					
					if AimAng > MaxAngleRad then AimAng = MaxAngleRad end
					if AimAng < -MaxAngleRad then AimAng = -MaxAngleRad end 
					
					if math.abs(vel:length()) > 0.05 and MovingAngleVelocity < MaxAngle then
						G_WheelAng = AimAng
						else
						G_WheelAng = Turn
					end
					memory.setfloat(WheelAngleAdress, G_WheelAng, true)
				end
			end
		end
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F10) and not sampIsChatInputActive() then 
			if not SampEvFuncRan and isSampAvailable() then sampevEvents() end
			Enabled = not Enabled
			PatchTurning(Enabled)
		end
	end 
end