local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local followingPlayer = nil
local followConnection = nil

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

local function startFollowing(player)
    if followConnection then
        followConnection:Disconnect()
    end

    followingPlayer = player
    followConnection = RunService.Heartbeat:Connect(function()
        if followingPlayer and followingPlayer.Character then
            teleportToPlayer(followingPlayer)
        end
    end)
end

local function stopFollowing()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    followingPlayer = nil
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

            local FollowButton = Instance.new("TextButton")
            FollowButton.Name = "FollowButton"
            FollowButton.Size = UDim2.new(0, 60, 1, -10)
            FollowButton.Position = UDim2.new(1, -65, 0, 5)
            FollowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
            FollowButton.Text = "Follow"
            FollowButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            FollowButton.TextSize = 14
            FollowButton.Font = Enum.Font.GothamSemibold
            FollowButton.Parent = PlayerButton

            local FollowButtonCorner = Instance.new("UICorner")
            FollowButtonCorner.CornerRadius = UDim.new(0, 4)
            FollowButtonCorner.Parent = FollowButton

            PlayerButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)

            FollowButton.MouseButton1Click:Connect(function()
                if followingPlayer == player then
                    stopFollowing()
                    FollowButton.Text = "Follow"
                    FollowButton.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
                else
                    startFollowing(player)
                    FollowButton.Text = "Stop"
                    FollowButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                end
            end)
        end
    end

    playerList.CanvasSize = UDim2.new(0, 0, 0, playerList.UIListLayout.AbsoluteContentSize.Y)
end

local function onPlayerAdded(player)
    updatePlayerList(LocalPlayer.PlayerGui:WaitForChild("ESPControl"):WaitForChild("MainFrame"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList"))
end

local function onPlayerRemoving(player)
    updatePlayerList(LocalPlayer.PlayerGui:WaitForChild("ESPControl"):WaitForChild("MainFrame"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList"))
    if followingPlayer == player then
        stopFollowing()
    end
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return {
    updatePlayerList = updatePlayerList,
    stopFollowing = stopFollowing
}