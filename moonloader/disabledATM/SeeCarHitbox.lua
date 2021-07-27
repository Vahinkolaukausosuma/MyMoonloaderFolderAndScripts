local memory =	require"memory"
Enabled = true
PlayerVehicle = {}
function GetCarVelocity(vehicle)
	local x = memory.getfloat(getCarPointer(vehicle)+68,false)
	local y = memory.getfloat(getCarPointer(vehicle)+72,false)
	local z = memory.getfloat(getCarPointer(vehicle)+76,false)
	return x,y,z
end


function DelGhosts() 
	while Enabled do
		wait(30000)
		for k,v in pairs(getAllVehicles()) do
			if not sampGetVehicleIdByCarHandle(v) then
				deleteCar(v)
			end 
			PlayerVehicle[v] = nil
		end 
	end
end



function matin()
	lua_thread.create(DelGhosts) 
	while true do
		wait(5)
		if isCharInAnyCar(PLAYER_PED) then
			local MyCar = storeCarCharIsInNoSave(PLAYER_PED)
			local MyPing = sampGetPlayerPing(sampGetPlayerIdByCharHandle(PLAYER_PED))
			for k,v in pairs(getAllChars()) do
				if isCharInAnyCar(v) then 
					local car = storeCarCharIsInNoSave(v)
					if car >= 0 then
							if MyCar ~= car then
						if not PlayerVehicle[car] then
							local x,y,z = getCarCoordinates(car)
							local Vx, Vy, Vz = GetCarVelocity(car)
							PlayerVehicle[car] = createCar(getCarModel(car),x,y,z)
							changeCarColour(PlayerVehicle[car],getCarColours(car))
							setCarCollision(PlayerVehicle[car],false)
							giveVehiclePaintjob(PlayerVehicle[car],getCurrentVehiclePaintjob(car))
							else 
							local x,y,z = getCarCoordinates(car)
							local Vx, Vy, Vz = GetCarVelocity(car)
							local ping = (sampGetPlayerPing(sampGetPlayerIdByCharHandle(v))*2) + (MyPing*2)
							ping = ping/10
							Vx = Vx * ping
							Vy = Vy * ping
							Vz = Vz * ping
							setCarCoordinatesNoOffset(PlayerVehicle[car],x+Vx, y+Vy, z+Vz)
							setCarHeading(PlayerVehicle[car],getCarHeading(car))
							setCarCollision(PlayerVehicle[car],false)
							--setVehicleQuaternion(PlayerVehicle[car],getVehicleQuaternion(PlayerVehicle[car]))
							--lua for k,v in pairs(getAllVehicles()) do if not sampGetVehicleIdByCarHandle(v) then deleteCar(v) PlayerVehicle[car] = nil end end
							end 
						end
					end 
				end
			end 
		end   
	end 
end   

