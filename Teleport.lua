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

local function createStylishButton(parent, text, position, size)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = size or UDim2.new(0.45, 0, 1, -10)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 14
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = parent

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 6)
    ButtonCorner.Parent = Button

    local ButtonStroke = Instance.new("UIStroke")
    ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
    ButtonStroke.Thickness = 1
    ButtonStroke.Parent = Button

    return Button
end

local function updatePlayerList(playerList)
    for _, child in ipairs(playerList:GetChildren()) do
        if child:IsA("Frame") then
            child:Destroy()
        end
    end

    for _, player in ipairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local PlayerFrame = Instance.new("Frame")
            PlayerFrame.Name = player.Name .. "Frame"
            PlayerFrame.Size = UDim2.new(1, -10, 0, 60)
            PlayerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            PlayerFrame.BorderSizePixel = 0
            PlayerFrame.Parent = playerList

            local PlayerFrameCorner = Instance.new("UICorner")
            PlayerFrameCorner.CornerRadius = UDim.new(0, 8)
            PlayerFrameCorner.Parent = PlayerFrame

            local PlayerName = Instance.new("TextLabel")
            PlayerName.Name = "PlayerName"
            PlayerName.Size = UDim2.new(1, -10, 0, 30)
            PlayerName.Position = UDim2.new(0, 10, 0, 5)
            PlayerName.BackgroundTransparency = 1
            PlayerName.Text = player.Name
            PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerName.TextSize = 18
            PlayerName.Font = Enum.Font.GothamSemibold
            PlayerName.TextXAlignment = Enum.TextXAlignment.Left
            PlayerName.Parent = PlayerFrame

            local TeleportButton = createStylishButton(PlayerFrame, "Teleport", UDim2.new(0, 10, 1, -35), UDim2.new(0.45, -15, 0, 30))
            local FollowButton = createStylishButton(PlayerFrame, "Follow", UDim2.new(0.55, 5, 1, -35), UDim2.new(0.45, -15, 0, 30))

            TeleportButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)

            FollowButton.MouseButton1Click:Connect(function()
                if followingPlayer == player then
                    stopFollowing()
                    FollowButton.Text = "Follow"
                    FollowButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
                else
                    startFollowing(player)
                    FollowButton.Text = "Stop Following"
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