script_name("oops")
script_author("Jonni")
script_dependencies("SAMP")

sampev = require"lib.samp.events"
KEY = require"lib.vkeys"
NextMsg = 5000000
DigNum = ""
ShouldPrint = false
Enabled = false
LastInteraction = gameClock()

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function AnyKeyHeld()
	for k,v in pairs(KEY) do
		if wasKeyPressed(v) then
			return v
		end
	end
	return false
end

function mtain()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do
		wait(200)
	end
	print("a")
	if sampGetCurrentServerAddress() ~= "217.160.170.209" then print"no" return end
	sampev.onShowTextDraw = function(tdid,td)
		print("playertd show : " .. tdid .. " " .. td.text)
	end
	sampev.onTextDrawSetString = function(a,b,c)
	if a ~= 21 and a ~= 50 then
		print("--------")
		print(a)
		print(b)
		print(c)
	end
		if isPlayerPlaying(PLAYER_HANDLE) then
			if not isCharInAnyCar(PLAYER_PED) then
				if 1 then
					if a and b and not c then
						if not b:match(":") and not b:match("|") and not b:match("km") then
							b = b:gsub(" ","")
							if tonumber(a) and tonumber(b) then
								DigNum = tostring(b)
								NextMsg = gameClock() + (math.random(2542,11353)/1000)
								print("Wait time: " .. NextMsg-gameClock())
								ShouldPrint = true
							end
						end
					end
				end
			end
		end
	end
	sampev.onSendChat = function(...)
		LastInteraction = gameClock()
	end
	sampev.onServerMessage = function(q,message)
		if string.find(string.sub(message,1,18),"PM from an admin") then
			Enabled = false
		end
	end
	while true do
		wait(8)
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F12) then
			Enabled = not Enabled
			print("now " .. tostring(Enabled))
		end
		if Enabled then
			if LastInteraction+1200 < gameClock() then
				local Alpha = 50 + (gameClock()-LastInteraction-120)*2 
				if Alpha > 255 then
					Alpha = 255
					Enabled = false
					ShouldPrint = false
					print("Disabled due to inactivity!!!!!")
					printString("Disabled due to inactivity!!!!!",10000)
					end
				drawRect(0, 0, 1920, 1080, 255, 0, 0, Alpha)
			end
		end
		if AnyKeyHeld() then LastInteraction = gameClock() end
		if NextMsg < gameClock() and ShouldPrint and Enabled then
			ShouldPrint = false
			sampSendChat("/dig "..DigNum)
		end
	end
end