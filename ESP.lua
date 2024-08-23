local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local LocalPlayer = Players.LocalPlayer
local espEnabled = false
local espObjects = {}

local function createESPObject(player)
    if player == LocalPlayer then return end
    
    local espObject = Instance.new("Folder")
    espObject.Name = "ESPObject_" .. player.Name
    espObject.Parent = workspace
    
    local highlight = Instance.new("Highlight")
    highlight.Name = "ESPHighlight"
    highlight.FillColor = Color3.fromRGB(255, 0, 0)
    highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
    highlight.FillTransparency = 0.5
    highlight.OutlineTransparency = 0
    highlight.Parent = espObject
    
    espObjects[player] = espObject
    
    return espObject
end

local function updateESP()
    for player, espObject in pairs(espObjects) do
        if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
            espObject.Parent = player.Character
            espObject.ESPHighlight.Adornee = player.Character
        else
            espObject.Parent = workspace
            espObject.ESPHighlight.Adornee = nil
        end
    end
end

local function onPlayerAdded(player)
    if player ~= LocalPlayer then
        createESPObject(player)
    end
end

local function onPlayerRemoving(player)
    if espObjects[player] then
        espObjects[player]:Destroy()
        espObjects[player] = nil
    end
end

local function toggleESP(enabled)
    espEnabled = enabled
    for _, espObject in pairs(espObjects) do
        espObject.ESPHighlight.Enabled = espEnabled
    end
end

-- Inizializza gli ESP per i giocatori esistenti
for _, player in ipairs(Players:GetPlayers()) do
    onPlayerAdded(player)
end

-- Connetti agli eventi dei giocatori
Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

-- Aggiorna continuamente l'ESP
RunService.Heartbeat:Connect(function()
    if espEnabled then
        updateESP()
    end
end)

-- Auto-inserimento dello script
local function autoInsertScript()
    local scriptName = "AutoInsertedESPScript"
    if not ReplicatedStorage:FindFirstChild(scriptName) then
        local moduleScript = Instance.new("ModuleScript")
        moduleScript.Name = scriptName
        moduleScript.Source = script.Source
        moduleScript.Parent = ReplicatedStorage
        print("ESP Script auto-inserito in ReplicatedStorage")
    else
        print("ESP Script già presente in ReplicatedStorage")
    end
end

autoInsertScript()

-- Esporta la funzione toggleESP per l'uso in UI.lua
return {
    toggleESP = toggleESP
}