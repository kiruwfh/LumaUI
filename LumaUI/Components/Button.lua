local Animator = require(script.Parent.Parent.Core.Animator)
local ThemeProvider = require(script.Parent.Parent.Theme.ThemeProvider)
local Signal = require(script.Parent.Parent.Core.Signal)
local Color = require(script.Parent.Parent.Utils.Color)

local Button = {}

local sizes = {
	sm = { height = 32, padX = 12, text = 14 },
	md = { height = 36, padX = 14, text = 16 },
	lg = { height = 44, padX = 18, text = 18 },
}

local function toSizeToken(value)
	if typeof(value) == "string" then
		return string.lower(value)
	end
	return "md"
end

local function clamp(n, a, b)
	if n < a then return a end
	if n > b then return b end
	return n
end

local function computeStyle(theme, variant, state)
	variant = string.lower(variant or "primary")
	state = state or "default"
	local c = theme.colors

	if variant == "primary" then
		local bg = c.primary
		if state == "hover" then bg = c.primaryHover end
		if state == "pressed" then bg = c.primaryPressed end
		if state == "disabled" then bg = Color.mix(c.primary, c.surface, 0.5) end
		return {
			bg = bg,
			text = c.onPrimary,
			stroke = Color.darken(bg, 0.25),
		}
	elseif variant == "danger" then
		local base = c.danger
		local bg = base
		if state == "hover" then bg = Color.lighten(base, 0.06) end
		if state == "pressed" then bg = Color.darken(base, 0.08) end
		if state == "disabled" then bg = Color.mix(base, c.surface, 0.55) end
		return {
			bg = bg,
			text = c.onPrimary,
			stroke = Color.darken(bg, 0.25),
		}
	elseif variant == "ghost" then
		local base = c.surface
		local bg = base
		if state == "hover" then bg = Color.lighten(base, 0.04) end
		if state == "pressed" then bg = Color.darken(base, 0.05) end
		if state == "disabled" then bg = Color.mix(base, c.bg, 0.5) end
		return {
			bg = bg,
			text = c.text,
			stroke = c.border,
		}
	else -- secondary
		local base = c.surfaceElevated
		local bg = base
		if state == "hover" then bg = Color.lighten(base, 0.04) end
		if state == "pressed" then bg = Color.darken(base, 0.06) end
		if state == "disabled" then bg = Color.mix(base, c.bg, 0.55) end
		return {
			bg = bg,
			text = c.text,
			stroke = c.border,
		}
	end
end

local function applyCommonProps(inst, props)
	for k, v in pairs(props or {}) do
		if k ~= "Variant" and k ~= "Size" and k ~= "Disabled" and k ~= "AnchorPoint" and k ~= "Position" and k ~= "Text" and k ~= "Corner" then
			pcall(function()
				inst[k] = v
			end)
		end
	end
end

function Button.new(parent, props)
	props = props or {}
	local theme = ThemeProvider.getTheme()

	local sizeTok = toSizeToken(props.Size or "md")
	local sz = sizes[sizeTok] or sizes.md
	local variant = props.Variant or "Primary"

	local btn = Instance.new("TextButton")
	btn.Name = props.Name or "Button"
	btn.AutoButtonColor = false
	btn.Selectable = true
	btn.BackgroundColor3 = computeStyle(theme, variant, "default").bg
	btn.TextColor3 = computeStyle(theme, variant, "default").text
	btn.Font = theme.typography.fontSemi or theme.typography.font
	btn.TextSize = sz.text
	btn.Text = props.Text or "Button"
	btn.RichText = true
	btn.BorderSizePixel = 0
	btn.Size = UDim2.new(0, 0, 0, sz.height)
	btn.AutomaticSize = Enum.AutomaticSize.X
	btn.AnchorPoint = props.AnchorPoint or Vector2.new(0, 0)
	btn.Position = props.Position or UDim2.new(0, 0, 0, 0)
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = props.Corner or theme.radii.md
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = computeStyle(theme, variant, "default").stroke
	stroke.Parent = btn

	local focusStroke = Instance.new("UIStroke")
	focusStroke.Thickness = 2
	focusStroke.Color = theme.colors.focus
	focusStroke.Transparency = 1
	focusStroke.Parent = btn

	local padding = Instance.new("UIPadding")
	padding.PaddingLeft = UDim.new(0, sz.padX)
	padding.PaddingRight = UDim.new(0, sz.padX)
	padding.Parent = btn

	local scale = Instance.new("UIScale")
	scale.Scale = 1
	scale.Parent = btn

	applyCommonProps(btn, props)

	local signals = {
		Activated = Signal.new(),
	}

	local state = {
		hover = false,
		pressed = false,
		disabled = props.Disabled or false,
		variant = variant,
		sizeTok = sizeTok,
	}

	local function targetStateName()
		if state.disabled then return "disabled" end
		if state.pressed then return "pressed" end
		if state.hover then return "hover" end
		return "default"
	end

	local function restyle(animated)
		local style = computeStyle(theme, state.variant, targetStateName())
		if animated then
			Animator.tween(btn, 0.12, { BackgroundColor3 = style.bg, TextColor3 = style.text })
			Animator.tween(stroke, 0.12, { Color = style.stroke })
		else
			btn.BackgroundColor3 = style.bg
			btn.TextColor3 = style.text
			stroke.Color = style.stroke
		end
		btn.Active = not state.disabled
		btn.AutoButtonColor = false
		btn.TextTransparency = state.disabled and 0.3 or 0
		stroke.Transparency = state.disabled and 0.5 or 0
	end

	local function pressScale(to)
		Animator.tween(scale, 0.08, { Scale = clamp(to, 0.94, 1) })
	end

	btn.MouseEnter:Connect(function()
		state.hover = true
		restyle(true)
	end)
	btn.MouseLeave:Connect(function()
		state.hover = false
		state.pressed = false
		pressScale(1)
		restyle(true)
	end)
	btn.MouseButton1Down:Connect(function()
		if state.disabled then return end
		state.pressed = true
		pressScale(0.97)
		restyle(true)
	end)
	btn.MouseButton1Up:Connect(function()
		if state.disabled then return end
		state.pressed = false
		pressScale(1)
		restyle(true)
	end)
	btn.Activated:Connect(function()
		if state.disabled then return end
		signals.Activated:Fire()
	end)

	btn.SelectionGained:Connect(function()
		Animator.tween(focusStroke, 0.1, { Transparency = 0 })
	end)
	btn.SelectionLost:Connect(function()
		Animator.tween(focusStroke, 0.1, { Transparency = 1 })
	end)

	local themeConn = ThemeProvider.onChanged(function(newTheme)
		theme = newTheme
		corner.CornerRadius = props.Corner or theme.radii.md
		focusStroke.Color = theme.colors.focus
		btn.Font = theme.typography.fontSemi or theme.typography.font
		restyle(false)
	end)

	local api = {}
	api.Instance = btn
	function api:on(ev, cb)
		local s = signals[ev]
		if not s then error("Unknown Button event: " .. tostring(ev)) end
		return s:Connect(cb)
	end
	function api:setText(t)
		btn.Text = t
	end
	function api:setDisabled(d)
		state.disabled = d and true or false
		restyle(true)
	end
	function api:setVariant(v)
		state.variant = v or state.variant
		restyle(true)
	end
	function api:Destroy()
		for _, s in pairs(signals) do s:Destroy() end
		if themeConn then themeConn:Disconnect() end
		btn:Destroy()
	end

	restyle(false)

	return api
end

return Button
