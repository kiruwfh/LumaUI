# LumaUI — Roblox UI Library (Starter)

LumaUI — минималистичная и быстрая UI‑библиотека для Roblox на чистом Luau без внешних зависимостей. Поддерживает темы (light/dark), дизайн‑токены, анимации, примитивы и компоненты.

## Установка

1) Скопируйте папку `LumaUI/` в `ReplicatedStorage` вашего проекта Roblox Studio (или в любое место по вашему выбору).
2) (Опционально) Скопируйте `Example/Example.client.lua` в `StarterPlayer/StarterPlayerScripts` как LocalScript и поправьте путь `require` при необходимости.

Структура:

```
ReplicatedStorage
└─ LumaUI
   ├─ init.lua
   ├─ Core
   │  ├─ Animator.lua
   │  └─ Signal.lua
   ├─ Theme
   │  ├─ Theme.lua
   │  └─ ThemeProvider.lua
   ├─ Primitives
   │  ├─ Surface.lua
   │  ├─ Stack.lua
   │  └─ Text.lua
   ├─ Components
   │  └─ Button.lua
   └─ Utils
      └─ Color.lua
```

## Быстрый старт

```lua
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Players = game:GetService("Players")

local LumaUI = require(ReplicatedStorage:WaitForChild("LumaUI"))
local screenGui = LumaUI.createScreenGui("LumaDemo")

-- Кнопка
local btn = LumaUI.Button.new(screenGui, {
	Text = "Click me",
	Variant = "Primary", -- Primary | Secondary | Ghost | Danger
	Size = "Md",         -- Sm | Md | Lg
	Position = UDim2.fromScale(0.5, 0.5),
	AnchorPoint = Vector2.new(0.5, 0.5),
})

btn:on("Activated", function()
	print("Clicked!")
end)

-- Смена темы на тёмную
LumaUI.setTheme("dark")
```

## Возможности (MVP)

- Простой и понятный API без Roact.
- Темы: light/dark, токены цветов, радиусов, spacing, типографики.
- Примитивы: `Surface`, `Text`, `Stack`.
- Компоненты: `Button` (варианты, размеры, hover/press анимации).
- Animator: обёртка над TweenService.
- Signal: лёгкие события.

## Переименование библиотеки

Если хотите другое имя (например, `AuroraUI`), переименуйте папку `LumaUI` и поправьте имя в `require`.

## Планы

- Toggle, Checkbox, Input, Slider.
- Modal/Dialog, Tooltip, Toast.
- Навигация геймпадом, FocusRing.
- Виртуализированные списки.

Если нужен другой стиль (неоморфизм, glassmorphism, материал) — скажите, я обновлю токены и стили.
