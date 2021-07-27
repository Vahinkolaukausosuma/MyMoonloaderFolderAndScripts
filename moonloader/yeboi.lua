local Aim =		require "lib.Aim"
local KEY =		require"lib.vkeys"
local mad = 	require 'MoonAdditions'
local memory =	require"memory"
local FovLock = 0.007
local FovLock = 0.08
-- local FovLock = 550.08
-- local FovLock = 550.08
local LerpValue = 0.94
-- local LerpValue = 0
local LerpEnabled = true
local Enabled = true 
 
local VelX,VelY,VelZ = 0,0,0

function LerpAngle(a, b, t)

	a = math.deg(a)
	b = math.deg(b)
	-- if a > math.pi * 2 then a = a + math.pi*2 end
	-- if a < math.pi * 2 then a = a - math.pi*2 end
	-- if b > math.pi * 2 then b = b + math.pi*2 end
	-- if b < math.pi * 2 then b = b -math.pi*2 end
    shortest_angle=((((b - a) % 360) + 540) % 360) - 180
	return math.rad(a + (shortest_angle * t) % 360)
end

function Lerp(from, to ,delta)
	if ( delta > 1 ) then return to end
	if ( delta < 0 ) then return from end
	return from + ( to - from ) * delta
end

function GetCarVelocity(vehicle)
	local x = memory.getfloat(getCarPointer(vehicle)+68,false)
	local y = memory.getfloat(getCarPointer(vehicle)+72,false)
	local z = memory.getfloat(getCarPointer(vehicle)+76,false)
	return x,y,z
end 

local function getTraceHitPosEx(x1,y1,z1,x2,y2,z2) 
	aa = mad.get_collision_between_points(x1,y1,z1,x2,y2,z2,{})
	if aa and aa.position then
		local a = tostring(aa.position)
		if a then
			local Addr = memory.getint32(tonumber((string.sub(a,11,string.len(a)))))
			local x = memory.getfloat(Addr,false)
			local y = memory.getfloat(Addr+4,false)
			local z = memory.getfloat(Addr+8,false)
			return x,y,z
		end
	end
	return nil
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100)
end
	print("pootis, Jonni") 
	if sampGetCurrentServerAddress() == "217.160.170.209" then print"no" return end
	while true do
		--printString(memory.getfloat(0xB6F258,false) .. " " .. memory.getfloat(0xB6F248,false),100)
		local CurrentWeapon = getCurrentCharWeapon(PLAYER_PED) 
		if CurrentWeapon >= 22 then
			if Enabled then
				-- for k,char in pairs({19969}) do
				for k,char in pairs(getAllChars()) do
					--local bool,id = sampGetPlayerIdByCharHandle(char)
					--if not bool then name = id else name = sampGetPlayerNickname(id) end
					--if name == "luckaleannn" then return 0 end
					if char ~= PLAYER_PED then
						
						local hp = getCharHealth(char)
						local didwefindit,plyid = sampGetPlayerIdByCharHandle(char)
						if didwefindit then
							hp = math.min(hp,sampGetPlayerHealth(plyid))
						end
						
						if hp > 0 then
						
							local bone = mad.get_char_bone(char, 5)    							
							local Mybone = mad.get_char_bone(PLAYER_PED, 5)

							if bone then
								if Mybone then
									bone_pos = bone.matrix.pos
									
									mybone_pos = Mybone.matrix.pos
									if isCharInAnyCar(char) then
										VelX,VelY,VelZ = GetCarVelocity(storeCarCharIsInNoSave(char))
										VelXX,VelYY,VelZZ = getCharVelocity(PLAYER_PED)
										bone_pos.x = bone_pos.x + VelX/11.8 - VelXX/60
										bone_pos.y = bone_pos.y + VelY/11.8 - VelYY/60
										bone_pos.z = bone_pos.z + VelZ/11.8 - VelZZ/60
										else
										VelX,VelY,VelZ = getCharVelocity(char)
										VelXX,VelYY,VelZZ = getCharVelocity(PLAYER_PED)
										bone_pos.x = bone_pos.x + VelX/60 - VelXX/60
										bone_pos.y = bone_pos.y + VelY/60 - VelYY/60
										bone_pos.z = bone_pos.z + VelZ/60 - VelZZ/60
									end		
									
								end
								local MeX, MeY, MeZ = getActiveCameraCoordinates()
								--local Dist = getDistanceBetweenCoords3d(bone_pos.x, bone_pos.y, bone_pos.z, MeX, MeY, MeZ)
								local Dist2D = getDistanceBetweenCoords2d(bone_pos.x, bone_pos.y, MeX, MeY)
								if not getTraceHitPosEx(mybone_pos.x,mybone_pos.y,mybone_pos.z, bone_pos.x,bone_pos.y,bone_pos.z) then
									if Dist2D < Aim.MaxDist(CurrentWeapon) then
										local HAngle = Aim.GetAngleBeetweenTwoPoints(MeX, MeY,bone_pos.x, bone_pos.y)+Aim.GetDist(CurrentWeapon)   
										local DelZ = MeZ-bone_pos.z
										local VAngle = -math.atan2(DelZ,Dist2D) -Aim.GetDistH(CurrentWeapon)       
										local FovX,FovY = Aim.LoSCheck(HAngle,VAngle)
										if Aim.getActiveCamMode() == 53 or Aim.getActiveCamMode() == 7 then
											if math.abs(FovY) < FovLock and math.abs(FovX) < FovLock then
												if LerpEnabled then
													HAngle = LerpAngle(HAngle,memory.getfloat(0xB6F258,false),LerpValue)
													VAngle = Lerp(VAngle,memory.getfloat(0xB6F248,false),LerpValue)
												end
												
												Aim.At(VAngle,HAngle)
											end
										end
									end
									--end
								end
							end
						end
						
					end
				end
			end
		end
		if wasKeyPressed(KEY.VK_P) and wasKeyPressed(KEY.VK_MENU) and not sampIsChatInputActive() then
			Enabled = not Enabled
			print("bot: " .. tostring(Enabled))
		end
		
		wait(0)
	end
end					