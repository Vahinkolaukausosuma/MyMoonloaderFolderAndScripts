local KEY = require"lib.vkeys"

function main()
	while true do
		wait(20)
		if isKeyDown(KEY.VK_CONTROL) and isKeyJustPressed(KEY.VK_F5) then
			sampConnectToServer(sampGetCurrentServerAddress()) 
		end
	end
end 