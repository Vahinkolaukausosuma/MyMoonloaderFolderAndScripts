local sampev = 	require"lib.samp.events"
local KEY =		require"lib.vkeys"
local memory =	require"memory"
local bit = 	require"bit"
local Enabled = false
local DriverSampID = false
local Dots = {}

function SetDriver(id)
	DriverSampID = tonumber(id)
end

sampev.onPassengerSync = function(plyid,data)
	if Enabled and not sampIsChatInputActive() and isGameWindowForeground() then
		if DriverSampID then
			if plyid == DriverSampID then
				
				local Left = data.leftRightKeys == 65408
				local Right = data.leftRightKeys == 128
				local Forward = data.upDownKeys == 65408 or data.keys.secondaryFire_shoot == 1
				local Backward = data.upDownKeys == 128 or data.keys.primaryFire == 1 
				
				setVirtualKeyDown(KEY.VK_A,Left)
				setVirtualKeyDown(KEY.VK_D,Right)
				setVirtualKeyDown(KEY.VK_W,Forward)
				setVirtualKeyDown(KEY.VK_S,Backward)			
				
				--azerty
				--setVirtualKeyDown(KEY.VK_Q,Left)
				--setVirtualKeyDown(KEY.VK_D,Right)
				--setVirtualKeyDown(KEY.VK_Z,Forward)
				--setVirtualKeyDown(KEY.VK_S,Backward)
			end
		end
	end
end


function generateRandomSpots()
	
	Dots = {}
	for x = 1,1920 do
		for y = 1,1080 do
			local tmp = {}
			--math.randomseed(os.time()+x+y)
			nLehmer = os.time() + x + y
			tmp.x = x
			tmp.y = y
			if math.random(0,200) == 0 then
				Dots[#Dots+1] = tmp
			end
		end
	end
end


function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100)
	end
	
	sampRegisterChatCommand("setdriverid",SetDriver)
	
	while true do
		wait(8)
		
		--for k,v in pairs(Dots) do 
		--	--renderDrawLine(v.x,v.y,v.x+1, v.y+1, 1,0xFFFFFFFF)
		--end
		
		
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F6) and not sampIsChatInputActive() then
			Enabled = not Enabled
			print("PassengerDriver now: ".. tostring(Enabled))
			if Enabled then
				--generateRandomSpots()
				--else
				--Dots = {}
			end
		end
	end
end
