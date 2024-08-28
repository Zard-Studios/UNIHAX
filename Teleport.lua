local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local followEnabled = {} -- Tabella per memorizzare lo stato di follow per ogni giocatore
local followConnection = nil -- Connessione per il loop di follow

-- Funzione per teletrasportarsi a un giocatore
local function teleportToPlayer(player)
    local targetCharacter = player.Character
    if targetCharacter and LocalPlayer.Character then
        local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
        local localCharacter = LocalPlayer.Character
        local localHumanoidRootPart = localCharacter and localCharacter:FindFirstChild("HumanoidRootPart")

        if targetHumanoidRootPart and localHumanoidRootPart then
            localCharacter:SetPrimaryPartCFrame(targetHumanoidRootPart.CFrame)
        end
    end
end

local function updatePlayerList(playerList)
    -- Pulisci lista
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    -- Lista con aggiornamenti
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Name = player.Name
            PlayerButton.Size = UDim2.new(1, -10, 0, 40) -- Riduzione per migliorare il padding
            PlayerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.TextSize = 14 -- Riduzione della dimensione del testo per evitare che esca fuori
            PlayerButton.TextWrapped = true -- Abilita il wrapping del testo
            PlayerButton.TextXAlignment = Enum.TextXAlignment.Left -- Allinea il testo a sinistra
            PlayerButton.Font = Enum.Font.GothamSemibold
            PlayerButton.Parent = playerList
            
            local PlayerButtonCorner = Instance.new("UICorner")
            PlayerButtonCorner.CornerRadius = UDim.new(0, 6)
            PlayerButtonCorner.Parent = PlayerButton
            
            local PlayerButtonStroke = Instance.new("UIStroke")
            PlayerButtonStroke.Color = Color3.fromRGB(100, 100, 100)
            PlayerButtonStroke.Thickness = 1
            PlayerButtonStroke.Parent = PlayerButton
            
            local PlayerNamePadding = Instance.new("UIPadding") -- Padding per evitare che il testo tocchi i bordi
            PlayerNamePadding.PaddingLeft = UDim.new(0, 10)
            PlayerNamePadding.PaddingRight = UDim.new(0, 10)
            PlayerNamePadding.Parent = PlayerButton
            
            PlayerButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)
        end
    end
    
    playerList.CanvasSize = UDim2.new(0, 0, 0, playerList.UIListLayout.AbsoluteContentSize.Y)
end

-- Funzioni per gestire i cambiamenti nella lista dei giocatori
local function onPlayerAdded(player)
    updatePlayerList(LocalPlayer.PlayerGui:WaitForChild("ESPControl"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList"))
end

local function onPlayerRemoving(player)
    followEnabled[player] = nil -- Rimuovi il giocatore dalla lista di follow
    updatePlayerList(LocalPlayer.PlayerGui:WaitForChild("ESPControl"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList"))
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return {
    updatePlayerList = updatePlayerList
}