
local git = "https://raw.githubusercontent.com/github-user123456789/-Kingdom-Hearts-Creation-Pack-By-Tetsukin-Roblox-/main/RaycastHitboxV3/"
local function require(a)
  return loadstring(game:service("HttpService"):GetAsync(git ..a))()
end

local Cast = {}
local Debugger = require("CastLogics/Debug/Debugger.lua")

function Cast:solve(Point, bool)	
	local RelativePartToWorldSpace = Point.RelativePart.Position + Point.RelativePart.CFrame:VectorToWorldSpace(Point.Attachment)
	if not Point.LastPosition then
		Point.LastPosition = RelativePartToWorldSpace
	end
	
	if bool then
		Debugger(RelativePartToWorldSpace - Point.LastPosition, CFrame.new(RelativePartToWorldSpace, Point.LastPosition))
	end

	return Point.LastPosition, RelativePartToWorldSpace - (Point.LastPosition and Point.LastPosition or Vector3.new()), RelativePartToWorldSpace
end

function Cast:lastPosition(Point, RelativePartToWorldSpace)
	Point.LastPosition = RelativePartToWorldSpace
end

return Cast
