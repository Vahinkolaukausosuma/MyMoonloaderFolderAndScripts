local KEY =		require"lib.vkeys"
local memory =	require"memory"
local GasAmount = 1.8
local Pointer = 0 
local stink = 0
local Bytes1 = {137, 142, 156, 4, 0, 0}
local Bytes2 = {137, 134, 156, 4, 0, 0}
local NOP = 144
local Addit = 0.45
local Pointer1 = 7003147
local TireRPMO = 0x848
local LowThrottle = 0.7
local LowThrottle = 0.6
local Pointer2 = 7003007
local Enabled = -1
local _Enabled = 5
local _EnabledWithTractionControl = 10
local _Disabled = -1
local EnableMessages = {}
EnableMessages[_Enabled] = "Enabled"
EnableMessages[_EnabledWithTractionControl] = "Enabled with traction control"
EnableMessages[_Disabled] = "Disabled"

function GetRearTireRPM(vehicle)
	local Addr = getCarPointer(vehicle)
	local t2 = math.abs(memory.getfloat(Addr+TireRPMO+4,true))
	local t4 = math.abs(memory.getfloat(Addr+TireRPMO+12,true))
	return math.floor(((t2+t4) / 2) * 67.7)
end
function GetFrontTireRPM(vehicle)
	local Addr = getCarPointer(vehicle)
	local t1 = math.abs(memory.getfloat(Addr+TireRPMO,true))
	local t3 = math.abs(memory.getfloat(Addr+TireRPMO+8,true))
	return math.floor(((t1+t3) / 2) * 67.7)
end


function GetCarVelocity(vehicle)
	local Addr = getCarPointer(vehicle)
	local x = memory.getfloat(Addr+68,true)
	local y = memory.getfloat(Addr+72,true)
	local z = memory.getfloat(Addr+76,true)
	return x,y,z
end


function CheckKey()
	if not sampIsChatInputActive() then
		local Add = 0
		if isKeyDown(KEY.VK_LSHIFT) then Add = Addit end
		
		if isKeyDown(KEY.VK_W) then
			if stink then
				memory.setfloat(Pointer,LowThrottle,true) return
				else
				memory.setfloat(Pointer,GasAmount+Add,true) return
			end
			else 
			memory.setfloat(Pointer,0,true)
		end
		if isKeyDown(KEY.VK_S) then
			memory.setfloat(Pointer,-GasAmount-Add,true) return
			else 
			memory.setfloat(Pointer,0,true)
		end
	end
end

function Hacc(bool)
	bool = bool > 0
	if bool then
		for i = 1,6 do 
			memory.setint8(Pointer1+i, NOP,true)
			memory.setint8(Pointer2+i, NOP,true)
		end
		else 
		for i = 1,6 do 
			memory.setint8(Pointer1+i, Bytes1[i],true)
			memory.setint8(Pointer2+i, Bytes2[i],true)
		end
	end
end

function main()
	sampRegisterChatCommand("gasmult", function(a)
		if tonumber(a) then
			if tonumber(a) > 5 or tonumber(a) < 0 then
				sampAddChatMessage("[ ! ] Value needs to be between 0 and 5",0xFFFF00)
				return
			end
			GasAmount = tonumber(a)
			sampAddChatMessage("[ ! ] Gas Multiplier set to: "..GasAmount,0xFFFF00)
		end
	end)
	while true do
		wait(0)
		if isCharInAnyCar(PLAYER_PED) then
			if Enabled == _Enabled or Enabled == _EnabledWithTractionControl then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				stink = false
				if Enabled == _EnabledWithTractionControl then
					local frpm = GetFrontTireRPM(car)
					local rpm = GetRearTireRPM(car)

					if rpm == 74 or frpm == 74 then
						stink = true
					end
				end
				Pointer = getCarPointer(car) + 1180
				CheckKey()
			end
		end
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F9) and not sampIsChatInputActive() then 
			if Enabled == _Disabled then Enabled = _Enabled
			elseif Enabled == _Enabled then Enabled = _EnabledWithTractionControl
			else Enabled = _Disabled
			end
			Hacc(Enabled) 
		print("Gas multiplier: "..EnableMessages[Enabled]) 
		end
	end
end