-- LumaUI Full Demo for Executor
-- Draggable window with all components showcase
-- Load: loadstring(game:HttpGet("https://raw.githubusercontent.com/kiruwfh/LumaUI/main/Example/FullDemo.lua"))()

local LumaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kiruwfh/LumaUI/main/LumaUI.lua"))()

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "LumaUIDemo"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

-- Main window container (draggable)
local windowFrame = Instance.new("Frame")
windowFrame.Name = "Window"
windowFrame.Size = UDim2.fromOffset(500, 600)
windowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
windowFrame.BackgroundTransparency = 1
windowFrame.Parent = gui

-- Draggable logic
local dragging, dragInput, dragStart, startPos
local function update(input)
	local delta = input.Position - dragStart
	windowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end
windowFrame.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = windowFrame.Position
		input.Changed:Connect(function()
			if input.UserInputState == Enum.UserInputState.End then dragging = false end
		end)
	end
end)
windowFrame.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
	if input == dragInput and dragging then update(input) end
end)

-- Main card surface
local card = LumaUI.Surface.new(windowFrame, {
	Name = "MainCard",
	Size = UDim2.new(1, 0, 1, 0),
	Variant = "Elevated",
	Padding = 20,
})

-- Main vertical stack
local mainColumn = LumaUI.Stack.new(card.Instance, {
	Name = "MainColumn",
	Direction = "Vertical",
	Spacing = 16,
	AutoSize = true,
	Size = UDim2.new(1, 0, 0, 0),
})

-- Header with title and close button
local headerRow = LumaUI.Stack.new(mainColumn.Instance, {
	Name = "Header",
	Direction = "Horizontal",
	Spacing = 8,
	Size = UDim2.new(1, 0, 0, 32),
})

local titleSurface = LumaUI.Surface.new(headerRow.Instance, {
	Name = "TitleBg",
	Size = UDim2.new(1, -40, 1, 0),
	Variant = "Ghost",
	Padding = 8,
})

LumaUI.Text.new(titleSurface.Instance, {
	Text = "<b>LumaUI</b> — Complete Demo",
	SizeToken = "lg",
	AutoSize = false,
	Size = UDim2.new(1, 0, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Left,
	TextYAlignment = Enum.TextYAlignment.Center,
})

local closeBtn = LumaUI.Button.new(headerRow.Instance, {
	Text = "✕",
	Variant = "Danger",
	Size = "sm",
})
closeBtn:on("Activated", function()
	gui:Destroy()
end)

-- Section 1: Button Variants
LumaUI.Text.new(mainColumn.Instance, {
	Text = "<b>Button Variants</b>",
	SizeToken = "md",
	AutoSize = true,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local buttonRow = LumaUI.Stack.new(mainColumn.Instance, {
	Name = "ButtonRow",
	Direction = "Horizontal",
	Spacing = 8,
	AutoSize = true,
})

local btnPrimary = LumaUI.Button.new(buttonRow.Instance, {
	Text = "Primary",
	Variant = "Primary",
	Size = "md",
})
btnPrimary:on("Activated", function()
	print("Primary clicked!")
end)

local btnSecondary = LumaUI.Button.new(buttonRow.Instance, {
	Text = "Secondary",
	Variant = "Secondary",
	Size = "md",
})
btnSecondary:on("Activated", function()
	print("Secondary clicked!")
end)

local btnGhost = LumaUI.Button.new(buttonRow.Instance, {
	Text = "Ghost",
	Variant = "Ghost",
	Size = "md",
})
btnGhost:on("Activated", function()
	print("Ghost clicked!")
end)

local btnDanger = LumaUI.Button.new(buttonRow.Instance, {
	Text = "Danger",
	Variant = "Danger",
	Size = "md",
})
btnDanger:on("Activated", function()
	print("Danger clicked!")
end)

-- Section 2: Button Sizes
LumaUI.Text.new(mainColumn.Instance, {
	Text = "<b>Button Sizes</b>",
	SizeToken = "md",
	AutoSize = true,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local sizeRow = LumaUI.Stack.new(mainColumn.Instance, {
	Name = "SizeRow",
	Direction = "Horizontal",
	Spacing = 8,
	AutoSize = true,
})

LumaUI.Button.new(sizeRow.Instance, {
	Text = "Small",
	Variant = "Primary",
	Size = "sm",
})

LumaUI.Button.new(sizeRow.Instance, {
	Text = "Medium",
	Variant = "Primary",
	Size = "md",
})

LumaUI.Button.new(sizeRow.Instance, {
	Text = "Large",
	Variant = "Primary",
	Size = "lg",
})

-- Section 3: Theme Switcher
LumaUI.Text.new(mainColumn.Instance, {
	Text = "<b>Theme Switcher</b>",
	SizeToken = "md",
	AutoSize = true,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local themeRow = LumaUI.Stack.new(mainColumn.Instance, {
	Name = "ThemeRow",
	Direction = "Horizontal",
	Spacing = 8,
	AutoSize = true,
})

local btnLight = LumaUI.Button.new(themeRow.Instance, {
	Text = "☀ Light Mode",
	Variant = "Secondary",
	Size = "md",
})
btnLight:on("Activated", function()
	LumaUI.setTheme("light")
	print("Switched to Light theme")
end)

local btnDark = LumaUI.Button.new(themeRow.Instance, {
	Text = "🌙 Dark Mode",
	Variant = "Secondary",
	Size = "md",
})
btnDark:on("Activated", function()
	LumaUI.setTheme("dark")
	print("Switched to Dark theme")
end)

-- Section 4: Surface Variants
LumaUI.Text.new(mainColumn.Instance, {
	Text = "<b>Surface Variants</b>",
	SizeToken = "md",
	AutoSize = true,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local surfaceRow = LumaUI.Stack.new(mainColumn.Instance, {
	Name = "SurfaceRow",
	Direction = "Horizontal",
	Spacing = 12,
	AutoSize = true,
})

local surface1 = LumaUI.Surface.new(surfaceRow.Instance, {
	Name = "Surface1",
	Size = UDim2.fromOffset(140, 80),
	Variant = "Default",
	Padding = 12,
})
LumaUI.Text.new(surface1.Instance, {
	Text = "Default\nSurface",
	AutoSize = false,
	Size = UDim2.new(1, 0, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Center,
	TextYAlignment = Enum.TextYAlignment.Center,
})

local surface2 = LumaUI.Surface.new(surfaceRow.Instance, {
	Name = "Surface2",
	Size = UDim2.fromOffset(140, 80),
	Variant = "Elevated",
	Padding = 12,
})
LumaUI.Text.new(surface2.Instance, {
	Text = "Elevated\nSurface",
	AutoSize = false,
	Size = UDim2.new(1, 0, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Center,
	TextYAlignment = Enum.TextYAlignment.Center,
})

local surface3 = LumaUI.Surface.new(surfaceRow.Instance, {
	Name = "Surface3",
	Size = UDim2.fromOffset(140, 80),
	Variant = "Ghost",
	Padding = 12,
})
LumaUI.Text.new(surface3.Instance, {
	Text = "Ghost\nSurface",
	AutoSize = false,
	Size = UDim2.new(1, 0, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Center,
	TextYAlignment = Enum.TextYAlignment.Center,
})

-- Section 5: Interactive Demo
LumaUI.Text.new(mainColumn.Instance, {
	Text = "<b>Interactive Demo</b>",
	SizeToken = "md",
	AutoSize = true,
	TextXAlignment = Enum.TextXAlignment.Left,
})

local demoCard = LumaUI.Surface.new(mainColumn.Instance, {
	Name = "DemoCard",
	Size = UDim2.new(1, 0, 0, 120),
	Variant = "Elevated",
	Padding = 16,
})

local demoColumn = LumaUI.Stack.new(demoCard.Instance, {
	Name = "DemoColumn",
	Direction = "Vertical",
	Spacing = 12,
	AutoSize = true,
	Size = UDim2.new(1, 0, 0, 0),
})

local counterText = LumaUI.Text.new(demoColumn.Instance, {
	Text = "Counter: 0",
	SizeToken = "lg",
	AutoSize = true,
	TextXAlignment = Enum.TextXAlignment.Center,
})

local counterRow = LumaUI.Stack.new(demoColumn.Instance, {
	Name = "CounterRow",
	Direction = "Horizontal",
	Spacing = 8,
	AutoSize = true,
})

local counter = 0
local decrementBtn = LumaUI.Button.new(counterRow.Instance, {
	Text = "−",
	Variant = "Secondary",
	Size = "lg",
})
decrementBtn:on("Activated", function()
	counter = counter - 1
	counterText.Instance.Text = "Counter: " .. counter
end)

local resetBtn = LumaUI.Button.new(counterRow.Instance, {
	Text = "Reset",
	Variant = "Ghost",
	Size = "md",
})
resetBtn:on("Activated", function()
	counter = 0
	counterText.Instance.Text = "Counter: " .. counter
end)

local incrementBtn = LumaUI.Button.new(counterRow.Instance, {
	Text = "+",
	Variant = "Primary",
	Size = "lg",
})
incrementBtn:on("Activated", function()
	counter = counter + 1
	counterText.Instance.Text = "Counter: " .. counter
end)

-- Footer
local footer = LumaUI.Surface.new(mainColumn.Instance, {
	Name = "Footer",
	Size = UDim2.new(1, 0, 0, 40),
	Variant = "Ghost",
	Padding = 10,
})

LumaUI.Text.new(footer.Instance, {
	Text = "💜 LumaUI v0.1.0 | Drag window to move | Made with ❤️",
	SizeToken = "sm",
	AutoSize = false,
	Size = UDim2.new(1, 0, 1, 0),
	TextXAlignment = Enum.TextXAlignment.Center,
	TextYAlignment = Enum.TextYAlignment.Center,
})

print("✓ LumaUI Full Demo loaded! Drag window to move, click ✕ to close")
