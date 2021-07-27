--local Aim = 	require"lib.Aim"
local memory =	require"memory"
local Vector = 	require"lib.vector3d"
local KEY =		require"lib.vkeys"
--local mad = 	require"MoonAdditions"
--local sampev = 	require"lib.samp.events"
local Enabled = false
--local Trace = mad.get_collision_between_points
-- local no = 11
-- local ninety = math.pi/2
-- pos = Vector(0,0,0)
-- dir = Vector(0,0,0)
-- function getAimVector(ass)
	-- local yaw = memory.getfloat(0xB6F258,false)
	-- local pitch = memory.getfloat(0xB6F248,false)
	-- x = (math.cos(yaw)*math.cos(pitch))
	-- y = (math.sin(yaw)*math.cos(pitch)) 
	-- z = math.sin(pitch)
	-- return Vector(-x*ass,-y*ass,z*ass)
-- end
function anglesToVector(yaw,pitch)
	x = (math.cos(yaw)*math.cos(pitch))
	y = (math.sin(yaw)*math.cos(pitch)) 
	z = math.sin(pitch)
	return Vector(-x,-y,z)
end

-- sampev.onAimSync = function(player,data)
	-- pos = Vector(data.camPos.x,data.camPos.y,data.camPos.z)
	-- dir = Vector(data.camFront.x,data.camFront.y,data.camFront.z)
-- end

-- function getTraceHitPosEx(p1,p2)
	-- aa = Trace(p1.x,p1.y,p1.z,p2.x,p2.y,p2.z,{
		-- vehicles=true,
		-- peds=true,
		-- buildings=true,
		-- dummies=true,
		-- see_through=true,
		-- shoot_through=true,
		-- ignore_some_objects=false
	-- },getCharPointer(PLAYER_PED))
	
	-- if aa and aa.position then
		-- return Vector(aa.position.x,aa.position.y,aa.position.z)
	-- end
	-- return nil
-- end

-- function getRightAngleAimVector(ass)
	-- if not ass then ass = 1 end
	-- local yaw = memory.getfloat(0xB6F258,false)+(math.pi/2)
	-- local pitch = memory.getfloat(0xB6F248,false)
	-- x = (math.cos(yaw)*math.cos(pitch))
	-- y = (math.sin(yaw)*math.cos(pitch))
	-- return Vector(-x*ass,-y*ass,0)
-- end

-- function quatToAngles(x,y,z,w)
	-- local angs = {}
	-- angs.x = math.deg(-math.asin(2*y*z-2*x*w) or 0)
	-- angs.y = math.deg(math.atan2(x*z+y*w,0.5-x*x-y*y) or 0)
	-- angs.z = math.deg(math.atan2(x*y+z*w,0.5-x*x-z*z) or 0)
	-- return angs
-- end

function getCamera()
	return 0x00B6F028
end

function getActiveCamMode()
	local activeCamId = memory.getint8(getCamera() + 0x59)
	return getCamMode(activeCamId)
end

function getCamMode(id)
	local cams = getCamera() + 0x174
	local cam = cams + id * 0x238
	return memory.getint16(cam + 0x0C)
end



function main() 
	--if not isSampLoaded() or not isSampfuncsLoaded() then return end
	--while not isSampAvailable() do
	--	wait(200)
	--end
	
	for i = 0,5 do
		memory.write(0x05231CA+i, 144,1, false)
	end
	
	while true do
		wait(0)
		if Enabled then
			--if Aim.getActiveCamMode() == 53 then
			local pos = Vector(getCharCoordinates(PLAYER_PED))+Vector(0,0,0.785)

			local heading = math.rad(getCharHeading(PLAYER_PED))
			local updown = memory.getfloat(0xB6F248,false)
			
			local FVector = 	anglesToVector(heading-math.pi/2,updown)
			local RVector = 	anglesToVector(heading+math.pi,0)
			local UpVector = 	anglesToVector(heading,math.rad(90)+0)

			local endpos = pos
			endpos = endpos + FVector * 0.1 * 500
			endpos = endpos + RVector * 1.2
			endpos = endpos + UpVector * 5.1
			
			--local hitpos = getTraceHitPosEx(pos,endpos) or endpos
			
			--X,Y = convert3DCoordsToScreen(hitpos.x,hitpos.y,hitpos.z)
			X2,Y2 = convert3DCoordsToScreen(endpos.x,endpos.y,endpos.z)
			
			if getActiveCamMode() == 4 then
				--X = X + 40
				X2 = X2 + 40 
			end			
			
			--renderDrawLine(X-12,Y-1,X+12,Y-1, 2, 0xFFFF0000)
			--renderDrawLine(X,Y,X,Y+12, 2, 0xFFFF0000)
			
			renderDrawLine(X2-12,Y2-1,X2+12,Y2-1, 2, 0xFF00FF00)
			renderDrawLine(X2,Y2,X2,Y2+12, 2, 0xFFFF0000)	
		end
		
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F2) and not sampIsChatInputActive() then 
			Enabled = not Enabled
			print("3dcrosshair : "..tostring(Enabled))
		end
	end
end
--[[
	
script_name('CrossHairHack')
script_author('FYP')
script_moonloader(019)
script_description('Get the latest MoonLoader updates from http://blast.hk/moonloader/')
local memory = require 'memory'


--- Config
alwaysVisible  = false                                 -- default: false
useTexture     = true                                  -- default: true
crosshairSize  = 72                                    -- default: 72
crosshairColor = {r = 130, g = 235, b = 125, a = 255}  -- default: 130, 235, 125, 255
cheatToggle    = 'CHH'                                 -- default: CHH
activated      = false                                 -- default: false
showGameCrosshairInstantly = false                     -- default: false


--- Main
function main()
	if showGameCrosshairInstantly then
		showCrosshairInstantlyPatch(true)
	end

	while true do
		if isPlayerPlaying(playerHandle) and isCharOnFoot(playerPed) then

			if testCheat(cheatToggle) then
				activated = not activated
			end

			if activated then
				local camMode = getActiveCamMode()
				local camAiming = (camMode == 53 or camMode == 7 or camMode == 8 or camMode == 51)
				if alwaysVisible or not (camAiming and (showGameCrosshairInstantly or getCameraTransitionState() ~= 1))
				then
						local weap = getCurrentCharWeapon(playerPed)
						local slot = getWeapontypeSlot(weap)
						if slot >= 2 and slot <= 7 then
							drawCustomCrosshair(weap == 34 or weap == 35 or weap == 36)
						end
				end
			end

		end
		wait(0)
	end
end


--- Events
function onExitScript()
	if showGameCrosshairInstantly then
		showCrosshairInstantlyPatch(false)
	end
end


--- Functions
function drawCustomCrosshair(center)
	local chx, chy
	if center then
		local szx, szy = getScreenResolution()
		chx, chy = convertWindowScreenCoordsToGameScreenCoords(szx / 2, szy / 2)
	else
		chx, chy = getCrosshairPosition()
	end
	if useTexture then
		if not crosshairTexture then
			loadTextureDictionary('hud')
			crosshairTexture = loadSprite('siteM16')
		end
		local chw, chh = getCrosshairSize(crosshairSize / 4)
		useRenderCommands(true)
		drawCrosshairSprite(chx - chw / 2, chy - chh / 2, chw, chh)
		drawCrosshairSprite(chx + chw / 2, chy - chh / 2, -chw, chh)
		drawCrosshairSprite(chx - chw / 2, chy + chh / 2, chw, -chh)
		drawCrosshairSprite(chx + chw / 2, chy + chh / 2, -chw, -chh)
	else
		local chw, chh = getCrosshairSize(crosshairSize / 2)
		local r, g, b, a = crosshairColor.r, crosshairColor.g, crosshairColor.b, crosshairColor.a
		drawRect(chx, chy, 1.0, chh, r, g, b, a)
		drawRect(chx, chy, chh, 1.0, r, g, b, a)
	end
end

function drawCrosshairSprite(x, y, w, h)
	local r, g, b, a = crosshairColor.r, crosshairColor.g, crosshairColor.b, crosshairColor.a
	setSpritesDrawBeforeFade(true)
	drawSprite(crosshairTexture, x, y, w, h, r, g, b, a)
end

function getCrosshairPosition()
	local chOff1 = memory.getfloat(0xB6EC10)
	local chOff2 = memory.getfloat(0xB6EC14)
	local szx, szy = getScreenResolution()
	return convertWindowScreenCoordsToGameScreenCoords(szx * chOff2, szy * chOff1)
end

function getCrosshairSize(size)
	return convertWindowScreenCoordsToGameScreenCoords(size, size)
end

function getCamera()
	return 0x00B6F028
end

function getCameraTransitionState()
	return memory.getint8(getCamera() + 0x58)
end

function getActiveCamMode()
	local activeCamId = memory.getint8(getCamera() + 0x59)
	return getCamMode(activeCamId)
end

function getCamMode(id)
	local cams = getCamera() + 0x174
	local cam = cams + id * 0x238
	return memory.getint16(cam + 0x0C)
end

function showCrosshairInstantlyPatch(enable)
	if enable then
		if not patch_showCrosshairInstantly then
			patch_showCrosshairInstantly = memory.read(0x0058E1D9, 1, true)
		end
		memory.write(0x0058E1D9, 0xEB, 1, true)
	elseif patch_showCrosshairInstantly ~= nil then
		memory.write(0x0058E1D9, patch_showCrosshairInstantly, 1, true)
		patch_showCrosshairInstantly = nil
	end
end

--]]