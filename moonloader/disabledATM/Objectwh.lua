local mad = require 'MoonAdditions'
local KEY =		require"lib.vkeys"
local Enabled = false

function main()
	while true do
		wait(8)
		if isPlayerPlaying(PLAYER_HANDLE) then
			if Enabled then
				if not isCharDead(PLAYER_PED) then
					for k,obj in pairs(getAllObjects()) do
						local __,X,Y,Z = getObjectCoordinates(obj)
						--if X ~= 0 and Y ~= 0 and Z ~= 0 then
							local _,x,y = convert3DCoordsToScreenEx(X,Y,Z,true,true)
							if x < 1920 and x >= 0 then
								if y < 1080 and y >= 0 then
									--renderDrawLine(1920/2, 1080,x,y, 2, 0xFFFFFFFF)
									--if obj > 24000 then
									--if getObjectModel(obj) == 955 or getObjectModel(obj) == 1776 then
										mad.draw_text("~r~".. "    " ..getObjectModel(obj), x, y, mad.font_style.MENU, 0.4, 0.9, mad.font_align.CENTER, 640, true, false, 255, 255, 255, 255, 0, 1)
									--end
										
										--mad.draw_text("~r~".. "    " ..getObjectModel(obj), x, y, mad.font_style.MENU, 0.4, 0.9, mad.font_align.CENTER, 640, true, false, 255, 255, 255, 255, 0, 1)
									--end
								end	
							end
						end
				--	end
				end
			end
		end
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F3) and not sampIsChatInputActive() then
			Enabled = not Enabled
			print("yee now :".. tostring(Enabled))
		end
	end
end

