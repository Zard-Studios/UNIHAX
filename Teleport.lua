local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local LocalPlayer = Players.LocalPlayer

local followingPlayer = nil
local followConnection = nil
local followButton = nil

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

local function startFollowing(player, button)
    if followConnection then
        stopFollowing()
    end

    followingPlayer = player
    followButton = button
    followConnection = RunService.Heartbeat:Connect(function()
        if followingPlayer and followingPlayer.Character then
            teleportToPlayer(followingPlayer)
        else
            stopFollowing()
        end
    end)

    if followButton then
        followButton.Text = "Stop"
        followButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    end
end

local function stopFollowing()
    if followConnection then
        followConnection:Disconnect()
        followConnection = nil
    end
    if followButton then
        followButton.Text = "Follow"
        followButton.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    end
    followingPlayer = nil
    followButton = nil
end

local function createStylishButton(parent, text, position, size)
    local Button = Instance.new("TextButton")
    Button.Name = text .. "Button"
    Button.Size = size or UDim2.new(0, 80, 1, -4)
    Button.Position = position
    Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Button.Text = text
    Button.TextColor3 = Color3.fromRGB(255, 255, 255)
    Button.TextSize = 12
    Button.Font = Enum.Font.GothamSemibold
    Button.Parent = parent
    Button.AutoButtonColor = false

    local ButtonCorner = Instance.new("UICorner")
    ButtonCorner.CornerRadius = UDim.new(0, 4)
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
            PlayerFrame.Size = UDim2.new(1, -10, 0, 30)
            PlayerFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            PlayerFrame.BorderSizePixel = 0
            PlayerFrame.Parent = playerList

            local PlayerFrameCorner = Instance.new("UICorner")
            PlayerFrameCorner.CornerRadius = UDim.new(0, 4)
            PlayerFrameCorner.Parent = PlayerFrame

            local PlayerName = Instance.new("TextLabel")
            PlayerName.Name = "PlayerName"
            PlayerName.Size = UDim2.new(0.4, -5, 1, 0)
            PlayerName.Position = UDim2.new(0, 5, 0, 0)
            PlayerName.BackgroundTransparency = 1
            PlayerName.Text = player.Name
            PlayerName.TextColor3 = Color3.fromRGB(255, 255, 255)
            PlayerName.TextSize = 14
            PlayerName.Font = Enum.Font.GothamSemibold
            PlayerName.TextXAlignment = Enum.TextXAlignment.Left
            PlayerName.TextTruncate = Enum.TextTruncate.AtEnd
            PlayerName.Parent = PlayerFrame

            local TeleportButton = createStylishButton(PlayerFrame, "Teleport", UDim2.new(0.4, 5, 0, 2))
            local FollowButton = createStylishButton(PlayerFrame, "Follow", UDim2.new(0.7, 5, 0, 2))

            TeleportButton.MouseButton1Click:Connect(function()
                teleportToPlayer(player)
            end)

            FollowButton.MouseButton1Click:Connect(function()
                if followingPlayer == player then
                    stopFollowing()
                else
                    startFollowing(player, FollowButton)
                end
            end)

            if followingPlayer == player then
                FollowButton.Text = "Stop"
                FollowButton.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
                followButton = FollowButton
            end
        end
    end

    playerList.CanvasSize = UDim2.new(0, 0, 0, playerList.UIListLayout.AbsoluteContentSize.Y)
end

local function onPlayerAdded(player)
    updatePlayerList(LocalPlayer.PlayerGui:WaitForChild("ESPControl"):WaitForChild("MainFrame"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList"))
end

local function onPlayerRemoving(player)
    if followingPlayer == player then
        stopFollowing()
    end
    updatePlayerList(LocalPlayer.PlayerGui:WaitForChild("ESPControl"):WaitForChild("MainFrame"):WaitForChild("TeleportFrame"):WaitForChild("PlayerList"))
end

Players.PlayerAdded:Connect(onPlayerAdded)
Players.PlayerRemoving:Connect(onPlayerRemoving)

return {
    updatePlayerList = updatePlayerList,
    stopFollowing = stopFollowing
}