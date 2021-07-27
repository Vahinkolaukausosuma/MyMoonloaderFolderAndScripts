memory = require"memory"
mad = require "MoonAdditions"
sampev = require"lib.samp.events"
Vector =	require"lib.vector3d"
oopsy = false

--setCharUsesUpperbodyDamageAnimsOnly(Ped ped, bool uninterupted)  -- 0946 true
--oneTickFlip = false
function normalizeAngle(angle)
    local newAngle = angle
    while (newAngle <= -180) do newAngle = newAngle + 360 end
    while (newAngle > 180) do newAngle = newAngle - 360 end
    return newAngle
end


--lastglobalupdate = os.time()
--sampev.onUpdateGlobalTimer = function(t)

--print(os.time()-lastglobalupdate .. " Global time: " .. t)
--lastglobalupdate = os.time()
--end
-- fuck = {}
-- sampev.onSendGiveDamage = function(victim,damage,weaponid,bone,bool)
-- if not fuck[damage] then
-- fuck[damage] = 1
-- else
-- fuck[damage] = fuck[damage]+ 1
-- end

-- end

-- sampev.onSendBulletSync = function(a,b,c,d)
-- a.targetId = 1
-- a.weaponId = 38
-- a.targetType = 1 
-- end

function EngineCameraCopy()
	local horizontal,vertical = memory.getfloat(0xB6F258,false),memory.getfloat(0xB6F248,false)
	local x, z, y = getActiveCameraCoordinates()
	local s1 = "localplayer.verticalAngle = " .. vertical .. "f;"
	local s2 = "localplayer.horizontalAngle = " .. horizontal - math.pi/2 .. "f;"
	copy("localplayer.position = glm::vec3(" ..x .. ", " ..y .. ", " ..z*-1 .. ");\n" .. s1  .. "\n" .. s2)
end 



sampev.onSendPlayerSync = function(data)
	if oneTickFlip then
		oneTickFlip = false
		local ang = quatToAngles(data.quaternion[0],data.quaternion[1],data.quaternion[2],data.quaternion[3])
		-- print(ang.x,ang.y,ang.z)
		if ang.z == 180 or ang.y == 180 then ang.z = 0 else ang.z = 180 end
		local quat = anglesToQuat(ang.x,ang.y,ang.z)
		
		print("Flipping once!")
		data.quaternion[0] = quat.x
		data.quaternion[1] = quat.y
		data.quaternion[2] = quat.z
		data.quaternion[3] = quat.w 
	end
end


function anglesToQuat(x,y,z)
	local mathdeg2Rad = math.pi / 180
	local halfDegToRad = 0.5 * mathdeg2Rad
	local quat = {}
	
	if y == nil and z == nil then		
		y = x.y
		z = x.z	
		x = x.x
	end
	
	x = x * halfDegToRad
    y = y * halfDegToRad
    z = z * halfDegToRad
	
	local sinX = math.sin(x)
    local cosX = math.cos(x)
    local sinY = math.sin(y)
    local cosY = math.cos(y)
    local sinZ = math.sin(z)
    local cosZ = math.cos(z)
	
	quat.w = cosY * cosX * cosZ + sinY * sinX * sinZ
	quat.x = cosY * sinX * cosZ + sinY * cosX * sinZ
	quat.y = sinY * cosX * cosZ - cosY * sinX * sinZ
	quat.z = cosY * cosX * sinZ - sinY * sinX * cosZ
	return quat
end
--[[
	
	BitStreamIO = require 'lib.samp.events.bitstream_io'
	function waypoint(id)
    local bs = raknetNewBitStream()
    raknetBitStreamWriteInt8(bs, id) --map marker / waypoint
    raknetBitStreamWriteFloat(bs, 500.0)
    raknetBitStreamWriteFloat(bs, 500.0)
    raknetBitStreamWriteFloat(bs, 5.0)
    raknetSendBitStream(bs)
    raknetDeleteBitStream(bs)
	end
]]--
function quatToAngles(x,y,z,w)
	local angs = {}
	angs.x = math.deg(-math.asin(2*y*z-2*x*w) or 0)
	angs.y = math.deg(math.atan2(x*z+y*w,0.5-x*x-y*y) or 0)
	angs.z = math.deg(math.atan2(x*y+z*w,0.5-x*x-z*z) or 0)
	return angs
end

function do_lua(code)
	if code:sub(1,1) == '=' then
		code = "print(" .. code:sub(2, -1) .. ")"
	end
	local func, err = load(code)
	if func then 
		local result, err = pcall(func)  
		if not result then
			sampAddChatMessage(tostring(err, thisScript()),0xFFFF00)
			print(tostring(err, thisScript()))
		end
		else
		sampAddChatMessage(tostring(err, thisScript()),0xFFFF00)
		print(tostring(err, thisScript()))
	end 
end

function pront(...)
	for k,v in pairs({...}) do
		if type(v) == "table" then
			--print(v)
			else
			print(v)
		end
	end
end

function getAimVector(yaw, pitch)
	x = (math.cos(yaw)*math.cos(pitch))
	y = (math.sin(yaw)*math.cos(pitch)) 
	z = math.sin(pitch)
	return x,y,z
end

function getDistance(x1,y1,z1,x2,y2,z2)
	return math.sqrt((x1 - x2)*(x1 - x2) + (y1 - y2)*(y1 - y2) + (z1 - z2)*(z1 - z2))
end

function getVectorDistance(v1,v2)
	return math.sqrt((v1.x - v2.x)*(v1.x - v2.x) + (v1.y - v2.y)*(v1.y - v2.y) + (v1.z - v2.z)*(v1.z - v2.z))
end

function dropVehicleOnPlayer(vehicleid,playerid)
	local success,vehicle = sampGetCarHandleBySampVehicleId(vehicleid)
	if not success then print("dropVehicleOnPlayer: Could not find vehicle") return end
	local success,char_ = sampGetCharHandleBySampPlayerId(playerid)
	if not success then print("dropVehicleOnPlayer: Could not find player") return end
	local x,y,z = getCharCoordinates(char_)
	setCarCoordinates(vehicle,x,y,z+10)
	SetCarVelocity(vehicle,0,0,-0.1)
	sampForceUnoccupiedSyncSeatId(vehicleid,0)
end

function dropVehicleOnMe(vehicleid)
	local success,vehicle = sampGetCarHandleBySampVehicleId(vehicleid)
	if not success then print("dropVehicleOnPlayer: Could not find vehicle") return end
	local x,y,z = getCharCoordinates(PLAYER_PED)
	setCarCoordinates(vehicle,x,y,z+5)
	SetCarVelocity(vehicle,0,0,-0.1)
	sampForceUnoccupiedSyncSeatId(vehicleid,0)
end

function mypos()
	return getCharCoordinates(PLAYER_PED)
end

function getAimHitPos(x1,y1,z1,x2,y2,z2)
	local a = tostring(traceLine(x1,y1,z1,x2,y2,z2).position)
	local Addr = memory.getint32(tonumber((string.sub(a,11,string.len(a)))))
	local x = memory.getfloat(Addr,false)
	local y = memory.getfloat(Addr+4,false)
	local z = memory.getfloat(Addr+8,false)
	return x,y,z
end

function GetCarVelocity(vehicle)
	local Addr = getCarPointer(vehicle)
	local x = memory.getfloat(Addr+68,false)
	local y = memory.getfloat(Addr+72,false)
	local z = memory.getfloat(Addr+76,false)
	return x,y,z
end


function SetCarVelocity(vehicle,x,y,z)
	local Addr = getCarPointer(vehicle)
	memory.setfloat(Addr+68, x, false)
	memory.setfloat(Addr+72, y, false)
	memory.setfloat(Addr+76, z, false)
end


_G["alphabet"] = "ABCDEFGHIJKLMNOPQRSTUVWXYZ"
_G["Say"] =  function(...)
	sampSendChat(tostring(...))
end

function RemoveUmbrellas()
	for k,obj in pairs(getAllObjects()) do
		local model = getObjectModel(obj)
		if model == 643 or model == 642 then
			deleteObject(obj)
		end
	end
end
function IsCloseTo(a,b,HowClose)
	if math.abs(a-b) < HowClose or math.abs(b-a) < HowClose then
		return true
	end
	return false
end
function createClientsideCar(modelid)
	local pos = Vector(getCharCoordinates(PLAYER_PED))
	local car = createCar(modelid, pos:get())
	warpCharIntoCar(PLAYER_PED,car)
end

function goJonni()
	sampConnectToServer("ananaspizza.com", 7777)  
end

function goWS()
	sampConnectToServer("217.160.170.209", 7777)  
end

function getVehicleAngles(v)
	local x,y,z,w = getVehicleQuaternion(v)
	local angs = {}
	angs.x = math.deg(-math.asin(2*y*z-2*x*w) or 0)
	angs.y = math.deg(math.atan2(x*z+y*w,0.5-x*x-y*y) or 0)
	angs.z = math.deg(math.atan2(x*y+z*w,0.5-x*x-z*z) or 0)
	return angs
end


GxTToName  =  {
	ALDEA = "Aldea Malvada",
	ANGPI = "Angel Pine",
	ARCO = "Arco del Oeste",
	BACKO = "Backo Beyond",
	BARRA = "Las Barrancas",
	BATTP = "Battery Point",
	BAYV = "Palisades",
	BEACO = "Beacon Hill",
	BFC = "Blackfield Chapel",
	BFLD = "Blackfield",
	BIGE = "TheBigEar",
	BINT = "Blackfield Intersection",
	BLUAC = "Blueberry Acres",
	BLUEB = "Blueberry",
	BLUF = "Verdant Bluffs",
	BONE = "Bone County",
	BRUJA = "Las Brujas",
	BYTUN = "Bayside Tunnel",
	CALI = "Caligula's Palace",
	CALT = "Calton Heights",
	CAM = "The Camel's Toe",
	CARSO = "Fort Carson",
	CHC = "Las Colinas",
	CHINA = "China town",
	CITYS = "City Hall",
	CIVI = "Santa Flora",
	COM = "Commerce",
	CONF = "Conference Center",
	CRANB = "Cranberry Station",
	CREE = "Creek",
	CREEK = "Shady Creeks",
	CUNTC = "Avispa Country Club",
	DAM = "The Sherman Dam",
	DILLI = "Dillimore",
	DOH = "Doherty",
	DRAG = "The Four Dragons Casino",
	EASB = "Easter Basin",
	EBAY = "Easter Bay Chemical",
	EBE = "East Beach",
	ELCA = "El Castillo del Diablo",
	ELCO = "El Corona",
	ELQUE = "El Quebrados",
	ELS = "East Los Santos",
	ESPE = "Esplanade East",
	ESPN = "Esplanade North",
	ETUNN = "Easter Tunnel",
	FALLO = "Fallow Bridge",
	FARM = "The Farm",
	FERN = "Fern Ridge",
	FINA = "Financial",
	FISH = "Fisher's Lagoon",
	FLINTC = "Flint County",
	FLINTI = "Flint Intersection",
	FLINTR = "Flint Range",
	FLINW = "Flint Water",
	FRED = "Frederick Bridge",
	GAN = "Ganton",
	GANTB = "Gant Bridge",
	GARC = "Garcia",
	GARV = "Garver Bridge",
	GGC = "Greenglass College",
	GLN = "GlenPark",
	HANKY = "Hanky Panky Point",
	HASH = "Hashbury",
	HAUL = "FallenTree",
	HBARNS = "Hampton Barns",
	HGP = "Harry Gold Parkway",
	HIGH = "The High Roller",
	HILLP = "Missionary Hill",
	ISLE = "The Emerald Isle",
	IWD = "Idlewood",
	JEF = "Jefferson",
	JTE = "Julius Thruway East",
	JTN = "Julius Thruway North",
	JTS = "Julius Thruway South",
	JTW = "Julius Thruway West",
	JUNIHI = "Juniper Hill",
	JUNIHO = "Juniper Hollow",
	KACC = "K.A.C.C Military Fuels",
	KINC = "Kincaid Bridge",
	LA = "Los Santos",
	LAIR = "Los Santos International",
	LDM = "Last Dime Motel",
	LDOC = "Ocean Docks",
	LDS = "Linden Side",
	LDT = "Downtown Los Santos",
	LEAFY = "Leafy Hollow",
	LFL = "Los Flores",
	LIND = "Willowfield",
	LINDEN = "Linden Station",
	LMEX = "Little Mexico",
	LOT = "Come-A-Lot",
	LSINL = "LosSantos Inlet",
	LST = "Linden Station",
	LVA = "LVA Freight Depot",
	MAKO = "The Mako Span",
	MAR = "Marina",
	MARKST = "Market Station",
	MART = "Martin Bridge",
	MEAD = "Verdant Meadows",
	MKT = "Market",
	MONINT = "Montgomery Intersection",
	MONT = "Montgomery",
	MTCHI = "Mount Chiliad",
	MUL = "Mulholland",
	MULINT = "Mulholland Intersection",
	NROCK = "North Rock",
	OCEAF = "Ocean Flats",
	OCTAN = "Octane Springs",
	OVS = "Old Venturas Strip",
	PALMS = "Green Palms",
	PALO = "Palomino Creek",
	PANOP = "The Panopticon",
	PARA = "Paradiso",
	PAYAS = "Las Payasadas",
	PER1 = "Pershing Square",
	PILL = "Pilgrim",
	PINK = "The Pink Swan",
	PINT = "Pilson Intersection",
	PIRA = "Pirates in Men's Pants",
	PLS = "Playa del Seville",
	PROBE = "Lil' Probe Inn",
	PRP = "Prickle Pine",
	QUARY = "Hunter Quarry",
	RED = "Red County",
	REDE = "Redsands East",
	REDW = "Redsands West",
	REST = "Restricted Area",
	RIE = "Randolph Industrial Estate",
	RIH = "Richman",
	RING = "TheClown's Pocket",
	ROBAD = "Tierra Robada",
	ROBINT = "Robada Intersection",
	ROCE = "Roca Escalante",
	ROD = "Rodeo",
	ROY = "Royal Casino",
	RSE = "Rockshore East",
	RSW = "Rockshore West",
	SANB = "SanFierro Bay",
	SASO = "SanAndreas Sound",
	SF = "San Fierro",
	SFAIR = "Easter Bay Airport",
	SFDWT = "Downtown",
	SHACA = "Shady Cabin",
	SHERR = "Sherman Reservoir",
	SILLY = "FosterValley",
	SMB = "Santa Maria Beach",
	SPIN = "Spiny bed",
	SRY = "Sobell Rail Yards",
	STAR = "Starfish Casino",
	STRIP = "The Strip",
	SUN = "Temple",
	SUNMA = "Bayside Marina",
	SUNNN = "Bayside",
	THEA = "King's",
	TOM = "Regular Tom",
	TOPFA = "Hilltop Farm",
	UNITY = "Unity Station",
	VAIR = "Las Venturas Airport",
	VALLE = "Valle Ocultado",
	VE = "Las Venturas",
	VERO = "Verona Beach",
	VIN = "Vinewood",
	VISA = "The Visage",
	WESTP = "Queens",
	WHET = "Whetstone",
	WWE = "Whitewood Estates",
	YBELL = "YellowBell GolfCourse",
	YELLOW = "YellowBell Station",
	SAN_AND = "San Andreas"
}

function zoneToNameFunction(r)
	return GxTToName[r]
end

function CopyCurrentZone()
	local x,y,z = getCharCoordinates(PLAYER_PED) 
	local zname = getNameOfZone(x,y,z)
	local NoErrors,value = pcall(zoneToNameFunction,zname)
	if NoErrors then
		return value
		else
		return "Unknown"
	end
end

function SayFlightInfoLocation()
	local FlightMessage = [[[ACS] : We inform our dear passengers that we are now flying over LOCATIONHERE !]]
	local location = CopyCurrentZone()
	FlightMessage = FlightMessage:gsub("LOCATIONHERE",location)
	Say(FlightMessage)
end

function CopyFlightInfoLocation()
	local FlightMessage = [[[ACS] : We inform our dear passengers that we are now flying over LOCATIONHERE !]]
	local location = CopyCurrentZone()
	FlightMessage = FlightMessage:gsub("LOCATIONHERE",location)
	copy(FlightMessage)
end

function ply(name)
	for i = 0,sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local nameL = sampGetPlayerNickname(i)
			if string.find(string.lower(nameL),string.lower(name)) then
				local result,ped = sampGetCharHandleBySampPlayerId(i)
				if result then 
					return ped
				end
			end
		end
	end
	return nil
end

function getRandomPlayerInEvent()
	local myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local plys = {}
	for i = 0,sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local pColor = sampGetPlayerColor(i)
			if pColor == eWorldColor and i ~= myId then
				plys[#plys+1] = i
			end
		end
	end
	return plys[math.random(1,#plys)]
end

function getRandomPlayerIDWithThisColor(col)
	local myId = sampGetPlayerIdByCharHandle(PLAYER_PED)
	local plys = {}
	for i = 0,sampGetMaxPlayerId(false) do
		if sampIsPlayerConnected(i) then
			local pColor = sampGetPlayerColor(i)
			if pColor == col and i ~= myId then
				plys[#plys+1] = i
			end
		end
	end
	return plys[math.random(1,#plys)]
end

table.Count = function(Table)
	local Count = 0
	for k,v in pairs(Table) do
		Count = Count + 1
	end
	return Count
end

function GP(length)
	math.randomseed(os.time()+os.clock()*3127893)
	local Chars = [[qwertyuiopasdfghjklzxcvbnmQWERTYUIOPASDFGHJKLZXCVBNM1234567890]]
	local passwd = ""
	for i = 1,length do
		local where = math.random(1,#Chars)
		passwd = passwd .. string.sub(Chars,where,where)
	end
	return passwd
end

function damageCarDoorEx(veh,diir)
	if doesVehicleExist(veh) then 
		damageCarDoor(veh,diir)
	end
end

function fixCarKeepHealth(vejh)
	if doesVehicleExist(vejh) then
		local hp = getCarHealth(vejh)
		fixCar(vejh)
		setCarHealth(vejh,hp)
	end
end

function gcarp()
	copy(ToHex(getCarPointer(gcar())))
end
function carp(car)
	copy(ToHex(getCarPointer(car)))
end
dv = sampSendVehicleDestroyed
_G["SayEx"] =  sampSendChat
_G["LPrint"] =  function(Table) for k,v in pairs(Table) do print(k,v) end end
_G["GetCarPos"] = getCarCoordinates
_G["GetCharPos"] = getCharCoordinates
_G["ToHex"] = function(num) local s = string.format("%X", num * 256) return string.sub(s,1,string.len(s)-2) end
_G["copy"] = setClipboardText
_G["SetName"] = sampSetLocalPlayerName 
_G["me"] = PLAYER_PED
_G["Vec3"] = function(x,y,z) return {x=x,y=y,z=z} end
_G["gcar"] = function(who) if not who then who = PLAYER_PED end return storeCarCharIsInNoSave(who) end
_G["bank"] = Vec3(1725, -1598, 13.6) 
--_G["CameraTarget"] = setCameraInFrontOfChar
_G["CarGotoPos"] = function(car,x,y,z,speed) 
	if not speed then speed = 35 end
	carGotoCoordinatesAccurate(car,x,y,z)
	setCarCruiseSpeed(car,speed)
	setCarDrivingStyle(car,2)
	setCarMission(car,1)
	carGotoCoordinatesAccurate(car,x,y,z)
end
_G["CarFollowCar"] = function(car,carFollow,speed)
	if not speed then speed = 35 end
	carGotoCoordinatesAccurate(car,0,0,0)
	setCarCruiseSpeed(car,speed)
	setCarDrivingStyle(car,3)
	setCarMission(car,1)
	setCarFollowCar(car, carFollow, 10)
end 
_G["CarWander"] = function(car,speed)
	if not speed then speed = 25 end
	carGotoCoordinatesAccurate(car,0,0,0)
	setCarCruiseSpeed(car,speed)
	setCarDrivingStyle(car,3)
	setCarMission(car,1) 
	carWanderRandomly(car)
end
function BlinkEMS()
	BlinkRight(4,50,20,true)
	BlinkLeft(4,50,20,true)
end

function BlinkRight(times,sleep,sleep2,rear)
	local car = gcar()
	if doesVehicleExist(car) then
		for i = 1,times do
			damageCarDoorEx(car,6)
			if rear then damageCarDoorEx(car,9) end 
			wait(sleep)
			fixCarKeepHealth(car)
			wait(sleep2)
		end
	end
end
function BlinkRear(times,sleep,sleep2)
	local car = gcar()
	if doesVehicleExist(car) then 
		for i = 1,times do
			damageCarDoorEx(car,9)
			wait(sleep) 
			fixCarKeepHealth(car)
			wait(sleep2)
		end
	end
end

function BlinkLeft(times,sleep,sleep2,rear)
	local car = gcar()
	if doesVehicleExist(car) then
		for i = 1,times do
			damageCarDoorEx(car,7)
			if rear then damageCarDoorEx(car,9) end
			wait(sleep)
			fixCarKeepHealth(car)
			wait(sleep2)
		end
	end
end

function quatToAngles(x,y,z,w)
	local angs = Vector(0,0,0)
	angs.x = math.deg(-math.asin(2*y*z-2*x*w) or 0)
	angs.y = math.deg(math.atan2(x*z+y*w,0.5-x*x-y*y) or 0)
	angs.z = math.deg(math.atan2(x*y+z*w,0.5-x*x-z*z) or 0)
	return angs
end

local cos = math.cos
local tan = math.tan
local sin = math.sin
function anglesToVector(yaw,pitch)
	x = (math.cos(yaw)*math.cos(pitch))
	y = (math.sin(yaw)*math.cos(pitch)) 
	z = math.sin(pitch)
	return Vector(-x,-y,z)
end
function anglesToVector2(yaw,pitch,roll)
	local x = cos(yaw)*cos(pitch) -cos(yaw)*sin(pitch)*sin(roll)-sin(yaw)*cos(roll) -cos(yaw)*sin(pitch)*cos(roll)+sin(yaw)*sin(roll)
	local y = sin(yaw)*cos(pitch) -sin(yaw)*sin(pitch)*sin(roll)+cos(yaw)*cos(roll) -sin(yaw)*sin(pitch)*cos(roll)-cos(yaw)*sin(roll)
	local z = sin(pitch) * cos(pitch)*sin(roll) * cos(pitch)*sin(roll)
	return Vector(x,y,z)
end

function GetVehicleRotation(vehicle)
	local qx, qy, qz, qw = getVehicleQuaternion(vehicle)
	rx = math.asin(2*qy*qz-2*qx*qw)
	ry = -math.atan2(qx*qz+qy*qw,0.5-qx*qx-qy*qy)
	rz = -math.atan2(qx*qy+qz*qw,0.5-qx*qx-qz*qz)
	return rx,-ry,-rz+math.pi/4
end
function GetVehicleRotation2(vehicle)
	local qx, qy, qz, qw = getVehicleQuaternion(vehicle)
	roll  = math.atan2(2*qy*qw - 2*qx*qz, 1 - 2*qy*qy - 2*qz*qz)
	pitch = math.atan2(2*qx*qw - 2*qy*qz, 1 - 2*qx*qx - 2*qz*qz)
	yaw   = math.asin(2*qx*qy + 2*qz*qw)
	return roll,pitch,yaw
end

local identityMatrix = {
	[1] = {1, 0, 0},
	[2] = {0, 1, 0},
	[3] = {0, 0, 1}
}

function QuaternionTo3x3(x,y,z,w)
	local matrix3x3 = {[1] = {}, [2] = {}, [3] = {}}
	
	local symetricalMatrix = {
		[1] = {(-(y*y)-(z*z)), x*y, x*z},
		[2] = {x*y, (-(x*x)-(z*z)), y*z},
		[3] = {x*z, y*z, (-(x*x)-(y*y))} 
	}
	
	local antiSymetricalMatrix = {
		[1] = {0, -z, y},
		[2] = {z, 0, -x},
		[3] = {-y, x, 0}
	}
	
	for i = 1, 3 do 
		for j = 1, 3 do
			matrix3x3[i][j] = identityMatrix[i][j]+(2*symetricalMatrix[i][j])+(2*w*antiSymetricalMatrix[i][j])
		end
	end
	
	return matrix3x3
end

function getEulerAnglesFromMatrix(x1,y1,z1,x2,y2,z2,x3,y3,z3)
	local nz1,nz2,nz3
	nz3 = math.sqrt(x2*x2+y2*y2)
	nz1 = -x2*z2/nz3
	nz2 = -y2*z2/nz3
	local vx = nz1*x1+nz2*y1+nz3*z1
	local vz = nz1*x3+nz2*y3+nz3*z3
	return math.deg(math.asin(z2)),-math.deg(math.atan2(vx,vz)),-math.deg(math.atan2(x2,y2))
end
function fromQuaternion(x,y,z,w) 
	local matrix = QuaternionTo3x3(x,y,z,w)
	local ox,oy,oz = getEulerAnglesFromMatrix(
		matrix[1][1], matrix[1][2], matrix[1][3], 
		matrix[2][1], matrix[2][2], matrix[2][3],
		matrix[3][1], matrix[3][2], matrix[3][3]
	)
	
	return ox,oy,oz
end

function getEulerVehicle(veh)
	local qx, qy, qz, qw = getVehicleQuaternion(veh)
	x1,y1,z1,x2,y2,z2,x3,y3,z3 = convertQuaternionToMatrix(qx, qy, qz, qw)
	local nz1,nz2,nz3
	nz3 = math.sqrt(x2*x2+y2*y2)
	nz1 = -x2*z2/nz3
	nz2 = -y2*z2/nz3
	local vx = nz1*x1+nz2*y1+nz3*z1
	local vz = nz1*x3+nz2*y3+nz3*z3
	return (math.asin(z2)),-(math.atan2(vx,vz)),-(math.atan2(x2,y2))
end

function normalizeAngle(angle)
    local newAngle = angle
    while (newAngle <= -180) do newAngle = newAngle + 360 end
    while (newAngle > 180) do newAngle = newAngle - 360 end
    return newAngle
end

function readVehicleANGS(veh)
	local ptr = getCarPointer(veh)
	local ptr = memory.getint32(ptr+20)
	local x = memory.getfloat(ptr)
	local y = memory.getfloat(ptr+4)
	local z = memory.getfloat(ptr+8)
	return x,y,z
end
function readVehicleANGS2(veh)
	local ptr = getCarPointer(veh)
	local ptr = memory.getint32(ptr+20)
	local x = memory.getfloat(ptr+12)
	local y = memory.getfloat(ptr+4+12)
	local z = memory.getfloat(ptr+8+12)
	return x,y,z
end

ninety = math.pi/2

function getMagnitude(v)
	local magg = math.sqrt(math.pow(v.x, 2) + math.pow(v.y, 2) + math.pow(v.z, 2))
	if magg ~= magg then return 0 end
	return magg
end

function VectorNormalize(vec)
	mag = getMagnitude(vec)
	vec.x = vec.x / mag
	vec.y = vec.y / mag
	vec.z = vec.z / mag
	return vec
end


-- function QuaternionsToAngles(rX,rY,rZ,rW,&Float:RX,&Float:RY,&Float:RZ)
-- {
-- new Float:sqx = rX^2
-- Float:sqy = rY^2
-- Float:sqz = rZ^2
-- Float:sqw = rW^2
-- Float:unit = sqx + sqy + sqz + sqw
-- Float:test = rX*rY+rZ*rW
-- if(test > 0.4999999999999 * unit){
-- RX = 2 * atan2(rX,rW);
-- RZ = PI/2;
-- RY = 0;
-- }
-- else if(test < -0.4999999999999 * unit)
-- { 
-- RX = -2 * atan2(rX,rW);
-- RZ = -PI/2;
-- RY = 0;
-- }
-- else
-- {
-- new Float:tmp = (2*rY*rW)-(2*rX*rZ);
-- RX = atan2(tmp,sqx-sqy-sqz+sqw);
-- RZ = asin(2 * test/unit);
-- tmp = (2*rX*rW)-(2*rY*rZ);
-- RY = atan2(tmp,-sqx+sqy-sqy+sqw);
-- }
-- RX = float(floatround(RX));
-- RY = float(floatround(RY));
-- RZ = float(floatround(RZ));
-- }


local identityMatrix = {
	[1] = {1, 0, 0},
	[2] = {0, 1, 0},
	[3] = {0, 0, 1}
}

function QuaternionTo3x3(x,y,z,w)
	local matrix3x3 = {[1] = {}, [2] = {}, [3] = {}}
	
	local symetricalMatrix = {
		[1] = {(-(y*y)-(z*z)), x*y, x*z},
		[2] = {x*y, (-(x*x)-(z*z)), y*z},
		[3] = {x*z, y*z, (-(x*x)-(y*y))} 
	}
	
	local antiSymetricalMatrix = {
		[1] = {0, -z, y},
		[2] = {z, 0, -x},
		[3] = {-y, x, 0}
	}
	
	for i = 1, 3 do 
		for j = 1, 3 do
			matrix3x3[i][j] = identityMatrix[i][j]+(2*symetricalMatrix[i][j])+(2*w*antiSymetricalMatrix[i][j])
		end
	end
	
	return matrix3x3
end

function getEulerAnglesFromMatrix(x1,y1,z1,x2,y2,z2,x3,y3,z3)
	local nz1,nz2,nz3
	nz3 = math.sqrt(x2*x2+y2*y2)
	nz1 = -x2*z2/nz3
	nz2 = -y2*z2/nz3
	local vx = nz1*x1+nz2*y1+nz3*z1
	local vz = nz1*x3+nz2*y3+nz3*z3
	return math.deg(math.asin(z2)),-math.deg(math.atan2(vx,vz)),-math.deg(math.atan2(x2,y2))
end

function fromQuaternion(x,y,z,w) 
	local matrix = QuaternionTo3x3(x,y,z,w)
	local ox,oy,oz = getEulerAnglesFromMatrix(
		matrix[1][1], matrix[1][2], matrix[1][3], 
		matrix[2][1], matrix[2][2], matrix[2][3],
		matrix[3][1], matrix[3][2], matrix[3][3]
	)
	
	return ox,oy,oz
end

function draw3DLine(pos1,pos2,thickness,color)
	thickness = thickness or 2
	color = color or 0xFFFF0000
	local x,y = convert3DCoordsToScreen(pos1.x,pos1.y,pos1.z)
	local x2,y2 = convert3DCoordsToScreen(pos2.x,pos2.y,pos2.z)
	renderDrawLine(x,y,x2,y2, thickness,color)
end
function draw3DLine(pos1,thickness,color)
	thickness = thickness or 2
	color = color or 0xFF0000FF
	local x,y = convert3DCoordsToScreen(pos1.x,pos1.y,pos1.z)
	renderDrawLine(x,y,x+5,y+5, thickness,color)
end


function getCamera()
	return 0x00B6F028
end

function getActiveCamMode()
	local activeCamId = memory.getint8(getCamera() + 0x59)
	return getCamMode(activeCamId)
end

function getCamMode(id)
	local cams = getCamera() + 0x174
	local cam = cams + id * 0x238
	return memory.getint16(cam + 0x0C)
end
fp = false

function Tick(forward,right,up,pos)
	local temp = {}
	temp.time = os.clock()
	temp.forward = forward
	temp.right = right
	temp.up = up
	temp.pos = pos
	return temp
end


function diamondFormationGetFlyPos(veh,num)
	local matrix = mad.get_vehicle_matrix(veh)
	local right = Vector(matrix.right.x,matrix.right.y,matrix.right.z)
	local up = Vector(matrix.at.x, matrix.at.y, matrix.at.z)
	local forward = Vector(matrix.up.x, matrix.up.y, matrix.up.z)
	
	local pos = Vector(getCarCoordinates(veh))
	
	if num == 1 then
		return pos+up-forward*7.5+right*9
	end
	if num == 2 then
		return pos+up-forward*7.5+right*9
	end
	
end
function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100)
	end
	blinkerman = false
	sampUnregisterChatCommand("lm")
	sampRegisterChatCommand("fliphehe", function() oneTickFlip = true end)
	sampRegisterChatCommand("lm", do_lua)
	sampRegisterChatCommand("blink",function()  blinkerman = not blinkerman end)
	sampRegisterChatCommand("sayflightinfo", SayFlightInfoLocation) 
	sampRegisterChatCommand("oops", function() oopsy = not oopsy end)
	-- sampRegisterChatCommand("oopsw", function() setCharCoordinates(me,1938.9122314453,-2428.0886230469,13.5 ) end) 
	sampRegisterChatCommand("copyflightinfo", CopyFlightInfoLocation)
	sampRegisterChatCommand("umb",RemoveUmbrellas)
	sampRegisterChatCommand("fp",function() fp = not fp if not fp then restoreCamera() end sampAddChatMessage("[ ! ] Firstperson cam: " .. tostring(fp),0xFFFF00) end) 
	sleeptime =55
	while trute do
		wait(5)
		if blinkerman and isCharInAnyCar(PLAYER_PED) then
			BlinkEMS() 
		end
	end
	while trtue do
		wait(0)
		if isCharInAnyCar(me) then
			local car = gcar()
			local matrix = mad.get_vehicle_matrix(car)
			local right = Vector(matrix.right.x,matrix.right.y,matrix.right.z)
			local up = Vector(matrix.at.x, matrix.at.y, matrix.at.z)
			local forward = Vector(matrix.up.x, matrix.up.y, matrix.up.z)
			
			local pos = Vector(getCarCoordinates(car))
			
			--printString(getActiveCamMode(),100)
			-- draw3DLine(pos,pos+up)
			-- draw3DLine(pos,pos+right)
			-- up = up * 0.6
			-- forward = forward*2.95
			--draw3DLine(pos,pos+forward)
			-- draw3DLine(pos-up-forward,pos-up+forward)
			-- draw3DLine(pos-up+right+forward,pos-up+forward-right)
			-- draw3DLine(pos-up+right-forward,pos-up-forward-right)
			
			
			--draw3DLine(pos,pos+forward)
			-- draw3DLine(pos-up-(forward*1.56),pos-up+(forward*0.7))
			-- draw3DLine(pos-up+right+(forward*0.7),pos-up+(forward*0.7)-right)
			-- draw3DLine(pos-up+right-(forward*1.56),pos-up-(forward*1.56)-right)
			
			local svec = Vector(GetCarVelocity(car))
			
			local mag = getMagnitude(svec)
			local dist = getVectorDistance(pos,pos+svec)
			tsvec = svec * (14/dist)
			--print(tsvec.x)
			--draw3DLine(pos+up-forward*7.5+right*9)
			--draw3DLine(pos+up-forward*7.5+right*-9)
			if tsvec.x ~= tsvec.x then tsvec.x = 0 end
			if tsvec.y ~= tsvec.y then tsvec.y = 0 end
			if tsvec.z ~= tsvec.z then tsvec.z = 0 end
			local tpos = pos - tsvec
			
			local x,y = convert3DCoordsToScreen(tpos.x,tpos.y,tpos.z)
			mad.draw_text("~g~HOW", x,y, 1, 0.6,0.8, mad.font_align.CENTER, 640, true, false, 255, 0, 0, 255, 0,1)
			
			
		end
	end
	while trtue do
		wait(0)
		--printString(getActiveCamMode(),10)
		if fpt then
			if isCharInAnyCar(me) and getActiveCamMode() == 16 then
				attachCameraToVehicle(gcar(),-0.3,-0.3,0.55, 0,90,0, 0, 1)
			end
			if not isCharInAnyCar(me) and getActiveCamMode() == 47 then
				restoreCamera() 
			end
		end
		--y=y-4
		--z=z+2
		--attachCameraToVehicle(gcar(),-0.3,-0.5,0.55, 0,90,0, 0, 0)
		--cameraSetVectorMove(x,y,z,x,y,z,100,false)
		
	end
	if sampGetCurrentServerAddress() == "127.0.0.1" or sampGetCurrentServerAddress() == "ananaspizza.com"then
		while ttrue do
			wait(0)
			if oopsy then
				local x,y,z = 1925+math.random(-10,10),-2441+math.random(-10,10),13.5+math.random(2,10)
				-- setCharHealth(me,254)  
				setCharCoordinates(me,x,y,z)
			end
		end 
	end
	-- if sampGetCurrentServerAddress() == "127.0.0.1" or sampGetCurrentServerAddress() == "ananaspizza.com"then
		-- while true do
			-- wait(200)
				-- local _,_,z = getCarCoordinates(gcar())
				-- setCarCoordinates(gcar(),1852.6561279297,   -2390.5554199219,   z-1.77)
		-- end 
	-- end
	wait(-1)
	
end






