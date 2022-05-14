local Outer = script.Parent.Outer
local tickz = 1
local canfire = false

while tickz < 250000 do
	if canfire == false then
		canfire = true
		tickz = tickz + 1
		Outer:emit(2)
		canfire = false
	end
	wait(0.05)
end
