local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local espEnabled = false

-- Funzione per applicare l'ESP a un personaggio
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

-- Funzione per gestire il personaggio aggiunto
local function onCharacterAdded(character)
    character:WaitForChild("Humanoid") -- Assicurati che il personaggio sia completamente caricato
    applyESPToCharacter(character)
    
    -- Collega la funzione al cambiamento del personaggio
    local function onCharacterRemoving()
        applyESPToCharacter(character)
    end
    character.AncestryChanged:Connect(function(_, parent)
        if parent == nil then
            onCharacterRemoving()
        end
    end)
end

-- Funzione per gestire i giocatori aggiunti
local function onPlayerAdded(player)
    if player ~= LocalPlayer then
        player.CharacterAdded:Connect(onCharacterAdded)
        -- Se il personaggio esiste già (giocatore già in gioco), applica subito l'ESP
        if player.Character then
            onCharacterAdded(player.Character)
        end
    end
end

-- Funzione per attivare/disattivare l'ESP
local function toggleESP(enabled)
    espEnabled = enabled
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            applyESPToCharacter(player.Character)
        end
    end
end

-- Connetti agli eventi PlayerAdded e CharacterAdded
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(function(player)
    if player.Character then
        applyESPToCharacter(player.Character)
    end
end)

-- Applica ESP ai personaggi esistenti quando il modulo viene caricato
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

return {
    toggleESP = toggleESP
}