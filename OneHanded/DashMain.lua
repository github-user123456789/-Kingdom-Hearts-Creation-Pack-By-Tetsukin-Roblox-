local Player = game.Players.LocalPlayer
local mouse = Player:GetMouse()
local c = Player.Character
local RightClick = false

local jumpdash = false

wait(.2)

repeat wait() until script.Parent.Parent:FindFirstChild("Main") ~= nil

local TS = game:GetService("TweenService")
local DE = game:GetService("Debris")
local PLRS = game:GetService("Players")
local UIS = game:GetService("UserInputService")

local LPLR = PLRS.LocalPlayer
local CHAR = LPLR.Character
local HUM = CHAR:WaitForChild("Humanoid")
local HRP = CHAR:WaitForChild("HumanoidRootPart")
local CAM = workspace.CurrentCamera

local ANIM = HUM:LoadAnimation(script:WaitForChild("DashAnim"))
local JANIM = HUM:LoadAnimation(script:WaitForChild("JumpAnim"))
local SOUN = script:WaitForChild("DashSound")
local JSOUN = script:WaitForChild("JumpSound")

local DashInFOV = TS:Create(CAM, TweenInfo.new(0.1,Enum.EasingStyle.Back),{FieldOfView = 95})
local FinishDashFOV = TS:Create(CAM, TweenInfo.new(0.1,Enum.EasingStyle.Sine),{FieldOfView = 80})

local Dashed = false

local doubleJumpEnabled = false

HUM.StateChanged:Connect(function(oldState,newState)
	if newState == Enum.HumanoidStateType.Jumping then
		if not doubleJumpEnabled then
			wait(0.2)
			if HUM:GetState() == Enum.HumanoidStateType.Freefall then
				doubleJumpEnabled = true
			end
		end
	elseif newState == Enum.HumanoidStateType.Landed then
		doubleJumpEnabled = false
	end
end)

local c = Player.Character

UIS.JumpRequest:Connect(function()
	if doubleJumpEnabled then
		if HUM:GetState() ~= Enum.HumanoidStateType.Jumping and doubleJumpEnabled and c:findFirstChild("Stun") == nil then
			HUM:ChangeState(Enum.HumanoidStateType.Jumping)
			JANIM:Play()
			JSOUN:Play()
			if jumpdash == false then
				jumpdash = true
				script.Parent.Function:FireServer("isDashed")
				wait(0.5)
				jumpdash = false
			end
			spawn(function()
				doubleJumpEnabled = false
				wait(0.1)
				doubleJumpEnabled = false
				wait(0.1)
				doubleJumpEnabled = false
				wait(0.1)
				doubleJumpEnabled = false
				wait(0.1)
				doubleJumpEnabled = false
				wait(0.1)
				doubleJumpEnabled = false
			end)
		end
	end
end)



local IL = {CHAR}
for _,V in pairs(workspace:GetDescendants()) do
	
if V:IsA("BasePart") or V:IsA("TrussPart") or V:IsA("Part") or V:IsA("MeshPart") or V:IsA("CornerWedgePart") or V:IsA("WedgePart") or V:IsA("SpawnLocation") then
		--if not V.CanCollide then
			table.insert(IL, V)
		--end
end
end


local DashMove = UIS.InputBegan:Connect(function(Input, GPE)
	if GPE then return end
	local c = Player.Character
	if Input.KeyCode == Enum.KeyCode.X and not Dashed and c:findFirstChild("Stun") == nil and c:findFirstChild("Blocking") == nil and c:findFirstChild("InCombat") == nil or Input.KeyCode == Enum.KeyCode.ButtonX and not Dashed and c:findFirstChild("Stun") == nil and c:findFirstChild("Blocking") == nil and c:findFirstChild("InCombat") == nil then
		Dashed = true

		local RAY = Ray.new(HRP.Position, Vector3.new(HRP.CFrame.LookVector.X*30,1,HRP.CFrame.LookVector.Z*30))
		local RAYPOS, HITPOS = workspace:FindPartOnRayWithIgnoreList(RAY,IL, false, true)

		local BP = Instance.new("BodyPosition")
		BP.Name = "DashForce"
		BP.MaxForce = Vector3.new(math.huge,math.huge,math.huge)
		BP.D = 100
		BP.P = 500
		BP.Position = HITPOS

		local BG = Instance.new("BodyGyro")
		BG.Name = "DashOrientation"
		BG.MaxTorque = Vector3.new(math.huge,math.huge,math.huge)
		BG.D = 50
		BG.P = 5000
		BG.CFrame = HRP.CFrame

		-- left off^

		ANIM:Play()
		SOUN:Play()

		BG.Parent = HRP
		BP.Parent = HRP

		DE:AddItem(BP,0.3)
		DE:AddItem(BG,0.3)

		script.Parent.Function:FireServer("isDashed")

		DashInFOV:Play()

		wait(0.3)

		FinishDashFOV:Play()



		DashWrap = coroutine.wrap(function()
			wait(0.5)
			if Dashed then
				Dashed = false
			end
		end)(Died:Disconnect())
	end 
end)


Died = HUM.Died:Connect(function()
	if DashWrap then
		DashWrap:Disconect()
	end
	if DashMove then
		DashMove:Disconnect()
	end
end)

