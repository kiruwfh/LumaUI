-- LumaUI single-file bundle for remote loadstring usage
-- Usage:
local LumaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kiruwfh/LumaUI/main/LumaUI.lua"))()

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")

-- Utils/Color
local Color = {}
local function clamp01(n)
	if n < 0 then return 0 elseif n > 1 then return 1 else return n end
end
function Color.lighten(c, a) a = clamp01(a or 0.1) return c:Lerp(Color3.new(1,1,1), a) end
function Color.darken(c, a) a = clamp01(a or 0.1) return c:Lerp(Color3.new(0,0,0), a) end
function Color.mix(a, b, t) return a:Lerp(b, clamp01(t or 0.5)) end
local function srgbToLinear(x) if x <= 0.04045 then return x/12.92 end return ((x + 0.055)/1.055) ^ 2.4 end
function Color.luminance(c)
	local r = srgbToLinear(c.R) local g = srgbToLinear(c.G) local b = srgbToLinear(c.B)
	return 0.2126*r + 0.7152*g + 0.0722*b
end
function Color.contrastColor(bg)
	if Color.luminance(bg) > 0.5 then return Color3.new(0,0,0) else return Color3.new(1,1,1) end
end

-- Core/Signal
local Signal = {} ; Signal.__index = Signal
function Signal.new() local self=setmetatable({},Signal) self._handlers={} self._dead=false return self end
function Signal:Connect(fn)
	assert(type(fn)=="function","Signal:Connect expects a function")
	if self._dead then return {Connected=false,Disconnect=function() end} end
	local connection = {
		Connected = true,
		_fn = fn,
		Disconnect = function(conn)
			if not conn.Connected then return end
			conn.Connected=false
			for i,h in ipairs(self._handlers) do
				if h==conn then table.remove(self._handlers,i) break end
			end
		end
	}
	table.insert(self._handlers, connection)
	return connection
end
function Signal:Once(fn) local conn conn=self:Connect(function(...) if conn then conn:Disconnect() end fn(...) end) return conn end
function Signal:Fire(...)
	if self._dead then return end
	local snapshot = {}
	for i,h in ipairs(self._handlers) do snapshot[i]=h end
	for _,h in ipairs(snapshot) do
		if h.Connected then
			local ok,err = pcall(h._fn, ...)
			if not ok then warn("Signal handler error:", err) end
		end
	end
end
function Signal:Wait()
	if self._dead then return end
	local be = Instance.new("BindableEvent")
	local conn
	conn = self:Connect(function(...) be:Fire(...) end)
	local result = { be.Event:Wait() }
	conn:Disconnect()
	be:Destroy()
	return table.unpack(result)
end
function Signal:Destroy()
	if self._dead then return end
	self._dead = true
	for _,h in ipairs(self._handlers) do h.Connected=false end
	self._handlers = {}
end

-- Core/Animator
local Animator = {}
function Animator.tween(instance, durationOrInfo, goalProps)
	local info
	if typeof(durationOrInfo)=="number" then
		info = TweenInfo.new(durationOrInfo, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	elseif typeof(durationOrInfo)=="TweenInfo" then
		info = durationOrInfo
	else
		info = TweenInfo.new(0.2, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
	end
	local tween = TweenService:Create(instance, info, goalProps or {})
	tween:Play()
	return tween
end

-- Theme
local Theme = {}
local function tokensLight()
	local primary = Color3.fromRGB(138, 92, 246)
	return {
		name = "light",
		colors = {
			primary = primary,
			primaryHover = Color.lighten(primary, 0.08),
			primaryPressed = Color.darken(primary, 0.08),
			bg = Color3.fromRGB(245, 246, 250),
			surface = Color3.fromRGB(252, 252, 255),
			surfaceElevated = Color3.fromRGB(244, 245, 250),
			border = Color3.fromRGB(225, 228, 238),
			text = Color3.fromRGB(20, 22, 26),
			subtext = Color3.fromRGB(94, 98, 110),
			danger = Color3.fromRGB(235, 87, 87),
			onPrimary = Color.contrastColor(primary),
			onSurface = Color.contrastColor(Color3.fromRGB(252,252,255)),
			focus = Color3.fromRGB(85, 204, 255),
		},
		radii = { xs=UDim.new(0,4), sm=UDim.new(0,6), md=UDim.new(0,8), lg=UDim.new(0,12), pill=UDim.new(1,0) },
		spacing = { 4,8,12,16,24,32 },
		typography = { font=Enum.Font.Gotham, fontSemi=Enum.Font.GothamSemibold, sizes={ sm=14, md=16, lg=18 } },
	}
end
local function tokensDark()
	local primary = Color3.fromRGB(158, 117, 255)
	return {
		name = "dark",
		colors = {
			primary = primary,
			primaryHover = Color.lighten(primary, 0.06),
			primaryPressed = Color.darken(primary, 0.07),
			bg = Color3.fromRGB(16, 18, 24),
			surface = Color3.fromRGB(22, 24, 30),
			surfaceElevated = Color3.fromRGB(28, 31, 38),
			border = Color3.fromRGB(45, 49, 58),
			text = Color3.fromRGB(235, 237, 243),
			subtext = Color3.fromRGB(165, 170, 185),
			danger = Color3.fromRGB(240, 85, 85),
			onPrimary = Color.contrastColor(primary),
			onSurface = Color.contrastColor(Color3.fromRGB(22,24,30)),
			focus = Color3.fromRGB(64, 170, 255),
		},
		radii = { xs=UDim.new(0,4), sm=UDim.new(0,6), md=UDim.new(0,8), lg=UDim.new(0,12), pill=UDim.new(1,0) },
		spacing = { 4,8,12,16,24,32 },
		typography = { font=Enum.Font.Gotham, fontSemi=Enum.Font.GothamSemibold, sizes={ sm=14, md=16, lg=18 } },
	}
end
local function deepCopy(t)
	if type(t)~="table" then return t end
	local o = {} ; for k,v in pairs(t) do o[k] = (type(v)=="table") and deepCopy(v) or v end
	return o
end
function Theme.merge(base, override)
	local r = deepCopy(base or {})
	for k,v in pairs(override or {}) do
		if type(v)=="table" and type(r[k])=="table" then r[k]=Theme.merge(r[k], v) else r[k]=v end
	end
	return r
end
function Theme.get(name) if name=="dark" then return tokensDark() end return tokensLight() end
Theme.defaultLight = tokensLight()
Theme.defaultDark = tokensDark()

-- ThemeProvider
local ThemeProvider = {}
local _current = Theme.get("light")
local _changed = Signal.new()
function ThemeProvider.setTheme(nameOrTokens)
	local t
	if typeof(nameOrTokens)=="string" then
		t = Theme.get(nameOrTokens)
	elseif typeof(nameOrTokens)=="table" then
		t = Theme.merge(Theme.get("light"), nameOrTokens)
	else
		warn("ThemeProvider.setTheme expects string or table; falling back to light")
		t = Theme.get("light")
	end
	_current = t
	_changed:Fire(_current)
end
function ThemeProvider.getTheme() return _current end
function ThemeProvider.onChanged(cb) return _changed:Connect(cb) end

-- Primitives/Surface
local Surface = {}
local function Surface_applyProps(inst, props)
	if not props then return end
	for k,v in pairs(props) do
		if k~="Variant" and k~="Corner" and k~="Padding" then
			pcall(function() inst[k] = v end)
		end
	end
end
function Surface.new(parent, props)
	props = props or {}
	local th = ThemeProvider.getTheme()
	local frame = Instance.new("Frame")
	frame.Name = props.Name or "Surface"
	frame.BackgroundColor3 = (props.Variant=="Elevated") and th.colors.surfaceElevated or th.colors.surface
	frame.BorderSizePixel = 0
	frame.BackgroundTransparency = 0
	frame.Size = props.Size or UDim2.fromOffset(200, 40)
	frame.Position = props.Position or UDim2.new(0,0,0,0)
	frame.AnchorPoint = props.AnchorPoint or Vector2.new(0,0)
	frame.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = props.Corner or th.radii.md
	corner.Parent = frame

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = th.colors.border
	stroke.Transparency = props.Variant=="Ghost" and 1 or 0
	stroke.Parent = frame

	if props.Padding then
		local pad = Instance.new("UIPadding")
		pad.PaddingTop = UDim.new(0, props.Padding)
		pad.PaddingBottom = UDim.new(0, props.Padding)
		pad.PaddingLeft = UDim.new(0, props.Padding)
		pad.PaddingRight = UDim.new(0, props.Padding)
		pad.Parent = frame
	end

	Surface_applyProps(frame, props)

	local themeConn = ThemeProvider.onChanged(function(newTh)
		local t = newTh or ThemeProvider.getTheme()
		frame.BackgroundColor3 = (props.Variant=="Elevated") and t.colors.surfaceElevated or t.colors.surface
		stroke.Color = t.colors.border
		corner.CornerRadius = props.Corner or t.radii.md
	end)

	local api = {}
	api.Instance = frame
	api.Destroy = function()
		if themeConn then themeConn:Disconnect() end
		frame:Destroy()
	end
	return api
end

-- Primitives/Text
local Text = {}
local sizeMap = { sm=14, md=16, lg=18 }
local function Text_applyProps(inst, props)
	if not props then return end
	for k,v in pairs(props) do
		if k~="SizeToken" and k~="ColorToken" and k~="AutoSize" then
			pcall(function() inst[k] = v end)
		end
	end
end
function Text.new(parent, props)
	props = props or {}
	local th = ThemeProvider.getTheme()
	local label = Instance.new("TextLabel")
	label.Name = props.Name or "Text"
	label.BackgroundTransparency = 1
	label.BorderSizePixel = 0
	label.Font = th.typography.font
	label.Text = props.Text or ""
	label.TextColor3 = th.colors.text
	label.TextSize = sizeMap[(props.SizeToken or "md"):lower()] or th.typography.sizes.md
	label.RichText = (props.RichText==nil) and true or props.RichText
	label.AutomaticSize = props.AutoSize and Enum.AutomaticSize.XY or Enum.AutomaticSize.None
	label.Size = props.Size or (props.AutoSize and UDim2.fromOffset(0,0) or UDim2.fromOffset(100,24))
	label.Parent = parent

	Text_applyProps(label, props)

	local themeConn = ThemeProvider.onChanged(function(newTh)
		local t = newTh or ThemeProvider.getTheme()
		label.Font = t.typography.font
		label.TextColor3 = t.colors.text
		label.TextSize = sizeMap[(props.SizeToken or "md"):lower()] or t.typography.sizes.md
	end)

	local api = {}
	api.Instance = label
	api.Destroy = function()
		if themeConn then themeConn:Disconnect() end
		label:Destroy()
	end
	return api
end

-- Primitives/Stack
local Stack = {}
local function Stack_applyProps(inst, props)
	if not props then return end
	for k,v in pairs(props) do
		if k~="Direction" and k~="Spacing" and k~="Align" and k~="AutoSize" then
			pcall(function() inst[k] = v end)
		end
	end
end
local function mapAlign(direction, align)
	align = (align or "Start"):lower()
	if direction == Enum.FillDirection.Horizontal then
		if align=="center" then return Enum.HorizontalAlignment.Center end
		if align=="end" then return Enum.HorizontalAlignment.Right end
		return Enum.HorizontalAlignment.Left
	else
		if align=="center" then return Enum.VerticalAlignment.Center end
		if align=="end" then return Enum.VerticalAlignment.Bottom end
		return Enum.VerticalAlignment.Top
	end
end
function Stack.new(parent, props)
	props = props or {}
	local frame = Instance.new("Frame")
	frame.Name = props.Name or "Stack"
	frame.BackgroundTransparency = 1
	frame.BorderSizePixel = 0
	frame.Size = props.Size or UDim2.new(1,0,0,0)
	frame.AutomaticSize = props.AutoSize and Enum.AutomaticSize.Y or Enum.AutomaticSize.None
	frame.Parent = parent

	local layout = Instance.new("UIListLayout")
	layout.FillDirection = (props.Direction=="Horizontal") and Enum.FillDirection.Horizontal or Enum.FillDirection.Vertical
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

	Stack_applyProps(frame, props)

	local api = {}
	api.Instance = frame
	api.Destroy = function() frame:Destroy() end
	return api
end

-- Components/Button
local Button = {}
local sizesBtn = {
	sm = { height=32, padX=12, text=14 },
	md = { height=36, padX=14, text=16 },
	lg = { height=44, padX=18, text=18 },
}
local function toSizeToken(v) if typeof(v)=="string" then return string.lower(v) end return "md" end
local function clamp(n,a,b) if n<a then return a end if n>b then return b end return n end
local function computeStyle(th, variant, state)
	variant = string.lower(variant or "primary")
	state = state or "default"
	local c = th.colors
	if variant == "primary" then
		local bg = c.primary
		if state=="hover" then bg = c.primaryHover end
		if state=="pressed" then bg = c.primaryPressed end
		if state=="disabled" then bg = Color.mix(c.primary, c.surface, 0.5) end
		return { bg=bg, text=c.onPrimary, stroke=Color.darken(bg, 0.25) }
	elseif variant == "danger" then
		local base = c.danger
		local bg = base
		if state=="hover" then bg = Color.lighten(base, 0.06) end
		if state=="pressed" then bg = Color.darken(base, 0.08) end
		if state=="disabled" then bg = Color.mix(base, c.surface, 0.55) end
		return { bg=bg, text=c.onPrimary, stroke=Color.darken(bg, 0.25) }
	elseif variant == "ghost" then
		local base = c.surface
		local bg = base
		if state=="hover" then bg = Color.lighten(base, 0.04) end
		if state=="pressed" then bg = Color.darken(base, 0.05) end
		if state=="disabled" then bg = Color.mix(base, c.bg, 0.5) end
		return { bg=bg, text=c.text, stroke=c.border }
	else -- secondary
		local base = c.surfaceElevated
		local bg = base
		if state=="hover" then bg = Color.lighten(base, 0.04) end
		if state=="pressed" then bg = Color.darken(base, 0.06) end
		if state=="disabled" then bg = Color.mix(base, c.bg, 0.55) end
		return { bg=bg, text=c.text, stroke=c.border }
	end
end
local function applyCommonProps(inst, props)
	for k,v in pairs(props or {}) do
		if k~="Variant" and k~="Size" and k~="Disabled" and k~="AnchorPoint" and k~="Position" and k~="Text" and k~="Corner" then
			pcall(function() inst[k] = v end)
		end
	end
end
function Button.new(parent, props)
	props = props or {}
	local th = ThemeProvider.getTheme()

	local sizeTok = toSizeToken(props.Size or "md")
	local sz = sizesBtn[sizeTok] or sizesBtn.md
	local variant = props.Variant or "Primary"

	local btn = Instance.new("TextButton")
	btn.Name = props.Name or "Button"
	btn.AutoButtonColor = false
	btn.Selectable = true
	btn.BackgroundColor3 = computeStyle(th, variant, "default").bg
	btn.TextColor3 = computeStyle(th, variant, "default").text
	btn.Font = th.typography.fontSemi or th.typography.font
	btn.TextSize = sz.text
	btn.Text = props.Text or "Button"
	btn.RichText = true
	btn.BorderSizePixel = 0
	btn.Size = UDim2.new(0,0,0, sz.height)
	btn.AutomaticSize = Enum.AutomaticSize.X
	btn.AnchorPoint = props.AnchorPoint or Vector2.new(0,0)
	btn.Position = props.Position or UDim2.new(0,0,0,0)
	btn.Parent = parent

	local corner = Instance.new("UICorner")
	corner.CornerRadius = props.Corner or th.radii.md
	corner.Parent = btn

	local stroke = Instance.new("UIStroke")
	stroke.Thickness = 1
	stroke.Color = computeStyle(th, variant, "default").stroke
	stroke.Parent = btn

	local focusStroke = Instance.new("UIStroke")
	focusStroke.Thickness = 2
	focusStroke.Color = th.colors.focus
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

	local signals = { Activated = Signal.new() }
	local state = { hover=false, pressed=false, disabled=props.Disabled or false, variant=variant, sizeTok=sizeTok }

	local function targetStateName()
		if state.disabled then return "disabled" end
		if state.pressed then return "pressed" end
		if state.hover then return "hover" end
		return "default"
	end

	local function restyle(animated)
		local style = computeStyle(th, state.variant, targetStateName())
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

	btn.MouseEnter:Connect(function() state.hover=true restyle(true) end)
	btn.MouseLeave:Connect(function() state.hover=false state.pressed=false pressScale(1) restyle(true) end)
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

	btn.SelectionGained:Connect(function() Animator.tween(focusStroke, 0.1, { Transparency = 0 }) end)
	btn.SelectionLost:Connect(function() Animator.tween(focusStroke, 0.1, { Transparency = 1 }) end)

	local themeConn = ThemeProvider.onChanged(function(newTh)
		th = newTh
		corner.CornerRadius = props.Corner or th.radii.md
		focusStroke.Color = th.colors.focus
		btn.Font = th.typography.fontSemi or th.typography.font
		restyle(false)
	end)

	local api = {}
	api.Instance = btn
	function api:on(ev, cb)
		local s = signals[ev]
		if not s then error("Unknown Button event: " .. tostring(ev)) end
		return s:Connect(cb)
	end
	function api:setText(t) btn.Text = t end
	function api:setDisabled(d) state.disabled = d and true or false restyle(true) end
	function api:setVariant(v) state.variant = v or state.variant restyle(true) end
	function api:Destroy()
		for _,s in pairs(signals) do s:Destroy() end
		if themeConn then themeConn:Disconnect() end
		btn:Destroy()
	end

	restyle(false)
	return api
end

-- Public API (like init.lua)
local LumaUI = {}
function LumaUI.setTheme(nameOrTokens) ThemeProvider.setTheme(nameOrTokens) end
function LumaUI.getTheme() return ThemeProvider.getTheme() end
function LumaUI.onThemeChanged(cb) return ThemeProvider.onChanged(cb) end

function LumaUI.createScreenGui(name, parent)
	local pg = parent
	if not pg then
		local player = Players.LocalPlayer
		if player then pg = player:WaitForChild("PlayerGui") end
	end
	local gui = Instance.new("ScreenGui")
	gui.Name = name or "LumaUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = pg or game:GetService("CoreGui")
	return gui
end

LumaUI.Surface = Surface
LumaUI.Text = Text
LumaUI.Stack = Stack
LumaUI.Button = Button
LumaUI.Theme = Theme
LumaUI.ThemeProvider = ThemeProvider

return LumaUI