local mad = require 'MoonAdditions'
local KEY =		require"lib.vkeys"
local Enabled = false

function main()
	while true do
		wait(0)
		if isPlayerPlaying(PLAYER_HANDLE) then
			if Enabled then
				if not isCharDead(PLAYER_PED) then
					for k,char in pairs(getAllChars()) do
						if char ~= PLAYER_PED then
							local bool,id = sampGetPlayerIdByCharHandle(char)
							if not bool then name = id else name = sampGetPlayerNickname(id) end
							local bone = mad.get_char_bone(char, 7)
							local bone = bone.matrix.pos
							local MeX, MeY, MeZ = getActiveCameraCoordinates()
							local Dist = getDistanceBetweenCoords3d(bone.x,bone.y,bone.z,MeX, MeY, MeZ)
							if Dist > 15 then
								local _,x,y = convert3DCoordsToScreenEx(bone.x,bone.y,bone.z,true,true)
								if x < 1920 and x >= 0 then
									if y < 1080 and y >= 0 then
										renderDrawLine(1920/2, 1080,x,y, 2, 0xFFFFFFFF)
										mad.draw_text("~r~".. name, x, y-20, mad.font_style.MENU, 0.4, 0.9, mad.font_align.CENTER, 640, true, false, 255, 255, 255, 255, 0, 1)
										mad.draw_text("~r~".. math.floor(Dist), x, y-35, mad.font_style.MENU, 0.4, 0.9, mad.font_align.CENTER, 640, true, false, 255, 255, 255, 255, 0, 1)
									end	
								end
							end
						end
					end
				end
			end
		end
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F3) and not sampIsChatInputActive() then
			Enabled = not Enabled
			print("yee now :".. tostring(Enabled))
		end
	end
end