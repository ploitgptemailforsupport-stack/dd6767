--// ============================================ //--
--//         Groka UI Library v5                  //--
--//  Beautiful • Smooth • Feature-Rich • Fixed   //--
--// ============================================ //--

local GrokaUI = {}

GrokaUI.Theme = {
	Background    = Color3.fromRGB(12, 12, 18),
	Surface       = Color3.fromRGB(20, 20, 30),
	Topbar        = Color3.fromRGB(16, 16, 24),
	Accent        = Color3.fromRGB(100, 130, 255),
	AccentDark    = Color3.fromRGB(60, 80, 200),
	Success       = Color3.fromRGB(60, 200, 120),
	Danger        = Color3.fromRGB(220, 70, 70),
	Text          = Color3.fromRGB(240, 240, 255),
	SubText       = Color3.fromRGB(140, 140, 170),
	Border        = Color3.fromRGB(40, 40, 60),
	TabActive     = Color3.fromRGB(100, 130, 255),
	TabInactive   = Color3.fromRGB(28, 28, 42),
}

Library.Icons = {
	Text = "rbxassetid://6031094678",
	Combat = "rbxassetid://...",
	Player = "rbxassetid://..."
}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Tween
local function tween(obj, props, t, style, dir)
	return TweenService:Create(
		obj,
		TweenInfo.new(
			t or 0.2,
			style or Enum.EasingStyle.Quart,
			dir or Enum.EasingDirection.Out
		),
		props
	)
end

--// Ripple
local function addRipple(btn, color)
	btn.MouseButton1Down:Connect(function(x, y)
		local ripple = Instance.new("Frame")
		ripple.AnchorPoint = Vector2.new(0.5, 0.5)
		ripple.Position = UDim2.fromOffset(
			x - btn.AbsolutePosition.X,
			y - btn.AbsolutePosition.Y
		)
		ripple.Size = UDim2.new(0, 0, 0, 0)
		ripple.BackgroundColor3 = color or Color3.new(1,1,1)
		ripple.BackgroundTransparency = 0.5
		ripple.ZIndex = 999
		ripple.Parent = btn

		local corner = Instance.new("UICorner")
		corner.CornerRadius = UDim.new(1,0)
		corner.Parent = ripple

		tween(ripple,{
			Size = UDim2.new(0,400,0,400),
			BackgroundTransparency = 1
		},0.45,Enum.EasingStyle.Quad):Play()

		task.delay(0.45,function()
			ripple:Destroy()
		end)
	end)
end

--// Notifications
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "GrokaNotifications"
NotifyGui.ResetOnSpawn = false
NotifyGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
NotifyGui.Parent = PlayerGui

local NotifyHolder = Instance.new("Frame")
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Size = UDim2.new(0,320,1,0)
NotifyHolder.Position = UDim2.new(1,-330,0,10)
NotifyHolder.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0,8)
NotifyLayout.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Parent = NotifyHolder

function GrokaUI:Notify(title,text,duration,typ)

	duration = duration or 4
	typ = typ or "info"

	local colors = {
		info = Color3.fromRGB(100,130,255),
		success = Color3.fromRGB(60,200,120),
		error = Color3.fromRGB(220,70,70),
		warning = Color3.fromRGB(255,180,60),
	}

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,78)
	frame.BackgroundColor3 = Color3.fromRGB(18,18,28)
	frame.Position = UDim2.new(1,0,0,0)
	frame.Parent = NotifyHolder
	frame.ClipsDescendants = true

	Instance.new("UICorner",frame).CornerRadius = UDim.new(0,14)

	local stroke = Instance.new("UIStroke")
	stroke.Color = colors[typ]
	stroke.Transparency = 0.4
	stroke.Parent = frame

	local titleLbl = Instance.new("TextLabel")
	titleLbl.BackgroundTransparency = 1
	titleLbl.Size = UDim2.new(1,-20,0,20)
	titleLbl.Position = UDim2.new(0,12,0,10)
	titleLbl.Text = title
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextColor3 = Color3.new(1,1,1)
	titleLbl.TextSize = 15
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = frame

	local body = Instance.new("TextLabel")
	body.BackgroundTransparency = 1
	body.Size = UDim2.new(1,-20,0,32)
	body.Position = UDim2.new(0,12,0,34)
	body.Text = text
	body.Font = Enum.Font.Gotham
	body.TextColor3 = Color3.fromRGB(190,190,210)
	body.TextSize = 13
	body.TextWrapped = true
	body.TextXAlignment = Enum.TextXAlignment.Left
	body.Parent = frame

	local bar = Instance.new("Frame")
	bar.Size = UDim2.new(1,0,0,3)
	bar.Position = UDim2.new(0,0,1,-3)
	bar.BackgroundColor3 = colors[typ]
	bar.BorderSizePixel = 0
	bar.Parent = frame

	tween(frame,{Position = UDim2.new(0,0,0,0)},0.3,Enum.EasingStyle.Back):Play()
	tween(bar,{Size = UDim2.new(0,0,0,3)},duration,Enum.EasingStyle.Linear):Play()

	task.delay(duration,function()
		tween(frame,{
			Position = UDim2.new(1,0,0,0),
			BackgroundTransparency = 1
		},0.25):Play()

		task.wait(0.3)
		frame:Destroy()
	end)
end

--// Window
function GrokaUI:CreateWindow(title,subtitle)

	local T = self.Theme
	local connections = {}

	local sg = Instance.new("ScreenGui")
	sg.Name = "GrokaUI"
	sg.ResetOnSpawn = false
	sg.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
	sg.Parent = PlayerGui

	local shadow = Instance.new("Frame")
	shadow.Size = UDim2.new(0,590,0,460)
	shadow.Position = UDim2.new(0.5,-295,0.5,-230)
	shadow.BackgroundColor3 = Color3.new(0,0,0)
	shadow.BackgroundTransparency = 0.5
	shadow.Parent = sg
	Instance.new("UICorner",shadow).CornerRadius = UDim.new(0,20)

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0,580,0,450)
	main.Position = UDim2.new(0.5,-290,0.5,-225)
	main.BackgroundColor3 = T.Background
	main.Parent = sg
	Instance.new("UICorner",main).CornerRadius = UDim.new(0,18)

	local stroke = Instance.new("UIStroke")
	stroke.Color = T.Border
	stroke.Parent = main

	--// Topbar
	local top = Instance.new("Frame")
	top.Size = UDim2.new(1,0,0,60)
	top.BackgroundColor3 = T.Topbar
	top.Parent = main
	Instance.new("UICorner",top).CornerRadius = UDim.new(0,18)

	local fix = Instance.new("Frame")
	fix.Size = UDim2.new(1,0,0,18)
	fix.Position = UDim2.new(0,0,1,-18)
	fix.BackgroundColor3 = T.Topbar
	fix.BorderSizePixel = 0
	fix.Parent = top

	local titleLbl = Instance.new("TextLabel")
	titleLbl.BackgroundTransparency = 1
	titleLbl.Position = UDim2.new(0,20,0,8)
	titleLbl.Size = UDim2.new(0,300,0,22)
	titleLbl.Text = title or "Groka UI"
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextSize = 20
	titleLbl.TextColor3 = T.Text
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = top

	if subtitle then
		local sub = Instance.new("TextLabel")
		sub.BackgroundTransparency = 1
		sub.Position = UDim2.new(0,20,0,32)
		sub.Size = UDim2.new(0,300,0,16)
		sub.Text = subtitle
		sub.Font = Enum.Font.Gotham
		sub.TextSize = 12
		sub.TextColor3 = T.SubText
		sub.TextXAlignment = Enum.TextXAlignment.Left
		sub.Parent = top
	end

	--// Close
	local close = Instance.new("TextButton")
	close.Size = UDim2.new(0,30,0,30)
	close.Position = UDim2.new(1,-42,0.5,-15)
	close.BackgroundColor3 = Color3.fromRGB(40,40,60)
	close.Text = "✕"
	close.Font = Enum.Font.GothamBold
	close.TextColor3 = T.Text
	close.TextSize = 14
	close.Parent = top
	Instance.new("UICorner",close).CornerRadius = UDim.new(0,8)

	close.MouseEnter:Connect(function()
		tween(close,{BackgroundColor3 = T.Danger},0.15):Play()
	end)

	close.MouseLeave:Connect(function()
		tween(close,{BackgroundColor3 = Color3.fromRGB(40,40,60)},0.15):Play()
	end)

	close.MouseButton1Click:Connect(function()
		tween(main,{
			Size = UDim2.new(0,0,0,0),
			Position = UDim2.new(0.5,0,0.5,0)
		},0.25):Play()

		tween(shadow,{
			BackgroundTransparency = 1
		},0.25):Play()

		task.wait(0.3)
		sg:Destroy()
	end)

	--// Minimise
	local minimised = false
	local fullSize = main.Size

	local minimise = Instance.new("TextButton")
	minimise.Size = UDim2.new(0,30,0,30)
	minimise.Position = UDim2.new(1,-78,0.5,-15)
	minimise.BackgroundColor3 = Color3.fromRGB(40,40,60)
	minimise.Text = "—"
	minimise.Font = Enum.Font.GothamBold
	minimise.TextColor3 = T.Text
	minimise.TextSize = 16
	minimise.Parent = top
	Instance.new("UICorner",minimise).CornerRadius = UDim.new(0,8)

	minimise.MouseButton1Click:Connect(function()
		minimised = not minimised

		if minimised then
			tween(main,{
				Size = UDim2.new(0,580,0,60)
			},0.25):Play()

			minimise.Text = "□"
		else
			tween(main,{
				Size = fullSize
			},0.25):Play()

			minimise.Text = "—"
		end
	end)

	--// Drag
	do
		local dragging = false
		local dragStart
		local startPos

		top.InputBegan:Connect(function(input)
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

				local delta = input.Position - dragStart

				main.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)

				shadow.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X - 5,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y - 5
				)
			end
		end)

		table.insert(connections,c)
	end

	--// Tabs
	local tabsHolder = Instance.new("Frame")
	tabsHolder.Size = UDim2.new(0,150,1,-70)
	tabsHolder.Position = UDim2.new(0,0,0,70)
	tabsHolder.BackgroundColor3 = T.Topbar
	tabsHolder.Parent = main
	Instance.new("UICorner",tabsHolder).CornerRadius = UDim.new(0,16)

	local tabsLayout = Instance.new("UIListLayout")
	tabsLayout.Padding = UDim.new(0,6)
	tabsLayout.Parent = tabsHolder

	local tabPad = Instance.new("UIPadding")
	tabPad.PaddingTop = UDim.new(0,8)
	tabPad.PaddingLeft = UDim.new(0,8)
	tabPad.PaddingRight = UDim.new(0,8)
	tabPad.Parent = tabsHolder

	local pages = Instance.new("Frame")
	pages.BackgroundTransparency = 1
	pages.Size = UDim2.new(1,-165,1,-80)
	pages.Position = UDim2.new(0,160,0,72)
	pages.Parent = main

	local Window = {}
	local tabButtons = {}
	local tabPages = {}
	local activeTab

	local function selectTab(button,page)

		activeTab = page

		for _,p in pairs(tabPages) do
			p.Visible = false
		end

		for _,b in pairs(tabButtons) do
			tween(b,{
				BackgroundColor3 = T.TabInactive,
				TextColor3 = T.SubText
			},0.15):Play()
		end

		page.Visible = true

		tween(button,{
			BackgroundColor3 = T.TabActive,
			TextColor3 = T.Text
		},0.15):Play()
	end

	function Window:Destroy()
		for _,c in pairs(connections) do
			pcall(function()
				c:Disconnect()
			end)
		end

		sg:Destroy()
	end

	--// Create Tab
	function Window:CreateTab(name,icon)

		local button = Instance.new("TextButton")
		button.Size = UDim2.new(1,0,0,38)
		button.BackgroundColor3 = T.TabInactive
		button.Text = (icon or "◈").."  "..name
		button.Font = Enum.Font.GothamBold
		button.TextColor3 = T.SubText
		button.TextSize = 14
		button.TextXAlignment = Enum.TextXAlignment.Left
		button.Parent = tabsHolder
		Instance.new("UICorner",button).CornerRadius = UDim.new(0,10)

		local pad = Instance.new("UIPadding")
		pad.PaddingLeft = UDim.new(0,12)
		pad.Parent = button

		table.insert(tabButtons,button)

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.new(1,0,1,0)
		page.BackgroundTransparency = 1
		page.BorderSizePixel = 0
		page.CanvasSize = UDim2.new(0,0,0,0)
		page.ScrollBarThickness = 3
		page.ScrollBarImageColor3 = T.Accent
		page.Visible = false
		page.Parent = pages

		table.insert(tabPages,page)

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0,8)
		layout.Parent = page

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
		end)

		button.MouseButton1Click:Connect(function()
			selectTab(button,page)
		end)

		if #tabPages == 1 then
			selectTab(button,page)
		end

		--// Elements
		local Elements = {}

		local function makeCard(h)

			local card = Instance.new("Frame")
			card.Size = UDim2.new(1,-4,0,h or 50)
			card.BackgroundColor3 = T.Surface
			card.Parent = page

			Instance.new("UICorner",card).CornerRadius = UDim.new(0,12)

			local s = Instance.new("UIStroke")
			s.Color = T.Border
			s.Parent = card

			return card
		end

		local function makeLabel(parent,text,x,y,size,bold,color)

			local lbl = Instance.new("TextLabel")
			lbl.BackgroundTransparency = 1
			lbl.Position = UDim2.new(0,x or 14,0,y or 0)
			lbl.Size = UDim2.new(1,-20,0,20)
			lbl.Text = text
			lbl.Font = bold and Enum.Font.GothamBold or Enum.Font.Gotham
			lbl.TextColor3 = color or T.Text
			lbl.TextSize = size or 14
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = parent

			return lbl
		end

		--// Section
		function Elements:AddSection(text)

			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(1,-4,0,26)
			holder.BackgroundTransparency = 1
			holder.Parent = page

			local line = Instance.new("Frame")
			line.Size = UDim2.new(1,-10,0,1)
			line.Position = UDim2.new(0,5,0.5,0)
			line.BackgroundColor3 = T.Border
			line.BorderSizePixel = 0
			line.Parent = holder

			local label = Instance.new("TextLabel")
			label.AutomaticSize = Enum.AutomaticSize.X
			label.Size = UDim2.new(0,0,1,0)
			label.Position = UDim2.new(0,14,0,0)
			label.BackgroundColor3 = T.Background
			label.Text = " "..text.." "
			label.Font = Enum.Font.GothamBold
			label.TextSize = 12
			label.TextColor3 = T.Accent
			label.Parent = holder
		end

		--// Button
		function Elements:AddButton(text,desc,callback)

			local card = makeCard(desc and 62 or 46)

			makeLabel(card,text,14,desc and 8 or 13,14,true,T.Text)

			if desc then
				makeLabel(card,desc,14,30,12,false,T.SubText)
			end

			local button = Instance.new("TextButton")
			button.BackgroundTransparency = 1
			button.Size = UDim2.new(1,0,1,0)
			button.Text = ""
			button.Parent = card

			addRipple(button,T.Accent)

			button.MouseButton1Click:Connect(function()
				if callback then
					callback()
				end
			end)
		end

		--// Toggle
		function Elements:AddToggle(text,desc,default,callback)

			local state = default or false
			local card = makeCard(desc and 62 or 46)

			makeLabel(card,text,14,desc and 8 or 13,14,true,T.Text)

			if desc then
				makeLabel(card,desc,14,30,12,false,T.SubText)
			end

			local toggle = Instance.new("Frame")
			toggle.Size = UDim2.new(0,46,0,24)
			toggle.Position = UDim2.new(1,-60,0.5,-12)
			toggle.BackgroundColor3 = state and T.Success or Color3.fromRGB(45,45,65)
			toggle.Parent = card
			Instance.new("UICorner",toggle).CornerRadius = UDim.new(1,0)

			local knob = Instance.new("Frame")
			knob.Size = UDim2.new(0,18,0,18)
			knob.Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
			knob.BackgroundColor3 = Color3.new(1,1,1)
			knob.Parent = toggle
			Instance.new("UICorner",knob).CornerRadius = UDim.new(1,0)

			local button = Instance.new("TextButton")
			button.BackgroundTransparency = 1
			button.Size = UDim2.new(1,0,1,0)
			button.Text = ""
			button.Parent = card

			button.MouseButton1Click:Connect(function()

				state = not state

				tween(toggle,{
					BackgroundColor3 = state and T.Success or Color3.fromRGB(45,45,65)
				},0.18):Play()

				tween(knob,{
					Position = state and UDim2.new(1,-21,0.5,-9) or UDim2.new(0,3,0.5,-9)
				},0.18):Play()

				if callback then
					callback(state)
				end
			end)

			local Toggle = {}

			function Toggle:Set(v)
				state = v
			end

			return Toggle
		end

		--// Label
		function Elements:AddLabel(text)

			local card = makeCard(40)

			local label = makeLabel(card,text,14,10,13,false,T.Text)

			local Label = {}

			function Label:Set(newText)
				label.Text = newText
			end

			return Label
		end

		--// Paragraph
		function Elements:AddParagraph(title,text)

			local card = makeCard(80)

			makeLabel(card,title,14,10,14,true,T.Text)
			makeLabel(card,text,14,34,12,false,T.SubText)

		end

		--// Slider
		function Elements:AddSlider(text,min,max,default,callback)

			local value = default or min
			local range = max - min

			local card = makeCard(68)

			makeLabel(card,text,14,10,14,true,T.Text)

			local valueLbl = makeLabel(card,tostring(value),0,10,14,true,T.Accent)
			valueLbl.Position = UDim2.new(1,-70,0,10)
			valueLbl.TextXAlignment = Enum.TextXAlignment.Right

			local bar = Instance.new("Frame")
			bar.Size = UDim2.new(1,-28,0,6)
			bar.Position = UDim2.new(0,14,0,44)
			bar.BackgroundColor3 = Color3.fromRGB(35,35,55)
			bar.Parent = card
			Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((value-min)/range,0,1,0)
			fill.BackgroundColor3 = T.Accent
			fill.Parent = bar
			Instance.new("UICorner",fill).CornerRadius = UDim.new(1,0)

			local dragging = false

			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			bar.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			local c = UIS.InputChanged:Connect(function(i)

				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then

					local pos = math.clamp(
						(i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
						0,
						1
					)

					value = math.floor(min + ((max-min) * pos))

					fill.Size = UDim2.new(pos,0,1,0)
					valueLbl.Text = tostring(value)

					if callback then
						callback(value)
					end
				end
			end)

			table.insert(connections,c)
		end

		--// Input
		function Elements:AddInput(text,placeholder,callback)

			local card = makeCard(64)

			makeLabel(card,text,14,8,14,true,T.Text)

			local box = Instance.new("TextBox")
			box.Size = UDim2.new(1,-28,0,30)
			box.Position = UDim2.new(0,14,0,30)
			box.BackgroundColor3 = Color3.fromRGB(28,28,44)
			box.PlaceholderText = placeholder or "Type..."
			box.Text = ""
			box.ClearTextOnFocus = false
			box.TextColor3 = T.Text
			box.PlaceholderColor3 = T.SubText
			box.Font = Enum.Font.Gotham
			box.TextSize = 13
			box.Parent = card

			Instance.new("UICorner",box).CornerRadius = UDim.new(0,8)

			box.FocusLost:Connect(function()
				if callback then
					callback(box.Text)
				end
			end)
		end

		--// Dropdown
		function Elements:AddDropdown(text,options,callback)

			local current = options[1] or "Select"
			local open = false

			local card = makeCard(46)
			card.ClipsDescendants = true

			makeLabel(card,text,14,13,14,true,T.Text)

			local valueLbl = makeLabel(card,current.." ▾",0,13,13,false,T.Accent)
			valueLbl.Position = UDim2.new(1,-150,0,13)
			valueLbl.TextXAlignment = Enum.TextXAlignment.Right

			local button = Instance.new("TextButton")
			button.BackgroundTransparency = 1
			button.Size = UDim2.new(1,0,1,0)
			button.Text = ""
			button.Parent = card

			local holder = Instance.new("Frame")
			holder.BackgroundTransparency = 1
			holder.Position = UDim2.new(0,8,0,48)
			holder.Size = UDim2.new(1,-16,0,0)
			holder.Parent = card

			local layout = Instance.new("UIListLayout")
			layout.Padding = UDim.new(0,4)
			layout.Parent = holder

			for _,opt in ipairs(options) do

				local optBtn = Instance.new("TextButton")
				optBtn.Size = UDim2.new(1,0,0,32)
				optBtn.BackgroundColor3 = Color3.fromRGB(30,30,48)
				optBtn.Text = tostring(opt)
				optBtn.TextColor3 = T.SubText
				optBtn.Font = Enum.Font.Gotham
				optBtn.TextSize = 13
				optBtn.Parent = holder

				Instance.new("UICorner",optBtn).CornerRadius = UDim.new(0,8)

				optBtn.MouseButton1Click:Connect(function()

					current = tostring(opt)
					valueLbl.Text = current.." ▾"

					open = false

					tween(card,{
						Size = UDim2.new(1,-4,0,46)
					},0.2):Play()

					if callback then
						callback(opt)
					end
				end)
			end

			button.MouseButton1Click:Connect(function()

				open = not open

				tween(card,{
					Size = UDim2.new(
						1,
						-4,
						0,
						open and (50 + (#options*36)) or 46
					)
				},0.22):Play()

				valueLbl.Text = current..(open and " ▴" or " ▾")
			end)
		end

		--// Keybind
		function Elements:AddKeybind(text,default,callback)

			local key = default or Enum.KeyCode.RightShift

			local card = makeCard(46)

			makeLabel(card,text,14,13,14,true,T.Text)

			local bindBtn = Instance.new("TextButton")
			bindBtn.Size = UDim2.new(0,90,0,26)
			bindBtn.Position = UDim2.new(1,-104,0.5,-13)
			bindBtn.BackgroundColor3 = Color3.fromRGB(35,35,55)
			bindBtn.Text = key.Name
			bindBtn.Font = Enum.Font.GothamBold
			bindBtn.TextColor3 = T.Text
			bindBtn.TextSize = 12
			bindBtn.Parent = card

			Instance.new("UICorner",bindBtn).CornerRadius = UDim.new(0,8)

			local waiting = false

			bindBtn.MouseButton1Click:Connect(function()

				if waiting then return end

				waiting = true
				bindBtn.Text = "..."

				local c
				c = UIS.InputBegan:Connect(function(input,gp)

					if gp then return end

					if input.UserInputType == Enum.UserInputType.Keyboard then

						key = input.KeyCode
						bindBtn.Text = key.Name
						waiting = false

						c:Disconnect()
					end
				end)
			end)

			local c = UIS.InputBegan:Connect(function(input,gp)

				if gp then return end

				if input.KeyCode == key then
					if callback then
						callback()
					end
				end
			end)

			table.insert(connections,c)
		end

		return Elements
	end

	return Window
end

return GrokaUI
