local sampev = require"lib.samp.events"
local KEY =		require"lib.vkeys"
local memory =	require"memory"
local Vector =	require"lib.vector3d"
local Enabled = false
local DriverSampID = false
local qWasHeld = false
local eWorldColor = 0xFF86C238
local afkColor = 0xFF444444
local NewDriverClock = 0
local eWasHeld = false
function SetDriver(id)
	DriverSampID = tonumber(id)
end


--dawsampev.onPlayerSync = function(plyid,data)
sampev.tonPassengerSync = function(plyid,data)
	--printStringNow(tostring(Enabled) .. " " .. tostring(DriverSampID),100)
	if Enabled and not sampIsChatInputActive() then
		if DriverSampID then
			if plyid == DriverSampID then
				
				local Left = data.leftRightKeys == 65408
				local Right = data.leftRightKeys == 128
				local Forward = data.upDownKeys == 65408 or data.keys.secondaryFire_shoot == 1
				local Backward = data.upDownKeys == 128 or data.keys.primaryFire == 1 
				
				setVirtualKeyDown(KEY.VK_A,Left)
				setVirtualKeyDown(KEY.VK_D,Right)
				setVirtualKeyDown(KEY.VK_W,Forward)
				setVirtualKeyDown(KEY.VK_S,Backward)
			end
		end
	end
end
--sampev.onPassengerSync = nil

sampev.onPlayerSync = function(plyid,data)
	--printStringNow(tostring(Enabled) .. " " .. tostring(DriverSampID),100)
	if Enabled and not sampIsChatInputActive() then
		if DriverSampID then
			if plyid == DriverSampID then
				
				local Left = data.leftRightKeys == 65408
				local Right = data.leftRightKeys == 128
				local Forward = data.upDownKeys == 65408
				local Backward = data.upDownKeys == 128
				
				setVirtualKeyDown(KEY.VK_A,Left)
				setVirtualKeyDown(KEY.VK_D,Right)
				setVirtualKeyDown(KEY.VK_W,Forward)
				setVirtualKeyDown(KEY.VK_S,Backward)
			end
		end
	end
end
sampev.onPlayerSync = nil



function GetCarVelocity(vehicle)
	local ptr = getCarPointer(vehicle)
	local x = memory.getfloat(ptr+68,false)
	local y = memory.getfloat(ptr+72,false)
	local z = memory.getfloat(ptr+76,false)
	return x,y,z
end

function GetVehicleRotation(veh)
	local x,y,z,w = getVehicleQuaternion(veh)
	local rx = math.asin(2*y*z-2*x*w) or 0
	local ry = -math.atan2(x*z+y*w,0.5-x*x-y*y) or 0
	local rz = -math.atan2(x*y+z*w,0.5-x*x-z*z) or 0
	return rx,ry,rz
end

function getRandomPlayerIDWithThisColor(col) 
	local myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local plys = {}
	for i = 0,sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local pColor = sampGetPlayerColor(i)
			if pColor == col and i ~= myId then
				plys[#plys+1] = i
			end
		end
	end
	return plys[math.random(1,#plys)]
end

function maint()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100)
	end
	
	sampRegisterChatCommand("setdriverid",SetDriver)
	
	while true do -- Randm EVent player control
		wait(8)
		if EEnabled then
			if os.clock()-NewDriverClock > 5 then
				if isCharInAnyCar(PLAYER_PED) then
					if not sampIsChatInputActive() and isGameWindowForeground() then
						local PlyID = getRandomPlayerIDWithThisColor(afkColor)
						local name = sampGetPlayerNickname(PlyID)
						SetDriver(PlyID)
						NewDriverClock = os.clock()
						--sampSendChat(name .. "(" .. PlyID ..  ")" .. " is controlling the vehicle !")
						sampAddChatMessage(name .. "(" .. PlyID ..  ")" .. " is controlling the vehicle !",eWorldColor)
					end
				end
			end
		end
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F6) and not sampIsChatInputActive() then
			Enabled = not Enabled
			print("PedDriver now: ".. tostring(Enabled))
		end
	end
end





--[[
	while traue do
	wait(0)
	
	if Enabled then
	if isCharInAnyPlane(PLAYER_PED) then
	if not sampIsChatInputActive() and isGameWindowForeground() then
	local vehicle = storeCarCharIsInNoSave(PLAYER_PED)
	if qWasHeld and isKeyDown(KEY.VK_Q) and isKeyDown(KEY.VK_E) and not eWasHeld then
	setVirtualKeyDown(KEY.VK_Q,false)
	end
	if eWasHeld and isKeyDown(KEY.VK_E) and isKeyDown(KEY.VK_Q) and not qWasHeld then
	setVirtualKeyDown(KEY.VK_E,false)
	end
	end
	end
	end
	qWasHeld = isKeyDown(KEY.VK_Q)
	eWasHeld = isKeyDown(KEY.VK_E)
	if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F6) and not sampIsChatInputActive() then
	Enabled = not Enabled
	print("PedDriver now: ".. tostring(Enabled))
	end
	end
	
	
	while trute do
	wait(16)
	if Enabled then
	if isCharInAnyCar(PLAYER_PED) then
	
	if isKeyDown(KEY.VK_W) and not sampIsChatInputActive() and isGameWindowForeground() then
	local car = storeCarCharIsInNoSave(PLAYER_PED)
	local x,y,z = GetVehicleRotation(car)
	local qx = (math.cos(x)*math.cos(y))
	local ang = 89-math.floor(qx*90)
	local speed = math.floor(Vector(GetCarVelocity(car)):length() * 180.5) 
	--printStringNow(ang,100)
	local up = ang <= 300
	local down = ang >= 22
	if down then up = false end
	if speed > 180 then
	--setVirtualKeyDown(KEY.VK_SPACE,up)
	--setVirtualKeyDown(KEY.VK_LSHIFT,down)
	end
	end
	end
	end
	if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F6) and not sampIsChatInputActive() then
	Enabled = not Enabled
	print("PedDriver now: ".. tostring(Enabled))
	end
	end
--]]