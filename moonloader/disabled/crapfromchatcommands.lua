
function FindVehicleID(fMass, fTurnMass, fDragMult, fBrakeBias)
	for i = 0,211 do
		if IsCloseTo(memory.getfloat(0xC2B9DC+ (i*224)+0x4,false), fMass,0.01) then
			if IsCloseTo(memory.getfloat(0xC2B9DC+ (i*224)+0xC,false), fTurnMass,0.01) then
				if IsCloseTo(memory.getfloat(0xC2B9DC+ (i*224)+0x10,false), fDragMult,0.01) then
					if IsCloseTo(memory.getfloat(0xC2B9DC+ (i*224)+0x98,false), fBrakeBias,0.01) then
						return i
					end
				end
			end
		end
	end
end
function p(name)
	for i = 0,sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local nameL = sampGetPlayerNickname(i)
			if string.find(string.lower(nameL),string.lower(name)) then
				return i,nameL
			end
		end
	end
	return nil
end
function GetCarData(plus)
	local _, PlayerID = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local data = allocateMemory(67)
	sampStorePlayerIncarData(PlayerID, data)
	local x = memory.getfloat(data+plus)
	freeMemory(data)
	return x
end



fesfe=[[
	function MakeBulletTrace(b,meem)
	--if table.Count(bullets) > 200 then bullets = {} end
	b = tostring(b)
	b = tonumber(string.sub(b,33,string.len(b)))+3
	local xOrigin = memory.getfloat(b) 
	local yOrigin = memory.getfloat(b+4)
	local zOrigin = memory.getfloat(b+8)
	local xHit = memory.getfloat(b+12)
	local yHit = memory.getfloat(b+16)
	local zHit = memory.getfloat(b+20)
	if zHit ~= 0 then
	if xOrigin and yOrigin and zOrigin and xHit and yHit and zHit then
	if FindNumber() then
	bullets[FindNumber()] = {
	Origin = Vector(xOrigin, yOrigin, zOrigin),
	Hit = Vector(xHit, yHit, zHit),
	Time = gameClock()+4,
	Color = "0xD2"..ToHex(math.random(30,200))..ToHex(math.random(30,200))..ToHex(math.random(30,200))
	}
	if meem then
	if getCurrentCharWeapon(PLAYER_PED) == 24 then
	local dist = getDistanceBetweenCoords3d(xOrigin, yOrigin, zOrigin, xHit, yHit, zHit)
	if dist >= DeagleShotMaxDist then
	if xHit ~= 0 and yHit ~= 0 and zHit ~= 0 then 
	DeagleShotMaxDist = dist 
	print("Deagle shot distance ".. dist)
	end
	end
	end
	end
	end
	end
	end
end]]





--[[
	function SendCarToPlayer(PlayerID,VehicleID) -- /lm for i =  1,200 do SendCarFlyingEx(12,i) end
	local data = allocateMemory(67)
	local x,y,z = 0,0,0
	local _,Handlee = sampGetCharHandleBySampPlayerId(PlayerID)
	
	sampStorePlayerIncarData(PlayerID, data)
	
	if _ then
	print(_,Handlee)
	if not isCharInAnyCar(Handlee) then
	xX,yY,zZ = getCharCoordinates(Handlee)
	print(xX,yY,zZ)
	setStructFloatElement(data, 32, xX, false)
	setStructFloatElement(data, 36, yY, false)
	setStructFloatElement(data, 40, zZ+20.0,false)
	end
	end
	print"aeokpdw"
	if VehicleID then
	setStructElement(data, 0, 2, VehicleID, false)
	end
	sampSendIncarData(data)
	freeMemory(data)
	end
--]]

--[[
	function GetCarDataEx()
	local _, PlayerID = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local data = allocateMemory(67)
	sampStorePlayerIncarData(PlayerID, data)
	--freeMemory(data)
	return data
	end
	function SendCarFlying()
	local _, PlayerID = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local data = allocateMemory(67)
	sampStorePlayerIncarData(PlayerID, data)
	setStructFloatElement(data, 44, 4, 4.0, false)
	sampSendIncarData(data)
	freeMemory(data)
	end
	function SendCarFlyingEx(PlayerID,VehicleID) -- /lm for i =  1,200 do SendCarFlyingEx(12,i) end
	local data = allocateMemory(67)
	sampStorePlayerIncarData(PlayerID, data)
	setStructFloatElement(data, 40, 0.0, false)
	setStructFloatElement(data, 36, 0.0, false)
	setStructFloatElement(data, 32, 0.0,false)
	
	if VehicleID then
	setStructElement(data, 0, 2, VehicleID, false)
	end
	sampSendIncarData(data)
	freeMemory(data)
	end
]]
--[[
	sampev.onSendTakeDamage = function(id,damage,bone)
	if id and damage and bone tööhen
	local name = sampGetPlayerNickname(id)
	if name then
	print(name.." did ".. damage.. " damage on bone "..bone)
	end
	end
	end

function SendCarFlyingohshitohfuckdontusethiseverlol(PlayerID)
	local data = allocateMemory(67)
	sampStorePlayerIncarData(PlayerID, data)
	setStructFloatElement(data, 44, 4, 4.0, false)
	sampSendIncarData(data)
	freeMemory(data)
end
]]--
	function SendCarFlyingEx(PlayerID,VehicleID) -- /lm for i =  1,200 do SendCarFlyingEx(12,i) end
	local data = allocateMemory(67)
	sampStorePlayerIncarData(PlayerID, data)
	setStructFloatElement(data, 40, 0.0, false)
	setStructFloatElement(data, 36, 0.0, false)
	setStructFloatElement(data, 32, 0.0,false)
	
	if VehicleID then
	setStructElement(data, 0, 2, VehicleID, false)
	end
	sampSendIncarData(data)
	freeMemory(data)
	end







	-- while true do
	-- wait(8)
	-- local resultME,MyID = sampGetPlayerIdByCharHandle(PLAYER_PED)
	-- if not resultME then return end
	-- local MyPing = sampGetPlayerPing(MyID)/1000
	-- for k,v in pairs(getAllChars()) do
	-- local vel = Vector(getCharVelocity(v))
	-- local pos = Vector(getCharCoordinates(v))
	-- local result,id = sampGetPlayerIdByCharHandle(v)
	-- if result then
	-- local ping = sampGetPlayerPing(id)/1000
	-- local x1,y1 = convert3DCoordsToScreen(pos:get())
	-- local x2,y2 = convert3DCoordsToScreen((pos+(vel*(ping+MyPing))):get())
	
	-- renderDrawLine(x1,y1,x2,y2, 2, 0xFFFF00FF)
	-- end
	-- end
	
--end


--memory.getfloat(0xC2B9DC+0x4,false) -- fMass
--memory.getfloat(0xC2B9DC+0xC,false) -- fTurnMass
--memory.getfloat(0xC2B9DC+0x10,false) -- fDragMult
--memory.getfloat(0xC2B9DC+0x98,false) -- fBrakeBias



function Hacc(bool)
	if bool then
		for i = 1,6 do 
			memory.write(Pointer1+i-1, NOP,1, false)
			memory.write(Pointer2+i-1, NOP,1, false)
		end
		else 
		for i = 1,6 do 
			memory.write(Pointer1+i-1, Bytes1[i],1, false)
			memory.write(Pointer2+i-1, Bytes2[i],1, false)
		end
	end
end


function getTraceHitPosEx(x1,y1,z1,x2,y2,z2)
	aa = Trace(x1,y1,z1,x2,y2,z2,{})
	if aa and aa.position then
		local a = tostring(aa.position)
		if a then
			local Addr = memory.getint32(tonumber((string.sub(a,11,string.len(a)))))
			local x = memory.getfloat(Addr,false)
			local y = memory.getfloat(Addr+4,false)
			local z = memory.getfloat(Addr+8,false)
			return x,y,z
		end
	end
	return nil
end
function getTraceHitPos(x1,y1,z1,x2,y2,z2)
	local a,b = processLineOfSight(x1,y1,z1,x2,y2,z2, true, true, false, true, false, false, false, false)
	if a then
		return b.pos[1],b.pos[2],b.pos[3]
	end
	return nil
end

function tprint (tbl, indent)
	if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			tprint(v, indent+1)
			elseif type(v) == 'boolean' then
			print(tostring(formatting) .. tostring(v))      
			else
			print(tostring(formatting) .. tostring(v))
		end
	end
end


function FString2(...)
	local msg = "" 
	for k,v in pairs({...}) do
		if type(v) ~= "function" then
			if type(v) == "table" then
				--for j,i in pairs(v) do
				msg = msg .. v.x .." "  .. x.y .. " " .. v.z .. "\n"
				--msg = msg .. tostring(j,i) .. "\n"
				--end
				else msg = msg .. tostring(v) .. "\n"
			end
		end
	end
	return msg
end



local Pointer = 0
local Bytes1 = {137, 142, 156, 4, 0, 0}
local Bytes2 = {137, 134, 156, 4, 0, 0}
local NOP = 144
local Pointer1 = 0x06ADC0C
local Pointer2 = 0x06ADB80

function FString(...)
	local msg = "" 
	for k,v in pairs({...}) do
		if type(v) == "table" then
			for j,i in pairs(v) do
				msg = msg .. tostring(i) .. " "
			end
			else msg = msg .. tostring(v) .. " "
		end
		
	end
	return msg
end

--sampev.onSendUnoccupiedSync = function(data)
--	print(data.vehicleId,data.seatId)
--end
--/lm require"lib.samp.events".onSendEditAttachedObject = function(...) pront(...) end
