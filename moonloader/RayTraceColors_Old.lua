local memory = require"memory"
--local Vector = require"lib.vector3d"
local mad = require"MoonAdditions"
_G["ToHex"] = function(num) local s = string.upper(string.format("%x", num * 256)) return string.sub(s,1,string.len(s)-2) end
local FovX = math.pi/2
local FovY = math.pi/2
local Width = 1920/4
local Height = 1080/4
local MinDepth = 5000
local MaxDepth = 0
local DistMult = 1.5
local DepthMap = {} 
local yaw = 0
local pitch = 0
local Trace = mad.get_collision_between_points
local checkSolid = true
local checkCar = true
local checkPed = false
local checkObject = false
local checkParticle = false
local checkseeThrough = false
local ignoreSomeObjects = false
local checkshootThrough = false
aaa=[[
local checkSolid = true 
local checkCar = false
local checkPed = false
local checkObject = true
local checkParticle = false
local checkseeThrough = true
local ignoreSomeObjects = false
local checkshootThrough = true
]]
local function getAimVectorVariable(yawAngle, pitchAngle, ass)
	local Yaw = yaw + yawAngle
	local Pitch = pitch + pitchAngle
	x = (math.cos(Yaw)*math.cos(Pitch))
	y = (math.sin(Yaw)*math.cos(Pitch)) 
	z = math.sin(Pitch)
	return x*ass,y*ass,z*ass
end

local function map(x, in_min,in_max, out_min, out_max)
	return (x - in_min) * (out_max - out_min) / (in_max - in_min) + out_min
end

local function getTraceHitPosEx(x1,y1,z1,x2,y2,z2)
	aa = Trace(x1,y1,z1,x2,y2,z2,{})
	if aa and aa.position then
		local a = tostring(aa.position)
		if a then
			local Addr = memory.getint32(tonumber((string.sub(a,11,string.len(a)))))
			local x = memory.getfloat(Addr,false)
			local y = memory.getfloat(Addr+4,false)
			local z = memory.getfloat(Addr+8,false)
			return x,y,z
		end
	end
	return nil
end
local function getTraceHitPos(x1,y1,z1,x2,y2,z2)
	local a,b = processLineOfSight(x1,y1,z1,x2,y2,z2, checkSolid, checkCar, checkPed, checkObject, checkParticle, checkseeThrough, ignoreSomeObjects, checkshootThrough)
	if a then
		return b.pos[1],b.pos[2],b.pos[3]
	end
	return nil
end
function getTraceHitPosEx(p1x,p1y,p1z,p2x,p2y,p2z)
	aa = Trace(p1x,p1y,p1z,p2x,p2y,p2z,{
		vehicles=true,
		peds=true,
		buildings=true,
		dummies=true,
		see_through=true,
		shoot_through=true,
		ignore_some_objects=false
	},getCharPointer(PLAYER_PED))
	
	if aa and aa.normal then
		return aa.position.x,aa.position.y,aa.position.z
	end
	return nil,nil,nil
end

aaaaa=[[
function getTraceHitPos(x1,y1,z1,x2,y2,z2)
	local a,b = processLineOfSight(x1,y1,z1,x2,y2,z2, true, true, true, true, false, false, false, false)
	if a then
		return b.pos[1],b.pos[2],b.pos[3]
	end
	return nil
end
]]
local function HSV(h, s, v)
    if s <= 0 then return v,v,v end
    h, s, v = h/256*6, s/255, v/255
    local c = v*s
    local x = (1-math.abs((h%2)-1))*c
    local m,r,g,b = (v-c), 0,0,0
    if h < 1     then r,g,b = c,x,0
		elseif h < 2 then r,g,b = x,c,0
		elseif h < 3 then r,g,b = 0,c,x
		elseif h < 4 then r,g,b = 0,x,c
		elseif h < 5 then r,g,b = x,0,c
		else              r,g,b = c,0,x
	end return (r+m)*255,(g+m)*255,(b+m)*255
end

local function CalculateDepth()
	for y=0,Height+1 do
		DepthMap[y] = {}
		for x=0,Width+1 do 
			DepthMap[y][x] = 0
		end
	end
	local MyPosX,MyPosY,MyPosZ = getCharCoordinates(PLAYER_PED)
	MyPosZ = MyPosZ + 0.785
	yaw = memory.getfloat(0xB6F258,false)-math.pi
	
	pitch = -memory.getfloat(0xB6F248,false)
	for u = 1,Height do 
		for i = 1,Width do
		
			local AimVecX,AimVecY,AimVecZ = getAimVectorVariable(FovY/2 - FovY*(i/Width),FovX/2 - (FovX)*(u/Height),1000)
			local AwayPosX,AwayPosY,AwayPosZ = MyPosX + AimVecX, MyPosY + AimVecY, MyPosZ + AimVecZ
			
			local HitPosX,HitPosY,HitPosZ = getTraceHitPosEx(MyPosX,MyPosY,MyPosZ,AwayPosX,AwayPosY,AwayPosZ)
			if HitPosX then
				local dist = getDistanceBetweenCoords3d(MyPosX,MyPosY,MyPosZ,HitPosX,HitPosY,HitPosZ)
				DepthMap[u][i] = dist
				if dist > MaxDepth then MaxDepth = dist end
				if dist < MinDepth then MinDepth = dist end
			end
		end
	end
end

local function SaveImage(filename)
	StartTime = os.clock()
	CalculateDepth()
	local f = io.open(filename..".ppm","w")
	f:write("P3\n"..Width.. " ".. Height.. "\n255\n")
	for u = Height,1,-1 do 
		for i = Width,1,-1 do
			local Depth = map(DepthMap[u][i]*DistMult,MinDepth,MaxDepth,0,255)
			if DepthMap[u][i] == 0 then
				--r,g,b = 0,191,255
				r,g,b = 0,0,0
				else
				r,g,b = HSV(Depth+11,200,200)
				--r,g,b = Depth,Depth,Depth
			end
			--local r,g,b = Depth,Depth,Depth
			r,g,b = math.floor(r), math.floor(g), math.floor(b)
			f:write(r.. " ".. g.. " ".. b.. " ")
		end
		f:write("\n")
	end
	f:close()
	print("Rendertime: ".. os.clock()-StartTime.. "s at resolution ".. Width .. " x ".. Height)
end

local function SaveImageClose(filename)
	StartTime = os.clock()
	CalculateDepth()
	local f = io.open(filename..".ppm","w")
	f:write("P3\n"..Width.. " ".. Height.. "\n255\n")
	for u = 1,Height do 
		for i = 1,Width do
			local Depth = map(DepthMap[u][i]*DistMult,MinDepth,300,0,255)
			if DepthMap[u][i] == 0 then
				--r,g,b = 0,191,255
				r,g,b = 0,0,0
				else
				r,g,b = HSV(Depth+11,200,200)
				--r,g,b = Depth,Depth,Depth
			end
			--local r,g,b = Depth,Depth,Depth
			r,g,b = math.floor(r), math.floor(g), math.floor(b)
			f:write(r.. " ".. g.. " ".. b.. " ")
		end
		f:write("\n")
	end
	f:close()
	print("Rendertime: ".. os.clock()-StartTime.. "s at resolution ".. Width .. " x ".. Height)
end

function main()
	if not isSampLoaded() or not isSampfuncsLoaded() then return end
	while not isSampAvailable() do
		wait(100)
	end
	sampRegisterChatCommand("savedepthmapold",SaveImage)
	sampRegisterChatCommand("savedepthmapcloseold",SaveImageClose)
	wait(-1)
end