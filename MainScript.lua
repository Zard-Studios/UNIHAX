local Players = game:GetService("Players")
local UI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/UI.lua"))()
local ESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/esp.lua"))()
local NoClip = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/NoClip.lua"))()
local Teleport = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/Teleport.lua"))()

UI.createGUI(ESP.toggleESP, NoClip.toggleNoClip, Teleport.toggleTeleport)

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
        UI.updatePlayerList()
    end)
end)

Players.PlayerRemoving:Connect(UI.updatePlayerList)