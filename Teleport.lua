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
    -- Pulisci la lista
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    -- Aggiungi i giocatori alla lista con pulsanti per Teleport e Follow
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerFrame = Instance.new("Frame")
            PlayerFrame.Name = player.Name
            PlayerFrame.Size = UDim2.new(1, -10, 0, 40)
            PlayerFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            PlayerFrame.Parent = playerList

            -- Pulsante per Teletrasporto
            local TeleportButton = Instance.new("TextButton")
            TeleportButton.Name = "TeleportButton"
            TeleportButton.Size = UDim2.new(0.5, -5, 1, 0)
            TeleportButton.Position = UDim2.new(0, 0, 0, 0)
            TeleportButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            TeleportButton.Text = "Teleport to " .. player.Name
            TeleportButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            TeleportButton.TextSize = 16
            TeleportButton.Font = Enum.Font.GothamSemibold
            TeleportButton.Parent = PlayerFrame

            -- Pulsante per Follow
            local FollowButton = Instance.new("TextButton")
            FollowButton.Name = "FollowButton"
            FollowButton.Size = UDim2.new(0.5, -5, 1, 0)
            FollowButton.Position = UDim2.new(0.5, 5, 0, 0)
            FollowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            FollowButton.Text = followEnabled[player] and "Unfollow" or "Follow"
            FollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            FollowButton.TextSize = 16
            FollowButton.Font = Enum.Font.GothamSemibold
            FollowButton.Parent = PlayerFrame

            -- Azione del pulsante Teleport
            TeleportButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)

            -- Azione del pulsante Follow
            FollowButton.MouseButton1Click:Connect(function()
                followEnabled[player] = not followEnabled[player] -- Inverti lo stato di follow
                FollowButton.Text = followEnabled[player] and "Unfollow" or "Follow"
                
                if followEnabled[player] then
                    -- Inizia a seguire il giocatore
                    if not followConnection then
                        followConnection = RunService.Heartbeat:Connect(function()
                            if followEnabled[player] then
                                teleportToPlayer(player)
                            else
                                followConnection:Disconnect()
                                followConnection = nil
                            end
                        end)
                    end
                else
                    -- Interrompi il follow se disattivato
                    if followConnection then
                        followConnection:Disconnect()
                        followConnection = nil
                    end
                end
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