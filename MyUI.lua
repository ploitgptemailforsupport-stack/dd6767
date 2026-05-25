--// ============================================ //--
--//         Groka UI Library v5                  //--
--//  Beautiful • Smooth • Feature-Rich • Fixed   //--
--//  Credits: Groka / ploitgptemailforsupport    //--
--// ============================================ //--

local GrokaUI = {}

GrokaUI.Theme = {
	Background  = Color3.fromRGB(10, 10, 16),
	Surface     = Color3.fromRGB(18, 18, 28),
	SurfaceHover = Color3.fromRGB(24, 24, 38),
	Topbar      = Color3.fromRGB(14, 14, 22),
	Accent      = Color3.fromRGB(108, 138, 255),
	AccentDark  = Color3.fromRGB(72, 96, 220),
	AccentGlow  = Color3.fromRGB(108, 138, 255),
	Success     = Color3.fromRGB(52, 210, 128),
	Danger      = Color3.fromRGB(235, 72, 72),
	Text        = Color3.fromRGB(245, 245, 252),
	SubText     = Color3.fromRGB(130, 132, 165),
	Border      = Color3.fromRGB(36, 38, 58),
	BorderLight = Color3.fromRGB(52, 54, 78),
	TabActive   = Color3.fromRGB(28, 30, 48),
	TabInactive = Color3.fromRGB(16, 16, 26),
	Input       = Color3.fromRGB(22, 22, 36),
	Track       = Color3.fromRGB(32, 34, 52),
}

GrokaUI.Icons = {
	Shop     = "rbxassetid://14736132203",
	Combat   = "rbxassetid://1506618227",
	Player   = "rbxassetid://2243841665",
	Settings = "rbxassetid://18801194979",
	Home     = "rbxassetid://1249553442",
	Star     = "rbxassetid://17843890299",
	Warning  = "rbxassetid://6031071057",
	Info     = "rbxassetid://6031075049",
}

GrokaUI.Credits = "Groka UI v5 | By tg9ze - Commander; Grok - Ideea; Claude - Designer"

local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

local function tween(obj, props, t, style, dir)
	return TweenService:Create(obj, TweenInfo.new(
		t or 0.2,
		style or Enum.EasingStyle.Quart,
		dir or Enum.EasingDirection.Out
	), props)
end

local function addCorner(parent, radius)
	local c = Instance.new("UICorner")
	c.CornerRadius = UDim.new(0, radius or 10)
	c.Parent = parent
	return c
end

local function addStroke(parent, color, transparency, thickness)
	local s = Instance.new("UIStroke")
	s.Color = color
	s.Transparency = transparency or 0.5
	s.Thickness = thickness or 1
	s.ApplyStrokeMode = Enum.ApplyStrokeMode.Border
	s.Parent = parent
	return s
end

local function parseAssetId(icon)
	if not icon then return nil end
	local iconStr = tostring(icon)
	return iconStr:match("rbxassetid://(%d+)") or iconStr:match("^(%d+)$")
end

local function addRipple(btn, color)
	btn.MouseButton1Down:Connect(function(x, y)
		local ripple = Instance.new("Frame")
		ripple.AnchorPoint = Vector2.new(0.5, 0.5)
		ripple.Position = UDim2.fromOffset(x - btn.AbsolutePosition.X, y - btn.AbsolutePosition.Y)
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.BackgroundColor3 = color or Color3.new(1, 1, 1)
		ripple.BackgroundTransparency = 0.6
		ripple.ZIndex = 999
		ripple.Parent = btn
		Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)
		tween(ripple, { Size = UDim2.new(0, 400, 0, 400), BackgroundTransparency = 1 }, 0.45, Enum.EasingStyle.Quad):Play()
		task.delay(0.45, function() ripple:Destroy() end)
	end)
end

--// NOTIFICATIONS
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "GrokaNotifications"
NotifyGui.ResetOnSpawn = false
NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifyGui.Parent = PlayerGui

local NotifyHolder = Instance.new("Frame")
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Size = UDim2.new(0, 420, 0, 500)
NotifyHolder.AnchorPoint = Vector2.new(0.5, 1)
NotifyHolder.Position = UDim2.new(0.5, 0, 1, -20)
NotifyHolder.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0, 9)
NotifyLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Parent = NotifyHolder

function GrokaUI:Notify(title, text, duration, typ)
	duration = duration or 4
	typ = typ or "info"
	local colors = {
		info = Color3.fromRGB(100, 130, 255),
		success = Color3.fromRGB(60, 200, 120),
		error = Color3.fromRGB(220, 70, 70),
		warning = Color3.fromRGB(255, 180, 60),
	}
	local accentColor = colors[typ] or colors.info
	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0, 500, 0, 50)
	frame.BackgroundColor3 = Color3.fromRGB(18, 18, 28)
	frame.Position = UDim2.new(0.5, -250, 0, 100)
	frame.ClipsDescendants = true
	frame.Parent = NotifyHolder
	local s = Instance.new("UIStroke")
	s.Color = accentColor
	s.Transparency = 0.4
	s.Parent = frame
	local titleLbl = Instance.new("TextLabel")
	titleLbl.BackgroundTransparency = 1
	titleLbl.Size = UDim2.new(1, -20, 0, 20)
	titleLbl.Position = UDim2.new(0, 12, 0, 7)
	titleLbl.Text = tostring(title)
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextColor3 = Color3.new(1, 1, 1)
	titleLbl.TextSize = 15
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = frame
	local body = Instance.new("TextLabel")
	body.BackgroundTransparency = 1
	body.Size = UDim2.new(1, -20, 0, 32)
	body.Position = UDim2.new(0, 12, 0, 24)
	body.Text = tostring(text)
	body.Font = Enum.Font.Gotham
	body.TextColor3 = Color3.fromRGB(190, 190, 210)
	body.TextSize = 13
	body.TextWrapped = true
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.Parent = frame
	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1, -16, 0, 2)
	bar.Position = UDim2.new(0, 8, 1, 6)
	bar.BackgroundColor3 = accentColor
	bar.BorderSizePixel = 0
	bar.Parent = frame
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)
	tween(frame, { Position = UDim2.new(0, 0, 0, 0) }, 0.3, Enum.EasingStyle.Back):Play()
	tween(bar, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Quart):Play()
	task.delay(duration, function()
		tween(frame, { Position = UDim2.new(0, 0, 0, 100), BackgroundTransparency = 1 }, 0.25):Play()
		task.wait(0.3)
		frame:Destroy()
	end)
end

--// CREATE WINDOW
function GrokaUI:CreateWindow(title, subtitle, icon)
	local T = self.Theme
	local connections = {}

	local WIN_W, WIN_H = 620, 480
	local SHADOW_W, SHADOW_H = WIN_W + 16, WIN_H + 16
	local OUTER_W, OUTER_H = WIN_W + 30, WIN_H + 30

	local sg = Instance.new("ScreenGui")
	sg.Name = "GrokaUI"
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.Parent = PlayerGui

	local shadowOuter = Instance.new("Frame")
	shadowOuter.Size = UDim2.new(0, OUTER_W, 0, OUTER_H)
	shadowOuter.Position = UDim2.new(0.5, -OUTER_W / 2, 0.5, -OUTER_H / 2)
	shadowOuter.BackgroundColor3 = T.Accent
	shadowOuter.BackgroundTransparency = 0.92
	shadowOuter.BorderSizePixel = 0
	shadowOuter.Parent = sg
	addCorner(shadowOuter, 24)

	local shadow = Instance.new("Frame")
	shadow.Size = UDim2.new(0, SHADOW_W, 0, SHADOW_H)
	shadow.Position = UDim2.new(0.5, -SHADOW_W / 2 + 3, 0.5, -SHADOW_H / 2 + 3)
	shadow.BackgroundColor3 = Color3.new(0, 0, 0)
	shadow.BackgroundTransparency = 0.55
	shadow.BorderSizePixel = 0
	shadow.Parent = sg
	addCorner(shadow, 22)

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0, WIN_W, 0, WIN_H)
	main.Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2)
	main.BackgroundColor3 = T.Background
	main.ClipsDescendants = true
	main.Parent = sg
	addCorner(main, 18)
	addStroke(main, T.Border, 0.35, 1)

	main.Size = UDim2.new(0, WIN_W - 20, 0, WIN_H - 20)
	main.Position = UDim2.new(0.5, -(WIN_W - 20) / 2, 0.5, -(WIN_H - 20) / 2)
	tween(main, {
		Size = UDim2.new(0, WIN_W, 0, WIN_H),
		Position = UDim2.new(0.5, -WIN_W / 2, 0.5, -WIN_H / 2),
	}, 0.35, Enum.EasingStyle.Back):Play()

	-- TOP BAR
	local topBar = Instance.new("Frame")
	topBar.Size = UDim2.new(1, 0, 0, 46)
	topBar.BackgroundColor3 = T.Topbar
	topBar.BorderSizePixel = 0
	topBar.ZIndex = 5
	topBar.Parent = main
	addCorner(topBar, 18)

	local topBarFix = Instance.new("Frame")
	topBarFix.Size = UDim2.new(1, 0, 0, 18)
	topBarFix.Position = UDim2.new(0, 0, 1, -18)
	topBarFix.BackgroundColor3 = T.Topbar
	topBarFix.BorderSizePixel = 0
	topBarFix.Parent = topBar

	local accentLine = Instance.new("Frame")
	accentLine.Size = UDim2.new(1, 0, 0, 2)
	accentLine.Position = UDim2.new(0, 0, 1, -2)
	accentLine.BackgroundColor3 = T.Accent
	accentLine.BorderSizePixel = 0
	accentLine.ZIndex = 6
	accentLine.Parent = topBar
	local accentGrad = Instance.new("UIGradient")
	accentGrad.Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0, T.Accent),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(140, 120, 255)),
		ColorSequenceKeypoint.new(1, T.AccentDark),
	})
	accentGrad.Parent = accentLine

	local function makeChromeBtn(text, posX, hoverColor)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(0, 30, 0, 30)
		btn.Position = UDim2.new(1, posX, 0.5, -15)
		btn.BackgroundColor3 = T.Surface
		btn.Text = text
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = T.SubText
		btn.TextSize = 13
		btn.AutoButtonColor = false
		btn.ZIndex = 10
		btn.Parent = topBar
		addCorner(btn, 9)
		local st = addStroke(btn, T.Border, 0.5)
		btn.MouseEnter:Connect(function()
			tween(btn, { BackgroundColor3 = hoverColor or T.SurfaceHover, TextColor3 = T.Text }, 0.15):Play()
			tween(st, { Transparency = 0.2 }, 0.15):Play()
		end)
		btn.MouseLeave:Connect(function()
			tween(btn, { BackgroundColor3 = T.Surface, TextColor3 = T.SubText }, 0.15):Play()
			tween(st, { Transparency = 0.5 }, 0.15):Play()
		end)
		return btn
	end

	local close = makeChromeBtn("✕", -12, T.Danger)
	local minimise = makeChromeBtn("—", -50)
	minimise.TextSize = 15

	close.MouseEnter:Connect(function()
		tween(close, { BackgroundColor3 = T.Danger, TextColor3 = Color3.new(1, 1, 1) }, 0.15):Play()
	end)
	close.MouseLeave:Connect(function()
		tween(close, { BackgroundColor3 = T.Surface, TextColor3 = T.SubText }, 0.15):Play()
	end)
	close.MouseButton1Click:Connect(function()
		tween(main, { Size = UDim2.new(0, 0, 0, 0), Position = UDim2.new(0.5, 0, 0.5, 0) }, 0.25):Play()
		tween(shadow, { BackgroundTransparency = 1 }, 0.25):Play()
		tween(shadowOuter, { BackgroundTransparency = 1 }, 0.25):Play()
		task.wait(0.3)
		sg:Destroy()
	end)

	-- HORIZONTAL SCROLLING TABS (room for chrome buttons on the right)
	local tabsScroll = Instance.new("ScrollingFrame")
	tabsScroll.Size = UDim2.new(1, -96, 1, -8)
	tabsScroll.Position = UDim2.new(0, 8, 0, 4)
	tabsScroll.BackgroundTransparency = 1
	tabsScroll.BorderSizePixel = 0
	tabsScroll.ScrollBarThickness = 3
	tabsScroll.ScrollBarImageColor3 = T.Accent
	tabsScroll.ScrollBarImageTransparency = 0.35
	tabsScroll.ScrollingDirection = Enum.ScrollingDirection.X
	tabsScroll.AutomaticCanvasSize = Enum.AutomaticSize.X
	tabsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
	tabsScroll.ZIndex = 6
	tabsScroll.Parent = topBar

	local tabsRow = Instance.new("Frame")
	tabsRow.Size = UDim2.new(0, 0, 1, 0)
	tabsRow.AutomaticSize = Enum.AutomaticSize.X
	tabsRow.BackgroundTransparency = 1
	tabsRow.ZIndex = 6
	tabsRow.Parent = tabsScroll

	local tabsRowLayout = Instance.new("UIListLayout")
	tabsRowLayout.FillDirection = Enum.FillDirection.Horizontal
	tabsRowLayout.Padding = UDim.new(0, 4)
	tabsRowLayout.VerticalAlignment = Enum.VerticalAlignment.Center
	tabsRowLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabsRowLayout.Parent = tabsRow

	tabsRowLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
		tabsScroll.CanvasSize = UDim2.new(0, tabsRowLayout.AbsoluteContentSize.X + 12, 0, 0)
	end)

	local minimised = false
	local fullH = WIN_H
	local miniH = 46

	minimise.MouseButton1Click:Connect(function()
		minimised = not minimised
		if minimised then
			middleArea.Visible = false
			bottomBar.Visible = false
			tween(main, { Size = UDim2.new(0, WIN_W, 0, miniH) }, 0.25):Play()
			tween(shadow, { Size = UDim2.new(0, SHADOW_W, 0, miniH + 16) }, 0.25):Play()
			tween(shadowOuter, { Size = UDim2.new(0, OUTER_W, 0, miniH + 30) }, 0.25):Play()
			minimise.Text = "□"
		else
			middleArea.Visible = true
			bottomBar.Visible = true
			tween(main, { Size = UDim2.new(0, WIN_W, 0, fullH) }, 0.25):Play()
			tween(shadow, { Size = UDim2.new(0, SHADOW_W, 0, SHADOW_H) }, 0.25):Play()
			tween(shadowOuter, { Size = UDim2.new(0, OUTER_W, 0, OUTER_H) }, 0.25):Play()
			minimise.Text = "—"
		end
	end)

	-- DRAG
	do
		local dragging, dragStart, startPos = false
		topBar.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging = true
				dragStart = input.Position
				startPos = main.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)
		local c = UIS.InputChanged:Connect(function(input)
			if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
				local d = input.Position - dragStart
				main.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X, startPos.Y.Scale, startPos.Y.Offset + d.Y)
				shadow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X - 6, startPos.Y.Scale, startPos.Y.Offset + d.Y - 6)
				shadowOuter.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + d.X - 9, startPos.Y.Scale, startPos.Y.Offset + d.Y - 9)
			end
		end)
		table.insert(connections, c)
	end

	-- MIDDLE
	local middleArea = Instance.new("Frame")
	middleArea.Size = UDim2.new(1, 0, 1, -46 - 36)
	middleArea.Position = UDim2.new(0, 0, 0, 46)
	middleArea.BackgroundTransparency = 1
	middleArea.Parent = main

	local sidebar = Instance.new("Frame")
	sidebar.Size = UDim2.new(0, 158, 1, 0)
	sidebar.BackgroundColor3 = T.Topbar
	sidebar.BorderSizePixel = 0
	sidebar.Parent = middleArea

	local sidebarDivider = Instance.new("Frame")
	sidebarDivider.Size = UDim2.new(0, 1, 1, -20)
	sidebarDivider.Position = UDim2.new(0, 158, 0, 10)
	sidebarDivider.BackgroundColor3 = T.Border
	sidebarDivider.BackgroundTransparency = 0.3
	sidebarDivider.BorderSizePixel = 0
	sidebarDivider.Parent = middleArea

	local windowNumericId = parseAssetId(icon)
	if windowNumericId then
		local iconBg = Instance.new("Frame")
		iconBg.Size = UDim2.new(0, 52, 0, 52)
		iconBg.Position = UDim2.new(0.5, -26, 0, 20)
		iconBg.BackgroundColor3 = T.Surface
		iconBg.ZIndex = 4
		iconBg.Parent = sidebar
		addCorner(iconBg, 14)
		addStroke(iconBg, T.BorderLight, 0.5)
		local img = Instance.new("ImageLabel")
		img.Size = UDim2.new(0, 30, 0, 30)
		img.Position = UDim2.new(0.5, -15, 0.5, -15)
		img.BackgroundTransparency = 1
		img.Image = "rbxassetid://" .. windowNumericId
		img.ImageColor3 = Color3.new(1, 1, 1)
		img.ScaleType = Enum.ScaleType.Fit
		img.ZIndex = 5
		img.Parent = iconBg
	end

	local sideTitleY = windowNumericId and 80 or 20
	local sideTitle = Instance.new("TextLabel")
	sideTitle.BackgroundTransparency = 1
	sideTitle.Size = UDim2.new(1, -16, 0, 22)
	sideTitle.Position = UDim2.new(0, 8, 0, sideTitleY)
	sideTitle.Text = title or "Groka UI"
	sideTitle.Font = Enum.Font.GothamBold
	sideTitle.TextSize = 15
	sideTitle.TextColor3 = T.Text
	sideTitle.TextXAlignment = Enum.TextXAlignment.Center
	sideTitle.Parent = sidebar

	if subtitle then
		local sideSub = Instance.new("TextLabel")
		sideSub.BackgroundTransparency = 1
		sideSub.Size = UDim2.new(1, -16, 0, 32)
		sideSub.Position = UDim2.new(0, 8, 0, sideTitleY + 24)
		sideSub.Text = subtitle
		sideSub.Font = Enum.Font.Gotham
		sideSub.TextSize = 11
		sideSub.TextColor3 = T.SubText
		sideSub.TextWrapped = true
		sideSub.TextXAlignment = Enum.TextXAlignment.Center
		sideSub.Parent = sidebar
	end

	local pages = Instance.new("Frame")
	pages.BackgroundTransparency = 1
	pages.Size = UDim2.new(1, -168, 1, 0)
	pages.Position = UDim2.new(0, 164, 0, 0)
	pages.Parent = middleArea

	local pagePad = Instance.new("UIPadding")
	pagePad.PaddingRight = UDim.new(0, 6)
	pagePad.PaddingTop = UDim.new(0, 4)
	pagePad.Parent = pages

	-- BOTTOM BAR
	local bottomBar = Instance.new("Frame")
	bottomBar.Size = UDim2.new(1, 0, 0, 36)
	bottomBar.Position = UDim2.new(0, 0, 1, -36)
	bottomBar.BackgroundColor3 = T.Topbar
	bottomBar.BorderSizePixel = 0
	bottomBar.ZIndex = 5
	bottomBar.Parent = main
	addCorner(bottomBar, 18)

	local bottomBarFix = Instance.new("Frame")
	bottomBarFix.Size = UDim2.new(1, 0, 0, 18)
	bottomBarFix.BackgroundColor3 = T.Topbar
	bottomBarFix.BorderSizePixel = 0
	bottomBarFix.Parent = bottomBar

	local bottomLine = Instance.new("Frame")
	bottomLine.Size = UDim2.new(1, 0, 0, 1)
	bottomLine.BackgroundColor3 = T.Border
	bottomLine.BackgroundTransparency = 0.3
	bottomLine.BorderSizePixel = 0
	bottomLine.ZIndex = 6
	bottomLine.Parent = bottomBar
