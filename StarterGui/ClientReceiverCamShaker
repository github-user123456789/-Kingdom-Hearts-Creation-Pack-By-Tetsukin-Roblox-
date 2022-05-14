local player = game.Players.LocalPlayer
local Camera = workspace.CurrentCamera
local TweenService = game:GetService("TweenService")
local Character = player.Character or player.CharacterAdded:Wait()
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage.CameraRemotes
local CameraFolder = game.ReplicatedStorage.CameraRemotes.Camera
local CameraShaker = require(game.ReplicatedStorage:WaitForChild("CameraShaker"))

local camShake = CameraShaker.new(Enum.RenderPriority.Camera.Value, function(shakeCf)
	Camera.CFrame = Camera.CFrame * shakeCf
end)

camShake:Start()

Character:WaitForChild("Humanoid").Died:Connect(function()
	Camera.CameraType = Enum.CameraType.Custom
end)

CameraFolder.ReallyBigExplosion.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.ReallyBigExplosion)
end)

CameraFolder.Bump.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.Bump)
end)

CameraFolder.BumpRemaked.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.BumpRemaked)
end)

CameraFolder.BigBump.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.BigBump)
end)

CameraFolder.Explosion.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.Explosion)
end)

CameraFolder.BigExplosion.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.BigExplosion)
end)

CameraFolder.RoughDriving.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.RoughDriving)
end)

CameraFolder.Vibration.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.Vibration)
end)

CameraFolder.HandheldCamera.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.HandheldCamera)
end)

CameraFolder.SmallExplosion.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.SmallExplosion)
end)

CameraFolder.SmallBump.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.SmallBump)
end)

CameraFolder.WeaponSwing.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.WeaponSwing)
end)

CameraFolder.ExplosionNormal.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.ExplosionNormal)
end)

CameraFolder.Earthquake.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.Earthquake)
end)

CameraFolder.BadTrip.OnClientEvent:Connect(function()
	camShake:Shake(CameraShaker.Presets.BadTrip)
end)

