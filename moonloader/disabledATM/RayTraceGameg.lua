local memory = require"memory"
local Vector = require"lib.vector3d"
KEY = require"lib.vkeys"
local mad = require"MoonAdditions"
_G["ToHex"] = function(num) local s = string.upper(string.format("%x", num * 256)) return string.sub(s,1,string.len(s)-2) end



local nScreenWidth = 240   			-- Console Screen Size X (columns)
local nScreenHeight = 40*2			-- Console Screen Size Y (rows)
local nMapWidth = 14				-- World Dimensions
local nMapHeight = 14 

local fPlayerX = 2  			-- Player Start Position
local fPlayerY = 3 
local fPlayerA = 0.0			-- Player Start Rotation
local fFOV = math.pi/4 	-- Field of View
local fDepth = 16.0			-- Maximum rendering distance
local fSpeed = 0.05			-- Walking Speed
local AdditiX = 1920/2
local AdditiY = 1080/2
local AddititX = 1920/2-170
local AddititY = 1080/2
local Red = 0xFF00FF00

function DrawBorders()
	renderDrawLine(AdditiX+nScreenWidth, AdditiY, AdditiX, AdditiY, 1, Red)
	renderDrawLine(AdditiX, AdditiY+nScreenHeight, AdditiX, AdditiY, 1, Red)
	renderDrawLine(AdditiX+nScreenWidth, AdditiY+nScreenHeight, AdditiX+nScreenWidth, AdditiY, 1, Red)
	renderDrawLine(AdditiX+nScreenWidth, AdditiY+nScreenHeight, AdditiX, AdditiY+nScreenHeight, 1, Red)
	
	renderDrawLine(AddititX+nMapWidth*8, AddititY, AddititX, AddititY, 1, Red)
	renderDrawLine(AddititX, AddititY+nMapHeight*8, AddititX, AddititY, 1, Red)
	renderDrawLine(AddititX+nMapWidth*8, AddititY+nMapHeight*8, AddititX+nMapWidth*8, AddititY, 1, Red)
	renderDrawLine(AddititX+nMapWidth*8, AddititY+nMapHeight*8, AddititX, AddititY+nMapHeight*8, 1, Red)
	
	--renderDrawBox(AddititX+(fPlayerX*8)-2, AddititY+(fPlayerY*8)-2, 5, 5, 0xFF00FF00)
	
	
	local fStepSize = 0.1				
	local fDistanceToWall = 0.0
	local bbHitWall = false
	
	local ffEyeY = math.cos(fPlayerA+fFOV+fFOV/2)
	local ffEyeX = math.sin(fPlayerA+fFOV+fFOV/2)
	
	while (not bbHitWall and fDistanceToWall < fDepth) do
		
		fDistanceToWall = fDistanceToWall + fStepSize
		nTestX = fPlayerX + (ffEyeX * fDistanceToWall)
		nTestY = fPlayerY + (ffEyeY * fDistanceToWall)
		
		--if (nTestX <= 5 and nTestY <= 5  and  nTestY >= 4 and nTestX >= 4) then
		--	bbHitWall = true
		--end 
		if (nTestX >= nMapWidth or nTestY >= nMapHeight  or  nTestY <= 0 or nTestX <= 0) then
			bbHitWall = true
		end
		if (nTestX <= 5 and nTestY <= 5  and  nTestY >= 4 and nTestX >= 4) then
			bbHitWall = true
		end 
	end
	local fStepSize = 0.1				
	local ffDistanceToWall = 0.0
	local bbHitWall = false
	
	local fffEyeY = math.cos(fPlayerA+fFOV/2)
	local fffEyeX = math.sin(fPlayerA+fFOV/2)
	
	while (not bbHitWall and ffDistanceToWall < fDepth) do
		
		ffDistanceToWall = ffDistanceToWall + fStepSize
		nTestX = fPlayerX + (fffEyeX * ffDistanceToWall)
		nTestY = fPlayerY + (fffEyeY * ffDistanceToWall)
		
		if (nTestX >= nMapWidth or nTestY >= nMapHeight  or  nTestY <= 0 or nTestX <= 0) then
			bbHitWall = true
		end
		if (nTestX <= 5 and nTestY <= 5  and  nTestY >= 4 and nTestX >= 4) then
			bbHitWall = true
		end 
	end
	
	
	renderDrawLine(AddititX+(fPlayerX*8), AddititY+(fPlayerY*8), AddititX+(fPlayerX*8)+(ffEyeX * fDistanceToWall)*7.9, AddititY+(fPlayerY*8)+(ffEyeY * fDistanceToWall)*7.9, 1, Red)
	renderDrawLine(AddititX+(fPlayerX*8), AddititY+(fPlayerY*8), AddititX+(fPlayerX*8)+(fffEyeX * ffDistanceToWall)*7.9, AddititY+(fPlayerY*8)+(fffEyeY * ffDistanceToWall)*7.9, 1, Red)
	--printString(fDistanceToWall,10)
end


function maint()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100) 
	end
	while trtue do
		wait(8)
		DrawBorders()
		if isKeyDown(KEY.VK_E) then
			fPlayerA = fPlayerA + 0.04
		end
		if isKeyDown(KEY.VK_Q) then
			fPlayerA = fPlayerA - 0.04
		end
		if isKeyDown(KEY.VK_W) then
			fPlayerX = fPlayerX +  math.sin(fPlayerA+fFOV) * fSpeed    
			fPlayerY = fPlayerY +  math.cos(fPlayerA+fFOV) * fSpeed
		end
		if isKeyDown(KEY.VK_S) then
			fPlayerX = fPlayerX -  math.sin(fPlayerA+fFOV) * fSpeed
			fPlayerY = fPlayerY -  math.cos(fPlayerA+fFOV) * fSpeed
		end
		if isKeyDown(KEY.VK_A) then
			fPlayerX = fPlayerX -  math.sin(fPlayerA+(fFOV+math.pi/2.0)) * fSpeed
			fPlayerY = fPlayerY -  math.cos(fPlayerA+(fFOV+math.pi/2.0)) * fSpeed
		end
		if isKeyDown(KEY.VK_D) then
			fPlayerX = fPlayerX +  math.sin(fPlayerA+(fFOV+math.pi/2.0)) * fSpeed
			fPlayerY = fPlayerY +  math.cos(fPlayerA+(fFOV+math.pi/2.0)) * fSpeed
		end
		
		for x = 1,nScreenWidth do
			
			
			local fRayAngle = (fPlayerA + fFOV/2.0) + (x / nScreenWidth) * fFOV
			local fStepSize = 0.1								
			local fDistanceToWall = 0.0
			
			local bHitWall = false
			local bHitProp = false
			
			local fEyeY = math.cos(fRayAngle)
			local fEyeX = math.sin(fRayAngle)
			
			while (not bHitWall and fDistanceToWall < fDepth) do
				
				fDistanceToWall = fDistanceToWall + fStepSize
				nTestX = fPlayerX + (fEyeX * fDistanceToWall)
				nTestY = fPlayerY + (fEyeY * fDistanceToWall)
				--if (nTestX <= 5 and nTestY <= 5  and  nTestY >= 4 and nTestX >= 4) then
				--	bHitWall = true
				--end 
				if (nTestX >= nMapWidth or nTestY >= nMapHeight  or  nTestY <= 0 or nTestX <= 0) then
					bHitWall = true
				end
				if (nTestX <= 5 and nTestY <= 5  and  nTestY >= 4 and nTestX >= 4) then
					bHitWall = true
				end 
			end
			
			local color = tostring(ToHex(math.floor(fDistanceToWall)*14))
			if string.len(color) == 1 then
				color = tonumber("0xFF0".. color .."0000")
				else
				color = tonumber("0xFF".. color .."0000")
			end
			
			local nCeiling = (nScreenHeight/2) - nScreenHeight / fDistanceToWall
			local nFloor = nScreenHeight - nCeiling
			
			if nCeiling < 0 then nCeiling = 0 end
			renderDrawLine(AdditiX+x,AdditiY,AdditiX+x,AdditiY+nScreenHeight-nCeiling, 1,color)
			for y = 0,nScreenHeight do
				local b = 1.0 - ((y -nScreenHeight/2.0) / (nScreenHeight / 2.0))
				if y <= nCeiling then
					local color = tostring(ToHex(math.floor(b*127)))
					if string.len(color) == 1 then
						color = tonumber("0xFF0".. color .. "0" .. color .."0" .. color)
						else
						color = tonumber("0xFF".. color .. color .. color)
					end
					renderDrawLine(AdditiX+x,AdditiY,AdditiX+x,AdditiY+y-1, 1,color)
					else if(y > nCeiling and y <= nFloor) then
						
						local color = tostring(ToHex(math.floor(b*255)))
						if string.len(color) == 1 then
							color = tonumber("0xFF0".. color .. "0" .. color .."0000")
							else
							color = tonumber("0xFF".. color .. color .. "00")
						end
						renderDrawLine(AdditiX+x,AdditiY+nScreenHeight,AdditiX+x,AdditiY+nScreenHeight-y-1, 1,color)
					end
				end
			end
		end
	end
end				