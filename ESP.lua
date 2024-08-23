local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer
local espEnabled = false

local function applyESPToCharacter(character)
    if not character then return end
    
    if espEnabled then
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
    else
        local highlight = character:FindFirstChild("ESPHighlight")
        if highlight then
            highlight:Destroy()
            print("ESP removed from", character.Name)
        end
    end
end

local function onCharacterAdded(player)
    if player.Character then
        applyESPToCharacter(player.Character)
        print("Character added:", player.Name)
    end
    
    player.CharacterAdded:Connect(function(character)
        character:WaitForChild("Humanoid")
        applyESPToCharacter(character)
        print("Character added (from event):", player.Name)
    end)
end

local function onPlayerAdded(player)
    if player ~= LocalPlayer then
        onCharacterAdded(player)
        print("Player added:", player.Name)
    end
end

local function updateAllPlayers()
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            applyESPToCharacter(player.Character)
        end
    end
end

local function toggleESP(enabled)
    espEnabled = enabled
    updateAllPlayers()
    print("ESP toggled to:", espEnabled)
end

-- Connetti agli eventi PlayerAdded
Players.PlayerAdded:Connect(onPlayerAdded)

-- Applica l'ESP ai giocatori esistenti
for _, player in ipairs(Players:GetPlayers()) do
    if player ~= LocalPlayer then
        onCharacterAdded(player)
    end
end

-- Aggiorna periodicamente l'ESP
RunService.Heartbeat:Connect(function()
    updateAllPlayers()
end)

return {
    toggleESP = toggleESP
}