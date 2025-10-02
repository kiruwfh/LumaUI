local ThemeProvider = require(script.Parent.Parent.Theme.ThemeProvider)

local Stack = {}

local function applyProps(inst, props)
	if not props then return end
	for k, v in pairs(props) do
		if k ~= "Direction" and k ~= "Spacing" and k ~= "Align" and k ~= "AutoSize" then
			local ok = pcall(function()
				inst[k] = v
			end)
			if not ok then end
		end
	end
end

local function mapAlign(direction, align)
	align = (align or "Start"):lower()
	if direction == Enum.FillDirection.Horizontal then
		if align == "center" then return Enum.HorizontalAlignment.Center end
		if align == "end" then return Enum.HorizontalAlignment.Right end
		return Enum.HorizontalAlignment.Left
	else
		if align == "center" then return Enum.VerticalAlignment.Center end
		if align == "end" then return Enum.VerticalAlignment.Bottom end
		return Enum.VerticalAlignment.Top
	end
end

function Stack.new(parent, props)
	props = props or {}
	local _ = ThemeProvider.getTheme() -- reserved for future token usage

	local frame = Instance.new("Frame")
	frame.Name = props.Name or "Stack"
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Size = props.Size or UDim2.new(1, 0, 0, 0)
	frame.AutomaticSize = props.AutoSize and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
	frame.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = (props.Direction == "Horizontal") and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
	layout.Padding = UDim.new(0, props.Spacing or 8)
	if layout.FillDirection == Enum.FillDirection.Horizontal then
		layout.HorizontalAlignment = mapAlign(layout.FillDirection, props.Align)
		layout.VerticalAlignment = Enum.VerticalAlignment.Center
	else
		layout.HorizontalAlignment = Enum.HorizontalAlignment.Left
		layout.VerticalAlignment = mapAlign(layout.FillDirection, props.Align)
	end
	layout.SortOrder = Enum.SortOrder.LayoutOrder
	layout.Parent = frame

	applyProps(frame, props)

	local api = {}
	api.Instance = frame
	api.Destroy = function()
		frame:Destroy()
	end
	return api
end

return Stack
