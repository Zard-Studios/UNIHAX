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
            print("ESP applied to", character.Name)
        end
    elseif not espEnabled and character then
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
            print("ESP removed from", character.Name)
        end
    end
end

local function onCharacterAdded(character)
    character:WaitForChild("Humanoid") -- Assicurati che il personaggio sia completamente caricato
    applyESPToCharacter(character)
    print("Character added:", character.Name)
end

local function onPlayerAdded(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(onCharacterAdded)
        -- Se il personaggio esiste già (giocatore già in gioco), applica subito l'ESP
        if player.Character then
            onCharacterAdded(player.Character)
        end
        print("Player added:", player.Name)
    end
end

local function toggleESP(enabled)
    espEnabled = enabled
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            -- Applica l'ESP ai personaggi esistenti
            if player.Character then
                applyESPToCharacter(player.Character)
            end
        end
    end
    print("ESP toggled to:", espEnabled)
end

-- Connetti agli eventi PlayerAdded e CharacterAdded
Players.PlayerAdded:Connect(onPlayerAdded)
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return {
    toggleESP = toggleESP
}