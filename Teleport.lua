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

-- Funzione per aggiornare la lista dei giocatori con pulsanti per teletrasporto e follow
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
            PlayerButton.Size = UDim2.new(1, -10, 0, 40)  -- Regolato per mantenere margini migliori
            PlayerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.TextSize = 16
            PlayerButton.Font = Enum.Font.GothamSemibold
            PlayerButton.TextScaled = true  -- Ridimensiona automaticamente il testo
            PlayerButton.TextWrapped = true -- Evita che il testo esca fuori dal pulsante
            PlayerButton.Parent = playerList
            
            -- Aggiunta di padding interno per evitare che il testo tocchi i bordi
            local TextPadding = Instance.new("UIPadding")
            TextPadding.PaddingLeft = UDim.new(0, 10)
            TextPadding.PaddingRight = UDim.new(0, 10)
            TextPadding.Parent = PlayerButton
            
            -- Bordo arrotondato
            local PlayerButtonCorner = Instance.new("UICorner")
            PlayerButtonCorner.CornerRadius = UDim.new(0, 6)
            PlayerButtonCorner.Parent = PlayerButton
            
            -- Bordo esterno
            local PlayerButtonStroke = Instance.new("UIStroke")
            PlayerButtonStroke.Color = Color3.fromRGB(100, 100, 100)
            PlayerButtonStroke.Thickness = 1
            PlayerButtonStroke.Parent = PlayerButton
            
            -- Evento click per teletrasporto
            PlayerButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)
        end
    end
    
    -- Ridimensiona automaticamente la lista
    playerList.CanvasSize = UDim2.new(0, 0, 0, playerList.UIListLayout.AbsoluteContentSize.Y)
end