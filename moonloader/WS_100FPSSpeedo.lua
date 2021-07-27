local sampev = require"lib.samp.events"
local memory =	require"memory"
TextDrawID = nil

function GetCarVelocity(vehicle)
	local Addr = getCarPointer(vehicle)
	local x = memory.getfloat(Addr+68,false)
	local y = memory.getfloat(Addr+72,false)
	local z = memory.getfloat(Addr+76,false)
	return x,y,z
end

sampev.onShowTextDraw = function(id,Table)
	if isPlayerPlaying(PLAYER_HANDLE) then
		if sampGetCurrentServerAddress() == "217.160.170.209" then
			if string.find(Table.text,"KM/H") then
				TextDrawID = id
				SpeedMsg = string.sub(Table.text,1,string.len(Table.text)-11)
			end
		end
	end
end
-- sampev.onSetPlayerPos = function(a)
	-- print(a)
-- end

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do
		wait(200)
	end
	
	while true do 
		wait(0)
		if TextDrawID then
			if isCharInAnyCar(PLAYER_PED) then
				local car = storeCarCharIsInNoSave(PLAYER_PED)
				local x,y,z = GetCarVelocity(car)
				local speed = tostring(math.floor(math.sqrt(((x*x)+(y*y))+(z*z))*180.5))
				
				if string.len(speed) ~= 3 then speed = "0"..speed end
				if string.len(speed) ~= 3 then speed = "0"..speed end
				speed = SpeedMsg .. "".. speed .."~g~ KM/H"
				sampTextdrawSetString(TextDrawID, speed)
			end
		end
	end
end