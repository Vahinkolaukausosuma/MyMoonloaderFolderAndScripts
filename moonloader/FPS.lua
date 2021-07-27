local mad = 	require "MoonAdditions"
local KEY =		require"lib.vkeys"
local sock = 	require"socket"
local lastTick = sock.gettime()
local Enabled = false
local targetFPS = 144
local targetFT = 1000/targetFPS /1000
local InCarFPS = 100
local InCarTargetFT = 1000/InCarFPS /1000
local num = 0
local frames = {}
local stacksize = 100

for i = 1,stacksize do frames[i] = 0 end
local afk = false
function matin()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100)
	end
	sampRegisterChatCommand("toggleafk", function() afk = not afk end)
	while true do
		wait(0)
		if afk then sock.sleep(0.1) end
		local bruh = sock.gettime()-lastTick
		local bruh420 = sock.gettime()-lastTick

		if not isCharInAnyCar(PLAYER_PED) then
			if targetFT-bruh > 0.0 then
				-- sock.sleep(targetFT-bruh)
			end
			else
			if InCarTargetFT-bruh > 0.0 then
				-- sock.sleep(InCarTargetFT-bruh)
			end
		end
		
		bruh = sock.gettime()-lastTick
		num = math.floor(1/bruh)
		frames[stacksize] = num
		for i = 1,stacksize do
			if i <= stacksize-1 then
				local temp = frames[i+1]
				frames[i] = temp
			end
		end
		frames[stacksize] = num
		local num2 = 0
		for k,v in pairs(frames) do
			num2 = num2 + v
			-- renderDrawLine(500+k*4,500,500+k*4,500+v, 4, 0xFFBB0000)
			-- renderDrawLine(1000+k*3,1070,1000+k*3,1070-v, 3, 0xFFBB0000)
			renderDrawLine(1000+k*3,1070-v-3,1000+k*3,1070-v, 3, 0xFFBB0000)
		end
		num2 = num2 / stacksize
		-- print(1/bruh420)
		mad.draw_text("~g~".. math.floor(num2), 22, 10, 1, 0.6,0.8, mad.font_align.CENTER, 640, true, false, 255, 0, 0, 255, 0,1)
		--mad.draw_text("~g~".. math.floor(num2), 22, 10, mad.font_style.PRICEDOWN, 0.6,0.8, mad.font_align.CENTER, 320, true, false, int text_r, int text_g, int text_b, int text_a, uint outline, uint shadow, int shadow_r, int shadow_g, int shadow_b, int shadow_a, bool background, int background_r, int background_g, int background_b, int background_a])
		lastTick = sock.gettime()
	end
end