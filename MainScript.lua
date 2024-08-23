local Players = game:GetService("Players")
local UI = require(game.ServerScriptService.UI)
local ESP = require(game.ServerScriptService.ESP)
local NoClip = require(game.ServerScriptService.NoClip)
local Teleport = require(game.ServerScriptService.Teleport)

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