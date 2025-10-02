local Color = require(script.Parent.Parent.Utils.Color)

local Theme = {}

local function tokensLight()
	local primary = Color3.fromRGB(138, 92, 246) -- purple
	local primaryHover = Color.lighten(primary, 0.08)
	local primaryPressed = Color.darken(primary, 0.08)

	local surface = Color3.fromRGB(252, 252, 255)
	local surfaceElevated = Color3.fromRGB(244, 245, 250)
	local bg = Color3.fromRGB(245, 246, 250)
	local border = Color3.fromRGB(225, 228, 238)
	local text = Color3.fromRGB(20, 22, 26)
	local subtext = Color3.fromRGB(94, 98, 110)
	local danger = Color3.fromRGB(235, 87, 87)

	return {
		name = "light",
		colors = {
			primary = primary,
			primaryHover = primaryHover,
			primaryPressed = primaryPressed,
			bg = bg,
			surface = surface,
			surfaceElevated = surfaceElevated,
			border = border,
			text = text,
			subtext = subtext,
			danger = danger,
			onPrimary = Color.contrastColor(primary),
			onSurface = Color.contrastColor(surface),
			focus = Color3.fromRGB(85, 204, 255),
		},
		radii = {
			xs = UDim.new(0, 4),
			sm = UDim.new(0, 6),
			md = UDim.new(0, 8),
			lg = UDim.new(0, 12),
			pill = UDim.new(1, 0),
		},
		spacing = { 4, 8, 12, 16, 24, 32 },
		typography = {
			font = Enum.Font.Gotham,
			fontSemi = Enum.Font.GothamSemibold,
			sizes = { sm = 14, md = 16, lg = 18 },
		},
	}
end

local function tokensDark()
	local primary = Color3.fromRGB(158, 117, 255)
	local primaryHover = Color.lighten(primary, 0.06)
	local primaryPressed = Color.darken(primary, 0.07)

	local surface = Color3.fromRGB(22, 24, 30)
	local surfaceElevated = Color3.fromRGB(28, 31, 38)
	local bg = Color3.fromRGB(16, 18, 24)
	local border = Color3.fromRGB(45, 49, 58)
	local text = Color3.fromRGB(235, 237, 243)
	local subtext = Color3.fromRGB(165, 170, 185)
	local danger = Color3.fromRGB(240, 85, 85)

	return {
		name = "dark",
		colors = {
			primary = primary,
			primaryHover = primaryHover,
			primaryPressed = primaryPressed,
			bg = bg,
			surface = surface,
			surfaceElevated = surfaceElevated,
			border = border,
			text = text,
			subtext = subtext,
			danger = danger,
			onPrimary = Color.contrastColor(primary),
			onSurface = Color.contrastColor(surface),
			focus = Color3.fromRGB(64, 170, 255),
		},
		radii = {
			xs = UDim.new(0, 4),
			sm = UDim.new(0, 6),
			md = UDim.new(0, 8),
			lg = UDim.new(0, 12),
			pill = UDim.new(1, 0),
		},
		spacing = { 4, 8, 12, 16, 24, 32 },
		typography = {
			font = Enum.Font.Gotham,
			fontSemi = Enum.Font.GothamSemibold,
			sizes = { sm = 14, md = 16, lg = 18 },
		},
	}
end

local function deepCopy(t)
	if type(t) ~= "table" then return t end
	local out = {}
	for k, v in pairs(t) do
		if type(v) == "table" then
			out[k] = deepCopy(v)
		else
			out[k] = v
		end
	end
	return out
end

function Theme.merge(base, override)
	local result = deepCopy(base or {})
	for k, v in pairs(override or {}) do
		if type(v) == "table" and type(result[k]) == "table" then
			result[k] = Theme.merge(result[k], v)
		else
			result[k] = v
		end
	end
	return result
end

function Theme.get(name)
	if name == "dark" then
		return tokensDark()
	end
	return tokensLight()
end

Theme.defaultLight = tokensLight()
Theme.defaultDark = tokensDark()

return Theme
