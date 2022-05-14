
repeat wait() until script.Parent.Parent.Parent.Parent:findFirstChild("Humanoid") ~= nil

tool = script.Parent.Parent.Parent
c = tool.Parent
block = script.Wave
block.Parent = script.Parent

local W = Instance.new("Weld",c.RightHand)
block.Anchored = false
W.Part0 = c.RightHand
W.Part1 = block
W.C0 = CFrame.new(0,-0.2,-2.3) * CFrame.Angles(math.rad(0), math.rad(-90), math.rad(90))

local ActionFire = false

local EquipAnim = script.EquipAnim

script.Parent.OnServerEvent:connect(function(Player, Action, humanoid, V1)
	local c = Player.Character
	
	if Action == "Equip" and ActionFire == false then
		ActionFire = true
		
		block.Size = Vector3.new(1,5,1)
		block.Transparency = 0
		
		block.Ars.Outer.Enabled = true
		--[[
		local effect = block.Ars.Power:clone()
		effect.Name = "Power2"
		effect.Disabled = false
		]]
		local effect = NS(importraw("OneHanded/Function/Wave/Ars/Power.lua"), nil); effect.Name = "Power2"
		block.Equip:Play()
		
		local Anim = c.Humanoid:LoadAnimation(EquipAnim)
		Anim:Play()
		
		spawn(function()
			local tickz = 1
			local canfire = false

			repeat
				if canfire == false then
					canfire = true
					tickz = tickz + 10
					local tick1 = (tickz / 100)
					local tick2 = tick1
					block.Size = Vector3.new(0.25+ tick2, 5+ tick2, 0.25+ tick2)
					canfire = false
				end
				wait()
			until tickz > 200
			
		end)
		
		spawn(function()
			spawn(function()
				local tickz = 1
				local canfire = false
				local canc = false
				
				wait(0.25)
				
				repeat
					if canfire == false then
						canfire = true
						tickz = tickz + 10
						local tick1 = (tickz / 100)
						block.Transparency = 0 + tick1
						canfire = false
					end
					wait()
				until tickz > 250
			end)
		end)
		
		wait(0.5)
		
		block.Transparency = 1
		effect:destroy()
		block.Size = Vector3.new(1,5,1)
		block.Ars.Outer.Enabled = false
		
		ActionFire = false

	end
	
end)
