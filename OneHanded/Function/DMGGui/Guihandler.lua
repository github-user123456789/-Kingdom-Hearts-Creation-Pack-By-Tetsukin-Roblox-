repeat wait() until script.Parent.Parent.Name == "Head"

local dmg = tonumber(script.Parent.Dmg.Text)
local gui = script.Parent

local mindmg = script.min.Value
local maxdmg = script.max.Value
local red = maxdmg / 1.25

if dmg >= red then
	gui.Dmg.TextColor3 = Color3.new(1, 0.25, 0.25)
	gui.Size = UDim2.new(4,0,2,0)
else
	gui.Dmg.TextColor3 = Color3.new(1, 1, 1)
	gui.Size = UDim2.new(3,0,1.5,0)
end
gui.StudsOffset = Vector3.new(math.random(-2,2),0,0)


local TweenService = game:GetService("TweenService")
local TweenNumber = script.TweenNumber
function AnimateNumber(n)
	TweenService:Create(TweenNumber, TweenInfo.new(.3), {Value = n}):Play()
end

script.TweenNumber:GetPropertyChangedSignal("Value"):Connect(function()
	script.Parent.Dmg.Text = TweenNumber.Value
end)

AnimateNumber(dmg)


wait(1)
script.Parent:destroy()
