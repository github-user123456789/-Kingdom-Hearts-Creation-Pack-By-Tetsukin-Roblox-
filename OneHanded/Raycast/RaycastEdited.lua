Enabled = true
ButtonDown = false
local MoveGlobe = false
local BlockGlobe = false
local hasDied = false
local slash = 0
local slashtick = math.random(1,3)
local clash = false

local BlockAnim = script.Parent.MainScript.Block
local Parry1 = script.Parent.MainScript.Parry1
local Parry2 = script.Parent.MainScript.Parry2
local Parry3 = script.Parent.MainScript.Parry3
local BackFlipAnim = script.Parent.MainScript.BackFlip

local ClashAnim = script.ClashAnim
local PushAnim = script.PushAnim
local FinishAnim = script.FinishAnim
local clasher = {}

function checkDist(part1,part2)
	if typeof(part1) ~= Vector3 then part1 = part1.Position end
	if typeof(part2) ~= Vector3 then part2 = part2.Position end
	return (part1 - part2).Magnitude 
end


local Combo1 = Instance.new("NumberValue",script)
script:FindFirstChildWhichIsA("NumberValue").Name = "Combo"
local Combo = script.Combo
Combo.Value = 6

local getkey = false

--local DataStore2 = require(game.ServerScriptService.DataModule)
local DataDefault = {Stats = {Coins = 0}, Customizations = {RKey = "KingdomKey", LKey = "KingdomKey"}}
local DataStore2 = function(a, plr)
	return DataDefault[a]
end
local MainKey = "PData"
local MKey = "KeyData"

script.Parent.MainScript.Function.OnServerEvent:connect(function(Player, Action, humanoid, V1)
	local c = Player.Character

	local Stats = DataStore2("Stats", Player):Get()
	local Customizations = DataStore2("Customizations", Player):Get()

	local Strengthz = Stats.Coins

	if Strengthz > 100 then
		Strengthz = 100
	end

	local Strength = 10

	if Strengthz ~= nil then
		Strength = 10 + (Strengthz / 10)
	end

	local mindmg = Strength * 0.5
	local maxdmg = Strength * 1.5

	local MaxStam = 100 + Strengthz
	local MaxBStam = 200 + Strengthz

	local keys = game.ServerStorage.KeyBlades
	
	if script.Parent:FindFirstChild("Main") == nil and getkey == false then
		getkey = true
		keys.RightHand:WaitForChild(Customizations.RKey):Clone().Parent = script.Parent
		keys.LeftHand:WaitForChild(Customizations.LKey):Clone().Parent = script.Parent
	end
	
	local MyName = c.Name
	
	if Action == "RemovePerfect" then
		if c:FindFirstChild("PerfectBlocking") ~= nil then
			c.PerfectBlocking:Destroy()
		end
	end
	
	if Action == "hit" and c:FindFirstChild("InCombat") and c:FindFirstChild("Stun") == nil and clash == false and humanoid.Parent:findFirstChild("isPlayer") == nil then
		if humanoid and checkDist(humanoid.Parent.HumanoidRootPart,c.HumanoidRootPart) < 10 and humanoid.Parent:FindFirstChild(MyName) == nil then
			
			spawn(function()
				local MN = Instance.new("BoolValue", humanoid.Parent)
				MN.Name = MyName
				game.Debris:AddItem(MN,0.3)	
			end)
			
			local SL = Instance.new("BoolValue", humanoid.Parent)
			SL.Name = "Stun"
			game.Debris:AddItem(SL,0)

			local dmg = math.random(mindmg,maxdmg)
			local gui = script.DMGGui:clone()


			if humanoid.Parent:findFirstChild("isPlayer") == nil and humanoid.Parent:findFirstChild("BlockStam") ~= nil then
				local VStam = humanoid.Parent:WaitForChild("BlockStam")

				if c:findFirstChild("BehindBlock") and Combo.Value == 6 then
					humanoid:TakeDamage(dmg * 1.1)
					gui.Parent = humanoid.Parent.Head
					gui.Dmg.Text = dmg * 1.1
					gui["Gui handler"].max.Value = maxdmg
					gui["Gui handler"].min.Value = mindmg

					local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*50
					game.Debris:AddItem(BV,0.3)	
					BV.Velocity = BV.Velocity + Vector3.new(0,15,0)

					spawn(function()
						local SL = Instance.new("BoolValue", humanoid.Parent)
						SL.Name = "Stun"
						wait(.4)
						SL:Destroy()
					end)

					local S = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
					S.SoundId = "rbxassetid://935843979"
					S.PlaybackSpeed = math.random(80,120)/100
					S:Play()

					spawn(function()
						local HitPar = workspace.CombatEffects.HitParticle:clone()
						HitPar.Parent = workspace.FX
						HitPar.CFrame = humanoid.Parent.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
						HitPar.HitParticle.Enabled = true
						HitPar.CombatSpark.Enabled = true
						wait()
						HitPar.HitParticle:Emit(1)
						HitPar.CombatSpark:Emit(1)
						wait(0.25)
						HitPar:destroy()
					end)


				elseif c:findFirstChild("BehindBlock") then
					humanoid:TakeDamage(dmg * 1.1)
					gui.Parent = humanoid.Parent.Head
					gui.Dmg.Text = dmg * 1.1
					gui["Gui handler"].max.Value = maxdmg
					gui["Gui handler"].min.Value = mindmg

					local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*2
					game.Debris:AddItem(BV,0.3)	

					spawn(function()
						local SL = Instance.new("BoolValue", humanoid.Parent)
						SL.Name = "Stun"
						wait(.4)
						SL:Destroy()
					end)

					local S = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
					S.SoundId = "rbxassetid://935843979"
					S.PlaybackSpeed = math.random(80,120)/100
					S:Play()

					spawn(function()
						local HitPar = workspace.CombatEffects.HitParticle:clone()
						HitPar.Parent = workspace.FX
						HitPar.CFrame = humanoid.Parent.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
						HitPar.HitParticle.Enabled = true
						HitPar.CombatSpark.Enabled = true
						wait()
						HitPar.HitParticle:Emit(1)
						HitPar.CombatSpark:Emit(1)
						wait(0.25)
						HitPar:destroy()
					end)



				elseif humanoid.Parent:findFirstChild("InCombat") and slash < 6 then

					if slash < 6 then
						slash = slash + 1

						if slashtick == 1 then
							slashtick = slashtick + 1

							local Anim = c.Humanoid:LoadAnimation(Parry1)
							Anim:Play()
						elseif slashtick == 2 then
							slashtick = slashtick + 1

							local Anim = c.Humanoid:LoadAnimation(Parry2)
							Anim:Play()
						elseif slashtick == 3 then
							slashtick = 1

							local Anim = c.Humanoid:LoadAnimation(Parry3)
							Anim:Play()
						end

						if slash < 6 then
							humanoid:TakeDamage(dmg / 10)
							gui.Parent = humanoid.Parent.Head
							gui.Dmg.Text = dmg / 10
							gui["Gui handler"].max.Value = maxdmg
							gui["Gui handler"].min.Value = mindmg
						end

						if slash >= 6 then
							if humanoid.Parent:FindFirstChild("UseAbility") ~= nil then
								clasher = humanoid.Parent
								spawn(function()

									c.Clashing.Value = true
									humanoid.Parent.Clashing.Value = true

									spawn(function()
										local SL = Instance.new("BoolValue", c)
										SL.Name = "InAbility"
									end)

									spawn(function()
										local SL = Instance.new("BoolValue", humanoid.Parent)
										SL.Name = "InAbility"
									end)

									local SC = Instance.new("Sound", c.HumanoidRootPart)
									SC.SoundId = "rbxassetid://7034811229"
									SC.PlaybackSpeed = 1.25
									SC.Looped = true
									SC:Play()

									local SC2 = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
									SC2.SoundId = "rbxassetid://7034811229"
									SC2.PlaybackSpeed = 1.25
									SC2.Looped = true
									SC2:Play()

									c.HumanoidRootPart.Anchored = true
									humanoid.Parent.HumanoidRootPart.Anchored = true
									humanoid.Parent.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,0,-5) * CFrame.Angles(math.rad(0), math.rad(180), math.rad(0))

									c.Humanoid.AutoRotate = false
									humanoid.AutoRotate = false

									local Anim = c.Humanoid:LoadAnimation(ClashAnim)
									Anim:Play()
									local Anim2 = humanoid:LoadAnimation(ClashAnim)
									Anim2:Play()

									local anchor1 = game.ReplicatedStorage.Clash.Anchor:Clone()
									anchor1.Parent = c.HumanoidRootPart
									anchor1.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,0,10)

									local anchor2 = game.ReplicatedStorage.Clash.Anchor:Clone()
									anchor2.Parent = humanoid.Parent.HumanoidRootPart
									anchor2.CFrame = humanoid.Parent.HumanoidRootPart.CFrame * CFrame.new(0,0,10)

									humanoid.Parent.HumanoidRootPart.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,0,-5) * CFrame.Angles(math.rad(0), math.rad(180), math.rad(0))

									local clasheffect1 = game.ReplicatedStorage.Clash.ClashEffect:clone()
									clasheffect1.Parent = c.HumanoidRootPart
									clasheffect1.CFrame = c.HumanoidRootPart.CFrame * CFrame.new(0,0,-2.5) * CFrame.Angles(math.rad(0), math.rad(-90), math.rad(0))
									clasheffect1.WeldConstraint.Part1 = c.HumanoidRootPart

									local clasheffect2 = game.ReplicatedStorage.Clash.ClashEffect:clone()
									clasheffect2.Parent = humanoid.Parent.HumanoidRootPart
									clasheffect2.CFrame = humanoid.Parent.HumanoidRootPart.CFrame * CFrame.new(0,0,-2.5) * CFrame.Angles(math.rad(0), math.rad(-90), math.rad(0))
									clasheffect2.WeldConstraint.Part1 = humanoid.Parent.HumanoidRootPart

									local Players = game:GetService("Players")
									local player = Players:GetPlayerFromCharacter(c)
									local player2 = Players:GetPlayerFromCharacter(humanoid.Parent)

									local guiclash1 = game.ReplicatedStorage.Clash.Vignette:Clone()
									local guiclash2 = game.ReplicatedStorage.Clash.Vignette:Clone()

									if player ~= nil then
										guiclash1.Parent = player.PlayerGui
										guiclash1.P1Name.Text = c.Name
										guiclash1.P2Name.Text = humanoid.Parent.Name
										guiclash1.Player1.Value = c
										guiclash1.Player2.Value = humanoid.Parent
									end
									if player2 ~= nil then
										guiclash2.Parent = player2.PlayerGui
										guiclash2.P1Name.Text = humanoid.Parent.Name
										guiclash2.P2Name.Text = c.Name
										guiclash2.Player1.Value = humanoid.Parent
										guiclash2.Player2.Value = c
									end



									spawn(function()
										repeat
											local mag1 = (c.HumanoidRootPart.Position - c.HumanoidRootPart.Anchor.Position).Magnitude
											local mag2 = (humanoid.Parent.HumanoidRootPart.Position - humanoid.Parent.HumanoidRootPart.Anchor.Position).Magnitude
											if mag1 <= 1 then

												local AnimationTracks = c.Humanoid:GetPlayingAnimationTracks()
												for i, v in pairs(AnimationTracks) do
													if v.Name == "ClashAnim" then
														v:Stop()
													end
												end

												local AnimationTracks = humanoid:GetPlayingAnimationTracks()
												for i, v in pairs(AnimationTracks) do
													if v.Name == "ClashAnim" then
														v:Stop()
													end
												end

												c.Humanoid.Health = c.Humanoid.Health - (c.Humanoid.MaxHealth * 0.35)

												local Anim = c.Humanoid:LoadAnimation(BackFlipAnim)
												Anim:Play()
												local Anim2 = humanoid:LoadAnimation(FinishAnim)
												Anim2:Play()

												local S = Instance.new("Sound", c.HumanoidRootPart)
												S.SoundId = "rbxassetid://5428215224"
												S.PlaybackSpeed = math.random(120,150)/100
												S:Play()

												game.Debris:AddItem(anchor1, 0)
												game.Debris:AddItem(anchor2, 0)
												game.Debris:AddItem(clasheffect1, 0)
												game.Debris:AddItem(clasheffect2, 0)
												c.Clashing.Value = false
												humanoid.Parent.Clashing.Value = false
												c.HumanoidRootPart.Anchored = false
												humanoid.Parent.HumanoidRootPart.Anchored = false
												c.Humanoid.AutoRotate = true
												humanoid.AutoRotate = true

												if c.HumanoidRootPart:findFirstChild("BodyVelocity") ~= nil then
													c.HumanoidRootPart:findFirstChild("BodyVelocity"):destroy()
													wait()
													local c = Player.Character
													local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
													BV.maxForce = Vector3.new(25000,25000,25000)
													BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*-50
													game.Debris:AddItem(BV,0.3)
													BV.Velocity = BV.Velocity + Vector3.new(0,15,0)
												else
													local c = Player.Character
													local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
													BV.maxForce = Vector3.new(25000,25000,25000)
													BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*-50
													game.Debris:AddItem(BV,0.3)
													BV.Velocity = BV.Velocity + Vector3.new(0,15,0)
												end

											elseif mag2 <= 1 then

												local AnimationTracks = c.Humanoid:GetPlayingAnimationTracks()
												for i, v in pairs(AnimationTracks) do
													if v.Name == "ClashAnim" then
														v:Stop()
													end
												end

												local AnimationTracks = humanoid:GetPlayingAnimationTracks()
												for i, v in pairs(AnimationTracks) do
													if v.Name == "ClashAnim" then
														v:Stop()
													end
												end

												humanoid.Health = humanoid.Health - (humanoid.MaxHealth * 0.35)

												local Anim = c.Humanoid:LoadAnimation(FinishAnim)
												Anim:Play()
												local Anim2 = humanoid:LoadAnimation(BackFlipAnim)
												Anim2:Play()

												local S = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
												S.SoundId = "rbxassetid://5428215224"
												S.PlaybackSpeed = math.random(120,150)/100
												S:Play()

												game.Debris:AddItem(anchor1, 0)
												game.Debris:AddItem(anchor2, 0)
												game.Debris:AddItem(clasheffect1, 0)
												game.Debris:AddItem(clasheffect2, 0)
												c.Clashing.Value = false
												humanoid.Parent.Clashing.Value = false
												c.HumanoidRootPart.Anchored = false
												humanoid.Parent.HumanoidRootPart.Anchored = false
												c.Humanoid.AutoRotate = true
												humanoid.AutoRotate = true

												if humanoid:findFirstChild("BodyVelocity") ~= nil then
													humanoid:findFirstChild("BodyVelocity"):destroy()
													wait()
													local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
													BV.maxForce = Vector3.new(25000,25000,25000)
													BV.Velocity = humanoid.Parent.HumanoidRootPart.CFrame.lookVector*-50
													game.Debris:AddItem(BV,0.3)
													BV.Velocity = BV.Velocity + Vector3.new(0,15,0)
												else
													local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
													BV.maxForce = Vector3.new(25000,25000,25000)
													BV.Velocity = humanoid.Parent.HumanoidRootPart.CFrame.lookVector*-50
													game.Debris:AddItem(BV,0.3)
													BV.Velocity = BV.Velocity + Vector3.new(0,15,0)
												end

											end
											wait()
										until c.Clashing.Value == false

										slash = 0

										wait(0.5)

										if c:FindFirstChild("InAbility") then
											c.InAbility:Destroy()
										end

										if humanoid.Parent:FindFirstChild("InAbility") then
											humanoid.Parent.InAbility:Destroy()
										end

										SC2:Destroy()
										SC:Destroy()

										if guiclash1 ~= nil then
											guiclash1:destroy()
										end
										if guiclash2 ~= nil then
											guiclash2:destroy()
										end

									end)
								end)	
							else
								spawn(function()

									local S = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
									S.SoundId = "rbxassetid://5428215224"
									S.PlaybackSpeed = math.random(120,150)/100
									S:Play()

									if c.HumanoidRootPart:findFirstChild("BodyVelocity") ~= nil then
										c.HumanoidRootPart:findFirstChild("BodyVelocity"):destroy()
										wait()
										local c = Player.Character
										local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
										BV.maxForce = Vector3.new(25000,25000,25000)
										BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*-50
										game.Debris:AddItem(BV,0.3)
										BV.Velocity = BV.Velocity + Vector3.new(0,15,0)
									else
										local c = Player.Character
										local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
										BV.maxForce = Vector3.new(25000,25000,25000)
										BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*-50
										game.Debris:AddItem(BV,0.3)
										BV.Velocity = BV.Velocity + Vector3.new(0,15,0)
									end

									local Anim = c.Humanoid:LoadAnimation(BackFlipAnim)
									Anim:Play()

									clash = true
									script.Clash:FireClient(Player)
									wait(0.5)
									clash = false
									script.ClashOff:FireClient(Player)
									wait(4.5)
									slash = 0
								end)	
							end
						end
					end

					local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
					game.Debris:AddItem(BV,0.3)
					BV.Velocity = BV.Velocity + Vector3.new(0,0,0)

					local c = Player.Character
					local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*-5
					game.Debris:AddItem(BV,0.3)
					BV.Velocity = BV.Velocity + Vector3.new(0,0,0)


					local FX = Instance.new("Part", workspace.FX)
					FX.Name = "CombatHit"
					FX.CanCollide = false
					FX.Anchored = true
					FX.Material = "ForceField"
					FX.Color = Color3.new(1,1,1)
					if slash < 6 then
						FX.Size = Vector3.new(0.25,0.25,0.25)
					elseif slash <= 6 then
						FX.Size = Vector3.new(2.5,2.5,2.5)
					end
					local SM = Instance.new("SpecialMesh", FX)SM.MeshType = "Sphere"
					SM.Scale = Vector3.new(0,0,0)
					FX.CFrame = humanoid.Parent.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)

					local SsSs = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
					SsSs.SoundId = "rbxassetid://507943576"
					SsSs.PlaybackSpeed = math.random(150,175)/100
					SsSs.Volume = 2
					SsSs:Play()

					local S = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
					S.SoundId = "rbxassetid://3455144981"
					S.PlaybackSpeed = math.random(80,120)/100
					S:Play()


					spawn(function()

						local ParPar = workspace.CombatEffects.ParrySpark:clone()
						ParPar.Parent = workspace.FX
						ParPar.CFrame = humanoid.Parent.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
						ParPar.HitParticle.Enabled = true
						ParPar.ParrySpark1.Enabled = true
						ParPar.ParrySpark2.Enabled = true
						ParPar.ParrySpark3.Enabled = true
						wait()
						ParPar.HitParticle:Emit(1)
						ParPar.ParrySpark1:Emit(1)
						ParPar.ParrySpark2:Emit(1)
						ParPar.ParrySpark3:Emit(1)
						wait(0.5)
						ParPar:destroy()

					end)


				elseif humanoid.Parent:findFirstChild("PerfectBlocking") then
					VStam.Value = VStam.Value - 5
					humanoid:TakeDamage(dmg / 100)
					gui.Parent = humanoid.Parent.Head
					gui.Dmg.Text = dmg / 100
					gui["Gui handler"].max.Value = maxdmg
					gui["Gui handler"].min.Value = mindmg
					local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*2
					game.Debris:AddItem(BV,0.3)

					local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*-1
					game.Debris:AddItem(BV,0.3)

					spawn(function()
						local c = Player.Character
						local SL = Instance.new("BoolValue", c)
						SL.Name = "Stun"
						wait(3)
						SL:Destroy()
					end)

					spawn(function()
						wait(0.25)
						local S = Instance.new("Sound", c)
						S.SoundId = "rbxassetid://507943576"
						S.PlaybackSpeed = math.random(80,120)/100
						S.Volume = 1.5
						S:Play()
						wait(1.5)
						local S = c.Sound
						S:Destroy()
					end)


					spawn(function()

						local PerBlos = workspace.CombatEffects.PerBlo:clone()
						PerBlos.Parent = workspace.FX
						PerBlos.CFrame = humanoid.Parent.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
						PerBlos.HitParticle.Enabled = true
						PerBlos.ParrySpark1.Enabled = true
						PerBlos.ParrySpark2.Enabled = true
						PerBlos.ParrySpark3.Enabled = true
						PerBlos.Attachment.Core.Enabled = true
						PerBlos.Attachment.Rays_Thick.Enabled = true
						PerBlos.Attachment.Rays_Thin.Enabled = true
						PerBlos.Attachment.Wave.Enabled = true
						wait()
						PerBlos.HitParticle:Emit(1)
						PerBlos.ParrySpark1:Emit(1)
						PerBlos.ParrySpark2:Emit(1)
						PerBlos.ParrySpark3:Emit(1)
						PerBlos.Attachment.Core:Emit(1)
						PerBlos.Attachment.Rays_Thick:Emit(1)
						PerBlos.Attachment.Rays_Thin:Emit(1)
						PerBlos.Attachment.Wave:Emit(1)
						wait(0.5)
						PerBlos:destroy()

					end)


				elseif humanoid.Parent:findFirstChild("Blocking") then
					VStam.Value = VStam.Value - 20
					humanoid:TakeDamage(dmg / 20)
					gui.Parent = humanoid.Parent.Head
					gui.Dmg.Text = dmg / 20
					gui["Gui handler"].max.Value = maxdmg
					gui["Gui handler"].min.Value = mindmg
					local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
					game.Debris:AddItem(BV,0.3)

					local S = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
					S.SoundId = "rbxassetid://305526724"
					S.PlaybackSpeed = math.random(80,120)/100
					S:Play()


					spawn(function()

						local ParPar = workspace.CombatEffects.ParrySpark:clone()
						ParPar.Parent = workspace.FX
						ParPar.CFrame = humanoid.Parent.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
						ParPar.HitParticle.Enabled = true
						ParPar.ParrySpark1.Enabled = true
						ParPar.ParrySpark2.Enabled = true
						ParPar.ParrySpark3.Enabled = true
						wait()
						ParPar.HitParticle:Emit(1)
						ParPar.ParrySpark1:Emit(1)
						ParPar.ParrySpark2:Emit(1)
						ParPar.ParrySpark3:Emit(1)
						wait(0.5)
						ParPar:destroy()

					end)


				elseif Combo.Value == 6 then
					humanoid:TakeDamage(dmg)
					gui.Parent = humanoid.Parent.Head
					gui.Dmg.Text = dmg
					gui["Gui handler"].max.Value = maxdmg
					gui["Gui handler"].min.Value = mindmg
					local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*50
					game.Debris:AddItem(BV,0.3)	
					BV.Velocity = BV.Velocity + Vector3.new(0,15,0)

					spawn(function()
						local SL = Instance.new("BoolValue", humanoid.Parent)
						SL.Name = "Stun"
						wait(.4)
						SL:Destroy()
					end)

					local S = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
					S.SoundId = "rbxassetid://296102734"
					S.PlaybackSpeed = math.random(80,120)/100
					S:Play()

					spawn(function()
						local HitPar = workspace.CombatEffects.HitParticle:clone()
						HitPar.Parent = workspace.FX
						HitPar.CFrame = humanoid.Parent.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
						HitPar.HitParticle.Enabled = true
						HitPar.CombatSpark.Enabled = true
						wait()
						HitPar.HitParticle:Emit(1)
						HitPar.CombatSpark:Emit(1)
						wait(0.25)
						HitPar:destroy()
					end)



				else
					humanoid:TakeDamage(dmg)
					gui.Parent = humanoid.Parent.Head
					gui.Dmg.Text = dmg
					gui["Gui handler"].max.Value = maxdmg
					gui["Gui handler"].min.Value = mindmg

					local BV = Instance.new("BodyVelocity", humanoid.Parent.HumanoidRootPart)
					BV.maxForce = Vector3.new(25000,25000,25000)
					BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
					game.Debris:AddItem(BV,0.3)	

					spawn(function()
						local SL = Instance.new("BoolValue", humanoid.Parent)
						SL.Name = "Stun"
						wait(.4)
						SL:Destroy()
					end)

					local S = Instance.new("Sound", humanoid.Parent.HumanoidRootPart)
					S.SoundId = "rbxassetid://296102734"
					S.PlaybackSpeed = math.random(80,120)/100
					S:Play()

					spawn(function()
						local HitPar = workspace.CombatEffects.HitParticle:clone()
						HitPar.Parent = workspace.FX
						HitPar.CFrame = humanoid.Parent.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
						HitPar.HitParticle.Enabled = true
						HitPar.CombatSpark.Enabled = true
						wait()
						HitPar.HitParticle:Emit(1)
						HitPar.CombatSpark:Emit(1)
						wait(0.25)
						HitPar:destroy()
					end)
				end
			end
		end
	end
	
	
	
	
	
	if Action == "SetUp" then

		if c.Head:findFirstChild("MoveStamina") == nil then
			local MStam = Instance.new("NumberValue", c)
			MStam.Name = "MoveStam"
			MStam.Value = MaxStam
			local mStam = script.MoveStamina:clone()
			mStam.Parent = c.Head


			spawn(function()
				while c.Parent == workspace do

					if MStam.Value >= MaxStam then
						MStam.Value = MaxStam
						mStam.Frame.Visible = false
						mStam.Back.Visible = false

					elseif MStam.Value <= 0 and c:findFirstChild("Blocking") or MStam.Value <= 0 and c:findFirstChild("PerfectBlocking") then

						ButtonDown = false
						spawn(function()
							local c = Player.Character
							local SL = Instance.new("BoolValue", c)
							SL.Name = "Stun"
							ButtonDown = false
							wait(3)
							SL:Destroy()
							ButtonDown = false
							return end)

					elseif MStam.Value < MaxStam and MStam.Value > 0 then
						if c:findFirstChild("isDashed") == nil then
							MStam.Value = MStam.Value + 0.25
							wait()
						end
						mStam.Frame.Visible = true
						mStam.Back.Visible = true
						mStam.Frame.Size = UDim2.new(MStam.Value/MaxStam,0,1,0)
					elseif MStam.Value <= 0 then

						spawn(function()
							local c = Player.Character
							local SL = Instance.new("BoolValue", c)
							SL.Name = "Stun"
							wait(5)
							SL:Destroy()
						end)

						if MoveGlobe == false then
							MoveGlobe = true
							local FX = Instance.new("Part", workspace.FX)
							FX.Name = "CombatHit"
							FX.CanCollide = false
							FX.Anchored = true
							FX.Material = "ForceField"
							FX.Color = Color3.fromRGB(55, 0, 55)
							FX.Size = Vector3.new(1,1,1)
							local SM = Instance.new("SpecialMesh", FX)SM.MeshType = "Sphere"
							SM.Scale = Vector3.new(0,0,0)
							FX.CFrame = c.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
							c.Humanoid.WalkSpeed = 0
							wait(5)
							MStam.Value = 25
							c.Humanoid.WalkSpeed = 20
							MoveGlobe = false
						end
					end

					wait()

				end

			end)

		end



		if c.Head:findFirstChild("BlockStamina") == nil then
			local CStam = Instance.new("NumberValue", c)
			CStam.Name = "BlockStam"
			CStam.Value = MaxBStam
			local Stam = script.BlockStamina:clone()
			Stam.Parent = c.Head
			spawn(function()
				while c.Parent == workspace do
					if CStam.Value >= MaxBStam then
						CStam.Value = MaxBStam
						Stam.Frame.Visible = false
						Stam.Back.Visible = false
						
					elseif CStam.Value <= 0 and c:findFirstChild("Blocking") or CStam.Value <= 0 and c:findFirstChild("PerfectBlocking") then

						ButtonDown = false
						spawn(function()
							local c = Player.Character
							local SL = Instance.new("BoolValue", c)
							SL.Name = "Stun"
							ButtonDown = false
							wait(5)
							SL:Destroy()
							return end)

					elseif CStam.Value < MaxBStam and CStam.Value > 0 then
						if c:findFirstChild("Blocking") == nil then
							CStam.Value = CStam.Value + 0.5
						end
						Stam.Frame.Visible = true
						Stam.Back.Visible = true
						Stam.Frame.Size = UDim2.new(CStam.Value/MaxBStam,0,1,0)
					elseif CStam.Value <= 0 then

						if BlockGlobe == false then
							BlockGlobe = true
							local FX = Instance.new("Part", workspace.FX)
							FX.Name = "CombatHit"
							FX.CanCollide = false
							FX.Anchored = true
							FX.Material = "ForceField"
							FX.Color = Color3.fromRGB(226, 155, 64)
							FX.Size = Vector3.new(1,1,1)
							local SM = Instance.new("SpecialMesh", FX)SM.MeshType = "Sphere"
							SM.Scale = Vector3.new(0,0,0)
							FX.CFrame = c.HumanoidRootPart.CFrame*CFrame.new(math.random(-20,20)/10,math.random(-20,20)/10,math.random(-20,20)/10)
							c.Humanoid.WalkSpeed = 0
							wait(5)
							CStam.Value = 25
							c.Humanoid.WalkSpeed = 20
							BlockGlobe = false
						end
					end

					wait()

				end

			end)

		end


	end


	if Action == "isDashed" then

		local MStam = c:WaitForChild("MoveStam")
		MStam.Value = MStam.Value - 20

		spawn(function()
			local c = Player.Character
			local isDA = Instance.new("BoolValue", c)
			isDA.Name = "isDashed"
			wait(1)
			isDA:Destroy()
		end)
	end


	if Action == "Release" then
		ButtonDown = false
		if c:findFirstChild("Stun") == nil then
			c.Humanoid.WalkSpeed = 20
			c.Humanoid.JumpPower = 50
		end
	end
	
	
	
	if Enabled == false then return end
	if Action == "Combat" and c:findFirstChild("Stun") == nil and clash == false then
			Enabled = false

		spawn(function()
			local c = Player.Character
			local InC = Instance.new("BoolValue", c)
			InC.Name = "InCombat"
			wait(0.41)
			InC:Destroy()
		end)
		
		spawn(function()
			local OldCombo = Combo.Value
			wait(2)
			if Combo.Value == OldCombo then
				Combo.Value = 6
			end
		end)
		
		game.ReplicatedStorage.CameraRemotes.Camera.WeaponSwing:FireClient(Player)
		
		if Combo.Value == 1 then
			Combo.Value = 2


			local S = Instance.new("Sound", c)
			S.SoundId = "rbxassetid://257091803"
			S.PlaybackSpeed = math.random(80,120)/100
			S:Play()

			c.Humanoid.WalkSpeed = 5


			local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
			BV.maxForce = Vector3.new(25000,25000,25000)
			BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
			game.Debris:AddItem(BV,0.45)	

		elseif Combo.Value == 2 then
			Combo.Value = 3


			local S = Instance.new("Sound", c)
			S.SoundId = "rbxassetid://257091803"
			S.PlaybackSpeed = math.random(80,120)/100
			S:Play()

			c.Humanoid.WalkSpeed = 5


			local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
			BV.maxForce = Vector3.new(25000,25000,25000)
			BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
			game.Debris:AddItem(BV,0.45)	

		elseif Combo.Value == 3 then
			Combo.Value = 4


			local S = Instance.new("Sound", c)
			S.SoundId = "rbxassetid://257091803"
			S.PlaybackSpeed = math.random(80,120)/100
			S:Play()

			c.Humanoid.WalkSpeed = 5


			local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
			BV.maxForce = Vector3.new(25000,25000,25000)
			BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
			game.Debris:AddItem(BV,0.45)	
			
		elseif Combo.Value == 4 then
			Combo.Value = 5


			local S = Instance.new("Sound", c)
			S.SoundId = "rbxassetid://257091803"
			S.PlaybackSpeed = math.random(80,120)/100
			S:Play()

			c.Humanoid.WalkSpeed = 5


			local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
			BV.maxForce = Vector3.new(25000,25000,25000)
			BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
			game.Debris:AddItem(BV,0.45)	
			
		elseif Combo.Value == 5 then
			Combo.Value = 6


			local S = Instance.new("Sound", c)
			S.SoundId = "rbxassetid://257091803"
			S.PlaybackSpeed = math.random(80,120)/100
			S:Play()

			c.Humanoid.WalkSpeed = 5


			local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
			BV.maxForce = Vector3.new(25000,25000,25000)
			BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
			game.Debris:AddItem(BV,0.45)	
			
		elseif Combo.Value == 6 then
			Combo.Value = 1


			local S = Instance.new("Sound", c)
			S.SoundId = "rbxassetid://257091803"
			S.PlaybackSpeed = math.random(80,120)/100
			S:Play()	

			c.Humanoid.WalkSpeed = 5


			local BV = Instance.new("BodyVelocity", c.HumanoidRootPart)
			BV.maxForce = Vector3.new(25000,25000,25000)
			BV.Velocity = c.HumanoidRootPart.CFrame.lookVector*5
			game.Debris:AddItem(BV,0.45)	

		end
		wait()
		
		local S = c.Sound
		if Combo.Value == 1 then wait(0.31)
			script.CastOff:FireClient(Player)
			if c:findFirstChild("Stun") == nil then
				c.Humanoid.WalkSpeed = 20
				c.Humanoid.JumpPower = 50
			end
			S:Destroy()
			script.CanAttack:FireClient(Player)
		elseif Combo.Value == 2 then wait(0.31)
			script.CastOff:FireClient(Player)
			if c:findFirstChild("Stun") == nil then
				c.Humanoid.WalkSpeed = 20
				c.Humanoid.JumpPower = 50
			end
			S:Destroy()
			script.CanAttack:FireClient(Player)
		elseif Combo.Value == 3 then wait(0.31)
			script.CastOff:FireClient(Player)
			if c:findFirstChild("Stun") == nil then
				c.Humanoid.WalkSpeed = 20
				c.Humanoid.JumpPower = 50
			end
			S:Destroy()
			script.CanAttack:FireClient(Player)
		elseif Combo.Value == 4 then wait(0.4)
			script.CastOff:FireClient(Player)
			if c:findFirstChild("Stun") == nil then
				c.Humanoid.WalkSpeed = 20
				c.Humanoid.JumpPower = 50
			end
			S:Destroy()
			script.CanAttack:FireClient(Player)
		elseif Combo.Value == 5 then wait(0.31)
			script.CastOff:FireClient(Player)
			if c:findFirstChild("Stun") == nil then
				c.Humanoid.WalkSpeed = 20
				c.Humanoid.JumpPower = 50
			end
			S:Destroy()
			script.CanAttack:FireClient(Player)
		elseif Combo.Value == 6 then wait(0.4)
			script.CastOff:FireClient(Player)
			if c:findFirstChild("Stun") == nil then
				c.Humanoid.WalkSpeed = 20
				c.Humanoid.JumpPower = 50
			end
			wait(1.25)
			S:Destroy()
			script.CanAttack:FireClient(Player)
		end

		Enabled = true
		
	elseif Action == "Block" and c:findFirstChild("Stun") == nil then

		ButtonDown = true
		Enabled = false

		local CStam = c:WaitForChild("BlockStam")

		spawn(function()
			while ButtonDown == true do
				CStam.Value = CStam.Value - 0.5
				c.Humanoid.WalkSpeed = 10
				c.Humanoid.JumpPower = 0
				wait(0.0015)
			end
		end)

		CStam.Value = CStam.Value - 20

		local B = Instance.new("BoolValue", c)
		B.Name = "PerfectBlocking"
		local FX = Instance.new("Part", workspace.FX)
		FX.Name = "CombatHit"
		FX.CanCollide = false
		FX.Anchored = false
		FX.Material = "ForceField"
		FX.Color = Color3.new(0,0,1)
		FX.Size = Vector3.new(1,1,1)
		local SM = Instance.new("SpecialMesh", FX)SM.MeshType = "Sphere"
		SM.Scale = Vector3.new(0,0,0)
		local W = Instance.new("Weld", c.HumanoidRootPart)
		W.Part0 = FX
		W.Part1 = c.HumanoidRootPart

		local Anim = c.Humanoid:LoadAnimation(BlockAnim)
		Anim:play()
		wait(0.25)
		B.Name = "Blocking"

		if ButtonDown == true then
			Enabled = false
			B.Name = "Blocking"
			wait(0.1)
		end

		wait(1)

		while ButtonDown == true do
			CStam.Value = CStam.Value - 0.01
			wait(0.01)
		end

		Anim:stop()
		Enabled = true

		game.Debris:AddItem(B,0)

	end
	
	

end)
