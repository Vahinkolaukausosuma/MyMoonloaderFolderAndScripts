local sampev = require"lib.samp.events"
local memory = require"memory"
local mad = require 'MoonAdditions'
local Vector = require"lib.vector3d"
local bullets = {}
local DeagleShotMaxDist = 0 
local lastmsg = ""
_G["ToHex"] = function(num) local s = string.upper(string.format("%x", num * 256)) return string.sub(s,1,string.len(s)-2) end
function FindNumber()
	for i = 0,200 do
		if not bullets[i] then return i end
	end
end

sampev.onBulletSync = function(id,b)
	MakeBulletTrace(b,id)
end
sampev.onSendBulletSync = function(b)
	MakeBulletTrace(b)
end
sampev.onStendGiveDamage = function(playerid,damage,weaponid,bone,somebool)
	if weaponid > 22 then
		local name = sampGetPlayerNickname(playerid)
		if bone == 9 then bone = "(9) Head" end
		msg = "Hit " ..name .. " damage: " .. tostring(damage):sub(1,4) .. " on bone ".. bone
--if msg ~= lastmsg then 
			print(msg)
		--end
		lastmsg = msg
	end
end

function MakeBulletTrace(b,id)
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
			local TableIndex = FindNumber()
			if TableIndex then
			r = math.random(30,200)  
			g = math.random(30,200)
			b = math.random(30,200)
			if not id then id = false end
				bullets[TableIndex] = {
					Origin = Vector(xOrigin, yOrigin, zOrigin) ,
					Hit = Vector(xHit, yHit, zHit),   
					Time = gameClock()+4, 
					r = r,
					g = g,
					b = b,
					Color = "0xD2"..ToHex(r)..ToHex(g)..ToHex(b)
				}
				if id then bullets[TableIndex].Name = sampGetPlayerNickname(id) end
			end
		end
	end
end

function mtain()
	while not isSampAvailable() or not isOpcodesAvailable() or not isSampfuncsLoaded() do wait(100) end
	while true do
		wait(0)
		for i = 0,200 do
			if bullets[i] then 
				if bullets[i].Time > gameClock() then
					local x,y = convert3DCoordsToScreen(bullets[i].Origin:get())
					local x2,y2 = convert3DCoordsToScreen(bullets[i].Hit:get())
					local a,s,d = bullets[i].Hit:get()
					local f,g,h = bullets[i].Origin:get()
					if isPointOnScreen(a,s,d,0) then
						if isPointOnScreen(f,g,h,0) then
							renderDrawLine(x,y,x2,y2,4,bullets[i].Color)
							renderDrawPolygon(x2,y2, 20 ,20 , 5, 5, bullets[i].Color)
							if bullets[i].Name then
								mad.draw_text(bullets[i].Name, x ,y-20 , mad.font_style.MENU, 0.4, 0.9, mad.font_align.CENTER, 640, true, false, bullets[i].r, bullets[i].g, bullets[i].b, 255, 0, 1)
							end
						end
					end
					else bullets[i] = nil
				end
			end 
		end
	end
end


adwdkkdawop= [[				if meem then
					if getCurrentCharWeapon(PLAYER_PED) == 24 then
						local dist = getDistanceBetweenCoords3d(xOrigin, yOrigin, zOrigin, xHit, yHit, zHit)
						if xHit ~= 0 and yHit ~= 0 and zHit ~= 0 then 
							if dist >= DeagleShotMaxDist then
								if dist < 400 then
									DeagleShotMaxDist = dist 
									print("Deagle shot distance ".. dist)
								end
							end
						end
					end
				end]]