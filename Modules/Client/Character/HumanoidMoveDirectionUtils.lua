--- Ever wanted to not rewrite all of Roblox's input systems! Well, now you can
-- with this slight hack!
-- @module HumanoidMoveDirectionUtils

local require = require(game:GetService("ReplicatedStorage"):WaitForChild("Nevermore"))

local UserInputService = game:GetService("UserInputService")

local getRotationInXZPlane = require("getRotationInXZPlane")

local LEFT = Vector3.new(-1, 0, 0)
local DIRECTION_INPUT_MAPS = {
	[Enum.KeyCode.Left] = LEFT;
	[Enum.KeyCode.Right] = -LEFT;
}

local HumanoidMoveDirectionUtils = {}

function HumanoidMoveDirectionUtils.getRelativeMoveDirection(cameraCFrame, humanoid)
	local moveDirection = humanoid.MoveDirection
	local flatCameraCFrame = getRotationInXZPlane(cameraCFrame)

	local relative = flatCameraCFrame:vectorToObjectSpace(moveDirection)

	-- Compensate for lack of camera movement in left/right arrow keys
	local direction = Vector3.new(0, 0, 0)
	for keycode, add in pairs(DIRECTION_INPUT_MAPS) do
		if UserInputService:IsKeyDown(keycode) then
			direction = direction + add
		end
	end
	if direction.magnitude > 0 then
		return (relative + direction.unit).unit
	end

	return relative
end

return HumanoidMoveDirectionUtils