local Signal = require(script.Parent.Parent.Core.Signal)
local Theme = require(script.Parent.Theme)

local ThemeProvider = {}

local _current = Theme.get("light")
local _changed = Signal.new()

function ThemeProvider.setTheme(nameOrTokens)
	local t = nil
	if typeof(nameOrTokens) == "string" then
		t = Theme.get(nameOrTokens)
	elseif typeof(nameOrTokens) == "table" then
		-- merge with light as base to ensure required fields
		t = Theme.merge(Theme.get("light"), nameOrTokens)
	else
		warn("ThemeProvider.setTheme expects string or table; falling back to light")
		t = Theme.get("light")
	end
	_current = t
	_changed:Fire(_current)
end

function ThemeProvider.getTheme()
	return _current
end

function ThemeProvider.onChanged(cb)
	return _changed:Connect(cb)
end

return ThemeProvider
