local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local espEnabled = false

local function applyESPToCharacter(character)
    if espEnabled and character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if not highlight then
            highlight = Instance.new("Highlight")
            highlight.Name = "ESPHighlight"
            highlight.FillColor = Color3.fromRGB(255, 0, 0)
            highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
            highlight.FillTransparency = 0.5
            highlight.OutlineTransparency = 0
            highlight.Parent = character
        end
    elseif not espEnabled and character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
        end
    end
end

local function onCharacterAdded(character)
    character:WaitForChild("Humanoid")
    applyESPToCharacter(character)
    
    local function onCharacterRemoving()
        applyESPToCharacter(character)
    end
    character.AncestryChanged:Connect(function(_, parent)
        if parent == nil then
            onCharacterRemoving()
        end
    end)
end

local function onPlayerAdded(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(onCharacterAdded)
        if player.Character then
            onCharacterAdded(player.Character)
        end
    end
end

local function toggleESP(enabled)
    espEnabled = enabled
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            applyESPToCharacter(player.Character)
        end
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        applyESPToCharacter(player.Character)
    end
end)

for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return {
    toggleESP = toggleESP
}