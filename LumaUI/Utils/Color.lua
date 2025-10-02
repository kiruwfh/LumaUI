local Color = {}

local function clamp01(n)
	if n < 0 then return 0 elseif n > 1 then return 1 else return n end
end

function Color.lighten(c, amount)
	amount = clamp01(amount or 0.1)
	return c:Lerp(Color3.new(1,1,1), amount)
end

function Color.darken(c, amount)
	amount = clamp01(amount or 0.1)
	return c:Lerp(Color3.new(0,0,0), amount)
end

function Color.mix(a, b, t)
	return a:Lerp(b, clamp01(t or 0.5))
end

local function srgbToLinear(x)
	if x <= 0.04045 then return x/12.92 end
	return ((x + 0.055)/1.055) ^ 2.4
end

function Color.luminance(c)
	local r = srgbToLinear(c.R)
	local g = srgbToLinear(c.G)
	local b = srgbToLinear(c.B)
	return 0.2126*r + 0.7152*g + 0.0722*b
end

function Color.contrastColor(bg)
	-- Simple heuristic: choose black or white for best contrast
	local lum = Color.luminance(bg)
	if lum > 0.5 then
		return Color3.new(0,0,0)
	else
		return Color3.new(1,1,1)
	end
end

return Color
