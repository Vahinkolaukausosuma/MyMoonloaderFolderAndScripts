local tsampev = require"lib.samp.events"
mad = require "MoonAdditions"
targetHP = 200
sampev.onSendGiveDamage = function(playerid,damage,weaponid,bone,somebool) 
	targetHP = targetHP-damage
	if weaponid >= 22 then
		local name = sampGetPlayerNickname(playerid)
		if bone == 9 then bone = "(9) Head" end
		msg = "Hit " ..name .. " damage: " .. tostring(damage) .. " on bone ".. bone
		print(msg)
	end
end
pickups = {{x=11,y=50,500}}
pickups = {}
sampev.otnCreatePickup = function(id, model, pickuptype, pos)
	if model ~= 1239 and model ~= 1274 and model ~=  1318 and model ~= 1239 and model ~= 1273 and model ~= 11738 and model ~= 1272 then
		table.insert(pickups,pos)

		else
		print("id: " .. id)
			-- .. " new pickup model id: " .. model)
		-- local x,y,z = getCharCoordinates(PLAYER_PED)
		-- local Dist = getDistanceBetweenCoords3d(pos.x,pos.y,pos.z,x,y,z)
		-- print("dist " .. Dist)
		-- print("new pickup model id: " .. model .. " but nasty model")
		-- local x,y,z = getCharCoordinates(PLAYER_PED)
		-- local Dist = getDistanceBetweenCoords3d(pos.x,pos.y,5,x,y,5)
		-- print("dist same z " .. Dist)
	end
	
	
end

function main() 
	sampRegisterChatCommand("targethp", function(a) targetHP = tonumber(a) end)
	while ttrue do 
		wait(8)
		
		printString(targetHP,100)
	end
	while trtue do
		wait(4)
		for k,v in pairs(pickups) do
		local _,x,y = convert3DCoordsToScreenEx(v.x,v.y,v.z,true,true)
			if x < 1920 and x >= 0 then
				if y < 1080 and y >= 0 then
					renderDrawLine(1920/2, 1080,x,y, 2, 0xFFFFFFFF)
					--mad.draw_text("~r~pickup".. , x, y-20, mad.font_style.MENU, 0.4, 0.9, mad.font_align.CENTER, 640, true, false, 255, 255, 255, 255, 0, 1)
				end	
			end
		end
	end
	wait(-1)

end
-- sampev.onSendTakeDamage = function(playerid,damage,weaponid,bone,somebool)
-- if weaponid > 22 then
-- local name = sampGetPlayerNickname(playerid)
-- if bone == 9 then bone = "(9) Head" end
-- msg = name .. " shot you damage: " .. tostring(damage):sub(1,4) .. " on bone ".. bone
-- print(msg)
-- end
-- end
