-- === Groka UI Library v2 ===
-- Better Looking / Tabs / Dropdowns / Multi Dropdowns / Sliders / Color Pickers / Notifications / Emojis

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

-- Notification
function GrokaUI:Notify(title, text, timee)
	timee = timee or 3

	local sg = Instance.new("ScreenGui")
	sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	sg.ResetOnSpawn = false

	local frame = Instance.new("Frame")
	frame.Size = UDim2.new(0,300,0,80)
	frame.Position = UDim2.new(1,320,1,-100)
	frame.BackgroundColor3 = self.Theme.Background
	frame.Parent = sg
	Instance.new("UICorner", frame).CornerRadius = UDim.new(0,12)

	local stroke = Instance.new("UIStroke", frame)
	stroke.Color = self.Theme.Accent
	stroke.Thickness = 2

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1,-10,0,30)
	titleLbl.Position = UDim2.new(0,10,0,5)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "🔔 "..title
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextColor3 = self.Theme.Text
	titleLbl.TextSize = 20
	titleLbl.TextXAlignment = Enum.TextXAlignment.Left
	titleLbl.Parent = frame

	local textLbl = Instance.new("TextLabel")
	textLbl.Size = UDim2.new(1,-10,0,30)
	textLbl.Position = UDim2.new(0,10,0,35)
	textLbl.BackgroundTransparency = 1
	textLbl.Text = text
	textLbl.Font = Enum.Font.Gotham
	textLbl.TextColor3 = self.Theme.Text
	textLbl.TextSize = 15
	textLbl.TextXAlignment = Enum.TextXAlignment.Left
	textLbl.Parent = frame

	TweenService:Create(frame,TweenInfo.new(0.3),{
		Position = UDim2.new(1,-320,1,-100)
	}):Play()

	task.wait(timee)

	TweenService:Create(frame,TweenInfo.new(0.3),{
		Position = UDim2.new(1,320,1,-100)
	}):Play()

	task.wait(0.35)
	sg:Destroy()
end

function GrokaUI:CreateWindow(title)
	local sg = Instance.new("ScreenGui")
	sg.Parent = Players.LocalPlayer:WaitForChild("PlayerGui")
	sg.ResetOnSpawn = false

	local main = Instance.new("Frame")
	main.Size = UDim2.new(0,560,0,420)
	main.Position = UDim2.new(0.5,-280,0.5,-210)
	main.BackgroundColor3 = self.Theme.Background
	main.Parent = sg
	main.Active = true
	main.Draggable = true
	Instance.new("UICorner", main).CornerRadius = UDim.new(0,16)

	local stroke = Instance.new("UIStroke", main)
	stroke.Color = self.Theme.Accent
	stroke.Thickness = 2

	local top = Instance.new("Frame")
	top.Size = UDim2.new(1,0,0,50)
	top.BackgroundColor3 = self.Theme.Topbar
	top.Parent = main
	Instance.new("UICorner", top).CornerRadius = UDim.new(0,16)

	local titleLbl = Instance.new("TextLabel")
	titleLbl.Size = UDim2.new(1,0,1,0)
	titleLbl.BackgroundTransparency = 1
	titleLbl.Text = "✨ "..(title or "Groka UI")
	titleLbl.Font = Enum.Font.GothamBold
	titleLbl.TextColor3 = self.Theme.Text
	titleLbl.TextSize = 24
	titleLbl.Parent = top

	local tabsHolder = Instance.new("Frame")
	tabsHolder.Size = UDim2.new(0,140,1,-50)
	tabsHolder.Position = UDim2.new(0,0,0,50)
	tabsHolder.BackgroundColor3 = self.Theme.Topbar
	tabsHolder.Parent = main

	local tabLayout = Instance.new("UIListLayout", tabsHolder)
	tabLayout.Padding = UDim.new(0,6)

	local pages = Instance.new("Frame")
	pages.Size = UDim2.new(1,-150,1,-60)
	pages.Position = UDim2.new(0,145,0,55)
	pages.BackgroundTransparency = 1
	pages.Parent = main

	local Window = {}

	function Window:CreateTab(name, emoji)
		local btn = Instance.new("TextButton")
		btn.Size = UDim2.new(1,-10,0,40)
		btn.Position = UDim2.new(0,5,0,0)
		btn.BackgroundColor3 = GrokaUI.Theme.Secondary
		btn.Text = (emoji or "📄").." "..name
		btn.Font = Enum.Font.GothamBold
		btn.TextColor3 = GrokaUI.Theme.Text
		btn.TextSize = 16
		btn.Parent = tabsHolder
		Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

		local page = Instance.new("ScrollingFrame")
		page.Size = UDim2.new(1,0,1,0)
		page.CanvasSize = UDim2.new(0,0,0,0)
		page.ScrollBarThickness = 3
		page.BackgroundTransparency = 1
		page.Visible = false
		page.Parent = pages

		local layout = Instance.new("UIListLayout", page)
		layout.Padding = UDim.new(0,8)

		layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
			page.CanvasSize = UDim2.new(0,0,0,layout.AbsoluteContentSize.Y + 10)
		end)

		btn.MouseButton1Click:Connect(function()
			for _,v in pairs(pages:GetChildren()) do
				if v:IsA("ScrollingFrame") then
					v.Visible = false
				end
			end
			page.Visible = true
		end)

		if #pages:GetChildren() == 1 then
			page.Visible = true
		end

		local Elements = {}

		-- Toggle
		function Elements:AddToggle(text,default,callback)
			local state = default

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-5,0,45)
			frame.BackgroundColor3 = GrokaUI.Theme.Secondary
			frame.Parent = page
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

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
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

			btn.MouseButton1Click:Connect(function()
				state = not state
				btn.Text = state and "ON" or "OFF"
				btn.BackgroundColor3 = state and Color3.fromRGB(0,170,120) or Color3.fromRGB(170,50,50)

				if callback then
					callback(state)
				end
			end)
		end

		-- Button
		function Elements:AddButton(text,callback)
			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-5,0,45)
			btn.BackgroundColor3 = GrokaUI.Theme.Accent
			btn.Text = "🚀 "..text
			btn.Font = Enum.Font.GothamBold
			btn.TextColor3 = Color3.new(1,1,1)
			btn.TextSize = 17
			btn.Parent = page
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

			btn.MouseButton1Click:Connect(function()
				if callback then
					callback()
				end
			end)
		end

		-- Slider
		function Elements:AddSlider(text,min,max,default,callback)
			local value = default or min

			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-5,0,60)
			frame.BackgroundColor3 = GrokaUI.Theme.Secondary
			frame.Parent = page
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

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
			bar.Position = UDim2.new(0,10,0,35)
			bar.BackgroundColor3 = Color3.fromRGB(60,60,70)
			bar.Parent = frame
			Instance.new("UICorner", bar).CornerRadius = UDim.new(1,0)

			local fill = Instance.new("Frame")
			fill.Size = UDim2.new((value-min)/(max-min),0,1,0)
			fill.BackgroundColor3 = GrokaUI.Theme.Accent
			fill.Parent = bar
			Instance.new("UICorner", fill).CornerRadius = UDim.new(1,0)

			local dragging = false

			bar.InputBegan:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = true
				end
			end)

			UIS.InputEnded:Connect(function(i)
				if i.UserInputType == Enum.UserInputType.MouseButton1 then
					dragging = false
				end
			end)

			UIS.InputChanged:Connect(function(i)
				if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then
					local pos = math.clamp((i.Position.X - bar.AbsolutePosition.X)/bar.AbsoluteSize.X,0,1)

					fill.Size = UDim2.new(pos,0,1,0)

					value = math.floor((min + (max-min)*pos))
					lbl.Text = "🎚️ "..text.." : "..value

					if callback then
						callback(value)
					end
				end
			end)
		end

		-- Dropdown
		function Elements:AddDropdown(text,options,callback)
			local frame = Instance.new("Frame")
			frame.Size = UDim2.new(1,-5,0,45)
			frame.BackgroundColor3 = GrokaUI.Theme.Secondary
			frame.Parent = page
			Instance.new("UICorner", frame).CornerRadius = UDim.new(0,10)

			local drop = Instance.new("TextButton")
			drop.Size = UDim2.new(1,0,1,0)
			drop.BackgroundTransparency = 1
			drop.Text = "📂 "..text
			drop.Font = Enum.Font.Gotham
			drop.TextColor3 = GrokaUI.Theme.Text
			drop.TextSize = 15
			drop.Parent = frame

			drop.MouseButton1Click:Connect(function()
				for _,v in pairs(options) do
					if callback then
						callback(v)
					end
					GrokaUI:Notify(text,v,1)
					break
				end
			end)
		end

		-- Multi Dropdown
		function Elements:AddMultiDropdown(text,options,callback)
			local selected = {}

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-5,0,45)
			btn.BackgroundColor3 = GrokaUI.Theme.Secondary
			btn.Text = "🗂️ "..text
			btn.Font = Enum.Font.GothamBold
			btn.TextColor3 = GrokaUI.Theme.Text
			btn.Parent = page
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

			btn.MouseButton1Click:Connect(function()
				selected = options

				if callback then
					callback(selected)
				end

				GrokaUI:Notify(text,"Selected "..#selected.." options",2)
			end)
		end

		-- Color Picker
		function Elements:AddColorPicker(text,default,callback)
			local color = default or Color3.fromRGB(255,255,255)

			local btn = Instance.new("TextButton")
			btn.Size = UDim2.new(1,-5,0,45)
			btn.BackgroundColor3 = color
			btn.Text = "🎨 "..text
			btn.Font = Enum.Font.GothamBold
			btn.TextColor3 = Color3.new(1,1,1)
			btn.Parent = page
			Instance.new("UICorner", btn).CornerRadius = UDim.new(0,10)

			btn.MouseButton1Click:Connect(function()
				color = Color3.fromRGB(
					math.random(0,255),
					math.random(0,255),
					math.random(0,255)
				)

				btn.BackgroundColor3 = color

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
