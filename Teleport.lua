local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

-- Funzione per teletrasportarsi a un altro giocatore
local function teleportToPlayer(player)
    local targetCharacter = player.Character
    if targetCharacter and targetCharacter:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character:SetPrimaryPartCFrame(targetCharacter.HumanoidRootPart.CFrame)
    end
end

-- Funzione per aggiornare la lista dei giocatori nell'interfaccia grafica
local function updatePlayerList()
    local playerList = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ESPControl"):WaitForChild("MainFrame"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList")
    playerList:ClearAllChildren()
    
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local Button = Instance.new("TextButton")
            Button.Name = player.Name
            Button.Size = UDim2.new(1, 0, 0, 30)
            Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Button.TextColor3 = Color3.fromRGB(255, 255, 255)
            Button.TextSize = 16
            Button.Font = Enum.Font.GothamSemibold
            Button.Text = player.Name
            Button.TextWrapped = true
            Button.Parent = playerList
            
            local ButtonCorner = Instance.new("UICorner")
            ButtonCorner.CornerRadius = UDim.new(0, 8)
            ButtonCorner.Parent = Button
            
            local ButtonStroke = Instance.new("UIStroke")
            ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
            ButtonStroke.Thickness = 2
            ButtonStroke.Parent = Button

            -- Collegamento del teletrasporto al click sul pulsante
            Button.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)
        end
    end
end

-- Funzione per mostrare o nascondere il frame del teletrasporto
local function toggleTeleportFrame()
    local mainFrame = LocalPlayer:WaitForChild("PlayerGui"):WaitForChild("ESPControl"):WaitForChild("MainFrame")
    local teleportFrame = mainFrame:FindFirstChild("TeleportFrame")
    if teleportFrame then
        teleportFrame.Visible = not teleportFrame.Visible
    end
end

-- Collegamento delle funzioni agli eventi di gioco
Players.PlayerAdded:Connect(updatePlayerList)
Players.PlayerRemoving:Connect(updatePlayerList)
updatePlayerList()

-- Esportazione delle funzioni per poterle utilizzare nell'interfaccia grafica
return {
    updatePlayerList = updatePlayerList,
    toggleTeleportFrame = toggleTeleportFrame
}