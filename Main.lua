local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/UI.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/ESP.lua"))()
local NoClip = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/NoClip.lua"))()
local Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/Teleport.lua"))()
local Fly = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/Fly.lua"))()

local espEnabled = false
local noClipEnabled = false
local flyEnabled = false

UI.createGUI()

local MainFrame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ESPControl"):WaitForChild("MainFrame")
local ESPButton = MainFrame:WaitForChild("ESP")
local NoClipButton = MainFrame:WaitForChild("NoClip")
local TeleportButton = MainFrame:WaitForChild("Teleport")
local FlyButton = MainFrame:WaitForChild("Fly")
local TeleportFrame = MainFrame:WaitForChild("TeleportFrame")
local PlayerList = TeleportFrame:WaitForChild("PlayerList")

ESPButton.MouseButton1Click:Connect(function()
    espEnabled = not espEnabled
    ESP.toggleESP(espEnabled)
    ESPButton.Text = espEnabled and "Disable ESP" or "Enable ESP"
    ESPButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
end)

NoClipButton.MouseButton1Click:Connect(function()
    noClipEnabled = not noClipEnabled
    NoClip.toggleNoClip(noClipEnabled)
    NoClipButton.Text = noClipEnabled and "Disable NoClip" or "Enable NoClip"
    NoClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
end)

FlyButton.MouseButton1Click:Connect(function()
    flyEnabled = not flyEnabled
    Fly.toggleFly()
    FlyButton.Text = flyEnabled and "Disable Fly" or "Enable Fly"
    FlyButton.BackgroundColor3 = flyEnabled and Color3.fromRGB(255, 165, 0) or Color3.fromRGB(60, 60, 60)
end)

TeleportButton.MouseButton1Click:Connect(function()
    TeleportFrame.Visible = not TeleportFrame.Visible
    Teleport.updatePlayerList(PlayerList)
end)

Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(character)
        if espEnabled then
            local highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end
    end)
    Teleport.updatePlayerList(PlayerList)
end)

Players.PlayerRemoving:Connect(function(player)
    Teleport.updatePlayerList(PlayerList)
end)