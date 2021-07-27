local KEY = require"lib.vkeys"
local memory =	require"memory"


function GetCarVelocity()
	local Addr = getCarPointer(storeCarCharIsInNoSave(PLAYER_PED))
	local x = memory.getfloat(Addr+68,false)
	local y = memory.getfloat(Addr+72,false)
	local z = memory.getfloat(Addr+76,false)
	return x,y,z
end

function SendCarFlying(Multiplier)
	if not Multiplier then Multiplier = 1 end
	local _, PlayerID = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local data = allocateMemory(67)
	sampStorePlayerIncarData(PlayerID, data)

	local x,y,z = GetCarVelocity()
	x = x * Multiplier
	y = y * Multiplier
	z = z * Multiplier
	setStructFloatElement(data, 36, x, false)
	setStructFloatElement(data, 40, y, false)
	setStructFloatElement(data, 44, z, false)
	sampSendIncarData(data)
	freeMemory(data)
end

function main()
	while true do
		wait(1)
		if isCharInAnyCar(PLAYER_PED) then
			if not sampIsChatInputActive() then
				if isKeyDown(KEY.VK_R) then
					local car = storeCarCharIsInNoSave(PLAYER_PED)
					SendCarFlying(5)
				end
			end
		end
	end
end

asasas=[[
	while true do
	--wait(100)
	SendCarFlying()
	end]]