
--local mad = require 'MoonAdditions'
local Aim =		require "lib.Aim"
local KEY =		require"lib.vkeys"
local memory =	require"memory"

local Pointer = 0
local Bytes1 = {137, 142, 156, 4, 0, 0}
local Bytes2 = {137, 134, 156, 4, 0, 0}
local Bytes3 = {137, 142, 148, 4, 0 ,0}
local NOP = 144
local Pointer1 = 0x06ADC0C
local Pointer2 = 0x06ADB80
local TurnAddress = 0x06ADD22
local Enabled = false
local LastX = 0
local LastY = 0

function Lerp( delta, from, to )
	if ( delta > 1 ) then return to end
	if ( delta < 0 ) then return from end
	return from + ( to - from ) * delta
end

function Hacc(bool)
	if bool then
		for i = 1,6 do 
			memory.write(Pointer1+i-1, NOP,1, false)
			memory.write(Pointer2+i-1, NOP,1, false)
			memory.write(TurnAddress+i-1, NOP,1, false)
		end
		else 
		for i = 1,6 do 
			memory.write(Pointer1+i-1, Bytes1[i],1, false)
			memory.write(Pointer2+i-1, Bytes2[i],1, false)
			memory.write(TurnAddress+i-1, Bytes3[i],1, false)
		end
	end
end

function main()
	while true do 
		wait(1)
		if isCharInAnyCar(PLAYER_PED) then
			if Enabled then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				local TurnA = memory.getint16(0x0B702AC,false)
				local Forward = (2000-(memory.getint16(0x0B702B0,false)))/2000
				local Backward = (2000-(memory.getint16(0x0B702C0,false)))/2000
				local Ang = TurnA/3200
				local WheelTurn = getCarPointer(car)+1172
				local ForwardPedal = getCarPointer(car)+1180
				--local BackwardPedal = getCarPointer(car)+1184
				memory.setfloat(WheelTurn, -Ang, false)
				--memory.setfloat(0x0B73494, 255, false)
				--0x0C8CFBF gtx 1060
				if Forward > Backward then
					memory.setfloat(ForwardPedal, Forward, false)
					memory.write(0x0B73478, 255,1, false)
					memory.write(0x0B73474, 0,1, false)
					else
					memory.setfloat(ForwardPedal, -Backward, false)
					memory.write(0x0B73478, 0,1, false)
				end
				if Backward > 0.001 then memory.write(0x0B73474, 255,1, false) end
				
				local CamX, CamY = getCarCoordinates(storeCarCharIsInNoSave(PLAYER_PED))
				local YAngle = Aim.GetAngleBeetweenTwoPoints(LastX,LastY,CamX, CamY)
				if math.abs(CamX-LastX) > 0.001 and math.abs(CamY-LastY) > 0.001 then
					Aim.At(memory.getfloat(0xB6F248,false),YAngle)
					LastX = Lerp(0.95,CamX,LastX)
					LastY = Lerp(0.95,CamY,LastY)
				end
			end
		end
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F10) and not sampIsChatInputActive() then 
			Enabled = not Enabled
			Hacc(Enabled)
			print("Autocam now: "..tostring(Enabled))
		end
	end
end

uselessshit = 
[[
	while false do
	wait(0)
	if isPlayerPlaying(PLAYER_HANDLE) then
	if not isCharDead(PLAYER_PED) then
	for k,char in pairs(getAllChars()) do
	if char ~= PLAYER_PED then
	local bool,id = sampGetPlayerIdByCharHandle(char)
	if not bool then name = id else name = sampGetPlayerNickname(id) end
local bone = mad.get_char_bone(char, 7)
local bone = bone.matrix.pos
local MeX, MeY, MeZ = getActiveCameraCoordinates()
local Dist = getDistanceBetweenCoords3d(bone.x,bone.y,bone.z,MeX, MeY, MeZ)
if Dist > 45 then
local _,x,y = convert3DCoordsToScreenEx(bone.x,bone.y,bone.z+0.8,true,true)
mad.draw_text("~r~".. name, x, y, mad.font_style.MENU, 0.4, 0.9, mad.font_align.CENTER, 640, true, false, 255, 255, 255, 255, 0, 1)
end
end
end
end
end
end


function main3()
while false do
if not sampIsChatInputActive() then
if isKeyDown(KEY.VK_P) then
if isPlayerControlLocked() then
Aim.At(0,memory.getfloat(0xB6F258,false) + 0.016)
else
Aim.At(memory.getfloat(0xB6F248,false),memory.getfloat(0xB6F258,false) + 0.010)
end 
end
end 
wait(5) 
end
end

]]