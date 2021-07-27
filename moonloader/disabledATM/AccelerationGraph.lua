local memory =	require"memory"
local KEY =		require"lib.vkeys"
local mad = 	require "MoonAdditions"
local Vector =	require"lib.vector3d"
local Enabled = false
local wasHeld = false
CurrentSpeeds = {}
Speeds = {}
lastSave = 0
Colors = {
	0xFF0000FF,
	0xFFFF0000,
	0xFF00FF00,
	0xFF00FFFF,
	0xFFFFFF00,
	0xFFFF00FF	
}

function GetCarVelocity(vehicle)
	local ptr = getCarPointer(vehicle)
	local x = memory.getfloat(ptr+68,false)
	local y = memory.getfloat(ptr+72,false)
	local z = memory.getfloat(ptr+76,false)
	return x,y,z
end

function Next()
	Speeds[#Speeds+1] = CurrentSpeeds
	CurrentSpeeds = {}
end

function VehicleMaxSpeed(id)
	if id == 534 then return 168 end
	if id == 541 then return 202 end
	if id == 415 then return 192 end
	
	if id == 522 then return 250 end
	return 42069
end

function maint()
	while not isSampAvailable() or not isOpcodesAvailable() or not isSampfuncsLoaded() do wait(100) end
	while true do
		wait(8)
		local start = os.clock()
		if Enabled then
			renderDrawLine(0,800,1900,800, 2, 0xFFFFFFFF)
			if isCharInAnyCar(PLAYER_PED) then
				if isKeyDown(KEY.VK_W) and not sampIsChatInputActive() then
					local car = storeCarCharIsInNoSave(PLAYER_PED)
					local speed = math.floor(Vector(GetCarVelocity(car)):length() * 180.5)
					if not CurrentSpeeds["StartTime"] then 
						CurrentSpeeds["StartTime"] = os.clock()
					end
					if not CurrentSpeeds["ReachedMaxSpeed"] then
						if #CurrentSpeeds < 1900 then
							if os.clock()-lastSave > 0.05 then
								CurrentSpeeds[#CurrentSpeeds+1] = {speed=speed*2,cTime=os.clock()}
								CurrentSpeeds["EndTime"] = os.clock()
								lastSave = os.clock()
								if speed >= VehicleMaxSpeed(getCarModel(car)) then
									CurrentSpeeds["ReachedMaxSpeed"] = true
								end
							end
						end
					end
				end
			end
		end
		for k,v in pairs(CurrentSpeeds) do
			if k ~= "StartTime" and k ~= "EndTime" and k ~= "ReachedMaxSpeed" then 
				if k > 1 then
					local t = math.floor((v.cTime-CurrentSpeeds["StartTime"])*50)
					local tLast = math.floor((CurrentSpeeds[k-1].cTime-CurrentSpeeds["StartTime"])*50)
					renderDrawLine(tLast,1000-CurrentSpeeds[k-1].speed,t,1000-v.speed, 2, Colors[#Speeds+1])
					if k == #CurrentSpeeds then
						mad.draw_text("~r~".. (t/50) .." seconds", tLast+30,1000-CurrentSpeeds[k-1].speed-10, mad.font_style.MENU, 0.4, 0.9, mad.font_align.LEFT, 640, true, false, 255, 255, 255, 255, 0, 1)
					end
				end
			end
		end
		for j,i in pairs(Speeds) do
			for k,v in pairs(i) do
				if k ~= "StartTime" and k ~= "EndTime" and k ~= "ReachedMaxSpeed" then 
					if k > 1 then
						local t = math.floor((v.cTime-Speeds[j]["StartTime"])*50)
						local tLast = math.floor((Speeds[j][k-1].cTime-Speeds[j]["StartTime"])*50)
						renderDrawLine(tLast,1000-Speeds[j][k-1].speed,t,1000-v.speed, 2, Colors[j])
						if k == #Speeds[j] then
							mad.draw_text("~r~".. (t/50) .." seconds", tLast+30,1000-Speeds[j][k-1].speed-10, mad.font_style.MENU, 0.4, 0.9, mad.font_align.LEFT, 640, true, false, 255, 255, 255, 255, 0, 1)
						end
					end
				end
			end
			--renderDrawLine(k,1000-v,k+2,1000-v, 2, Colors[j])
			--Colors[j]
			end
			
			if not wasHeld and isKeyDown(KEY.VK_F12) and not isKeyDown(KEY.VK_MENU) then
				Next()
			end
			if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F12) and not sampIsChatInputActive() then 
				Enabled = not Enabled
				print("AccelerationGraph: "..tostring(Enabled))
				if not Enabled then
					CurrentSpeeds = {}
					Speeds = {}
				end
			end
			wasHeld = isKeyDown(KEY.VK_F12)
			--printStringNow(os.clock()-start,100)
			--printStringNow(#CurrentSpeeds,100)
	end
end