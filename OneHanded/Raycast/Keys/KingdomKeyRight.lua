repeat wait() until script.Parent.Parent:findFirstChild("Humanoid") ~= nil
tool = script.Parent
c = tool.Parent
block = script.Main
block.Parent = script.Parent


if c:FindFirstChild("RKey") ~= nil then
	local W = Instance.new("Weld",c.RKey)
	block.Anchored = false
	W.Part0 = c.RKey
	W.Part1 = block
	W.C0 = CFrame.new(0,-0.25,-1.7) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(90))
else
	local W = Instance.new("Weld",c.RightHand)
	block.Anchored = false
	W.Part0 = c.RightHand
	W.Part1 = block
	W.C0 = CFrame.new(0,-0.25,-1.7) * CFrame.Angles(math.rad(90), math.rad(0), math.rad(90))
end
