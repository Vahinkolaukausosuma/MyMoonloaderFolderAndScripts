sampev = require"lib.samp.events"

function GetWHash()
	local FF = io.open("woolfram.txt","r")
	if FF then
		local con = FF:read(("*all"))
		FF:close()
		if string.len(con) > 5 then
			return getHashKey(con)
		end
	end
	return 0
end
--FileHash = GetWHash() 

function maint() 
	sampev.onServerMessage = function(q,message)
		local where = string.find(message,":")
		if where and not NotPrinted then
			if string.sub(message,where+2,where+3) == ".w" then
				message = string.sub(message,where+5,string.len(message))
				local URL = "http://api.wolframalpha.com/v2/query?input=".. message .. "&appid=HEEJVY-84733RJQUH"
				downloadUrlToFile(URL, "woolfram.txt")
				NotPrinted = true
				FileHash = GetWHash()
			end
		end
	end
	
	while true do
	local CurrentHash = GetWHash() 
		if FileHash ~= CurrentHash then
			if NotPrinted then
				NotPrinted = false
				local f = io.open("woolfram.txt","r")
				local content = f:read(("*all"))
				f:close()
				local result, err = pcall(collect,content)
				if result and err and err[2] and err[2][2] and err[2][2][1] and err[2][2][1][1] and err[2][2][1][1].xarg and err[2][2][1][1].xarg.alt then
					sampSendChat("Wolfram: "..tostring(err[2][2][1][1].xarg.alt))
					else sampSendChat("No result")
				end	
			end
		end
		wait(100)
	end
end

function tprint (tbl, indent)
	if not indent then indent = 0 end
	for k, v in pairs(tbl) do
		formatting = string.rep("  ", indent) .. k .. ": "
		if type(v) == "table" then
			print(formatting)
			tprint(v, indent+1)
			elseif type(v) == 'boolean' then
			print(formatting .. tostring(v))      
			else
			print(formatting .. v)
		end
	end
end


function parseargs(s)
	local arg = {}
	string.gsub(s, "([%-%w]+)=([\"'])(.-)%2", function (w, _, a)
		arg[w] = a
	end)
	return arg
end

function collect(s)
	local stack = {}
	local top = {}
	table.insert(stack, top)
	local ni,c,label,xarg, empty
	local i, j = 1, 1
	while true do
		ni,j,c,label,xarg, empty = string.find(s, "<(%/?)([%w:]+)(.-)(%/?)>", i)
		if not ni then break end
		local text = string.sub(s, i, ni-1)
		if not string.find(text, "^%s*$") then
			table.insert(top, text)
		end
		if empty == "/" then  -- empty element tag
			table.insert(top, {label=label, xarg=parseargs(xarg), empty=1})
			elseif c == "" then   -- start tag
			top = {label=label, xarg=parseargs(xarg)}
			table.insert(stack, top)   -- new level
			else  -- end tag
			local toclose = table.remove(stack)  -- remove top
			top = stack[#stack]
			if #stack < 1 then
				error("nothing to close with "..label)
			end
			if toclose.label ~= label then
				error("trying to close "..toclose.label.." with "..label)
			end
			table.insert(top, toclose)
		end
		i = j+1
	end
	local text = string.sub(s, i)
	if not string.find(text, "^%s*$") then
		table.insert(stack[#stack], text)
	end
	if #stack > 1 then
		error("unclosed "..stack[#stack].label)
	end
	return stack[1]
end 