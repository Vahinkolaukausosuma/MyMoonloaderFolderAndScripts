sampev = require"lib.samp.events"
NextMsg = 0
prcnt = "%"
sampev.otnServerMessage = function(q,message)
	local where = string.find(message,":")
	--local Clan = string.find(string.sub(message,1,3),"[C]")
	if where then
		if string.sub(message,where+2,where+2) == "=" then
			message = string.sub(message,where+3,string.len(message)) 
			--f = io.open("math.txt","w")
			--f:write("return ".. message)
			--f:close()
			--local result, err = pcall(dofile,"math.txt")
			--if type(err) ~= "number" then return end
			local fnc = load("return "..message)
			local good,result = pcall(fnc)
			if good then
				message = result
			end 
			--message = "/c ".. message
			if fnc and NextMsg < gameClock() then 
				--if Clan then 
				--print(message)
				--sampSendChat("/c "..message)
				--NextMsg = gameClock()+1
				--else
				print(message)
				sampSendChat(message)
				NextMsg = gameClock()+1
				--end
			end
		end
	end
end