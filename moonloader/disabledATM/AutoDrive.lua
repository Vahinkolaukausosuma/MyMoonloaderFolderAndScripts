KEY = require"lib.vkeys"
x,y,z = 0,0,0
function maint()
	while true do
		wait(200)
		if isKeyDown(KEY.VK_SHIFT) and isKeyDown(KEY.VK_F3) then
			AutoDrive()
		end 
	end
end
function gcar()
	return storeCarCharIsInNoSave(PLAYER_PED)
end


function AutoDrive()
	if isCharInAnyCar(PLAYER_PED) then
		MyCar = gcar()
		x,y,z = getCarCoordinates(MyCar)
		for k,car in pairs(getAllVehicles()) do
			if MyCar ~= car then
				carGotoCoordinates(car,x,y,z)
				setCarCruiseSpeed(car,8000)
				setCarDrivingStyle(car,2)
				setCarMission(car,1)
			end
		end
	end
end
