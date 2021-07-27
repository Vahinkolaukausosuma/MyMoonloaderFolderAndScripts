KEY = require"lib.vkeys"
x,y,z = 0,0,0
function matin()
	while true do
		wait(200)
		if isKeyDown(KEY.VK_SHIFT) and isKeyDown(KEY.VK_F3) then
			AutoDrive()
		end 
	end
end


function maitnt()
	
	while true do
	wait(200)
	local add = 5
		if isKeyDown(KEY.VK_SHIFT) and isKeyDown(KEY.VK_F3) then
			if isCharInAnyCar(PLAYER_PED) then
				MyCar = gcar()
				local x,y,z = getCarCoordinates(MyCar)
				for k,v in pairs(getAllVehicles()) do 
					if v ~= MyCar then
						setCarCoordinates(v,x,y,z+add)
						add = add + 4
					end
				end
			end
		end 
	end
end
function gcar()
	return storeCarCharIsInNoSave(PLAYER_PED)
end


function AutoDrive()
	if isCharInAnyCar(PLAYER_PED) then
		MyCar = gcar()
		--local Lastcar = MyCar
		--x,y,z = getCarCoordinates(MyCar)
		for k,car in pairs(getAllVehicles()) do
			if MyCar ~= car then
				carGotoCoordinates(car,x,y,z)
				setCarCruiseSpeed(car,35)
				setCarDrivingStyle(car,3)
				setCarMission(car,1)
				setCarFollowCar(car, MyCar, 50)
			end
		end
	end
end
