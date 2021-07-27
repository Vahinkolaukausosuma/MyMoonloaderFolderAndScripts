function SaveObjects(filename)
	Objs = {}
	for k,obj in pairs(getAllObjects()) do
	if sampGetObjectSampIdByHandle(obj) ~= -1 then
		local num = #Objs+1
		Objs[num] = {}
		_,Objs[num].PosX,Objs[num].PosY,Objs[num].PosZ = getObjectCoordinates(obj)
		Objs[num].QuatX,Objs[num].QuatY,Objs[num].QuatZ,Objs[num].QuatW = getObjectQuaternion(obj)
		Objs[num].ModelID = getObjectModel(obj)
	end
	f = io.open(filename..".json","w")
	f:write(encodeJson(Objs))
	f:close()
	end
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100)
	end
	sampRegisterChatCommand("saveobj", SaveObjects)
	wait(-1)
end