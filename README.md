**Welcome to GrokaUI!**

***Thanks for using my library. I really appreciate it and we'd love if you join our Discord server.***

GrokaUI is a modern Roblox UI library focused on being clean, smooth, customizable and easy to use.

It comes with:
- Tabs
- Buttons
- Toggles
- Sliders
- Dropdowns
- Inputs
- Keybinds
- Notifications
- Ripple effects
- Smooth animations
- Modern design

The library is still being improved and more features will be added soon.

If you find bugs or have ideas, feel free to suggest them in the Discord server.

# Getting Started

1. insert the libraly 

local Library = loadstring(game:HttpGet("https://raw.githubusercontent.com/ploitgptemailforsupport-stack/dd6767/refs/heads/main/MyUI.lua"))()

2. create a window local Window = Library:CreateWindow(
    "Groka Hub",
    "Example UI"
)

3. Create a tab 

local Main = Window:CreateTab("Main", "🏠")

4. make a Button 

Main:AddButton("Click Me", "Example button", function()
    print("Hello from GrokaUI!")
end)
