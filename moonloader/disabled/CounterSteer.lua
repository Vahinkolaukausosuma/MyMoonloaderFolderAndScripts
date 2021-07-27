local memory =	require"memory"
local KEY =		require"lib.vkeys"
local Vector =	require"lib.vector3d"
local Enabled = false
local TurnAddress = 0x06ADD22-1
local Bytes3 = {137, 142, 148, 4, 0 ,0}
local NOP = 144
local TurnRate = math.rad(2.3)
local Turn = 0
local ElapsedTime = os.clock()
local KeyHeld = false
local MaxTurn = 0.7
local SteerMult = 0.952
function GetCarVelocity(vehicle)
	local x = memory.getfloat(getCarPointer(vehicle)+68,false)
	local y = memory.getfloat(getCarPointer(vehicle)+72,false)
	local z = memory.getfloat(getCarPointer(vehicle)+76,false)
	return x,y,z
end

function HaccTurn(bool)
	if bool then
		for i = 1,6 do 
			memory.write(TurnAddress+i, NOP,1, false)
		end
		else 
		for i = 1,6 do 
			memory.write(TurnAddress+i, Bytes3[i],1, false)
		end
	end
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
	while true do
		wait(5)
		if Enabled then
			if isCharInAnyCar(PLAYER_PED) then
				local MyCar = storeCarCharIsInNoSave(PLAYER_PED)
				local p1 = Vector(getCarCoordinates(MyCar))
				local vel = Vector(GetCarVelocity(MyCar))
				local p2 = p1+(vel*-1)
				local A2 = CalcAngle(p1,p2)
				local Rot = Vector(GetVehicleRotation(MyCar))
				local AimAng = normalizeAngle(normalizeAngle(A2.x)-normalizeAngle(-90-math.deg(Rot.z)))
				local WheelTurn = getCarPointer(MyCar)+1172
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
				
				memory.setfloat(WheelTurn, AimAng, false)
				if math.abs(vel:length()) > 0.05 then
					memory.setfloat(WheelTurn, AimAng, false)
					else
					memory.setfloat(WheelTurn, Turn, false)
				end
			end
		end   
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F11) and not sampIsChatInputActive() then 
			Enabled = not Enabled
			HaccTurn(Enabled)
			print("CounterSteering: "..tostring(Enabled))
		end
	end 
end   






















