-- Example usage for LumaUI
-- Place this LocalScript under StarterPlayer/StarterPlayerScripts
-- Ensure the LumaUI folder is under ReplicatedStorage

local ReplicatedStorage = game:GetService("ReplicatedStorage")

-- Try to load LumaUI from GitHub raw first, fallback to local ReplicatedStorage
local function loadLumaUI()
    local urls = {
        "https://raw.githubusercontent.com/kiruwfh/LumaUI/main/LumaUI.lua",
        "https://raw.githubusercontent.com/kiruwfh/LumaUI/refs/heads/main/LumaUI.lua",
    }
    for _, u in ipairs(urls) do
        local ok, lib = pcall(function()
            local src = game:HttpGet(u)
            local fn = loadstring(src)
            return fn()
        end)
        if ok and lib then return lib end
    end
    -- Fallback to local module
    local ok, lib = pcall(function()
        return require(ReplicatedStorage:WaitForChild("LumaUI"))
    end)
    if ok and lib then return lib end
    error("LumaUI not found (remote and local fallback failed)")
end

local LumaUI = loadLumaUI()

local gui = LumaUI.createScreenGui("LumaDemo")

-- Card surface in the center
local card = LumaUI.Surface.new(gui, {
	Name = "Card",
	Size = UDim2.fromOffset(420, 260),
	AnchorPoint = Vector2.new(0.5, 0.5),
	Position = UDim2.fromScale(0.5, 0.5),
	Variant = "Elevated",
	Padding = 16,
})

-- Vertical stack
local column = LumaUI.Stack.new(card.Instance, {
	Name = "Column",
	Direction = "Vertical",
	Spacing = 12,
	AutoSize = true,
	Size = UDim2.new(1, 0, 0, 0),
})

LumaUI.Text.new(column.Instance, {
	Text = "LumaUI — Demo",
	SizeToken = "lg",
	AutoSize = true,
	TextXAlignment = Enum.TextXAlignment.Left,
})

LumaUI.Text.new(column.Instance, {
	Text = "Buttons (variants & sizes):",
	SizeToken = "sm",
	AutoSize = true,
	TextColor3 = Color3.fromRGB(120, 125, 140),
	TextXAlignment = Enum.TextXAlignment.Left,
})

-- Row of buttons
local row1 = LumaUI.Stack.new(column.Instance, {
	Name = "Row1",
	Direction = "Horizontal",
	Spacing = 8,
	AutoSize = true,
})

local p = LumaUI.Button.new(row1.Instance, { Text = "Primary", Variant = "Primary", Size = "Md" })
local s = LumaUI.Button.new(row1.Instance, { Text = "Secondary", Variant = "Secondary", Size = "Md" })
local g = LumaUI.Button.new(row1.Instance, { Text = "Ghost", Variant = "Ghost", Size = "Md" })
local d = LumaUI.Button.new(row1.Instance, { Text = "Danger", Variant = "Danger", Size = "Md" })

p:on("Activated", function()
	print("Primary clicked")
end)

s:on("Activated", function()
	print("Secondary clicked")
end)

g:on("Activated", function()
	print("Ghost clicked")
end)

d:on("Activated", function()
	print("Danger clicked")
end)

-- Dark/Light toggle
LumaUI.Text.new(column.Instance, {
	Text = "Theme:",
	SizeToken = "sm",
	AutoSize = true,
	TextColor3 = Color3.fromRGB(120, 125, 140),
	TextXAlignment = Enum.TextXAlignment.Left,
})

local row2 = LumaUI.Stack.new(column.Instance, {
	Name = "Row2",
	Direction = "Horizontal",
	Spacing = 8,
	AutoSize = true,
})

local bLight = LumaUI.Button.new(row2.Instance, { Text = "Light", Variant = "Secondary" })
local bDark = LumaUI.Button.new(row2.Instance, { Text = "Dark", Variant = "Secondary" })

bLight:on("Activated", function()
	LumaUI.setTheme("light")
end)

bDark:on("Activated", function()
	LumaUI.setTheme("dark")
end)

-- Footer text
local footer = LumaUI.Text.new(column.Instance, {
	Text = "Tip: Try hovering, pressing, and switching themes.",
	SizeToken = "sm",
	AutoSize = true,
	TextXAlignment = Enum.TextXAlignment.Left,
})
