-- ESP.lua
local function toggleESP(enabled, button)
    if enabled then
        button.Text = "Enable ESP"
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player.Character then
                local highlight = player.Character:FindFirstChild("ESPHighlight")
                if highlight then
                    highlight:Destroy()
                end
            end
        end
    else
        button.Text = "Disable ESP"
        for _, player in ipairs(game:GetService("Players"):GetPlayers()) do
            if player.Character then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = player.Character
            end
        end
    end
end

return toggleESP