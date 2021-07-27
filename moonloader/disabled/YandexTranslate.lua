sampev = require"lib.samp.events"
FileHassh = 0
YandexMsg = nil
ShouldPrint = false

function GetYHash()
	FF = io.open("Yandex.txt","r")
	if FF then 
		local con = FF:read(("*all"))
		return getHashKey("w.."..con)
	end
	FF:close()
	return 0 
end

function maint()
	sampev.onServerMessage = function(q,message)
		--if string.find(message,"SDC") then
		lang = nil
		local where = string.find(message,":")
		if where then
			if not string.find(string.sub(message,1,where),"mcool") then
				if string.sub(message,where+2,where+3) == ".t" then
					message = string.sub(message,where+5,string.len(message))
					if string.sub(message,6,6) == "," then 
						lang = string.sub(message,1,5)
						message = string.sub(message,7,string.len(message))
						print(lang)
						print(message)
					end
					if not lang then lang = "en" end
					local URL = "https://translate.yandex.net/api/v1.5/tr.json/translate?text=" .. message .. "&lang=".. lang .. "&key=trnsl.1.1.20180423T152707Z.a5f0d6bad9496d4e.1eafc54fd75d289d92f3f181be9f30dd19ef875b"
					FileHassh = GetYHash()
					downloadUrlToFile(URL, "Yandex.txt")
					ShouldPrint = true
				end
			end
			--	end
		end
	end
	
	while true do
		if ShouldPrint and FileHassh ~= GetYHash()then
			ShouldPrint = false
			local f = io.open("Yandex.txt","r")
			YandexMsg = decodeJson(f:read(("*all")))
			f:close()
			print(YandexMsg.text[1])
			sampSendChat("Translation: "..YandexMsg.text[1])
		end
		wait(50)
	end
end
