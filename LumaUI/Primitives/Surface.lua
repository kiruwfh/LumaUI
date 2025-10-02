local ThemeProvider = require(script.Parent.Parent.Theme.ThemeProvider)

local Surface = {}

local function applyProps(inst, props)
	if not props then return end
	for k, v in pairs(props) do
		if k ~= "Variant" and k ~= "Corner" and k ~= "Padding" then
			local ok = pcall(function()
				inst[k] = v
			end)
			if not ok then
				-- ignore unsupported props on this instance
			end
		end
	end
end

function Surface.new(parent, props)
	props = props or {}
	local theme = ThemeProvider.getTheme()

	local frame = Instance.new("Frame")
	frame.Name = props.Name or "Surface"
	frame.BackgroundColor3 = (props.Variant == "Elevated") and theme.colors.surfaceElevated or theme.colors.surface
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 0
	frame.Size = props.Size or UDim2.fromOffset(200, 40)
	frame.Position = props.Position or UDim2.new(0, 0, 0, 0)
	frame.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = props.Corner or theme.radii.md
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = theme.colors.border
	stroke.Transparency = props.Variant == "Ghost" and 1 or 0
	stroke.Parent = frame

	if props.Padding then
		local pad = Instance.new("UIPadding")
		pad.PaddingTop = UDim.new(0, props.Padding)
		pad.PaddingBottom = UDim.new(0, props.Padding)
		pad.PaddingLeft = UDim.new(0, props.Padding)
		pad.PaddingRight = UDim.new(0, props.Padding)
		pad.Parent = frame
	end

	applyProps(frame, props)

	local themeConn
	local function onThemeChanged(newTheme)
		local th = newTheme or ThemeProvider.getTheme()
		frame.BackgroundColor3 = (props.Variant == "Elevated") and th.colors.surfaceElevated or th.colors.surface
		stroke.Color = th.colors.border
		corner.CornerRadius = props.Corner or th.radii.md
	end
	themeConn = ThemeProvider.onChanged(onThemeChanged)

	local api = {}
	api.Instance = frame
	api.Destroy = function()
		if themeConn then themeConn:Disconnect() end
		frame:Destroy()
	end

	return api
end

return Surface
