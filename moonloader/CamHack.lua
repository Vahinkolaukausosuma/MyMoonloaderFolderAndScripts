local KEY =		require"lib.vkeys"
local Enabled = false
local memory =	require"memory"


function maitn()
	
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do wait(100) end
	if sampGetCurrentServerAddress() == "217.160.170.209" then print("no thanks") return end
	while true do 
		wait(5)
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F11) then
			Enabled = not Enabled
			print("CamBoi now: ".. tostring(Enabled))
		end 
		Ass()
		
	end
end

function Ass()
	-- if not sampIsChatInputActive() then
		if Enabled then
			local GoAmount = 1
			local x,y,z = getActiveCameraCoordinates()
			--x,y,z= 1831.818359,  -1390.075562,19.027275
			--memory.setfloat(0xB6F258,3.123753309,false)
			--memory.setfloat(0xB6F248,-0.1494004577,false)
			
			if isKeyDown(KEY.VK_SHIFT) and not isKeyDown(KEY.VK_CONTROL) then
				GoAmount = 5
			end
			if isKeyDown(KEY.VK_CONTROL) and not isKeyDown(KEY.VK_SHIFT) then
				GoAmount = 0.1
			end
			if isKeyDown(KEY.VK_SPACE) then
				z = z+GoAmount
			end
			if isKeyDown(KEY.VK_MENU) then
				z = z-GoAmount
			end
			local yaw = memory.getfloat(0xB6F258,false)
			local pitch = memory.getfloat(0xB6F248,false)
			xx = (math.cos(yaw)*math.cos(pitch)) *-GoAmount
			yy = (math.sin(yaw)*math.cos(pitch)) *-GoAmount
			zz = math.sin(pitch) * GoAmount
			
			local yawR = memory.getfloat(0xB6F258,false)+math.pi/2
			xxR = (math.cos(yawR)*math.cos(pitch)) *-GoAmount
			yyR = (math.sin(yawR)*math.cos(pitch)) *-GoAmount
			
			if isKeyDown(KEY.VK_W) then
				x = x + xx
				y = y + yy
				z = z + zz
			end
			if isKeyDown(KEY.VK_S) then
				x = x - xx
				y = y - yy
				z = z - zz
			end
			if isKeyDown(KEY.VK_A) then
				x = x + xxR
				y = y + yyR
			end
			if isKeyDown(KEY.VK_D) then
				x = x - xxR
				y = y - yyR
			end
			cameraSetVectorMove(x,y,z,x,y,z,100,1)
		end 
	-- end
end
