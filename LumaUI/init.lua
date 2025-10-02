local Theme = require(script.Theme.Theme)
local ThemeProvider = require(script.Theme.ThemeProvider)

local Button = require(script.Components.Button)
local Surface = require(script.Primitives.Surface)
local TextPrimitive = require(script.Primitives.Text)
local Stack = require(script.Primitives.Stack)

local Players = game:GetService("Players")

local LumaUI = {}

-- Theme controls
function LumaUI.setTheme(nameOrTokens)
	ThemeProvider.setTheme(nameOrTokens)
end

function LumaUI.getTheme()
	return ThemeProvider.getTheme()
end

function LumaUI.onThemeChanged(callback)
	return ThemeProvider.onChanged(callback)
end

-- ScreenGui helper
function LumaUI.createScreenGui(name, parent)
	local pg = parent
	if not pg then
		local player = Players.LocalPlayer
		if player then
			pg = player:WaitForChild("PlayerGui")
		end
	end

	local gui = Instance.new("ScreenGui")
	gui.Name = name or "LumaUI"
	gui.ResetOnSpawn = false
	gui.IgnoreGuiInset = false
	gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	gui.Parent = pg or game:GetService("CoreGui")
	return gui
end

-- Expose modules
LumaUI.Theme = Theme
LumaUI.ThemeProvider = ThemeProvider
LumaUI.Button = Button
LumaUI.Surface = Surface
LumaUI.Text = TextPrimitive
LumaUI.Stack = Stack

return LumaUI
