
local git = "https://raw.githubusercontent.com/github-user123456789/-Kingdom-Hearts-Creation-Pack-By-Tetsukin-Roblox-/main/RaycastHitboxV3/"
local function require(a)
  return loadstring(game:service("HttpService"):GetAsync(git ..a))()
end

local Cast = {}
local Debugger = require("CastLogics/Debug/Debugger")

function Cast:solve(Point, bool)
	if bool then
		Debugger(Point.Attachment.WorldPosition - Point.Attachment0.WorldPosition, CFrame.new(Point.Attachment.WorldPosition, Point.Attachment0.WorldPosition))
	end

	return Point.Attachment.WorldPosition, Point.Attachment0.WorldPosition - Point.Attachment.WorldPosition
end

function Cast:lastPosition(Point)
	Point.LastPosition = Point.Attachment.WorldPosition
end

return Cast
