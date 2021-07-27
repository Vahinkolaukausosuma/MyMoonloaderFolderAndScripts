local sampev = require"lib.samp.events"
local KEY =		require"lib.vkeys"
local memory =	require"memory"
local Enabled = false
local RCCarHandle = false
local RCCarSampID = false
local turned = false
local TurnRate = math.rad(2.3)
local Turn = 0
local KeyHeld = false
local MaxTurn = 0.7
local gassed = false
local turnfunctionaddress = 0x43828F-1
local turnfunctionbytes = {137,134,148,4,0,0}
local throttlefunctionaddress = 0x4382B5-1
local throttlefunctionbytes = {137,142,156,4,0,0}
local NOP = 144
e = 0
local lastFoceUpdate = os.clock()


function PatchNPCDrivingFunctionsKinda(bool)
	if bool then
		for i = 1,6 do 
			memory.setint8(turnfunctionaddress+i, NOP,true)
			memory.setint8(throttlefunctionaddress+i, NOP,true)
		end
		else 
		for i = 1,6 do 
			memory.setint8(turnfunctionaddress+i, turnfunctionbytes[i],true)
			memory.setint8(throttlefunctionaddress+i, throttlefunctionbytes[i],true)
		end
	end
	print("Patched npc driving functions : " .. tostring(Enabled))
end


function SetRCVehicleID(id)
	id = tonumber(id)
	local result, car = sampGetCarHandleBySampVehicleId(id)
	if result then
		print("set vehicle to samp id " .. id .. ", handle: " .. car)
		RCCarHandle = car
		RCCarSampID = id
	end
end
--doesVehicleExist(1321232313321231231231211)
function Lerp( delta, from, to )
	if ( delta > 1 ) then return to end
	if ( delta < 0 ) then return from end
	return from + ( to - from ) * delta
end

--sampev.onSendUnoccupiedSync = function(data)
	--if RCCarSampID == data.vehicleId then
	--	data.moveSpeed.x = data.moveSpeed.x * 1.2
	--	data.moveSpeed.y = data.moveSpeed.y * 1.2
	--	data.moveSpeed.z = data.moveSpeed.z * 1.2
	--end

	--print(data.seatId)
	
--end
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100)
	end
	sampRegisterChatCommand("setrcid",SetRCVehicleID)
	
	while true do
		wait(8)
		if RCCarHandle and Enabled and doesVehicleExist(RCCarHandle) and not sampIsChatInputActive() then

			KeyHeld = false
			if isKeyDown(KEY.VK_LEFT) and not sampIsChatInputActive() then
				if Turn + TurnRate > MaxTurn then
					Turn = MaxTurn
					else 
					Turn = Turn + TurnRate
				end
				KeyHeld = true
			end
			if isKeyDown(KEY.VK_RIGHT) and not sampIsChatInputActive() then
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
			 
			memory.setfloat(getCarPointer(RCCarHandle)+1172, Turn, false)
			carGotoCoordinatesAccurate(RCCarHandle,0,0,0)
			setCarCruiseSpeed(RCCarHandle,230)
			setCarDrivingStyle(RCCarHandle,3)
			setCarMission(RCCarHandle,1)
			carWanderRandomly(RCCarHandle)
			
			if os.clock()-lastFoceUpdate > 0.1 then
				lastFoceUpdate = os.clock()
				--print("uipdating")
				sampForceUnoccupiedSyncSeatId(RCCarSampID,0)
				e=e+1
				printString(e,1000)
			end
			
			
			gassed = false
			if isKeyDown(KEY.VK_UP) and not gassed then memory.setfloat(getCarPointer(RCCarHandle)+1180, 1, false) gassed = true end
			if isKeyDown(KEY.VK_DOWN) and not gassed  then memory.setfloat(getCarPointer(RCCarHandle)+1180, -1, false) gassed = true end
			if not gassed then memory.setfloat(getCarPointer(RCCarHandle)+1180, 0, false) end 
			
		end
		
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F5) and not sampIsChatInputActive() then
			Enabled = not Enabled
			PatchNPCDrivingFunctionsKinda(Enabled)
			if not Enabled and doesVehicleExist(RCCarHandle) then
				carSetIdle(RCCarHandle)
			end
			print("RC Car now: ".. tostring(Enabled))
		end
	end
end
