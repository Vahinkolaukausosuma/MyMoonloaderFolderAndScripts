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


function main() 
	sampRegisterChatCommand("targethp", function(a) targetHP = tonumber(a) end)
	while ttrue do 
		wait(8)
		
		printString(targetHP,100)
	end
end
