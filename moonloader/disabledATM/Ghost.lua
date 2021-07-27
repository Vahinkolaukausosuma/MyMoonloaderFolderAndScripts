local KEY = require"lib.vkeys"

function mattttin()
	while true do
		wait(100)
		if isCharInAnyCar(PLAYER_PED) then
			local MyCar = storeCarCharIsInNoSave(PLAYER_PED)
			for k,v in pairs(getAllChars()) do
				if isCharInAnyCar(v) then
					local car = storeCarCharIsInNoSave(v)
					if car >= 0 then
						if MyCar ~= car then
							if v ~= PLAYER_PED then 
								if isKeyDown(KEY.VK_LSHIFT) then
									setCarCollision(car,false)
									else setCarCollision(car,true)
								end
							end
						end
					end
				end
			end
		end
	end
end