local TweenService = game:GetService("TweenService")

local Animator = {}

function Animator.tween(instance, durationOrInfo, goalProps)
	local info
	if typeof(durationOrInfo) == "number" then
		info = TweenInfo.new(durationOrInfo, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	elseif typeof(durationOrInfo) == "TweenInfo" then
		info = durationOrInfo
	else
		info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end
	local tween = TweenService:Create(instance, info, goalProps or {})
	tween:Play()
	return tween
end

return Animator
