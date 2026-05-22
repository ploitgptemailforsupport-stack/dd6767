--// === Groka UI Library v3 (FIXED) === //--
--// Real Dropdowns / MultiDropdowns / Better Sliders / Cleanup / Notifications

local GrokaUI = {}
GrokaUI.Theme = {
	Background = Color3.fromRGB(18,18,25),
	Topbar = Color3.fromRGB(25,25,35),
	Accent = Color3.fromRGB(120,120,255),
	Text = Color3.fromRGB(255,255,255),
	Secondary = Color3.fromRGB(35,35,45)
}

local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")

local Player = Players.LocalPlayer
local PlayerGui = Player:WaitForChild("PlayerGui")

--// Notification Holder
local NotifyGui = Instance.new("ScreenGui")
NotifyGui.Name = "GrokaNotifications"
NotifyGui.ResetOnSpawn = false
NotifyGui.Parent = PlayerGui

local NotifyHolder = Instance.new("Frame")
NotifyHolder.Size = UDim2.new(0,320,1,0)
NotifyHolder.Position = UDim2.new(1,-330,0,10)
NotifyHolder.BackgroundTransparency = 1
NotifyHolder.Parent = NotifyGui

local NotifyLayout = Instance.new("UIListLayout")
NotifyLayout.Padding = UDim.new(0,10)
NotifyLayout.SortOrder = Enum.SortOrder.LayoutOrder
NotifyLayout.Parent = NotifyHolder

--// Notify
function GrokaUI:Notify(title,text,timee)
	timee = timee or 3

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(1,0,0,80)
	frame.BackgroundColor3 = self.Theme.Background
	frame.BackgroundTransparency = 0.05
	frame.Parent = NotifyHolder

	Instance.new("UICorner",frame).CornerRadius = UDim.new(0,12)

	local stroke = Instance.new("UIStroke")
	stroke.Color = self.Theme.Accent
	stroke.Thickness = 2
	stroke.Parent = frame

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1,-10,0,28)
	titleLbl.Position = UDim2.new(0,10,0,5)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "🔔 "..title
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextColor3 = self.Theme.Text
	titleLbl.TextSize = 19
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = frame

	local textLbl = Instance.new("TextLabel")
	textLbl.Size = UDim2.new(1,-10,0,24)
	textLbl.Position = UDim2.new(0,10,0,38)
	textLbl.BackgroundTransparency = 1
	textLbl.Text = tostring(text)
	textLbl.Font = Enum.Font.Gotham
	textLbl.TextColor3 = self.Theme.Text
	textLbl.TextSize = 14
	textLbl.TextXAlignment = Enum.TextXAlignment.Left
	textLbl.Parent = frame

	frame.Position = UDim2.new(1,350,0,0)

	TweenService:Create(frame,TweenInfo.new(0.25),{
		Position = UDim2.new(0,0,0,0)
	}):Play()

	task.delay(timee,function()
		local tween = TweenService:Create(frame,TweenInfo.new(0.25),{
			BackgroundTransparency = 1
		})
		tween:Play()

		for _,v in pairs(frame:GetDescendants()) do
			if v:IsA("TextLabel") then
				TweenService:Create(v,TweenInfo.new(0.25),{
					TextTransparency = 1
				}):Play()
			end
		end

		task.wait(0.3)
		frame:Destroy()
	end)
end

--// Create Window
function GrokaUI:CreateWindow(title)

	local connections = {}

	local sg = Instance.new("ScreenGui")
	sg.Name = "GrokaUI"
	sg.ResetOnSpawn = false
	sg.Parent = PlayerGui

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0,560,0,420)
	main.Position = UDim2.new(0.5,-280,0.5,-210)
	main.BackgroundColor3 = self.Theme.Background
	main.Parent = sg

	Instance.new("UICorner",main).CornerRadius = UDim.new(0,16)

	local stroke = Instance.new("UIStroke")
	stroke.Color = self.Theme.Accent
	stroke.Thickness = 2
	stroke.Parent = main

	--// Topbar
	local top = Instance.new("Frame")
	top.Size = UDim2.new(1,0,0,50)
	top.BackgroundColor3 = self.Theme.Topbar
	top.Parent = main

	Instance.new("UICorner",top).CornerRadius = UDim.new(0,16)

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1,0,1,0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "✨ "..(title or "Groka UI")
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextColor3 = self.Theme.Text
	titleLbl.TextSize = 24
	titleLbl.Parent = top

	--// Dragging
	do
		local dragging = false
		local dragInput
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

		top.InputChanged:Connect(function(input)
			if input.UserInputType == Enum.UserInputType.MouseMovement then
				dragInput = input
			end
		end)

		UIS.InputChanged:Connect(function(input)
			if input == dragInput and dragging then
				local delta = input.Position - dragStart

				main.Position = UDim2.new(
					startPos.X.Scale,
					startPos.X.Offset + delta.X,
					startPos.Y.Scale,
					startPos.Y.Offset + delta.Y
				)
			end
		end)
	end

	--// Tabs
	local tabsHolder = Instance.new("Frame")
	tabsHolder.Size = UDim2.new(0,140,1,-50)
	tabsHolder.Position = UDim2.new(0,0,0,50)
	tabsHolder.BackgroundColor3 = self.Theme.Topbar
	tabsHolder.Parent = main

	local tabLayout = Instance.new("UIListLayout")
	tabLayout.Padding = UDim.new(0,6)
	tabLayout.Parent = tabsHolder

	local pages = Instance.new("Frame")
	pages.Size = UDim2.new(1,-150,1,-60)
	pages.Position = UDim2.new(0,145,0,55)
	pages.BackgroundTransparency = 1
	pages.Parent = main

	local Window = {}

	local tabButtons = {}

	function Window:Destroy()
		for _,c in pairs(connections) do
			pcall(function()
				c:Disconnect()
			end)
		end
		sg:Destroy()
	end

	function Window:CreateTab(name,emoji)

		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,-10,0,40)
		btn.Position = UDim2.new(0,5,0,0)
		btn.BackgroundColor3 = GrokaUI.Theme.Secondary
		btn.Text = (emoji or "📄").." "..name
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = GrokaUI.Theme.Text
		btn.TextSize = 16
		btn.Parent = tabsHolder

		Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)

		table.insert(tabButtons,btn)

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.new(1,0,1,0)
		page.CanvasSize = UDim2.new(0,0,0,0)
		page.ScrollBarThickness = 3
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = pages

		local layout = Instance.new("UIListLayout")
		layout.Padding = UDim.new(0,8)
		layout.Parent = page

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
		end)

		btn.MouseButton1Click:Connect(function()

			for _,v in pairs(pages:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end

			for _,b in pairs(tabButtons) do
				TweenService:Create(b,TweenInfo.new(0.2),{
					BackgroundColor3 = GrokaUI.Theme.Secondary
				}):Play()
			end

			page.Visible = true

			TweenService:Create(btn,TweenInfo.new(0.2),{
				BackgroundColor3 = GrokaUI.Theme.Accent
			}):Play()
		end)

		if #pages:GetChildren() == 1 then
			page.Visible = true
			btn.BackgroundColor3 = GrokaUI.Theme.Accent
		end

		local Elements = {}

		--// Button
		function Elements:AddButton(text,callback)

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-5,0,45)
			btn.BackgroundColor3 = GrokaUI.Theme.Accent
			btn.Text = "🚀 "..text
			btn.Font = Enum.Font.GothamBold
			btn.TextColor3 = Color3.new(1,1,1)
			btn.TextSize = 17
			btn.Parent = page

			Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)

			btn.MouseButton1Click:Connect(function()
				if callback then
					callback()
				end
			end)
		end

		--// Toggle
		function Elements:AddToggle(text,default,callback)

			local state = default or false

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-5,0,45)
			frame.BackgroundColor3 = GrokaUI.Theme.Secondary
			frame.Parent = page

			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,10)

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(0.7,0,1,0)
			lbl.BackgroundTransparency = 1
			lbl.Text = "⚡ "..text
			lbl.Font = Enum.Font.Gotham
			lbl.TextColor3 = GrokaUI.Theme.Text
			lbl.TextSize = 16
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = frame

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(0,70,0,30)
			btn.Position = UDim2.new(1,-80,0.5,-15)
			btn.BackgroundColor3 = state and Color3.fromRGB(0,170,120) or Color3.fromRGB(170,50,50)
			btn.Text = state and "ON" or "OFF"
			btn.Font = Enum.Font.GothamBold
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Parent = frame

			Instance.new("UICorner",btn).CornerRadius = UDim.new(0,8)

			btn.MouseButton1Click:Connect(function()

				state = not state

				btn.Text = state and "ON" or "OFF"

				TweenService:Create(btn,TweenInfo.new(0.15),{
					BackgroundColor3 = state and Color3.fromRGB(0,170,120) or Color3.fromRGB(170,50,50)
				}):Play()

				if callback then
					callback(state)
				end
			end)
		end

		--// Slider
		function Elements:AddSlider(text,min,max,default,callback)

			local value = default or min
			local range = math.max(max - min,1)

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-5,0,60)
			frame.BackgroundColor3 = GrokaUI.Theme.Secondary
			frame.Parent = page

			Instance.new("UICorner",frame).CornerRadius = UDim.new(0,10)

			local lbl = Instance.new("TextLabel")
			lbl.Size = UDim2.new(1,-10,0,20)
			lbl.Position = UDim2.new(0,10,0,5)
			lbl.BackgroundTransparency = 1
			lbl.Text = "🎚️ "..text.." : "..value
			lbl.Font = Enum.Font.Gotham
			lbl.TextColor3 = GrokaUI.Theme.Text
			lbl.TextSize = 15
			lbl.TextXAlignment = Enum.TextXAlignment.Left
			lbl.Parent = frame

			local bar = Instance.new("Frame")
			bar.Size = UDim2.new(1,-20,0,10)
			bar.Position = UDim2.new(0,10,0,38)
			bar.BackgroundColor3 = Color3.fromRGB(60,60,70)
			bar.Parent = frame

			Instance.new("UICorner",bar).CornerRadius = UDim.new(1,0)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((value-min)/range,0,1,0)
			fill.BackgroundColor3 = GrokaUI.Theme.Accent
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

			local conn = UIS.InputChanged:Connect(function(i)

				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then

					local pos = math.clamp(
						(i.Position.X - bar.AbsolutePosition.X) / bar.AbsoluteSize.X,
						0,
						1
					)

					fill.Size = UDim2.new(pos,0,1,0)

					value = math.floor(min + (range * pos))

					lbl.Text = "🎚️ "..text.." : "..value

					if callback then
						callback(value)
					end
				end
			end)

			table.insert(connections,conn)
		end

		--// REAL Dropdown
		function Elements:AddDropdown(text,options,callback)

			local opened = false
			local current = options[1] or "None"

			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(1,-5,0,45)
			holder.BackgroundColor3 = GrokaUI.Theme.Secondary
			holder.ClipsDescendants = true
			holder.Parent = page

			Instance.new("UICorner",holder).CornerRadius = UDim.new(0,10)

			local mainBtn = Instance.new("TextButton")
			mainBtn.Size = UDim2.new(1,0,0,45)
			mainBtn.BackgroundTransparency = 1
			mainBtn.Text = "📂 "..text.." : "..current
			mainBtn.Font = Enum.Font.Gotham
			mainBtn.TextColor3 = GrokaUI.Theme.Text
			mainBtn.TextSize = 15
			mainBtn.Parent = holder

			local optionLayout = Instance.new("UIListLayout")
			optionLayout.Padding = UDim.new(0,4)
			optionLayout.Parent = holder

			mainBtn.MouseButton1Click:Connect(function()

				opened = not opened

				local size = opened and (45 + (#options * 35) + 10) or 45

				TweenService:Create(holder,TweenInfo.new(0.2),{
					Size = UDim2.new(1,-5,0,size)
				}):Play()
			end)

			for _,opt in ipairs(options) do

				local option = Instance.new("TextButton")
				option.Size = UDim2.new(1,-10,0,30)
				option.Position = UDim2.new(0,5,0,0)
				option.BackgroundColor3 = Color3.fromRGB(45,45,55)
				option.Text = tostring(opt)
				option.Font = Enum.Font.Gotham
				option.TextColor3 = GrokaUI.Theme.Text
				option.TextSize = 14
				option.Parent = holder

				Instance.new("UICorner",option).CornerRadius = UDim.new(0,8)

				option.MouseButton1Click:Connect(function()

					current = tostring(opt)

					mainBtn.Text = "📂 "..text.." : "..current

					opened = false

					TweenService:Create(holder,TweenInfo.new(0.2),{
						Size = UDim2.new(1,-5,0,45)
					}):Play()

					if callback then
						callback(opt)
					end
				end)
			end
		end

		--// REAL Multi Dropdown
		function Elements:AddMultiDropdown(text,options,callback)

			local opened = false
			local selected = {}

			local holder = Instance.new("Frame")
			holder.Size = UDim2.new(1,-5,0,45)
			holder.BackgroundColor3 = GrokaUI.Theme.Secondary
			holder.ClipsDescendants = true
			holder.Parent = page

			Instance.new("UICorner",holder).CornerRadius = UDim.new(0,10)

			local mainBtn = Instance.new("TextButton")
			mainBtn.Size = UDim2.new(1,0,0,45)
			mainBtn.BackgroundTransparency = 1
			mainBtn.Text = "🗂️ "..text.." [0]"
			mainBtn.Font = Enum.Font.GothamBold
			mainBtn.TextColor3 = GrokaUI.Theme.Text
			mainBtn.TextSize = 15
			mainBtn.Parent = holder

			mainBtn.MouseButton1Click:Connect(function()

				opened = not opened

				local size = opened and (45 + (#options * 35) + 10) or 45

				TweenService:Create(holder,TweenInfo.new(0.2),{
					Size = UDim2.new(1,-5,0,size)
				}):Play()
			end)

			for _,opt in ipairs(options) do

				local option = Instance.new("TextButton")
				option.Size = UDim2.new(1,-10,0,30)
				option.Position = UDim2.new(0,5,0,0)
				option.BackgroundColor3 = Color3.fromRGB(45,45,55)
				option.Text = tostring(opt)
				option.Font = Enum.Font.Gotham
				option.TextColor3 = GrokaUI.Theme.Text
				option.TextSize = 14
				option.Parent = holder

				Instance.new("UICorner",option).CornerRadius = UDim.new(0,8)

				local enabled = false

				option.MouseButton1Click:Connect(function()

					enabled = not enabled

					option.BackgroundColor3 = enabled and GrokaUI.Theme.Accent or Color3.fromRGB(45,45,55)

					if enabled then
						table.insert(selected,opt)
					else
						for i,v in pairs(selected) do
							if v == opt then
								table.remove(selected,i)
							end
						end
					end

					mainBtn.Text = "🗂️ "..text.." ["..#selected.."]"

					if callback then
						callback(selected)
					end
				end)
			end
		end

		--// Color Picker
		function Elements:AddColorPicker(text,default,callback)

			local colors = {
				Color3.fromRGB(255,0,0),
				Color3.fromRGB(0,255,0),
				Color3.fromRGB(0,170,255),
				Color3.fromRGB(255,255,0),
				Color3.fromRGB(255,0,255),
				Color3.fromRGB(255,140,0),
				Color3.fromRGB(255,255,255)
			}

			local index = 1
			local color = default or colors[1]

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-5,0,45)
			btn.BackgroundColor3 = color
			btn.Text = "🎨 "..text
			btn.Font = Enum.Font.GothamBold
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Parent = page

			Instance.new("UICorner",btn).CornerRadius = UDim.new(0,10)

			btn.MouseButton1Click:Connect(function()

				index += 1

				if index > #colors then
					index = 1
				end

				color = colors[index]

				TweenService:Create(btn,TweenInfo.new(0.2),{
					BackgroundColor3 = color
				}):Play()

				if callback then
					callback(color)
				end
			end)
		end

		return Elements
	end

	return Window
end

return GrokaUI
