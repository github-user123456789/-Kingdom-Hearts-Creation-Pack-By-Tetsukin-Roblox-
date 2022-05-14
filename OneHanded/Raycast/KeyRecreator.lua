-- UTILS --
local Utils = {}
function Utils:Create(InstData, Props)
	local Obj = Instance.new(InstData[1], InstData[2])
	for k, v in pairs (Props) do
		Obj[k] = v
	end; return Obj
end
function Utils:CNR(cf) -- CFrameNoRotate
	return CFrame.new(cf.x,cf.y,cf.z)
end
-- LEGACY FUNCTIONS WITH ADDED FEATURES
function Utils:ezweld(p, a, b, cf, c1)
	local weld = Instance.new("Weld",p)
	weld.Part0 = a
	weld.Part1 = b
	weld.C0 = cf
	if c1 then weld.C1 = c1 end
    return weld
end
function Utils:NewSound(p, id, pit, vol, loop, autoplay)
	local Sound = Instance.new("Sound",p)
    Sound.Pitch = pit
    Sound.Volume = vol
    Sound.SoundId = "rbxassetid://" ..id
    Sound.Looped = loop
	if autoplay then
    	Sound:Play()
	end
    return Sound
end
-----------

local git = "https://raw.githubusercontent.com/github-user123456789/-Kingdom-Hearts-Creation-Pack-By-Tetsukin-Roblox-/main/"
local function importraw(a)
	return game:service("HttpService"):GetAsync(git ..a)
end

local function addattach(a, b)
	return Utils:Create({"Attachment"}, {Name = a, Position = b})
end

local a = function()
	local fold = Instance.new("Folder")
	local lh = Utils:Create({"Folder", fold}, {Name = "LeftHand"})
	local rh = Utils:Create({"Folder", fold}, {Name = "RightHand"})
	
	local function kingdomkeyinst(key)
		addattach("DmgPoint", Vector3.new(-2.25, 0, 0)).Parent = key
		addattach("DmgPoint", Vector3.new(-1.25, 0, 0)).Parent = key
		addattach("DmgPoint", Vector3.new(1.75, 0, 0)).Parent = key
		addattach("DmgPoint", Vector3.new(0.75, 0, 0)).Parent = key
		addattach("DmgPoint", Vector3.new(2.75, 0, 0)).Parent = key
		addattach("DmgPoint", Vector3.new(-0.25, 0, 0)).Parent = key
		local tr1 = addattach("TrailPoint", Vector3.new(0.7556982040405273, -0.036734312772750854, -0.0167388916015625)); tr1.Parent = key
		local tr2 = addattach("TrailPoint", Vector3.new(-2.381399154663086, 0.01102641224861145, -0.0077114105224609375)); tr2.Parent = key
		
		Utils:Create({"Trail", key}, {
			Color = Color3.fromRGB(159, 159, 159),
			LightEmission = .6,
			LightInfluence = 1,
			Texture = "rbxassetid://4480871448",
			TextureLength = 1,
			TextureMode = "Stretch",
			Transparency = NumberSequence.new(.5, 1),
			Attachment0 = tr1,
			Attachment1 = tr2,
			Lifetime = .1,
			MaxLength = 0,
			MinLength = .1,
		})
		Utils:Create({"ParticleEmitter", key}, {
			LightEmission = 1, LightInfluence = 1,
			Orientation = "FacingCamera",
			Size = NumberSequence.new(.05, 0),
			Texture = "rbxassetid://280989634",
			Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0, 0), NumberSequenceKeypoint.new(.9, 0),
			NumberSequenceKeypoint.new(.99, .998), NumberSequenceKeypoint.new(1, 0), NumberSequenceKeypoint.new(1, .981)}),
			EmissionDirection = "Front",
			Rate = 10,
			Speed = NumberRange.new(1),
		})
	end
	
	local kingdomkey = NS(importraw("OneHanded/Raycast/Keys/KingdomKeyLeft.lua"), lh); kingdomkey.Name = "KingdomKey"
	local key = Utils:Create({"Part", kingdomkey}, {
		Orientation = Vector3.new(0, 90, 180),
		Size = Vector3.new(4.951, 0.501, 1.651),
		Color = Color3.fromRGB(239, 184, 56),
		Name = "Main2",
	}); kingdomkeyinst(key)
	
	kingdomkey = NS(importraw("OneHanded/Raycast/Keys/KingdomKeyRight.lua"), rh); kingdomkey.Name = "KingdomKey"
	key = Utils:Create({"Part", kingdomkey}, {
		Orientation = Vector3.new(0, 90, 180),
		Size = Vector3.new(4.951, 0.501, 1.651),
		Color = Color3.fromRGB(239, 184, 56),
		Name = "Main",
	}); kingdomkeyinst(key)
	
	return fold
end
return a
