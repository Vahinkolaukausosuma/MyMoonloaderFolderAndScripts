function main()
	while true do
		local HSens = readMemory(0xB6EC1C, 4, 0)
		local VSens = readMemory(0xB6EC18, 4, 0)
		if VSens ~= HSens then
			writeMemory(0xB6EC18, 4, HSens, 0)
		end
		wait(1000)
	end
end