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

local RS = game:GetService("ReplicatedStorage")
local RAYCAST_HITBOX = require(RS.RaycastHitboxV3)
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
