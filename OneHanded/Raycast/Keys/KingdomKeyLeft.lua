repeat wait() until script.Parent.Parent:findFirstChild("Humanoid") ~= nil
tool = script.Parent
c = tool.Parent
block = script.Main2
block.Parent = script.Parent


if c:FindFirstChild("LKey") ~= nil then
	local W = Instance.new("Weld",c.LKey)
	block.Anchored = false
	W.Part0 = c.LKey
	W.Part1 = block
	W.C0 = CFrame.new(0,-0.25,-1.7) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(90))
else
	local W = Instance.new("Weld",c.LeftHand)
	block.Anchored = false
	W.Part0 = c.LeftHand
	W.Part1 = block
	W.C0 = CFrame.new(0,-0.25,-1.7) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(90))
end
