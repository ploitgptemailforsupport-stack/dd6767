--// ============================================ //--
--//         Groka UI Library v4                  //--
--//   Beautiful • Smooth • Feature-Rich          //--
--// ============================================ //--

local GrokaUI = {}

GrokaUI.Theme = {
	Background    = Color3.fromRGB(12, 12, 18),
	Surface       = Color3.fromRGB(20, 20, 30),
	Topbar        = Color3.fromRGB(16, 16, 24),
	Accent        = Color3.fromRGB(100, 130, 255),
	AccentDark    = Color3.fromRGB(60,  80, 200),
	Success       = Color3.fromRGB(60,  200, 120),
	Danger        = Color3.fromRGB(220, 70,  70),
	Text          = Color3.fromRGB(240, 240, 255),
	SubText       = Color3.fromRGB(140, 140, 170),
	Border        = Color3.fromRGB(40,  40,  60),
	TabActive     = Color3.fromRGB(100, 130, 255),
	TabInactive   = Color3.fromRGB(28,  28,  42),
}

local TweenService = game:GetService("TweenService")
local UIS          = game:GetService("UserInputService")
local Players      = game:GetService("Players")
local RunService   = game:GetService("RunService")

local Player    = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Tween shorthand
local function tween(obj, props, t, style, dir)
	return TweenService:Create(obj,
		TweenInfo.new(t or 0.2, style or Enum.EasingStyle.Quart, dir or Enum.EasingDirection.Out),
		props
	)
end

--// Ripple effect on click
local function addRipple(btn, color)
	btn.MouseButton1Click:Connect(function()
		local ripple = Instance.new("Frame")
		ripple.Size       = UDim2.new(0, 0, 0, 0)
		ripple.Position   = UDim2.new(0.5, 0, 0.5, 0)
		ripple.AnchorPoint = Vector2.new(0.5, 0.5)
		ripple.BackgroundColor3 = color or Color3.fromRGB(255,255,255)
		ripple.BackgroundTransparency = 0.7
		ripple.ZIndex     = 10
		ripple.Parent     = btn
		Instance.new("UICorner", ripple).CornerRadius = UDim.new(1, 0)

		tween(ripple, {
			Size = UDim2.new(2, 0, 2, 0),
			BackgroundTransparency = 1
		}, 0.4, Enum.EasingStyle.Quad):Play()

		task.delay(0.4, function() ripple:Destroy() end)
	end)
end

--// ============================
--//   NOTIFICATION SYSTEM
--// ============================

local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name          = "GrokaNotifications"
NotifyGui.ResetOnSpawn  = false
NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifyGui.Parent        = PlayerGui

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Size                 = UDim2.new(0, 320, 1, 0)
NotifyHolder.Position             = UDim2.new(1, -335, 0, 10)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Parent               = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding    = UDim.new(0, 8)
NotifyLayout.SortOrder  = Enum.SortOrder.LayoutOrder
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.Parent     = NotifyHolder

local NotifyPad = Instance.new("UIPadding")
NotifyPad.PaddingBottom = UDim.new(0, 10)
NotifyPad.Parent = NotifyHolder

local notifyColors = {
	info    = Color3.fromRGB(100, 130, 255),
	success = Color3.fromRGB(60,  200, 120),
	warning = Color3.fromRGB(255, 180, 60),
	error   = Color3.fromRGB(220, 70,  70),
}

local notifyIcons = {
	info    = "ℹ️",
	success = "✅",
	warning = "⚠️",
	error   = "❌",
}

function GrokaUI:Notify(title, text, duration, notifyType)
	duration   = duration   or 4
	notifyType = notifyType or "info"

	local accentColor = notifyColors[notifyType] or notifyColors.info
	local icon        = notifyIcons[notifyType]  or "🔔"

	local frame = Instance.new("Frame")
	frame.Size                 = UDim2.new(1, 0, 0, 80)
	frame.BackgroundColor3     = Color3.fromRGB(18, 18, 28)
	frame.BackgroundTransparency = 0
	frame.ClipsDescendants     = true
	frame.Parent               = NotifyHolder

	Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 14)

	-- Left accent bar
	local bar = Instance.new("Frame")
	bar.Size              = UDim2.new(0, 3, 1, -16)
	bar.Position          = UDim2.new(0, 0, 0, 8)
	bar.BackgroundColor3  = accentColor
	bar.Parent            = frame
	Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

	-- Outer stroke
	local stroke = Instance.new("UIStroke")
	stroke.Color     = accentColor
	stroke.Thickness = 1
	stroke.Transparency = 0.6
	stroke.Parent    = frame

	-- Icon
	local iconLbl = Instance.new("TextLabel")
	iconLbl.Size                = UDim2.new(0, 30, 0, 30)
	iconLbl.Position            = UDim2.new(0, 14, 0, 10)
	iconLbl.BackgroundTransparency = 1
	iconLbl.Text                = icon
	iconLbl.TextSize            = 20
	iconLbl.Font                = Enum.Font.GothamBold
	iconLbl.TextColor3          = accentColor
	iconLbl.Parent              = frame

	-- Title
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size               = UDim2.new(1, -58, 0, 24)
	titleLbl.Position           = UDim2.new(0, 50, 0, 8)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text               = tostring(title)
	titleLbl.Font               = Enum.Font.GothamBold
	titleLbl.TextColor3         = self.Theme.Text
	titleLbl.TextSize           = 15
	titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
	titleLbl.Parent             = frame

	-- Body
	local bodyLbl = Instance.new("TextLabel")
	bodyLbl.Size                = UDim2.new(1, -58, 0, 30)
	bodyLbl.Position            = UDim2.new(0, 50, 0, 34)
	bodyLbl.BackgroundTransparency = 1
	bodyLbl.Text                = tostring(text)
	bodyLbl.Font                = Enum.Font.Gotham
	bodyLbl.TextColor3          = self.Theme.SubText
	bodyLbl.TextSize            = 13
	bodyLbl.TextXAlignment      = Enum.TextXAlignment.Left
	bodyLbl.TextWrapped         = true
	bodyLbl.Parent              = frame

	-- Progress bar
	local progress = Instance.new("Frame")
	progress.Size             = UDim2.new(1, -16, 0, 2)
	progress.Position         = UDim2.new(0, 8, 1, -6)
	progress.BackgroundColor3 = accentColor
	progress.BackgroundTransparency = 0.4
	progress.Parent           = frame
	Instance.new("UICorner", progress).CornerRadius = UDim.new(1, 0)

	-- Slide in
	frame.Position = UDim2.new(1, 20, 0, 0)
	tween(frame, { Position = UDim2.new(0, 0, 0, 0) }, 0.35, Enum.EasingStyle.Back):Play()

	-- Drain progress bar
	tween(progress, { Size = UDim2.new(0, 0, 0, 2) }, duration, Enum.EasingStyle.Linear):Play()

	task.delay(duration, function()
		tween(frame, {
			Position = UDim2.new(1, 20, 0, 0),
			BackgroundTransparency = 1
		}, 0.3):Play()
		task.wait(0.35)
		frame:Destroy()
	end)

	return frame
end

--// ============================
--//   CREATE WINDOW
--// ============================

function GrokaUI:CreateWindow(title, subtitle)

	local connections = {}
	local T = self.Theme

	local sg = Instance.new("ScreenGui")
	sg.Name            = "GrokaUI_"..tostring(title)
	sg.ResetOnSpawn    = false
	sg.ZIndexBehavior  = Enum.ZIndexBehavior.Sibling
	sg.Parent          = PlayerGui

	-- Shadow frame (fake drop shadow)
	local shadow = Instance.new("Frame")
	shadow.Size               = UDim2.new(0, 580, 0, 450)
	shadow.Position           = UDim2.new(0.5, -288, 0.5, -220)
	shadow.BackgroundColor3   = Color3.fromRGB(0, 0, 0)
	shadow.BackgroundTransparency = 0.55
	shadow.ZIndex             = 0
	shadow.Parent             = sg
	Instance.new("UICorner", shadow).CornerRadius = UDim.new(0, 20)

	-- Main window
	local main = Instance.new("Frame")
	main.Size             = UDim2.new(0, 570, 0, 440)
	main.Position         = UDim2.new(0.5, -285, 0.5, -215)
	main.BackgroundColor3 = T.Background
	main.ZIndex           = 1
	main.Parent           = sg
	Instance.new("UICorner", main).CornerRadius = UDim.new(0, 18)

	local mainStroke = Instance.new("UIStroke")
	mainStroke.Color       = T.Border
	mainStroke.Thickness   = 1.5
	mainStroke.Parent      = main

	-- Subtle gradient overlay
	local grad = Instance.new("UIGradient")
	grad.Color    = ColorSequence.new({
		ColorSequenceKeypoint.new(0,   Color3.fromRGB(30,  30,  50)),
		ColorSequenceKeypoint.new(1,   Color3.fromRGB(10,  10,  18)),
	})
	grad.Rotation = 135
	grad.Parent   = main

	--// ---- TOPBAR ----
	local top = Instance.new("Frame")
	top.Size             = UDim2.new(1, 0, 0, 54)
	top.BackgroundColor3 = T.Topbar
	top.ZIndex           = 2
	top.Parent           = main
	Instance.new("UICorner", top).CornerRadius = UDim.new(0, 18)

	-- Cover bottom rounding of topbar
	local topFix = Instance.new("Frame")
	topFix.Size             = UDim2.new(1, 0, 0, 18)
	topFix.Position         = UDim2.new(0, 0, 1, -18)
	topFix.BackgroundColor3 = T.Topbar
	topFix.BorderSizePixel  = 0
	topFix.ZIndex           = 2
	topFix.Parent           = top

	-- Accent gradient line under topbar
	local accentLine = Instance.new("Frame")
	accentLine.Size             = UDim2.new(1, 0, 0, 1)
	accentLine.Position         = UDim2.new(0, 0, 1, 0)
	accentLine.BackgroundColor3 = T.Accent
	accentLine.BackgroundTransparency = 0.5
	accentLine.ZIndex           = 3
	accentLine.Parent           = top
	Instance.new("UIGradient", accentLine).Color = ColorSequence.new({
		ColorSequenceKeypoint.new(0,   Color3.fromRGB(80, 80, 255)),
		ColorSequenceKeypoint.new(0.5, Color3.fromRGB(180, 100, 255)),
		ColorSequenceKeypoint.new(1,   Color3.fromRGB(80, 80, 255)),
	})

	-- Logo dot
	local dot = Instance.new("Frame")
	dot.Size             = UDim2.new(0, 10, 0, 10)
	dot.Position         = UDim2.new(0, 18, 0.5, -5)
	dot.BackgroundColor3 = T.Accent
	dot.ZIndex           = 3
	dot.Parent           = top
	Instance.new("UICorner", dot).CornerRadius = UDim.new(1, 0)

	-- Title
	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size               = UDim2.new(0, 250, 0, 28)
	titleLbl.Position           = UDim2.new(0, 36, 0, 7)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text               = tostring(title or "Groka UI")
	titleLbl.Font               = Enum.Font.GothamBold
	titleLbl.TextColor3         = T.Text
	titleLbl.TextSize           = 20
	titleLbl.TextXAlignment     = Enum.TextXAlignment.Left
	titleLbl.ZIndex             = 3
	titleLbl.Parent             = top

	-- Subtitle
	if subtitle then
		local subLbl = Instance.new("TextLabel")
		subLbl.Size               = UDim2.new(0, 250, 0, 16)
		subLbl.Position           = UDim2.new(0, 36, 0, 32)
		subLbl.BackgroundTransparency = 1
		subLbl.Text               = tostring(subtitle)
		subLbl.Font               = Enum.Font.Gotham
		subLbl.TextColor3         = T.SubText
		subLbl.TextSize           = 12
		subLbl.TextXAlignment     = Enum.TextXAlignment.Left
		subLbl.ZIndex             = 3
		subLbl.Parent             = top

		-- Make topbar a bit taller to fit subtitle
		top.Size = UDim2.new(1, 0, 0, 62)
		topFix.Position = UDim2.new(0, 0, 1, -18)
	end

	--// ---- WINDOW TOGGLE BUTTON (minimise) ----
	local minimised = false
	local fullHeight = main.Size.Y.Offset

	local toggleBtn = Instance.new("TextButton")
	toggleBtn.Size               = UDim2.new(0, 30, 0, 30)
	toggleBtn.Position           = UDim2.new(1, -82, 0.5, -15)
	toggleBtn.BackgroundColor3   = Color3.fromRGB(40, 40, 60)
	toggleBtn.Text               = "—"
	toggleBtn.Font               = Enum.Font.GothamBold
	toggleBtn.TextColor3         = T.SubText
	toggleBtn.TextSize           = 16
	toggleBtn.ZIndex             = 4
	toggleBtn.Parent             = top
	Instance.new("UICorner", toggleBtn).CornerRadius = UDim.new(0, 8)

	toggleBtn.MouseEnter:Connect(function()
		tween(toggleBtn, { BackgroundColor3 = T.Accent, TextColor3 = T.Text }, 0.15):Play()
	end)
	toggleBtn.MouseLeave:Connect(function()
		tween(toggleBtn, { BackgroundColor3 = Color3.fromRGB(40,40,60), TextColor3 = T.SubText }, 0.15):Play()
	end)

	toggleBtn.MouseButton1Click:Connect(function()
		minimised = not minimised
		if minimised then
			local topH = top.Size.Y.Offset
			tween(main, { Size = UDim2.new(0, 570, 0, topH) }, 0.3, Enum.EasingStyle.Quart):Play()
			tween(shadow, { Size = UDim2.new(0, 580, 0, topH + 10) }, 0.3, Enum.EasingStyle.Quart):Play()
			toggleBtn.Text = "□"
		else
			tween(main, { Size = UDim2.new(0, 570, 0, fullHeight) }, 0.3, Enum.EasingStyle.Quart):Play()
			tween(shadow, { Size = UDim2.new(0, 580, 0, fullHeight + 10) }, 0.3, Enum.EasingStyle.Quart):Play()
			toggleBtn.Text = "—"
		end
	end)

	--// ---- CLOSE BUTTON ----
	local closeBtn = Instance.new("TextButton")
	closeBtn.Size               = UDim2.new(0, 30, 0, 30)
	closeBtn.Position           = UDim2.new(1, -44, 0.5, -15)
	closeBtn.BackgroundColor3   = Color3.fromRGB(40, 40, 60)
	closeBtn.Text               = "✕"
	closeBtn.Font               = Enum.Font.GothamBold
	closeBtn.TextColor3         = T.SubText
	closeBtn.TextSize           = 14
	closeBtn.ZIndex             = 4
	closeBtn.Parent             = top
	Instance.new("UICorner", closeBtn).CornerRadius = UDim.new(0, 8)

	closeBtn.MouseEnter:Connect(function()
		tween(closeBtn, { BackgroundColor3 = T.Danger, TextColor3 = T.Text }, 0.15):Play()
	end)
	closeBtn.MouseLeave:Connect(function()
		tween(closeBtn, { BackgroundColor3 = Color3.fromRGB(40,40,60), TextColor3 = T.SubText }, 0.15):Play()
	end)

	closeBtn.MouseButton1Click:Connect(function()
		tween(main,   { Size = UDim2.new(0, 570, 0, 0), BackgroundTransparency = 1 }, 0.25):Play()
		tween(shadow, { BackgroundTransparency = 1 }, 0.25):Play()
		task.wait(0.3)
		sg:Destroy()
	end)

	--// ---- DRAGGING ----
	do
		local dragging, dragInput, dragStart, startMainPos, startShadowPos = false

		top.InputBegan:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseButton1 then
				dragging       = true
				dragStart      = input.Position
				startMainPos   = main.Position
				startShadowPos = shadow.Position
				input.Changed:Connect(function()
					if input.UserInputState == Enum.UserInputState.End then
						dragging = false
					end
				end)
			end
		end)

		top.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)

		local c = UIS.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart
				main.Position = UDim2.new(
					startMainPos.X.Scale,   startMainPos.X.Offset   + delta.X,
					startMainPos.Y.Scale,   startMainPos.Y.Offset   + delta.Y
				)
				shadow.Position = UDim2.new(
					startShadowPos.X.Scale, startShadowPos.X.Offset + delta.X,
					startShadowPos.Y.Scale, startShadowPos.Y.Offset + delta.Y
				)
			end
		end)
		table.insert(connections, c)
	end

	--// ---- TAB SIDEBAR ----
	local tabsHolder = Instance.new("Frame")
	tabsHolder.Size             = UDim2.new(0, 148, 1, -(top.Size.Y.Offset + 2))
	tabsHolder.Position         = UDim2.new(0, 0, 0, top.Size.Y.Offset + 2)
	tabsHolder.BackgroundColor3 = T.Topbar
	tabsHolder.ZIndex           = 2
	tabsHolder.Parent           = main
	Instance.new("UICorner", tabsHolder).CornerRadius = UDim.new(0, 18)

	-- Cover right rounding
	local tabFix = Instance.new("Frame")
	tabFix.Size             = UDim2.new(0, 18, 1, 0)
	tabFix.Position         = UDim2.new(1, -18, 0, 0)
	tabFix.BackgroundColor3 = T.Topbar
	tabFix.BorderSizePixel  = 0
	tabFix.ZIndex           = 2
	tabFix.Parent           = tabsHolder

	local tabPad = Instance.new("UIPadding")
	tabPad.PaddingTop    = UDim.new(0, 10)
	tabPad.PaddingLeft   = UDim.new(0, 8)
	tabPad.PaddingRight  = UDim.new(0, 8)
	tabPad.Parent        = tabsHolder

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding   = UDim.new(0, 6)
	tabLayout.SortOrder = Enum.SortOrder.LayoutOrder
	tabLayout.Parent    = tabsHolder

	-- Divider between tabs and content
	local divider = Instance.new("Frame")
	divider.Size             = UDim2.new(0, 1, 1, -(top.Size.Y.Offset + 20))
	divider.Position         = UDim2.new(0, 152, 0, top.Size.Y.Offset + 10)
	divider.BackgroundColor3 = T.Border
	divider.ZIndex           = 2
	divider.Parent           = main

	--// ---- PAGE AREA ----
	local pages = Instance.new("Frame")
	pages.Size                 = UDim2.new(1, -162, 1, -(top.Size.Y.Offset + 12))
	pages.Position             = UDim2.new(0, 158, 0, top.Size.Y.Offset + 6)
	pages.BackgroundTransparency = 1
	pages.ZIndex               = 2
	pages.Parent               = main

	--// ============================================================
	--// WINDOW OBJECT
	--// ============================================================
	local Window    = {}
	local tabButtons = {}
	local tabPages   = {}
	local activeTab  = nil

	function Window:Destroy()
		for _, c in pairs(connections) do
			pcall(function() c:Disconnect() end)
		end
		sg:Destroy()
	end

	local function selectTab(btn, page)
		if activeTab == page then return end
		activeTab = page

		for _, p in pairs(tabPages) do
			p.Visible = false
		end
		for _, b in pairs(tabButtons) do
			tween(b, { BackgroundColor3 = T.TabInactive, TextColor3 = T.SubText }, 0.18):Play()
		end

		page.Visible = true
		tween(btn, { BackgroundColor3 = T.TabActive, TextColor3 = T.Text }, 0.18):Play()
	end

	--// ============================================================
	--// CREATE TAB
	--// ============================================================
	function Window:CreateTab(name, icon)

		local btn = Instance.new("TextButton")
		btn.Size             = UDim2.new(1, 0, 0, 38)
		btn.BackgroundColor3 = T.TabInactive
		btn.Font             = Enum.Font.GothamBold
		btn.Text             = (icon or "◈").."  "..name
		btn.TextColor3       = T.SubText
		btn.TextSize         = 14
		btn.TextXAlignment   = Enum.TextXAlignment.Left
		btn.ZIndex           = 3
		btn.Parent           = tabsHolder
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 10)

		local btnPad = Instance.new("UIPadding")
		btnPad.PaddingLeft = UDim.new(0, 12)
		btnPad.Parent      = btn

		-- Hover
		btn.MouseEnter:Connect(function()
			if btn.BackgroundColor3 ~= T.TabActive then
				tween(btn, { BackgroundColor3 = Color3.fromRGB(35,35,55) }, 0.12):Play()
			end
		end)
		btn.MouseLeave:Connect(function()
			if btn.BackgroundColor3 ~= T.TabActive then
				tween(btn, { BackgroundColor3 = T.TabInactive }, 0.12):Play()
			end
		end)

		table.insert(tabButtons, btn)

		-- Page (scrolling)
		local page = Instance.new("ScrollingFrame")
		page.Size                = UDim2.new(1, 0, 1, 0)
		page.CanvasSize          = UDim2.new(0, 0, 0, 0)
		page.ScrollBarThickness  = 3
		page.ScrollBarImageColor3 = T.Accent
		page.BackgroundTransparency = 1
		page.Visible             = false
		page.ZIndex              = 2
		page.Parent              = pages

		table.insert(tabPages, page)

		local pagePad = Instance.new("UIPadding")
		pagePad.PaddingRight  = UDim.new(0, 6)
		pagePad.PaddingBottom = UDim.new(0, 10)
		pagePad.Parent        = page

		local layout = Instance.new("UIListLayout")
		layout.Padding   = UDim.new(0, 8)
		layout.SortOrder = Enum.SortOrder.LayoutOrder
		layout.Parent    = page

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0, 0, 0, layout.AbsoluteContentSize.Y + 16)
		end)

		btn.MouseButton1Click:Connect(function()
			selectTab(btn, page)
		end)

		-- Auto-select first tab
		if #tabPages == 1 then
			selectTab(btn, page)
		end

		--// ====================================================
		--// ELEMENTS
		--// ====================================================
		local Elements = {}

		-- Helper: base card frame
		local function makeCard(h)
			local card = Instance.new("Frame")
			card.Size             = UDim2.new(1, -4, 0, h or 50)
			card.BackgroundColor3 = T.Surface
			card.ZIndex           = 3
			card.Parent           = page
			Instance.new("UICorner", card).CornerRadius = UDim.new(0, 12)
			local s = Instance.new("UIStroke")
			s.Color       = T.Border
			s.Thickness   = 1
			s.Parent      = card
			return card
		end

		-- Helper: label inside card
		local function makeLabel(parent, text, x, y, w, h, size, bold, color)
			local lbl = Instance.new("TextLabel")
			lbl.Size               = UDim2.new(w or 0.6, 0, 0, h or 20)
			lbl.Position           = UDim2.new(0, x or 14, 0, y or 0)
			lbl.BackgroundTransparency = 1
			lbl.Text               = tostring(text)
			lbl.Font               = bold and Enum.Font.GothamBold or Enum.Font.Gotham
			lbl.TextColor3         = color or T.Text
			lbl.TextSize           = size or 14
			lbl.TextXAlignment     = Enum.TextXAlignment.Left
			lbl.ZIndex             = 4
			lbl.Parent             = parent
			return lbl
		end

		--// Section label
		function Elements:AddSection(text)
			local frame = Instance.new("Frame")
			frame.Size                 = UDim2.new(1, -4, 0, 28)
			frame.BackgroundTransparency = 1
			frame.ZIndex               = 3
			frame.Parent               = page

			local line = Instance.new("Frame")
			line.Size             = UDim2.new(1, -10, 0, 1)
			line.Position         = UDim2.new(0, 5, 0.5, 0)
			line.BackgroundColor3 = T.Border
			line.ZIndex           = 3
			line.Parent           = frame

			local lbl = Instance.new("TextLabel")
			lbl.Size               = UDim2.new(0, 0, 1, 0)
			lbl.AutomaticSize      = Enum.AutomaticSize.X
			lbl.Position           = UDim2.new(0, 14, 0, 0)
			lbl.BackgroundColor3   = T.Background
			lbl.BackgroundTransparency = 0
			lbl.Text               = "  "..tostring(text).."  "
			lbl.Font               = Enum.Font.GothamBold
			lbl.TextColor3         = T.Accent
			lbl.TextSize           = 12
			lbl.TextXAlignment     = Enum.TextXAlignment.Center
			lbl.ZIndex             = 4
			lbl.Parent             = frame
		end

		--// Button
		function Elements:AddButton(text, desc, callback)

			local card = makeCard(desc and 62 or 46)

			-- Gradient accent bg on hover
			local fill = Instance.new("Frame")
			fill.Size               = UDim2.new(0, 0, 1, 0)
			fill.BackgroundColor3   = T.Accent
			fill.BackgroundTransparency = 0.85
			fill.ZIndex             = 3
			fill.Parent             = card
			Instance.new("UICorner", fill).CornerRadius = UDim.new(0, 12)

			makeLabel(card, text, 14, desc and 8 or 14, 0.75, 20, 14, true, T.Text)
			if desc then
				makeLabel(card, desc, 14, 30, 0.8, 16, 12, false, T.SubText)
			end

			-- Arrow indicator
			local arrow = Instance.new("TextLabel")
			arrow.Size               = UDim2.new(0, 24, 0, 24)
			arrow.Position           = UDim2.new(1, -30, 0.5, -12)
			arrow.BackgroundTransparency = 1
			arrow.Text               = "›"
			arrow.Font               = Enum.Font.GothamBold
			arrow.TextColor3         = T.Accent
			arrow.TextSize           = 22
			arrow.ZIndex             = 4
			arrow.Parent             = card

			local clickArea = Instance.new("TextButton")
			clickArea.Size               = UDim2.new(1, 0, 1, 0)
			clickArea.BackgroundTransparency = 1
			clickArea.Text               = ""
			clickArea.ZIndex             = 5
			clickArea.Parent             = card

			clickArea.MouseEnter:Connect(function()
				tween(fill, { Size = UDim2.new(1, 0, 1, 0), BackgroundTransparency = 0.88 }, 0.2):Play()
				tween(arrow, { TextColor3 = T.Text }, 0.15):Play()
			end)
			clickArea.MouseLeave:Connect(function()
				tween(fill, { Size = UDim2.new(0, 0, 1, 0), BackgroundTransparency = 0.85 }, 0.2):Play()
				tween(arrow, { TextColor3 = T.Accent }, 0.15):Play()
			end)

			clickArea.MouseButton1Click:Connect(function()
				if callback then callback() end
			end)

			addRipple(clickArea, T.Accent)
		end

		--// Toggle
		function Elements:AddToggle(text, desc, default, callback)

			local state = default or false
			local card  = makeCard(desc and 62 or 46)

			makeLabel(card, text, 14, desc and 8 or 13, 0.65, 20, 14, true, T.Text)
			if desc then
				makeLabel(card, desc, 14, 30, 0.65, 16, 12, false, T.SubText)
			end

			-- Track
			local track = Instance.new("Frame")
			track.Size             = UDim2.new(0, 46, 0, 24)
			track.Position         = UDim2.new(1, -58, 0.5, -12)
			track.BackgroundColor3 = state and T.Success or Color3.fromRGB(45, 45, 65)
			track.ZIndex           = 4
			track.Parent           = card
			Instance.new("UICorner", track).CornerRadius = UDim.new(1, 0)

			-- Thumb
			local thumb = Instance.new("Frame")
			thumb.Size             = UDim2.new(0, 18, 0, 18)
			thumb.Position         = state and UDim2.new(1, -21, 0.5, -9) or UDim2.new(0, 3, 0.5, -9)
			thumb.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			thumb.ZIndex           = 5
			thumb.Parent           = track
			Instance.new("UICorner", thumb).CornerRadius = UDim.new(1, 0)

			local clickArea = Instance.new("TextButton")
			clickArea.Size               = UDim2.new(1, 0, 1, 0)
			clickArea.BackgroundTransparency = 1
			clickArea.Text               = ""
			clickArea.ZIndex             = 6
			clickArea.Parent             = card

			clickArea.MouseButton1Click:Connect(function()
				state = not state
				tween(track, { BackgroundColor3 = state and T.Success or Color3.fromRGB(45,45,65) }, 0.18):Play()
				tween(thumb, { Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9) }, 0.18):Play()
				if callback then callback(state) end
			end)

			-- Return setter
			local Toggle = {}
			function Toggle:Set(val)
				state = val
				tween(track, { BackgroundColor3 = state and T.Success or Color3.fromRGB(45,45,65) }, 0.18):Play()
				tween(thumb, { Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9) }, 0.18):Play()
				if callback then callback(state) end
			end
			return Toggle
		end

		--// Slider
		function Elements:AddSlider(text, min, max, default, callback)

			local value = math.clamp(default or min, min, max)
			local range = math.max(max - min, 1)
			local card  = makeCard(66)

			local topRow = makeLabel(card, text, 14, 10, 0.6, 18, 14, true, T.Text)
			local valLbl = Instance.new("TextLabel")
			valLbl.Size               = UDim2.new(0, 60, 0, 18)
			valLbl.Position           = UDim2.new(1, -72, 0, 10)
			valLbl.BackgroundTransparency = 1
			valLbl.Text               = tostring(value)
			valLbl.Font               = Enum.Font.GothamBold
			valLbl.TextColor3         = T.Accent
			valLbl.TextSize           = 14
			valLbl.TextXAlignment     = Enum.TextXAlignment.Right
			valLbl.ZIndex             = 4
			valLbl.Parent             = card

			-- Bar bg
			local bar = Instance.new("Frame")
			bar.Size             = UDim2.new(1, -28, 0, 6)
			bar.Position         = UDim2.new(0, 14, 0, 42)
			bar.BackgroundColor3 = Color3.fromRGB(35, 35, 55)
			bar.ZIndex           = 4
			bar.Parent           = card
			Instance.new("UICorner", bar).CornerRadius = UDim.new(1, 0)

			-- Fill
			local fill = Instance.new("Frame")
			fill.Size             = UDim2.new((value - min) / range, 0, 1, 0)
			fill.BackgroundColor3 = T.Accent
			fill.ZIndex           = 5
			fill.Parent           = bar
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)

			-- Knob
			local knob = Instance.new("Frame")
			knob.Size             = UDim2.new(0, 16, 0, 16)
			knob.Position         = UDim2.new((value - min) / range, -8, 0.5, -8)
			knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
			knob.ZIndex           = 6
			knob.Parent           = bar
			Instance.new("UICorner", knob).CornerRadius = UDim.new(1, 0)

			local dragging = false

			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
					tween(knob, { Size = UDim2.new(0, 20, 0, 20), Position = UDim2.new((value-min)/range,-10,0.5,-10) }, 0.1):Play()
				end
			end)
			bar.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
					tween(knob, { Size = UDim2.new(0, 16, 0, 16) }, 0.1):Play()
				end
			end)

			local c = UIS.InputChanged:Connect(function(i)
				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = math.clamp((i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X, 0, 1)
					value = math.floor(min + range * pos)
					fill.Size       = UDim2.new(pos, 0, 1, 0)
					knob.Position   = UDim2.new(pos, -10, 0.5, -10)
					valLbl.Text     = tostring(value)
					if callback then callback(value) end
				end
			end)
			table.insert(connections, c)
		end

		--// Dropdown
		function Elements:AddDropdown(text, options, callback)

			local opened  = false
			local current = options[1] or "Select..."
			local optionH = 34
			local closedH = 46
			local openH   = closedH + (#options * (optionH + 4)) + 8

			local card = makeCard(closedH)
			card.ClipsDescendants = true

			makeLabel(card, text, 14, 13, 0.55, 20, 14, true, T.Text)

			local valLbl = Instance.new("TextLabel")
			valLbl.Size               = UDim2.new(0, 140, 0, 20)
			valLbl.Position           = UDim2.new(1, -150, 0, 13)
			valLbl.BackgroundTransparency = 1
			valLbl.Text               = tostring(current).." ▾"
			valLbl.Font               = Enum.Font.Gotham
			valLbl.TextColor3         = T.Accent
			valLbl.TextSize           = 13
			valLbl.TextXAlignment     = Enum.TextXAlignment.Right
			valLbl.ZIndex             = 4
			valLbl.Parent             = card

			local topBtn = Instance.new("TextButton")
			topBtn.Size               = UDim2.new(1, 0, 0, closedH)
			topBtn.BackgroundTransparency = 1
			topBtn.Text               = ""
			topBtn.ZIndex             = 5
			topBtn.Parent             = card

			-- Options list
			local optList = Instance.new("Frame")
			optList.Size             = UDim2.new(1, -16, 0, (#options * (optionH + 4)))
			optList.Position         = UDim2.new(0, 8, 0, closedH + 4)
			optList.BackgroundTransparency = 1
			optList.ZIndex           = 4
			optList.Parent           = card

			local optLayout = Instance.new("UIListLayout")
			optLayout.Padding   = UDim.new(0, 4)
			optLayout.SortOrder = Enum.SortOrder.LayoutOrder
			optLayout.Parent    = optList

			for _, opt in ipairs(options) do
				local ob = Instance.new("TextButton")
				ob.Size             = UDim2.new(1, 0, 0, optionH)
				ob.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
				ob.Text             = tostring(opt)
				ob.Font             = Enum.Font.Gotham
				ob.TextColor3       = T.SubText
				ob.TextSize         = 13
				ob.ZIndex           = 5
				ob.Parent           = optList
				Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 8)

				ob.MouseEnter:Connect(function()
					tween(ob, { BackgroundColor3 = Color3.fromRGB(45,45,70), TextColor3 = T.Text }, 0.1):Play()
				end)
				ob.MouseLeave:Connect(function()
					if tostring(opt) ~= current then
						tween(ob, { BackgroundColor3 = Color3.fromRGB(30,30,48), TextColor3 = T.SubText }, 0.1):Play()
					end
				end)
				ob.MouseButton1Click:Connect(function()
					current        = tostring(opt)
					valLbl.Text    = current.." ▾"
					opened         = false
					tween(card, { Size = UDim2.new(1,-4,0,closedH) }, 0.2):Play()
					if callback then callback(opt) end
				end)
			end

			topBtn.MouseButton1Click:Connect(function()
				opened = not opened
				tween(card, { Size = UDim2.new(1,-4,0, opened and openH or closedH) }, 0.25, Enum.EasingStyle.Quart):Play()
				valLbl.Text = current..(opened and " ▴" or " ▾")
			end)
		end

		--// Multi Dropdown
		function Elements:AddMultiDropdown(text, options, callback)

			local opened   = false
			local selected = {}
			local optionH  = 34
			local closedH  = 46
			local openH    = closedH + (#options * (optionH + 4)) + 8

			local card = makeCard(closedH)
			card.ClipsDescendants = true

			makeLabel(card, text, 14, 13, 0.55, 20, 14, true, T.Text)

			local countLbl = Instance.new("TextLabel")
			countLbl.Size               = UDim2.new(0, 140, 0, 20)
			countLbl.Position           = UDim2.new(1, -150, 0, 13)
			countLbl.BackgroundTransparency = 1
			countLbl.Text               = "0 selected ▾"
			countLbl.Font               = Enum.Font.Gotham
			countLbl.TextColor3         = T.Accent
			countLbl.TextSize           = 13
			countLbl.TextXAlignment     = Enum.TextXAlignment.Right
			countLbl.ZIndex             = 4
			countLbl.Parent             = card

			local topBtn = Instance.new("TextButton")
			topBtn.Size               = UDim2.new(1, 0, 0, closedH)
			topBtn.BackgroundTransparency = 1
			topBtn.Text               = ""
			topBtn.ZIndex             = 5
			topBtn.Parent             = card

			local optList = Instance.new("Frame")
			optList.Size             = UDim2.new(1, -16, 0, (#options * (optionH + 4)))
			optList.Position         = UDim2.new(0, 8, 0, closedH + 4)
			optList.BackgroundTransparency = 1
			optList.ZIndex           = 4
			optList.Parent           = card

			local optLayout = Instance.new("UIListLayout")
			optLayout.Padding   = UDim.new(0, 4)
			optLayout.SortOrder = Enum.SortOrder.LayoutOrder
			optLayout.Parent    = optList

			for _, opt in ipairs(options) do
				local enabled = false

				local ob = Instance.new("TextButton")
				ob.Size             = UDim2.new(1, 0, 0, optionH)
				ob.BackgroundColor3 = Color3.fromRGB(30, 30, 48)
				ob.Text             = tostring(opt)
				ob.Font             = Enum.Font.Gotham
				ob.TextColor3       = T.SubText
				ob.TextSize         = 13
				ob.ZIndex           = 5
				ob.Parent           = optList
				Instance.new("UICorner", ob).CornerRadius = UDim.new(0, 8)

				-- Checkmark
				local check = Instance.new("TextLabel")
				check.Size               = UDim2.new(0, 20, 0, 20)
				check.Position           = UDim2.new(1, -26, 0.5, -10)
				check.BackgroundTransparency = 1
				check.Text               = "✓"
				check.Font               = Enum.Font.GothamBold
				check.TextColor3         = T.Success
				check.TextSize           = 14
				check.Visible            = false
				check.ZIndex             = 6
				check.Parent             = ob

				ob.MouseButton1Click:Connect(function()
					enabled = not enabled
					check.Visible = enabled
					tween(ob, {
						BackgroundColor3 = enabled and Color3.fromRGB(30,55,40) or Color3.fromRGB(30,30,48),
						TextColor3       = enabled and T.Text or T.SubText
					}, 0.15):Play()

					if enabled then
						table.insert(selected, opt)
					else
						for i, v in pairs(selected) do
							if v == opt then table.remove(selected, i) break end
						end
					end

					countLbl.Text = #selected.." selected"..(opened and " ▴" or " ▾")
					if callback then callback(selected) end
				end)
			end

			topBtn.MouseButton1Click:Connect(function()
				opened = not opened
				tween(card, { Size = UDim2.new(1,-4,0, opened and openH or closedH) }, 0.25, Enum.EasingStyle.Quart):Play()
				countLbl.Text = #selected.." selected"..(opened and " ▴" or " ▾")
			end)
		end

		--// Text Input
		function Elements:AddInput(text, placeholder, callback)

			local card = makeCard(62)
			makeLabel(card, text, 14, 8, 0.7, 18, 14, true, T.Text)

			local box = Instance.new("TextBox")
			box.Size               = UDim2.new(1, -28, 0, 28)
			box.Position           = UDim2.new(0, 14, 0, 30)
			box.BackgroundColor3   = Color3.fromRGB(28, 28, 44)
			box.Text               = ""
			box.PlaceholderText    = placeholder or "Type here..."
			box.PlaceholderColor3  = T.SubText
			box.Font               = Enum.Font.Gotham
			box.TextColor3         = T.Text
			box.TextSize           = 13
			box.ClearTextOnFocus   = false
			box.ZIndex             = 4
			box.Parent             = card
			Instance.new("UICorner", box).CornerRadius = UDim.new(0, 8)

			local boxStroke = Instance.new("UIStroke")
			boxStroke.Color     = T.Border
			boxStroke.Thickness = 1
			boxStroke.Parent    = box

			local pad = Instance.new("UIPadding")
			pad.PaddingLeft = UDim.new(0, 10)
			pad.Parent      = box

			box.Focused:Connect(function()
				tween(boxStroke, { Color = T.Accent }, 0.15):Play()
			end)
			box.FocusLost:Connect(function()
				tween(boxStroke, { Color = T.Border }, 0.15):Play()
				if callback then callback(box.Text) end
			end)
		end

		--// Color Picker (preset swatches)
		function Elements:AddColorPicker(text, default, callback)

			local colors = {
				{ name = "Blue",   c = Color3.fromRGB(100, 130, 255) },
				{ name = "Purple", c = Color3.fromRGB(160, 80,  255) },
				{ name = "Cyan",   c = Color3.fromRGB(60,  210, 230) },
				{ name = "Green",  c = Color3.fromRGB(60,  200, 120) },
				{ name = "Yellow", c = Color3.fromRGB(255, 210, 60)  },
				{ name = "Orange", c = Color3.fromRGB(255, 140, 60)  },
				{ name = "Red",    c = Color3.fromRGB(230, 70,  70)  },
				{ name = "White",  c = Color3.fromRGB(240, 240, 255) },
			}

			local selected = default or colors[1].c
			local card = makeCard(70)

			makeLabel(card, text, 14, 8, 0.7, 18, 14, true, T.Text)

			local swatchRow = Instance.new("Frame")
			swatchRow.Size               = UDim2.new(1, -28, 0, 28)
			swatchRow.Position           = UDim2.new(0, 14, 0, 32)
			swatchRow.BackgroundTransparency = 1
			swatchRow.ZIndex             = 4
			swatchRow.Parent             = card

			local swatchLayout = Instance.new("UIListLayout")
			swatchLayout.FillDirection  = Enum.FillDirection.Horizontal
			swatchLayout.Padding        = UDim.new(0, 6)
			swatchLayout.SortOrder      = Enum.SortOrder.LayoutOrder
			swatchLayout.Parent         = swatchRow

			for _, col in ipairs(colors) do
				local swatch = Instance.new("TextButton")
				swatch.Size             = UDim2.new(0, 24, 0, 24)
				swatch.BackgroundColor3 = col.c
				swatch.Text             = ""
				swatch.ZIndex           = 5
				swatch.Parent           = swatchRow
				Instance.new("UICorner", swatch).CornerRadius = UDim.new(1, 0)

				if col.c == selected then
					local ring = Instance.new("UIStroke")
					ring.Color     = Color3.fromRGB(255,255,255)
					ring.Thickness = 2
					ring.Parent    = swatch
				end

				swatch.MouseButton1Click:Connect(function()
					selected = col.c
					-- Clear rings
					for _, s in pairs(swatchRow:GetChildren()) do
						if s:IsA("TextButton") then
							local st = s:FindFirstChildOfClass("UIStroke")
							if st then st:Destroy() end
						end
					end
					local ring = Instance.new("UIStroke")
					ring.Color     = Color3.fromRGB(255,255,255)
					ring.Thickness = 2
					ring.Parent    = swatch
					if callback then callback(col.c) end
				end)
			end
		end

		return Elements
	end

	return Window
end

return GrokaUI
