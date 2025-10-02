local ThemeProvider = require(script.Parent.Parent.Theme.ThemeProvider)

local Text = {}

local function applyProps(inst, props)
	if not props then return end
	for k, v in pairs(props) do
		if k ~= "SizeToken" and k ~= "ColorToken" and k ~= "AutoSize" then
			local ok = pcall(function()
				inst[k] = v
			end)
			if not ok then end
		end
	end
end

local sizeMap = {
	sm = 14,
	md = 16,
	lg = 18,
}

function Text.new(parent, props)
	props = props or {}
	local theme = ThemeProvider.getTheme()

	local label = Instance.new("TextLabel")
	label.Name = props.Name or "Text"
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Font = theme.typography.font
	label.Text = props.Text or ""
	label.TextColor3 = theme.colors.text
	label.TextSize = sizeMap[(props.SizeToken or "md"):lower()] or theme.typography.sizes.md
	label.RichText = props.RichText == nil and true or props.RichText
	label.AutomaticSize = props.AutoSize and Enum.AutomaticSize.XY or Enum.AutomaticSize.None
	label.Size = props.Size or (props.AutoSize and UDim2.fromOffset(0, 0) or UDim2.fromOffset(100, 24))
	label.Parent = parent

	applyProps(label, props)

	local themeConn
	local function onThemeChanged(newTheme)
		local th = newTheme or ThemeProvider.getTheme()
		label.Font = th.typography.font
		label.TextColor3 = th.colors.text
		label.TextSize = sizeMap[(props.SizeToken or "md"):lower()] or th.typography.sizes.md
	end
	themeConn = ThemeProvider.onChanged(onThemeChanged)

	local api = {}
	api.Instance = label
	api.Destroy = function()
		if themeConn then themeConn:Disconnect() end
		label:Destroy()
	end
	return api
end

return Text
