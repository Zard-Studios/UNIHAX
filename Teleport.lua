local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local function teleportToPlayer(player)
    local targetCharacter = player.Character
    if targetCharacter and LocalPlayer.Character then
        local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
        local localHumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
        
        if targetHumanoidRootPart and localHumanoidRootPart then
            -- Teletrasporto istantaneo
            localHumanoidRootPart.CFrame = targetHumanoidRootPart.CFrame
        end
    end
end

local function updatePlayerList(playerList)
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("TextButton") then
            child:Destroy()
        end
    end
    
    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerButton = Instance.new("TextButton")
            PlayerButton.Name = player.Name
            PlayerButton.Size = UDim2.new(1, -10, 0, 40)
            PlayerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
            PlayerButton.Text = player.Name
            PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerButton.TextSize = 16
            PlayerButton.Font = Enum.Font.GothamSemibold
            PlayerButton.Parent = playerList
            
            local PlayerButtonCorner = Instance.new("UICorner")
            PlayerButtonCorner.CornerRadius = UDim.new(0, 6)
            PlayerButtonCorner.Parent = PlayerButton
            
            local PlayerButtonStroke = Instance.new("UIStroke")
            PlayerButtonStroke.Color = Color3.fromRGB(100, 100, 100)
            PlayerButtonStroke.Thickness = 1
            PlayerButtonStroke.Parent = PlayerButton
            
            PlayerButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)
        end
    end
    
    playerList.CanvasSize = UDim2.new(0, 0, 0, playerList.UIListLayout.AbsoluteContentSize.Y)
end

-- Assicurati che playerList sia visibile e correttamente definito
local function onPlayerAdded(player)
    if player ~= LocalPlayer then
        updatePlayerList(LocalPlayer.PlayerGui:WaitForChild("ESPControl"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList"))
    end
end

local function onPlayerRemoving(player)
    updatePlayerList(LocalPlayer.PlayerGui:WaitForChild("ESPControl"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList"))
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return {
    updatePlayerList = updatePlayerList
}