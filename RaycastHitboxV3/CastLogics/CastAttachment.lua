
local git = "https://raw.githubusercontent.com/github-user123456789/-Kingdom-Hearts-Creation-Pack-By-Tetsukin-Roblox-/main/RaycastHitboxV3/"
local function require(a)
  return loadstring(game:service("HttpService"):GetAsync(git ..a))()
end

local Cast = {}
local Debugger = require("CastLogics/Debug/Debugger.lua")

function Cast:solve(Point, bool)
	if not Point.LastPosition then
		Point.LastPosition = Point.Attachment.WorldPosition
	end
	
	if bool then
		Debugger(Point.Attachment.WorldPosition - Point.LastPosition, CFrame.new(Point.Attachment.WorldPosition, Point.LastPosition))
	end
	return Point.LastPosition, Point.Attachment.WorldPosition - Point.LastPosition
end

function Cast:lastPosition(Point)
	Point.LastPosition = Point.Attachment.WorldPosition	
end

return Cast
