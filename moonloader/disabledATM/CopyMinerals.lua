script_name("Mineral lister")
script_author("Jonni")
script_dependencies("SAMP")

sampev = require"lib.samp.events"

function string:split(sep)
	local sep, fields = sep or ":", {}
	local pattern = string.format("([^%s]+)", sep)
	self:gsub(pattern, function(c) fields[#fields+1] = c end)
	return fields
end

function main()
	if not isSampfuncsLoaded() or not isSampLoaded() then return end
	while not isSampAvailable() do
		wait(200)
	end
	if sampGetCurrentServerAddress() == "92.222.0.57" then
		sampev.onShowDialog = function(...)
			local Params = {...}
			if Params[3] == "Minerals" then
				local TotalCount = 0
				local Zinc = 0
				local Lead = 0
				local Iron = 0
				local Lithium = 0
				for k,v in pairs(Params[6]:split("\n")) do
					local count = 0
					local Divider = 1
					if string.find(v,"ore") then Divider = 4 end
					for i = 1,string.len(v) do
						if tonumber(string.sub(v,i,i)) then
							count = count .. string.sub(v,i,i)
						end
					end
					if Divider and count then
						count = tonumber(count)/Divider
					end
					if string.find(string.lower(v),"lithium") then Lithium = Lithium + count end
					if string.find(string.lower(v),"iron") then Iron = Iron + count end
					if string.find(string.lower(v),"zinc") then Zinc = Zinc + count end
					if string.find(string.lower(v),"lead") then Lead = Lead + count end
					TotalCount = TotalCount + count
				end
				local msg = "; Total minerals: "..TotalCount.. " in RC: ".. TotalCount*0.2
				local ingots = "Iron: " .. math.floor(Iron).. ", Lead: " .. math.floor(Lead)..", Lithium: ".. math.floor(Lithium).. ", Zinc: ".. math.floor(Zinc)
				setClipboardText(ingots .. msg)
			end
			return true
		end
	end
end

