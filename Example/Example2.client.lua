-- LumaUI Side-Nav Beautiful GUI (Executor)
-- Load: loadstring(game:HttpGet("https://raw.githubusercontent.com/kiruwfh/LumaUI/main/Example/Example2.client.lua"))()

local LumaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kiruwfh/LumaUI/main/LumaUI.lua"))()
local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")

-- Root GUI
local gui = Instance.new("ScreenGui")
gui.Name = "LumaUI_SideNav"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

-- Draggable container
local windowFrame = Instance.new("Frame")
windowFrame.Name = "Window"
windowFrame.Size = UDim2.fromOffset(760, 480)
windowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
windowFrame.BackgroundTransparency = 1
windowFrame.Parent = gui

-- Drag logic
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
    local delta = input.Position - dragStart
    windowFrame.Position = UDim2.new(
        startPos.X.Scale, startPos.X.Offset + delta.X,
        startPos.Y.Scale, startPos.Y.Offset + delta.Y
    )
end

-- Main Surface
local root = LumaUI.Surface.new(windowFrame, {
    Name = "Root",
    Size = UDim2.fromScale(1, 1),
    Variant = "Elevated",
    Padding = 0
})

-- Header (draggable area)
local header = Instance.new("Frame")
header.Name = "Header"
header.BackgroundColor3 = LumaUI.getTheme().colors.primary
header.BorderSizePixel = 0
header.Size = UDim2.new(1, 0, 0, 56)
header.Parent = root.Instance

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = header

header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = windowFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        updateDrag(input)
    end
end)

local headerPad = Instance.new("UIPadding")
headerPad.PaddingLeft = UDim.new(0, 16)
headerPad.PaddingRight = UDim.new(0, 16)
headerPad.PaddingTop = UDim.new(0, 10)
headerPad.PaddingBottom = UDim.new(0, 10)
headerPad.Parent = header

local headerRow = Instance.new("UIListLayout")
headerRow.FillDirection = Enum.FillDirection.Horizontal
headerRow.HorizontalAlignment = Enum.HorizontalAlignment.Left
headerRow.VerticalAlignment = Enum.VerticalAlignment.Center
headerRow.Padding = UDim.new(0, 12)
headerRow.Parent = header

local title = Instance.new("TextLabel")
title.BackgroundTransparency = 1
title.Size = UDim2.new(0, 260, 1, 0)
title.Font = Enum.Font.GothamBold
title.Text = "LumaUI — Control Center"
title.TextSize = 20
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextXAlignment = Enum.TextXAlignment.Left
title.Parent = header

local version = Instance.new("TextLabel")
version.BackgroundTransparency = 1
version.Size = UDim2.new(0, 100, 1, 0)
version.Font = Enum.Font.Gotham
version.Text = "v0.1.0"
version.TextSize = 13
version.TextColor3 = Color3.fromRGB(220, 220, 255)
version.TextXAlignment = Enum.TextXAlignment.Left
version.Parent = header

-- Close button
local headerRight = Instance.new("Frame")
headerRight.BackgroundTransparency = 1
headerRight.Size = UDim2.new(1, -420, 1, 0)
headerRight.Parent = header

local headerRightLayout = Instance.new("UIListLayout")
headerRightLayout.FillDirection = Enum.FillDirection.Horizontal
headerRightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
headerRightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
headerRightLayout.Parent = headerRight

local closeBtn = LumaUI.Button.new(headerRight, { Text = "✕", Variant = "Danger", Size = "sm" })
closeBtn:on("Activated", function()
    gui:Destroy()
end)

-- Left nav surface
local nav = LumaUI.Surface.new(root.Instance, {
    Name = "Nav",
    Size = UDim2.new(0, 180, 1, -56),
    Position = UDim2.new(0, 0, 0, 56),
    Variant = "Ghost",
    Padding = 12
})

local navCol = LumaUI.Stack.new(nav.Instance, {
    Direction = "Vertical",
    Spacing = 8,
    AutoSize = true,
    Size = UDim2.new(1, 0, 0, 0)
})

LumaUI.Text.new(navCol.Instance, {
    Text = "<b>Navigation</b>",
    SizeToken = "sm",
    AutoSize = true
})

local tabs = { "Home", "Utilities", "Theme", "About" }
local tabButtons = {}
local activeTab = "Home"

-- Content area
local content = Instance.new("Frame")
content.Name = "Content"
content.Size = UDim2.new(1, -180, 1, -56)
content.Position = UDim2.new(0, 180, 0, 56)
content.BackgroundTransparency = 1
content.Parent = root.Instance

-- Tab containers
local containers = {}
for _, name in ipairs(tabs) do
    local f = Instance.new("Frame")
    f.Name = name
    f.BackgroundTransparency = 1
    f.Size = UDim2.new(1, 0, 1, 0)
    f.Visible = (name == activeTab)
    f.Parent = content
    containers[name] = f
end

-- Helpers
local function setActiveTab(name)
    activeTab = name
    for t, btn in pairs(tabButtons) do
        btn:setVariant(t == name and "Primary" or "Ghost")
    end
    for t, frame in pairs(containers) do
        frame.Visible = (t == name)
    end
end

-- Build nav buttons
for _, name in ipairs(tabs) do
    local btn = LumaUI.Button.new(navCol.Instance, {
        Text = name,
        Variant = (name == activeTab) and "Primary" or "Ghost",
        Size = "md",
    })
    tabButtons[name] = btn
    btn:on("Activated", function()
        setActiveTab(name)
    end)
end

-- HOME TAB
do
    local holder = containers["Home"]
    local col = LumaUI.Stack.new(holder, {
        Direction = "Vertical",
        Spacing = 14,
        AutoSize = true,
        Size = UDim2.new(1, -20, 0, 0)
    })

    LumaUI.Text.new(col.Instance, {
        Text = "<b>Welcome!</b>",
        SizeToken = "lg",
        AutoSize = true
    })

    local row = LumaUI.Stack.new(col.Instance, {
        Direction = "Horizontal",
        Spacing = 12,
        AutoSize = true
    })

    local card1 = LumaUI.Surface.new(row.Instance, { Size = UDim2.fromOffset(220, 100), Variant = "Elevated", Padding = 12 })
    LumaUI.Text.new(card1.Instance, { Text = "👤 Player\n"..Players.LocalPlayer.Name, AutoSize = false, Size = UDim2.new(1, 0, 1, 0), TextYAlignment = Enum.TextYAlignment.Center })

    local card2 = LumaUI.Surface.new(row.Instance, { Size = UDim2.fromOffset(220, 100), Variant = "Elevated", Padding = 12 })
    LumaUI.Text.new(card2.Instance, { Text = "⭐ UserId\n"..Players.LocalPlayer.UserId, AutoSize = false, Size = UDim2.new(1, 0, 1, 0), TextYAlignment = Enum.TextYAlignment.Center })

    local actions = LumaUI.Stack.new(col.Instance, { Direction = "Horizontal", Spacing = 8, AutoSize = true })
    local b1 = LumaUI.Button.new(actions.Instance, { Text = "Dark Mode", Variant = "Secondary" })
    b1:on("Activated", function() LumaUI.setTheme("dark"); header.BackgroundColor3 = LumaUI.getTheme().colors.primary end)

    local b2 = LumaUI.Button.new(actions.Instance, { Text = "Light Mode", Variant = "Secondary" })
    b2:on("Activated", function() LumaUI.setTheme("light"); header.BackgroundColor3 = LumaUI.getTheme().colors.primary end)
end

-- UTILITIES TAB
do
    local holder = containers["Utilities"]
    local col = LumaUI.Stack.new(holder, {
        Direction = "Vertical",
        Spacing = 14,
        AutoSize = true,
        Size = UDim2.new(1, -20, 0, 0)
    })

    LumaUI.Text.new(col.Instance, { Text = "<b>Utilities</b>", SizeToken = "lg", AutoSize = true })

    local row = LumaUI.Stack.new(col.Instance, { Direction = "Horizontal", Spacing = 8, AutoSize = true })

    local u1 = LumaUI.Button.new(row.Instance, { Text = "ESP (mock)", Variant = "Primary" })
    u1:on("Activated", function() print("[LumaUI] ESP toggled (mock)") end)

    local u2 = LumaUI.Button.new(row.Instance, { Text = "Fly (mock)", Variant = "Secondary" })
    u2:on("Activated", function() print("[LumaUI] Fly toggled (mock)") end)

    local u3 = LumaUI.Button.new(row.Instance, { Text = "Speed++ (mock)", Variant = "Ghost" })
    u3:on("Activated", function() print("[LumaUI] Speed boosted (mock)") end)

    local counterCard = LumaUI.Surface.new(col.Instance, { Size = UDim2.fromOffset(280, 110), Variant = "Elevated", Padding = 12 })
    local counterCol = LumaUI.Stack.new(counterCard.Instance, { Direction = "Vertical", Spacing = 8, AutoSize = true })
    local counterText = LumaUI.Text.new(counterCol.Instance, { Text = "Counter: 0", SizeToken = "lg", AutoSize = true })
    local ctrRow = LumaUI.Stack.new(counterCol.Instance, { Direction = "Horizontal", Spacing = 8, AutoSize = true })

    local counter = 0
    LumaUI.Button.new(ctrRow.Instance, { Text = "−", Variant = "Secondary", Size = "lg" }):on("Activated", function()
        counter -= 1; counterText.Instance.Text = "Counter: "..counter
    end)
    LumaUI.Button.new(ctrRow.Instance, { Text = "Reset", Variant = "Ghost" }):on("Activated", function()
        counter = 0; counterText.Instance.Text = "Counter: 0"
    end)
    LumaUI.Button.new(ctrRow.Instance, { Text = "+", Variant = "Primary", Size = "lg" }):on("Activated", function()
        counter += 1; counterText.Instance.Text = "Counter: "..counter
    end)
end

-- THEME TAB
do
    local holder = containers["Theme"]
    local col = LumaUI.Stack.new(holder, {
        Direction = "Vertical",
        Spacing = 14,
        AutoSize = true,
        Size = UDim2.new(1, -20, 0, 0)
    })

    LumaUI.Text.new(col.Instance, { Text = "<b>Theme</b>", SizeToken = "lg", AutoSize = true })

    local row = LumaUI.Stack.new(col.Instance, { Direction = "Horizontal", Spacing = 8, AutoSize = true })
    local light = LumaUI.Button.new(row.Instance, { Text = "☀ Light", Variant = "Secondary" })
    local dark = LumaUI.Button.new(row.Instance, { Text = "🌙 Dark", Variant = "Secondary" })

    light:on("Activated", function()
        LumaUI.setTheme("light")
        header.BackgroundColor3 = LumaUI.getTheme().colors.primary
    end)
    dark:on("Activated", function()
        LumaUI.setTheme("dark")
        header.BackgroundColor3 = LumaUI.getTheme().colors.primary
    end)
end

-- ABOUT TAB
do
    local holder = containers["About"]
    local col = LumaUI.Stack.new(holder, {
        Direction = "Vertical",
        Spacing = 12,
        AutoSize = true,
        Size = UDim2.new(1, -20, 0, 0)
    })

    LumaUI.Text.new(col.Instance, { Text = "<b>About LumaUI</b>", SizeToken = "lg", AutoSize = true })
    LumaUI.Text.new(col.Instance, {
        Text = "Minimal, clean UI primitives for Roblox. Components: Button, Surface, Text, Stack. Theme: Light/Dark.",
        SizeToken = "sm", AutoSize = true
    })
    LumaUI.Text.new(col.Instance, {
        Text = "Made with ❤️. Press RightShift to hide/show window.",
        SizeToken = "sm", AutoSize = true
    })
end

-- Toggle visibility: RightShift
UserInputService.InputBegan:Connect(function(input, gp)
    if not gp and input.KeyCode == Enum.KeyCode.RightShift then
        windowFrame.Visible = not windowFrame.Visible
    end
end)

print("✨ LumaUI Side-Nav GUI loaded! Use the left menu to navigate.")