Player = game.Players.LocalPlayer
repeat wait() until Player.Character
c = Player.Character
local UIS = game:GetService("UserInputService")
local currenthp = c.Humanoid.Health
local fired = false

spawn(function()
	while true do
		wait(2)
		if currenthp ~= c.Humanoid.Health then
			currenthp = c.Humanoid.Health
		end
	end
end)

local BAnim = script.Block
local BSoun = script.Sound

game:GetService("RunService").RenderStepped:connect(function()
	local c = Player.Character

	if c.Humanoid.Health < currenthp and fired == false and c:FindFirstChild("Blocking") then
		fired = true
		currenthp = c.Humanoid.Health

		if c:FindFirstChild("InValor") == nil and c:FindFirstChild("InMaster") == nil and c:FindFirstChild("InFinal") == nil then
			local Anim = c.Humanoid:LoadAnimation(BAnim)
			Anim:Play()
		end
		
		BSoun.PlaybackSpeed = math.random(80,120)/100
		BSoun:Play()

		wait()
		fired = false
	end

end)
