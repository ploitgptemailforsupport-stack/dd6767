-- === My Custom UI Library ===

local MyUI = {}

function MyUI:CreateWindow(title)
    local sg = Instance.new("ScreenGui")
    sg.ResetOnSpawn = false
    sg.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 420, 0, 500)
    frame.Position = UDim2.new(0.5, -210, 0.5, -250)
    frame.BackgroundColor3 = Color3.fromRGB(20, 20, 35)
    frame.Active = true
    frame.Draggable = true
    frame.Parent = sg

    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 12)
    Instance.new("UIStroke", frame).Color = Color3.fromRGB(100, 100, 255)

    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1,0,0,50)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title or "My UI Library"
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.TextScaled = true
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.Parent = frame

    local content = Instance.new("Frame")
    content.Size = UDim2.new(1, -20, 1, -70)
    content.Position = UDim2.new(0, 10, 0, 60)
    content.BackgroundTransparency = 1
    content.Parent = frame

    Instance.new("UIListLayout", content).Padding = UDim.new(0, 8)

    return {
        Frame = frame,
        Content = content,
        AddToggle = function(self, name, default, callback)
            local tFrame = Instance.new("Frame")
            tFrame.Size = UDim2.new(1,0,0,45)
            tFrame.BackgroundTransparency = 1
            tFrame.Parent = self.Content

            local label = Instance.new("TextLabel")
            label.Size = UDim2.new(0.7,0,1,0)
            label.BackgroundTransparency = 1
            label.Text = name
            label.TextColor3 = Color3.new(1,1,1)
            label.TextScaled = true
            label.TextXAlignment = Enum.TextXAlignment.Left
            label.Parent = tFrame

            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(0,60,0,30)
            btn.Position = UDim2.new(0.75,0,0.2,0)
            btn.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
            btn.Text = default and "ON" or "OFF"
            btn.TextColor3 = Color3.new(1,1,1)
            btn.TextScaled = true
            btn.Parent = tFrame
            Instance.new("UICorner", btn).CornerRadius = UDim.new(0,8)

            local state = default
            btn.MouseButton1Click:Connect(function()
                state = not state
                btn.Text = state and "ON" or "OFF"
                btn.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
                if callback then callback(state) end
            end)
        end
    }
end

return MyUI