local KEY =		require"lib.vkeys"
local Enabled = true
local Binds = {}

function Bind(key,msg)
	if not msg then msg = "no msg" end
	if not key then return end
	if type(key) == "string" then
		Binds[key:byte()] =  "/" .. msg
		else
		Binds[key] =  "/" .. msg
	end
end

Bind("3","rollfall")
Bind("4","fallback")
Bind("5","seehits")
Bind(KEY.VK_DIVIDE,"reload 2 deagle")
Bind(KEY.VK_MULTIPLY,"reload 2 sniper")
Bind(KEY.VK_ADD,"en")
Bind(KEY.VK_SUBTRACT,"ex")
Bind(KEY.VK_NUMPAD1,"usemedikit")
Bind(KEY.VK_NUMPAD2,"lifejump")
Bind(KEY.VK_NUMPAD9,"cmc 1")
Bind(KEY.VK_NUMPAD8,"cmc 2")
Bind(KEY.VK_NUMPAD5,"repair")
Bind(KEY.VK_NUMPAD6,"putnitro")


function main() 
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(200)
	end
	
	while true do
		wait(5)
		if Enabled and isPlayerPlaying(PLAYER_PED) and not sampIsChatInputActive() and not isSampfuncsConsoleActive() then
			for k,v in pairs(Binds) do
				if wasKeyPressed(k) then sampSendChat(v) print(v) end
			
			end
		end
		
		if isKeyDown(KEY.VK_MENU) and wasKeyPressed(KEY.VK_F1) and not sampIsChatInputActive() then 
			Enabled = not Enabled
			print("keybinder : "..tostring(Enabled))
		end
	end
end
