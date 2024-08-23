local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character:WaitForChild("Humanoid")
local RootPart = Character:WaitForChild("HumanoidRootPart")

local espEnabled = false
local noClipEnabled = false

local function createGUI()
    local existingGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ESPControl")
    if existingGui then
        existingGui:Destroy()
    end

    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ESPControl"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")

    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 250, 0, 200)
    MainFrame.Position = UDim2.new(0.5, -125, 0.5, -100)
    MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame

    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 30)
    TitleBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame

    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -30, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "UNIHAX"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 18
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.Parent = TitleBar

    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -30, 0, 0)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.SourceSansBold
    CloseButton.Parent = TitleBar

    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 10)
    CloseCorner.Parent = CloseButton

    local function createButton(name, position)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(0.8, 0, 0, 40)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
        Button.Text = "Enable " .. name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 16
        Button.Font = Enum.Font.SourceSansBold
        Button.Parent = MainFrame

        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button

        return Button
    end

    local ESPButton = createButton("ESP", UDim2.new(0.1, 0, 0.2, 0))
    local NoClipButton = createButton("NoClip", UDim2.new(0.1, 0, 0.45, 0))

    -- Dropdown per il teletrasporto
    local TeleportDropdown = Instance.new("TextButton")
    TeleportDropdown.Name = "TeleportDropdown"
    TeleportDropdown.Size = UDim2.new(0.8, 0, 0, 40)
    TeleportDropdown.Position = UDim2.new(0.1, 0, 0.7, 0)
    TeleportDropdown.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
    TeleportDropdown.Text = "Teleport to Player"
    TeleportDropdown.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportDropdown.TextSize = 16
    TeleportDropdown.Font = Enum.Font.SourceSansBold
    TeleportDropdown.Parent = MainFrame

    local DropdownCorner = Instance.new("UICorner")
    DropdownCorner.CornerRadius = UDim.new(0, 8)
    DropdownCorner.Parent = TeleportDropdown

    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Name = "PlayerList"
    PlayerList.Size = UDim2.new(0.8, 0, 0, 0)
    PlayerList.Position = UDim2.new(0.1, 0, 0.85, 0)
    PlayerList.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    PlayerList.BorderSizePixel = 0
    PlayerList.ScrollBarThickness = 4
    PlayerList.Visible = false
    PlayerList.Parent = MainFrame

    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Parent = PlayerList
    PlayerListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    PlayerListLayout.Padding = UDim.new(0, 2)

    local function toggleESP()
        espEnabled = not espEnabled
        ESPButton.Text = espEnabled and "Disable ESP" or "Enable ESP"
        ESPButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(80, 80, 80)

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local character = player.Character
                if character then
                    local highlight = character:FindFirstChild("ESPHighlight")
                    if espEnabled and not highlight then
                        highlight = Instance.new("Highlight")
                        highlight.Name = "ESPHighlight"
                        highlight.FillColor = Color3.fromRGB(255, 0, 0)
                        highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                        highlight.FillTransparency = 0.5
                        highlight.OutlineTransparency = 0
                        highlight.Parent = character
                    elseif not espEnabled and highlight then
                        highlight:Destroy()
                    end
                end
            end
        end
    end

    local function toggleNoClip()
        noClipEnabled = not noClipEnabled
        NoClipButton.Text = noClipEnabled and "Disable NoClip" or "Enable NoClip"
        NoClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(80, 80, 80)

        if noClipEnabled then
            RunService:BindToRenderStep("NoClip", 100, function()
                if Character and Character:IsDescendantOf(workspace) then
                    for _, part in ipairs(Character:GetDescendants()) do
                        if part:IsA("BasePart") then
                            part.CanCollide = false
                        end
                    end
                end
            end)
        else
            RunService:UnbindFromRenderStep("NoClip")
            if Character and Character:IsDescendantOf(workspace) then
                for _, part in ipairs(Character:GetDescendants()) do
                    if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                        part.CanCollide = true
                    end
                end
            end
        end
    end

    local function updatePlayerList()
        for _, child in ipairs(PlayerList:GetChildren()) do
            if child:IsA("TextButton") then
                child:Destroy()
            end
        end

        for _, player in ipairs(Players:GetPlayers()) do
            if player ~= LocalPlayer then
                local PlayerButton = Instance.new("TextButton")
                PlayerButton.Name = player.Name
                PlayerButton.Size = UDim2.new(1, -8, 0, 30)
                PlayerButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
                PlayerButton.Text = player.Name
                PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                PlayerButton.TextSize = 14
                PlayerButton.Font = Enum.Font.SourceSans
                PlayerButton.Parent = PlayerList

                local PlayerButtonCorner = Instance.new("UICorner")
                PlayerButtonCorner.CornerRadius = UDim.new(0, 4)
                PlayerButtonCorner.Parent = PlayerButton

                PlayerButton.MouseButton1Click:Connect(function()
                    local targetCharacter = player.Character
                    if targetCharacter and LocalPlayer.Character then
                        local targetHumanoidRootPart = targetCharacter:FindFirstChild("HumanoidRootPart")
                        local localHumanoidRootPart = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        
                        if targetHumanoidRootPart and localHumanoidRootPart then
                            local tweenInfo = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
                            local tween = TweenService:Create(localHumanoidRootPart, tweenInfo, {CFrame = targetHumanoidRootPart.CFrame})
                            tween:Play()
                        end
                    end
                    PlayerList.Visible = false
                end)
            end
        end

        PlayerList.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y)
    end

    local function togglePlayerList()
        PlayerList.Visible = not PlayerList.Visible
        if PlayerList.Visible then
            updatePlayerList()
            PlayerList:TweenSize(UDim2.new(0.8, 0, 0, 150), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        else
            PlayerList:TweenSize(UDim2.new(0.8, 0, 0, 0), Enum.EasingDirection.Out, Enum.EasingStyle.Quad, 0.3, true)
        end
    end

    ESPButton.MouseButton1Click:Connect(toggleESP)
    NoClipButton.MouseButton1Click:Connect(toggleNoClip)
    TeleportDropdown.MouseButton1Click:Connect(togglePlayerList)

    local dragging
    local dragInput
    local dragStart
    local startPos

    local function update(input)
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    TitleBar.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            dragging = true
            dragStart = input.Position
            startPos = MainFrame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    dragging = false
                end
            end)
        end
    end)

    TitleBar.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            dragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            update(input)
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        ScreenGui.Enabled = false
    end)

    UserInputService.InputBegan:Connect(function(input, gameProcessed)
        if not gameProcessed and input.KeyCode == Enum.KeyCode.RightAlt then
            ScreenGui.Enabled = not ScreenGui.Enabled
        end
    end)

    Players.PlayerAdded:Connect(function(player)
        player.CharacterAdded:Connect(function(character)
            if espEnabled then
                local highlight = Instance.new("Highlight")
                highlight.Name = "ESPHighlight"
                highlight.FillColor = Color3.fromRGB(255, 0, 0)
                highlight.OutlineColor = Color3.fromRGB(255, 255, 0)
                highlight.FillTransparency = 0.5
                highlight.OutlineTransparency = 0
                highlight.Parent = character
            end
        end)
        updatePlayerList()
    end)

    Players.PlayerRemoving:Connect(updatePlayerList)

    ScreenGui.Enabled = true
end

createGUI()