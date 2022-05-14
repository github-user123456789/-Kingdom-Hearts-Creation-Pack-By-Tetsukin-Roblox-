wait(2)
Player = game.Players.LocalPlayer
repeat wait() until Player.Character
Character = Player.Character
mouse = Player:GetMouse()
Tool = script.Parent
local c = Player.Character or Player.CharacterAdded:Wait()
local Humanoid = c:WaitForChild("Humanoid") or c.Humanoid
local HumanoidRootPart = c:WaitForChild("HumanoidRootPart") or c.HumanoidRootPart


Player.CharacterAdded:Connect(function(Char)
	c = Char
	Humanoid = Char:WaitForChild("Humanoid")
	HumanoidRootPart = Char:WaitForChild("HumanoidRootPart")
end)

script.Function:FireServer("SetUp")

Key = ""
Key2 = ""
Key3 = ""
ButtonDown = false
Enabled = true
local EquipOn = false
local hasDied = false
local RunMain = Instance.new("StringValue", script)
RunMain.Value = "http://www.roblox.com/asset/?id=913376220"
local IdleMain = Instance.new("StringValue", script)
IdleMain.Value = "http://www.roblox.com/asset/?id=507766388"

if Character.Animate.run:findFirstChild("RunAnim") ~= nil then
	RunMain.Value = Character.Animate.run.RunAnim.AnimationId
	IdleMain.Value = Character.Animate.idle.Animation1.AnimationId
elseif Character.Animate.run:findFirstChild("run") ~= nil then
	RunMain.Value = Character.Animate.run.run.AnimationId
	IdleMain.Value = Character.Animate.idle.Animation1.AnimationId
end

local UserInputService = game:GetService("UserInputService")
local Tool = script.Parent

local isAiming = false
---Mobile Control---


c:WaitForChild("Humanoid").Died:connect(function()
	if c:WaitForChild("Humanoid").Health <= 0 then
		if hasDied == false then
			hasDied = true

			wait()
			script.Enabled = false

		end
	end
end)



repeat wait() until script.Parent:FindFirstChild("Main") ~= nil

-- MAKE RAYCAST HITBOX BECAUSE NO HTTP REQUESTS ON CLIENT --

local function mainhandlerlua()
	-- [[ Services ]]
	local RunService = game:GetService("RunService")
	local CollectionService = game:GetService("CollectionService")

	-- [[ Constants ]]
	local SYNC_RATE = RunService.Heartbeat
	local MAIN = script.Parent

	-- [[ Variables ]
	local ActiveHitboxes = {}
	local Handler = {}


	--------
	function Handler:add(hitboxObject)
		assert(typeof(hitboxObject) ~= "Instance", "Make sure you are initializing from the Raycast module, not from this handler.")
		table.insert(ActiveHitboxes, hitboxObject)
	end

	function Handler:remove(object)
		for i in ipairs(ActiveHitboxes) do
			if ActiveHitboxes[i].object == object then
				ActiveHitboxes[i]:Destroy()
				setmetatable(ActiveHitboxes[i], nil)
				table.remove(ActiveHitboxes, i)
			end
		end
	end

	function Handler:check(object)
		for _, hitbox in ipairs(ActiveHitboxes) do
			if hitbox.object == object then
				return hitbox
			end
		end
	end

	function OnTagRemoved(object)
		Handler:remove(object)
	end

	CollectionService:GetInstanceRemovedSignal("RaycastModuleManaged"):Connect(OnTagRemoved)


	--------
	SYNC_RATE:Connect(function()
		for Index, Object in ipairs(ActiveHitboxes) do
			if Object.deleted then
				Handler:remove(Object.object)
			else
				for _, Point in ipairs(Object.points) do
					if not Object.active then
						Point.LastPosition = nil
					else
						local rayStart, rayDir, RelativePointToWorld = Point.solver:solve(Point, Object.debugMode)
						local raycastResult = workspace:Raycast(rayStart, rayDir, Object.raycastParams)
						Point.solver:lastPosition(Point, RelativePointToWorld)

						if raycastResult then
							local hitPart = raycastResult.Instance
							local findModel = not Object.partMode and hitPart:FindFirstAncestorOfClass("Model")
							local humanoid = findModel and findModel:FindFirstChildOfClass("Humanoid")
							local target = humanoid or (Object.partMode and hitPart)

							if target and not Object.targetsHit[target] then
								Object.targetsHit[target] = true
								Object.OnHit:Fire(hitPart, humanoid, raycastResult, Point.group)
							end
						end
						
						Object.OnUpdate:Fire(Point.LastPosition)
					end
				end
			end
		end
	end)

	return Handler

end

local function dbdebugger()
	local Debris = game:GetService("Debris")

	return function(distance, newCFrame)
		local beam = Instance.new("Part")
		beam.BrickColor = BrickColor.new("Bright red")
		beam.Material = Enum.Material.Neon
		beam.Anchored = true
		beam.CanCollide = false
		beam.Name = "RaycastHitboxDebugPart"
		
		local Dist = (distance).Magnitude
		beam.Size = Vector3.new(0.1, 0.1, Dist)
		beam.CFrame = newCFrame * CFrame.new(0, 0, -Dist / 2)
		
		beam.Parent = workspace.Terrain
		Debris:AddItem(beam, 1)
	end

end
--
local function clcastattachlua()

	local Cast = {}
	local Debugger = dbdebugger()

	function Cast:solve(Point, bool)
		if not Point.LastPosition then
			Point.LastPosition = Point.Attachment.WorldPosition
		end
		
		if bool then
			Debugger(Point.Attachment.WorldPosition - Point.LastPosition, CFrame.new(Point.Attachment.WorldPosition, Point.LastPosition))
		end
		return Point.LastPosition, Point.Attachment.WorldPosition - Point.LastPosition
	end

	function Cast:lastPosition(Point)
		Point.LastPosition = Point.Attachment.WorldPosition	
	end

	return Cast
end
local function clcastvectorlua()

	local Cast = {}
	local Debugger = dbdebugger()

	function Cast:solve(Point, bool)	
		local RelativePartToWorldSpace = Point.RelativePart.Position + Point.RelativePart.CFrame:VectorToWorldSpace(Point.Attachment)
		if not Point.LastPosition then
			Point.LastPosition = RelativePartToWorldSpace
		end
		
		if bool then
			Debugger(RelativePartToWorldSpace - Point.LastPosition, CFrame.new(RelativePartToWorldSpace, Point.LastPosition))
		end

		return Point.LastPosition, RelativePartToWorldSpace - (Point.LastPosition and Point.LastPosition or Vector3.new()), RelativePartToWorldSpace
	end

	function Cast:lastPosition(Point, RelativePartToWorldSpace)
		Point.LastPosition = RelativePartToWorldSpace
	end

	return Cast

end
local function clcastlinklua()

	local Cast = {}
	local Debugger = dbdebugger()

	function Cast:solve(Point, bool)
		if bool then
			Debugger(Point.Attachment.WorldPosition - Point.Attachment0.WorldPosition, CFrame.new(Point.Attachment.WorldPosition, Point.Attachment0.WorldPosition))
		end

		return Point.Attachment.WorldPosition, Point.Attachment0.WorldPosition - Point.Attachment.WorldPosition
	end

	function Cast:lastPosition(Point)
		Point.LastPosition = Point.Attachment.WorldPosition
	end

	return Cast

end
--
--
local function toolssignallua()
--- @Swordphin123, wao such minimalism

local connection = {}
connection.__index = connection

function connection:Create()
	return setmetatable({}, connection)
end

function connection:Connect(Listener)
	self[1] = Listener
end

function connection:Fire(...)
	if not self[1] then return end 
	
	local newThread = coroutine.create(self[1])
	coroutine.resume(newThread, ...)
end

function connection:Delete()
	self[1] = nil
end

return connection
end
--

local function hitboxlua()
	
	local MAIN
	local function require(a)
	  return MAIN[a]()
	end

	-- [[ Services ]]
	local Players = game:GetService("Players")
	local CollectionService = game:GetService("CollectionService")

	-- [[ Variables ]]
	--local MAIN = script.Parent
	MAIN = {CastLogics = {CastAttachment = clcastattachlua, CastVectorPoint = clcastvectorlua,
	CastLinkAttachment = clcastlinklua}, Tools = {Signal = toolssignallua}}

	local CastAttachment  = require(MAIN.CastLogics.CastAttachment)
	local CastVectorPoint = require(MAIN.CastLogics.CastVectorPoint)
	local CastLinkAttach  = require(MAIN.CastLogics.CastLinkAttachment)
	
	local Signal = require(MAIN.Tools.Signal)

	--------
	local HitboxObject = {}
	local Hitbox = {}
	Hitbox.__index = Hitbox

	function Hitbox:__tostring() 
		return string.format("Hitbox for instance %s [%s]", self.object.Name, self.object.ClassName)
	end

	function HitboxObject:new()
	    return setmetatable({}, Hitbox)
	end

	function Hitbox:config(object, ignoreList)
		self.active = false
		self.deleted = false
		self.partMode = false
		self.debugMode = false
		self.points = {}
		self.targetsHit = {}
		self.OnHit = Signal:Create()
		self.OnUpdate = Signal:Create()
		self.raycastParams = RaycastParams.new()
		self.raycastParams.FilterType = Enum.RaycastFilterType.Blacklist
		self.raycastParams.FilterDescendantsInstances = ignoreList or {}
		
		self.object = object
		CollectionService:AddTag(self.object, "RaycastModuleManaged")
	end

	function Hitbox:SetPoints(object, vectorPoints, groupName)
		if object and (object:IsA("BasePart") or object:IsA("MeshPart")) then
			for _, vectors in ipairs(vectorPoints) do
				if typeof(vectors) == "Vector3" then
					local Point = {
						RelativePart = object, 
						Attachment = vectors, 
						LastPosition = nil,
						group = groupName,
						solver = CastVectorPoint
					}
					table.insert(self.points, Point)
				end
			end
		end
	end

	function Hitbox:RemovePoints(object, vectorPoints)
		if object then
			if object:IsA("BasePart") or object:IsA("MeshPart") then --- for some reason it doesn't recognize meshparts unless I add it in
				for i = 1, #self.points do
					local Point = self.points[i]
					for _, vectors in ipairs(vectorPoints) do
						if typeof(Point.Attachment) == "Vector3" and Point.Attachment == vectors and Point.RelativePart == object then
							self.points[i] = nil
						end
					end
				end
			end
		end
	end

	function Hitbox:LinkAttachments(primaryAttachment, secondaryAttachment)
		if primaryAttachment:IsA("Attachment") and secondaryAttachment:IsA("Attachment") then
			local group = primaryAttachment:FindFirstChild("Group")
			local Point = {
				RelativePart = nil,
				Attachment = primaryAttachment,
				Attachment0 = secondaryAttachment,
				LastPosition = nil,
				group = group and group.Value,
				solver = CastLinkAttach
			}
			table.insert(self.points, Point)
		end
	end

	function Hitbox:UnlinkAttachments(primaryAttachment)
		for i, Point in ipairs(self.points) do
			if Point.Attachment and Point.Attachment == primaryAttachment then
				table.remove(self.points, i)
				break
			end
		end
	end

	function Hitbox:seekAttachments(attachmentName, canWarn)
		if #self.points <= 0 then
			table.insert(self.raycastParams.FilterDescendantsInstances, workspace.Terrain)
		end
		for _, attachment in ipairs(self.object:GetDescendants()) do
			if attachment:IsA("Attachment") and attachment.Name == attachmentName then
				local group = attachment:FindFirstChild("Group")
				local Point = {
					Attachment = attachment, 
					RelativePart = nil, 
					LastPosition = nil, 
					group = group and group.Value,
					solver = CastAttachment
				}
				table.insert(self.points, Point)
			end
		end
		
		if canWarn then
			if #self.points <= 0 then
				warn(string.format("\n[[RAYCAST WARNING]]\nNo attachments with the name '%s' were found in %s. No raycasts will be drawn. Can be ignored if you are using SetPoints.",
					attachmentName, self.object.Name)
				)
			else
				print(string.format("\n[[RAYCAST MESSAGE]]\n\nCreated Hitbox for %s - Attachments found: %s", 
					self.object.Name, #self.points)
				)
			end
		end
	end

	function Hitbox:Destroy()
		if self.deleted then return end
		if self.OnHit then self.OnHit:Delete() end
		if self.OnUpdate then self.OnUpdate:Delete() end
		
		self.points = nil
		self.active = false
		self.deleted = true
	end

	function Hitbox:HitStart()
		self.active = true
	end

	function Hitbox:HitStop()
		if self.deleted then return end
		
		self.active = false
		table.clear(self.targetsHit)
	end

	function Hitbox:PartMode(bool)
		self.partMode = bool
	end

	function Hitbox:DebugMode(bool)
		self.debugMode = bool
	end

	return HitboxObject
end

local function RHMain()
	local RaycastHitbox = { 
		Version = "3.2",
		AttachmentName = "DmgPoint",
		DebugMode = false,
		WarningMessage = false
	}

	--------

	local git = "https://raw.githubusercontent.com/github-user123456789/-Kingdom-Hearts-Creation-Pack-By-Tetsukin-Roblox-/main/RaycastHitboxV3/"
	local fakescript = {MainHandler = mainhandlerlua, HitboxObject = hitboxlua}
	local function require(a)
	  return a()
	end

	local Handler = require(fakescript.MainHandler)
	local HitboxClass = require(fakescript.HitboxObject)

	function RaycastHitbox:Initialize(object, ignoreList)
		assert(object, "You must provide an object instance.")
		
		local newHitbox = Handler:check(object)
		if not newHitbox then
			newHitbox = HitboxClass:new()
			newHitbox:config(object, ignoreList)
			newHitbox:seekAttachments(RaycastHitbox.AttachmentName, RaycastHitbox.WarningMessage)
			newHitbox.debugMode = RaycastHitbox.DebugMode
			Handler:add(newHitbox)
		end
		return newHitbox
	end

	function RaycastHitbox:Deinitialize(object) --- Deprecated
		Handler:remove(object)
	end

	function RaycastHitbox:GetHitbox(object)
	   return Handler:check(object)
	end

	return RaycastHitbox
end
------------------------------------------------------------

local RS = game:GetService("ReplicatedStorage")
--local RAYCAST_HITBOX = loadstring(game:service("HttpService"):GetAsync("https://raw.githubusercontent.com/github-user123456789/-Kingdom-Hearts-Creation-Pack-By-Tetsukin-Roblox-/main/RaycastHitboxV3/Main.lua"))()
local RAYCAST_HITBOX = RHMain()
local Sword = script.Parent.Main
local ignoreList = {c}
local newHitbox = RAYCAST_HITBOX:Initialize(Sword, ignoreList)
newHitbox:SetPoints(Sword, {Vector3.new(0, -2, 0), Vector3.new(-1, -2, 0), Vector3.new(3, -2, 0), Vector3.new(5, -2, 0)})
newHitbox:SetPoints(Sword, {Vector3.new(0, 3, 0), Vector3.new(-1, 3, 0), Vector3.new(3, 3, 0), Vector3.new(5, 3, 0)})
local canattack = true
local castoff = true
local clash = false
repeat wait() until script.Parent.RayCast:FindFirstChild("Combo")
local Combo = script.Parent.RayCast.Combo
local Combo1 = script.Combo1
local Combo2 = script.Combo2
local Combo3 = script.Combo3
local Combo4 = script.Combo4
local Combo5 = script.Combo5

Tool.Activated:connect(function()
	if Enabled == true and canattack == true and clash == false and c:FindFirstChild("Stun") == nil and c:FindFirstChild("InAbility") == nil then
		canattack = false
		castoff = false
		script.Function:FireServer("Combat")
		if Combo.Value == 1 then
			local Anim = c.Humanoid:LoadAnimation(Combo2)
			Anim:Play()
			wait(0.1)
			newHitbox:HitStart()
			repeat wait() until castoff == true
			newHitbox:HitStop()
			
			newHitbox.OnHit:Connect(function(hit, humanoid)
				if humanoid.Parent:FindFirstChild("isPlayer") == nil then
					script.Function:FireServer("hit",humanoid)
				end
			end)

		elseif Combo.Value == 2 then
			local Anim = c.Humanoid:LoadAnimation(Combo3)
			Anim:Play()
			wait(0.1)
			newHitbox:HitStart()
			repeat wait() until castoff == true
			newHitbox:HitStop()
			
			newHitbox.OnHit:Connect(function(hit, humanoid)
				if humanoid.Parent:FindFirstChild("isPlayer") == nil then
					script.Function:FireServer("hit",humanoid)
				end
			end)

		elseif Combo.Value == 3 then
			local Anim = c.Humanoid:LoadAnimation(Combo4)
			Anim:Play()
			wait(0.1)
			newHitbox:HitStart()
			repeat wait() until castoff == true
			newHitbox:HitStop()
			
			newHitbox.OnHit:Connect(function(hit, humanoid)
				if humanoid.Parent:FindFirstChild("isPlayer") == nil then
					script.Function:FireServer("hit",humanoid)
				end
			end)
			
		elseif Combo.Value == 4 then
			local Anim = c.Humanoid:LoadAnimation(Combo5)
			Anim:Play()
			wait(0.1)
			newHitbox:HitStart()
			repeat wait() until castoff == true
			newHitbox:HitStop()

			newHitbox.OnHit:Connect(function(hit, humanoid)
				if humanoid.Parent:FindFirstChild("isPlayer") == nil then
					script.Function:FireServer("hit",humanoid)
				end
			end)

		elseif Combo.Value == 5 then
			local Anim = c.Humanoid:LoadAnimation(Combo1)
			Anim:Play()
			wait(0.1)
			newHitbox:HitStart()
			repeat wait() until castoff == true
			newHitbox:HitStop()
			
			newHitbox.OnHit:Connect(function(hit, humanoid)
				if humanoid.Parent:FindFirstChild("isPlayer") == nil then
					script.Function:FireServer("hit",humanoid)
				end
			end)

		end
	end
end)

game:GetService("RunService").RenderStepped:connect(function()
	if c:FindFirstChild("Stun") ~= nil then
		newHitbox:HitStop()
		repeat wait() until c:FindFirstChild("Stun") == nil
		canattack = true	
		Enabled = true
	end
end)

function CAttack()
	canattack = true
end
function COff()
	castoff = true
end
script.Parent.RayCast.CanAttack.OnClientEvent:Connect(CAttack)
script.Parent.RayCast.CastOff.OnClientEvent:Connect(COff)
function ClashOn()
	clash = true
end
function ClashOff()
	clash = false
end
script.Parent.RayCast.Clash.OnClientEvent:Connect(ClashOn)
script.Parent.RayCast.ClashOff.OnClientEvent:Connect(ClashOff)


Tool.Equipped:connect(function()
	EquipOn = true
	script.DashMain.Disabled = false
	script.Function:FireServer("Equip")
	wait(0.1)
	
	if EquipOn == true and c:findFirstChild("Stun") == nil and Character.Animate.run:findFirstChild("RunAnim") ~= nil then
		wait(0.1)
		Character.Animate.run.RunAnim.AnimationId = "rbxassetid://6986688297"
		Character.Animate.idle.Animation1.AnimationId = "rbxassetid://6987491425"
		c.Humanoid.WalkSpeed = 20
	elseif EquipOn == true and c:findFirstChild("Stun") == nil and Character.Animate.run:findFirstChild("run") ~= nil then
		wait(0.1)
		Character.Animate.run.run.AnimationId = "rbxassetid://6986688297"
		Character.Animate.idle.Animation1.AnimationId = "rbxassetid://6987491425"
		c.Humanoid.WalkSpeed = 20
	end
end)

Tool.Unequipped:connect(function()
	EquipOn = false
	script.DashMain.Disabled = true
	script.Function:FireServer("UnEquip")
	wait(0.1)
	
	if EquipOn == false and c:findFirstChild("Stun") == nil and Character.Animate.run:findFirstChild("RunAnim") ~= nil then
		Character.Animate.run.RunAnim.AnimationId = RunMain.Value
		Character.Animate.idle.Animation1.AnimationId = IdleMain.Value
		c.Humanoid.WalkSpeed = 16
	elseif EquipOn == false and c:findFirstChild("Stun") == nil and Character.Animate.run:findFirstChild("run") ~= nil then
		Character.Animate.run.run.AnimationId = RunMain.Value
		Character.Animate.idle.Animation1.AnimationId = IdleMain.Value
		c.Humanoid.WalkSpeed = 16
	end
end)


local canblock = true

game:GetService("UserInputService").InputEnded:connect(function(Input, Game)
	if Game == true then return end
	repeat wait(0.5) until Key == "F" or Key3 == "ButtonL1"
	if Input.KeyCode == Enum.KeyCode.F and Key == "F" and ButtonDown == true or ButtonDown == true and Input.KeyCode == Enum.KeyCode.ButtonL1 and Key3 == "ButtonL1" then
		Key = ""
		ButtonDown = false	
		wait(1)
		Enabled = true
		canattack = true
		newHitbox:HitStop()
		canblock = true
	end
end)

game:GetService("UserInputService").InputBegan:connect(function(Input, Game)
	if Game == true then return end
	if Input.KeyCode == Enum.KeyCode.F and EquipOn == true and canblock == true and c:FindFirstChild("InAbility") == nil or canblock == true and Input.KeyCode == Enum.KeyCode.ButtonL1 and EquipOn == true and c:FindFirstChild("InAbility") == nil then
		canblock = false
		ButtonDown = true
		Enabled = false
		script.Function:FireServer("Block")
		wait(1)
		Key = "F"
		Key2 = "LeftShift"
		Key3 = "ButtonL1"
		while ButtonDown == true do
			wait()
		end
		script.Function:FireServer("Release")
	end
end)


script.Parent.CameraOff.OnClientEvent:Connect(function()

	Character.Animate.run.RunAnim.AnimationId = "http://www.roblox.com/asset/?id=913376220"
	Character.Animate.idle.Animation1.AnimationId = "http://www.roblox.com/asset/?id=507766388"

	Character.Humanoid.WalkSpeed = 16

end)

game:GetService("RunService").RenderStepped:connect(function()
	if c:FindFirstChild("PerfectBlocking") ~= nil then
		wait(4)
		if c:FindFirstChild("PerfectBlocking") ~= nil then
			script.Function:FireServer("RemovePerfect")
		end
	end
end)
