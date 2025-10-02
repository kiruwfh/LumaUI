-- LumaUI Beautiful Executor GUI
-- Modern interface with tabs, player stats, and smooth animations
-- Load: loadstring(game:HttpGet("https://raw.githubusercontent.com/kiruwfh/LumaUI/main/Example/Example.client.lua"))()

local LumaUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/kiruwfh/LumaUI/main/LumaUI.lua"))()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")

-- Create ScreenGui
local gui = Instance.new("ScreenGui")
gui.Name = "LumaExecutor"
gui.ResetOnSpawn = false
gui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
gui.Parent = game:GetService("CoreGui")

-- Window container (draggable)
local windowFrame = Instance.new("Frame")
windowFrame.Name = "MainWindow"
windowFrame.Size = UDim2.fromOffset(580, 420)
windowFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
windowFrame.AnchorPoint = Vector2.new(0.5, 0.5)
windowFrame.BackgroundTransparency = 1
windowFrame.Parent = gui

-- Draggable logic
local dragging, dragInput, dragStart, startPos
local function updateDrag(input)
	local delta = input.Position - dragStart
	windowFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

-- Main card
local mainCard = LumaUI.Surface.new(windowFrame, {
	Name = "MainCard",
	Size = UDim2.new(1, 0, 1, 0),
	Variant = "Elevated",
	Padding = 0,
})

-- Header area
local headerBg = Instance.new("Frame")
headerBg.Name = "HeaderBg"
headerBg.Size = UDim2.new(1, 0, 0, 60)
headerBg.BackgroundColor3 = LumaUI.getTheme().colors.primary
headerBg.BorderSizePixel = 0
headerBg.Parent = mainCard.Instance

local headerCorner = Instance.new("UICorner")
headerCorner.CornerRadius = UDim.new(0, 8)
headerCorner.Parent = headerBg

local headerMask = Instance.new("Frame")
headerMask.Size = UDim2.new(1, 0, 0, 30)
headerMask.Position = UDim2.new(0, 0, 1, -30)
headerMask.BackgroundColor3 = headerBg.BackgroundColor3
headerMask.BorderSizePixel = 0
headerMask.Parent = headerBg

-- Make header draggable
headerBg.InputBegan:Connect(function(input)
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
headerBg.InputChanged:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseMovement then
		dragInput = input
	end
end)
UserInputService.InputChanged:Connect(function(input)
	if input == dragInput and dragging then
		updateDrag(input)
	end
end)

-- Header content
local headerPadding = Instance.new("UIPadding")
headerPadding.PaddingLeft = UDim.new(0, 20)
headerPadding.PaddingRight = UDim.new(0, 20)
headerPadding.PaddingTop = UDim.new(0, 12)
headerPadding.PaddingBottom = UDim.new(0, 12)
headerPadding.Parent = headerBg

local headerLayout = Instance.new("UIListLayout")
headerLayout.FillDirection = Enum.FillDirection.Horizontal
headerLayout.HorizontalAlignment = Enum.HorizontalAlignment.Left
headerLayout.VerticalAlignment = Enum.VerticalAlignment.Center
headerLayout.Padding = UDim.new(0, 12)
headerLayout.Parent = headerBg

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(0, 200, 1, 0)
titleLabel.BackgroundTransparency = 1
titleLabel.Font = Enum.Font.GothamBold
titleLabel.Text = "⚡ LumaUI Executor"
titleLabel.TextColor3 = Color3.new(1, 1, 1)
titleLabel.TextSize = 20
titleLabel.TextXAlignment = Enum.TextXAlignment.Left
titleLabel.Parent = headerBg

local versionLabel = Instance.new("TextLabel")
versionLabel.Name = "Version"
versionLabel.Size = UDim2.new(0, 80, 0, 20)
versionLabel.BackgroundTransparency = 1
versionLabel.Font = Enum.Font.Gotham
versionLabel.Text = "v0.1.0"
versionLabel.TextColor3 = Color3.fromRGB(200, 200, 255)
versionLabel.TextSize = 12
versionLabel.TextXAlignment = Enum.TextXAlignment.Left
versionLabel.Parent = headerBg

-- Close button in header
local closeBtnFrame = Instance.new("Frame")
closeBtnFrame.Name = "CloseBtnContainer"
closeBtnFrame.Size = UDim2.new(1, -300, 1, 0)
closeBtnFrame.BackgroundTransparency = 1
closeBtnFrame.Parent = headerBg

local closeBtnLayout = Instance.new("UIListLayout")
closeBtnLayout.FillDirection = Enum.FillDirection.Horizontal
closeBtnLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
closeBtnLayout.VerticalAlignment = Enum.VerticalAlignment.Center
closeBtnLayout.Parent = closeBtnFrame

local minimizeBtn = LumaUI.Button.new(closeBtnFrame, {
	Text = "−",
	Variant = "Ghost",
	Size = "sm",
	TextColor3 = Color3.new(1, 1, 1),
})
minimizeBtn:on("Activated", function()
	windowFrame.Visible = false
	task.wait(0.1)
	windowFrame.Visible = true
end)

local closeBtn = LumaUI.Button.new(closeBtnFrame, {
	Text = "✕",
	Variant = "Danger",
	Size = "sm",
})
closeBtn:on("Activated", function()
	gui:Destroy()
end)

-- Content area
local contentFrame = Instance.new("Frame")
contentFrame.Name = "Content"
contentFrame.Size = UDim2.new(1, 0, 1, -60)
contentFrame.Position = UDim2.new(0, 0, 0, 60)
contentFrame.BackgroundTransparency = 1
contentFrame.Parent = mainCard.Instance

local contentPadding = Instance.new("UIPadding")
contentPadding.PaddingLeft = UDim.new(0, 20)
contentPadding.PaddingRight = UDim.new(0, 20)
contentPadding.PaddingTop = UDim.new(0, 16)
contentPadding.PaddingBottom = UDim.new(0, 16)
contentPadding.Parent = contentFrame

-- Tab system
local tabs = {"Dashboard", "Player", "Settings"}
local activeTab = "Dashboard"
local tabContents = {}

-- Tab buttons row
local tabRow = LumaUI.Stack.new(contentFrame, {
	Name = "TabRow",
	Direction = "Horizontal",
	Spacing = 8,
	Size = UDim2.new(1, 0, 0, 36),
})

local tabButtons = {}
for _, tabName in ipairs(tabs) do
	local btn = LumaUI.Button.new(tabRow.Instance, {
		Text = tabName,
		Variant = activeTab == tabName and "Primary" or "Ghost",
		Size = "md",
	})
	tabButtons[tabName] = btn
	btn:on("Activated", function()
		activeTab = tabName
		for name, b in pairs(tabButtons) do
			b:setVariant(name == tabName and "Primary" or "Ghost")
		end
		for name, content in pairs(tabContents) do
			content.Visible = (name == tabName)
		end
	end)
end

-- Tab content area
local tabContentArea = Instance.new("Frame")
tabContentArea.Name = "TabContent"
tabContentArea.Size = UDim2.new(1, 0, 1, -52)
tabContentArea.Position = UDim2.new(0, 0, 0, 52)
tabContentArea.BackgroundTransparency = 1
tabContentArea.Parent = contentFrame

-- Dashboard Tab
local dashboardTab = Instance.new("Frame")
dashboardTab.Name = "Dashboard"
dashboardTab.Size = UDim2.new(1, 0, 1, 0)
dashboardTab.BackgroundTransparency = 1
dashboardTab.Parent = tabContentArea
tabContents["Dashboard"] = dashboardTab

local dashColumn = LumaUI.Stack.new(dashboardTab, {
	Name = "DashColumn",
	Direction = "Vertical",
	Spacing = 16,
	AutoSize = true,
	Size = UDim2.new(1, 0, 0, 0),
})

LumaUI.Text.new(dashColumn.Instance, {
	Text = "<b>Welcome to LumaUI!</b>",
	SizeToken = "lg",
	AutoSize = true,
})

-- Stats cards row
local statsRow = LumaUI.Stack.new(dashColumn.Instance, {
	Name = "StatsRow",
	Direction = "Horizontal",
	Spacing = 12,
	AutoSize = true,
})

local function createStatCard(icon, label, value)
	local card = LumaUI.Surface.new(statsRow.Instance, {
		Name = label .. "Card",
		Size = UDim2.fromOffset(170, 80),
		Variant = "Elevated",
		Padding = 14,
	})
	local col = LumaUI.Stack.new(card.Instance, {
		Direction = "Vertical",
		Spacing = 6,
		AutoSize = true,
	})
	LumaUI.Text.new(col.Instance, {
		Text = icon .. " " .. label,
		SizeToken = "sm",
		AutoSize = true,
	})
	local valueText = LumaUI.Text.new(col.Instance, {
		Text = value,
		SizeToken = "lg",
		AutoSize = true,
	})
	return valueText
end

local fpsText = createStatCard("📊", "FPS", "60")
local pingText = createStatCard("📡", "Ping", "0ms")
local playersText = createStatCard("👥", "Players", tostring(#Players:GetPlayers()))

-- Update stats
RunService.RenderStepped:Connect(function()
	local fps = math.floor(1 / RunService.RenderStepped:Wait())
	fpsText.Instance.Text = tostring(fps)
end)

task.spawn(function()
	while task.wait(1) do
		local ping = Players.LocalPlayer:GetNetworkPing() * 1000
		pingText.Instance.Text = math.floor(ping) .. "ms"
		playersText.Instance.Text = tostring(#Players:GetPlayers())
	end
end)

-- Quick actions
LumaUI.Text.new(dashColumn.Instance, {
	Text = "<b>Quick Actions</b>",
	SizeToken = "md",
	AutoSize = true,
})

local actionsRow = LumaUI.Stack.new(dashColumn.Instance, {
	Name = "ActionsRow",
	Direction = "Horizontal",
	Spacing = 8,
	AutoSize = true,
})

local rejoinBtn = LumaUI.Button.new(actionsRow.Instance, {
	Text = "🔄 Rejoin",
	Variant = "Secondary",
})
rejoinBtn:on("Activated", function()
	game:GetService("TeleportService"):Teleport(game.PlaceId, Players.LocalPlayer)
end)

local copyIdBtn = LumaUI.Button.new(actionsRow.Instance, {
	Text = "📋 Copy Game ID",
	Variant = "Ghost",
})
copyIdBtn:on("Activated", function()
	setclipboard(tostring(game.PlaceId))
	print("Game ID copied!")
end)

-- Player Tab
local playerTab = Instance.new("Frame")
playerTab.Name = "Player"
playerTab.Size = UDim2.new(1, 0, 1, 0)
playerTab.BackgroundTransparency = 1
playerTab.Visible = false
playerTab.Parent = tabContentArea
tabContents["Player"] = playerTab

local playerColumn = LumaUI.Stack.new(playerTab, {
	Name = "PlayerColumn",
	Direction = "Vertical",
	Spacing = 16,
	AutoSize = true,
	Size = UDim2.new(1, 0, 0, 0),
})

local player = Players.LocalPlayer

LumaUI.Text.new(playerColumn.Instance, {
	Text = "<b>Player Information</b>",
	SizeToken = "lg",
	AutoSize = true,
})

local infoCard = LumaUI.Surface.new(playerColumn.Instance, {
	Name = "InfoCard",
	Size = UDim2.new(1, 0, 0, 160),
	Variant = "Elevated",
	Padding = 16,
})

local infoCol = LumaUI.Stack.new(infoCard.Instance, {
	Direction = "Vertical",
	Spacing = 10,
	AutoSize = true,
})

local function addInfo(label, value)
	local row = LumaUI.Stack.new(infoCol.Instance, {
		Direction = "Horizontal",
		Spacing = 8,
		AutoSize = true,
	})
	LumaUI.Text.new(row.Instance, {
		Text = label .. ":",
		SizeToken = "sm",
		AutoSize = true,
	})
	LumaUI.Text.new(row.Instance, {
		Text = value,
		SizeToken = "sm",
		AutoSize = true,
	})
end

addInfo("👤 Username", player.Name)
addInfo("🆔 User ID", tostring(player.UserId))
addInfo("📅 Account Age", player.AccountAge .. " days")
addInfo("⭐ Display Name", player.DisplayName)

-- Settings Tab
local settingsTab = Instance.new("Frame")
settingsTab.Name = "Settings"
settingsTab.Size = UDim2.new(1, 0, 1, 0)
settingsTab.BackgroundTransparency = 1
settingsTab.Visible = false
settingsTab.Parent = tabContentArea
tabContents["Settings"] = settingsTab

local settingsColumn = LumaUI.Stack.new(settingsTab, {
	Name = "SettingsColumn",
	Direction = "Vertical",
	Spacing = 16,
	AutoSize = true,
	Size = UDim2.new(1, 0, 0, 0),
})

LumaUI.Text.new(settingsColumn.Instance, {
	Text = "<b>Appearance</b>",
	SizeToken = "lg",
	AutoSize = true,
})

local themeCard = LumaUI.Surface.new(settingsColumn.Instance, {
	Name = "ThemeCard",
	Size = UDim2.new(1, 0, 0, 100),
	Variant = "Elevated",
	Padding = 16,
})

local themeCol = LumaUI.Stack.new(themeCard.Instance, {
	Direction = "Vertical",
	Spacing = 12,
	AutoSize = true,
})

LumaUI.Text.new(themeCol.Instance, {
	Text = "Theme Mode",
	SizeToken = "md",
	AutoSize = true,
})

local themeRow = LumaUI.Stack.new(themeCol.Instance, {
	Direction = "Horizontal",
	Spacing = 8,
	AutoSize = true,
})

local lightBtn = LumaUI.Button.new(themeRow.Instance, {
	Text = "☀️ Light",
	Variant = "Secondary",
})
lightBtn:on("Activated", function()
	LumaUI.setTheme("light")
	headerBg.BackgroundColor3 = LumaUI.getTheme().colors.primary
	headerMask.BackgroundColor3 = headerBg.BackgroundColor3
end)

local darkBtn = LumaUI.Button.new(themeRow.Instance, {
	Text = "🌙 Dark",
	Variant = "Secondary",
})
darkBtn:on("Activated", function()
	LumaUI.setTheme("dark")
	headerBg.BackgroundColor3 = LumaUI.getTheme().colors.primary
	headerMask.BackgroundColor3 = headerBg.BackgroundColor3
end)

print("✨ LumaUI Executor loaded! Press TAB to toggle visibility")

-- Toggle with TAB key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.Tab then
		windowFrame.Visible = not windowFrame.Visible
	end
end)
