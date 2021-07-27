local sampev = require"lib.samp.events"
BLACK_ID = nil
RC_ID = nil
CLOCK_ID = nil

sampev.onShowTextDraw = function(ID,data)
	if sampGetCurrentServerAddress() == "217.160.170.209" then
		if data.text == "000000000" and not data.text:find("Slot",1,true) then
			BLACK_ID = ID
			return
		end
		if data.text:find(":",1,true) and not data.text:find("/",1,true) and not data.text:find("Slot",1,true) and data.text:len() <=5 then
			CLOCK_ID = ID
			return
		end
		if data.text:find("RC",1,true) and not data.text:find("Slot",1,true) then
			RC_ID = ID
			return
		end
	end
end

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do
		wait(200)
	end
	if sampGetCurrentServerAddress() ~= "217.160.170.209" then return end
	while true do
		wait(5000) 
		local mult = 0.9
		if BLACK_ID then
			--print("TD Black ID: " .. BLACK_ID)
			sampTextdrawSetPos(BLACK_ID, 555,62)
			sampTextdrawSetLetterSizeAndColor(BLACK_ID, 0.354* mult, 1.725,0xFF000000)
		end
		if RC_ID then
			--print("TD RC ID: " .. RC_ID)
			sampTextdrawSetPos(RC_ID, 555,61.8) 
			sampTextdrawSetLetterSizeAndColor(RC_ID, 0.354* mult, 1.725, 0xFFFFFF00)
		end
		if CLOCK_ID then
			sampTextdrawSetPos(CLOCK_ID, 620,20)  
			sampTextdrawSetLetterSizeAndColor(CLOCK_ID, 0.5*0.7, 1.5*0.75, 0xFFFFFFFF)
		end
	end
end



