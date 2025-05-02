local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local Humanoid = Character and Character:WaitForChild("Humanoid")
local RootPart = Character and Character:WaitForChild("HumanoidRootPart")

-- Funzione per aggiornare i riferimenti al personaggio quando riappare
local function updateCharacterReferences(newCharacter)
    Character = newCharacter
    Humanoid = Character:WaitForChild("Humanoid")
    RootPart = Character:WaitForChild("HumanoidRootPart")
end

-- Connessione all'evento CharacterAdded per aggiornare i riferimenti quando il personaggio riappare
LocalPlayer.CharacterAdded:Connect(updateCharacterReferences)
local espEnabled = false
local noClipEnabled = false

local function createGUI()
    local existingGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ESPControl")
    if existingGui then
        existingGui:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ESPControl"
    ScreenGui.Parent = game:GetService("CoreGui") or LocalPlayer:WaitForChild("PlayerGui")
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.DisplayOrder = 999
    
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 300, 0, 400)
    MainFrame.Position = UDim2.new(0.5, -150, 0.5, -200)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Parent = ScreenGui
    
    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 10)
    Corner.Parent = MainFrame
    
    local TitleBar = Instance.new("Frame")
    TitleBar.Name = "TitleBar"
    TitleBar.Size = UDim2.new(1, 0, 0, 40)
    TitleBar.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TitleBar.BorderSizePixel = 0
    TitleBar.Parent = MainFrame
    
    local TitleCorner = Instance.new("UICorner")
    TitleCorner.CornerRadius = UDim.new(0, 10)
    TitleCorner.Parent = TitleBar
    
    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Name = "TitleLabel"
    TitleLabel.Size = UDim2.new(1, -40, 1, 0)
    TitleLabel.Position = UDim2.new(0, 10, 0, 0)
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Text = "UNIHAX"
    TitleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TitleLabel.TextSize = 22
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.Parent = TitleBar
    
    local MinimizeButton = Instance.new("TextButton")
    MinimizeButton.Name = "MinimizeButton"
    MinimizeButton.Size = UDim2.new(0, 30, 0, 30)
    MinimizeButton.Position = UDim2.new(1, -70, 0, 5)
    MinimizeButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
    MinimizeButton.Text = "-"
    MinimizeButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizeButton.TextSize = 18
    MinimizeButton.Font = Enum.Font.GothamBold
    MinimizeButton.Parent = TitleBar
    
    local MinimizeCorner = Instance.new("UICorner")
    MinimizeCorner.CornerRadius = UDim.new(0, 8)
    MinimizeCorner.Parent = MinimizeButton
    
    local CloseButton = Instance.new("TextButton")
    CloseButton.Name = "CloseButton"
    CloseButton.Size = UDim2.new(0, 30, 0, 30)
    CloseButton.Position = UDim2.new(1, -35, 0, 5)
    CloseButton.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    CloseButton.Text = "X"
    CloseButton.TextColor3 = Color3.fromRGB(255, 255, 255)
    CloseButton.TextSize = 18
    CloseButton.Font = Enum.Font.GothamBold
    CloseButton.Parent = TitleBar
    
    local CloseCorner = Instance.new("UICorner")
    CloseCorner.CornerRadius = UDim.new(0, 8)
    CloseCorner.Parent = CloseButton
    
    -- Crea il frame minimizzato (inizialmente nascosto)
    local MinimizedFrame = Instance.new("Frame")
    MinimizedFrame.Name = "MinimizedFrame"
    MinimizedFrame.Size = UDim2.new(0, 50, 0, 50)
    MinimizedFrame.Position = UDim2.new(1, -60, 1, -60)
    MinimizedFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    MinimizedFrame.BorderSizePixel = 0
    MinimizedFrame.Visible = false
    MinimizedFrame.Parent = ScreenGui
    
    local MinimizedCorner = Instance.new("UICorner")
    MinimizedCorner.CornerRadius = UDim.new(0, 10)
    MinimizedCorner.Parent = MinimizedFrame
    
    local MinimizedIcon = Instance.new("TextLabel")
    MinimizedIcon.Name = "MinimizedIcon"
    MinimizedIcon.Size = UDim2.new(1, 0, 1, 0)
    MinimizedIcon.BackgroundTransparency = 1
    MinimizedIcon.Text = "UH"
    MinimizedIcon.TextColor3 = Color3.fromRGB(255, 255, 255)
    MinimizedIcon.TextSize = 20
    MinimizedIcon.Font = Enum.Font.GothamBold
    MinimizedIcon.Parent = MinimizedFrame
    
    local function createButton(name, position)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(0.9, 0, 0, 50)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        Button.Text = "Enable " .. name
        Button.TextColor3 = Color3.fromRGB(255, 255, 255)
        Button.TextSize = 18
        Button.Font = Enum.Font.GothamSemibold
        Button.Parent = MainFrame
        
        local ButtonCorner = Instance.new("UICorner")
        ButtonCorner.CornerRadius = UDim.new(0, 8)
        ButtonCorner.Parent = Button
        
        local ButtonStroke = Instance.new("UIStroke")
        ButtonStroke.Color = Color3.fromRGB(100, 100, 100)
        ButtonStroke.Thickness = 2
        ButtonStroke.Parent = Button
        
        return Button
    end
    
    local ESPButton = createButton("ESP", UDim2.new(0.05, 0, 0.15, 0))
    local NoClipButton = createButton("NoClip", UDim2.new(0.05, 0, 0.3, 0))
    local TeleportButton = createButton("Teleport", UDim2.new(0.05, 0, 0.45, 0))
    
    local TeleportFrame = Instance.new("Frame")
    TeleportFrame.Name = "TeleportFrame"
    TeleportFrame.Size = UDim2.new(0.9, 0, 0.4, 0)
    TeleportFrame.Position = UDim2.new(0.05, 0, 0.6, 0)
    TeleportFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TeleportFrame.BorderSizePixel = 0
    TeleportFrame.Visible = false
    TeleportFrame.Parent = MainFrame
    
    local TeleportCorner = Instance.new("UICorner")
    TeleportCorner.CornerRadius = UDim.new(0, 8)
    TeleportCorner.Parent = TeleportFrame
    
    local TeleportLabel = Instance.new("TextLabel")
    TeleportLabel.Name = "TeleportLabel"
    TeleportLabel.Size = UDim2.new(1, 0, 0, 30)
    TeleportLabel.BackgroundTransparency = 1
    TeleportLabel.Text = "Teleport to Player"
    TeleportLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TeleportLabel.TextSize = 18
    TeleportLabel.Font = Enum.Font.GothamSemibold
    TeleportLabel.Parent = TeleportFrame
    
    local PlayerList = Instance.new("ScrollingFrame")
    PlayerList.Name = "PlayerList"
    PlayerList.Size = UDim2.new(1, -20, 1, -40)
    PlayerList.Position = UDim2.new(0, 10, 0, 35)
    PlayerList.BackgroundTransparency = 1
    PlayerList.BorderSizePixel = 0
    PlayerList.ScrollBarThickness = 6
    PlayerList.Parent = TeleportFrame
    
    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Parent = PlayerList
    PlayerListLayout.SortOrder = Enum.SortOrder.Name
    PlayerListLayout.Padding = UDim.new(0, 5)
    
    local function toggleESP()
        espEnabled = not espEnabled
        ESPButton.Text = espEnabled and "Disable ESP" or "Enable ESP"
        ESPButton.BackgroundColor3 = espEnabled and Color3.fromRGB(0, 170, 255) or Color3.fromRGB(60, 60, 60)
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
        NoClipButton.BackgroundColor3 = noClipEnabled and Color3.fromRGB(0, 255, 0) or Color3.fromRGB(60, 60, 60)
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
                PlayerButton.Size = UDim2.new(1, -10, 0, 40)
                PlayerButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
                PlayerButton.Text = player.Name
                PlayerButton.TextColor3 = Color3.fromRGB(255, 255, 255)
                PlayerButton.TextSize = 16
                PlayerButton.Font = Enum.Font.GothamSemibold
                PlayerButton.Parent = PlayerList
                
                local PlayerButtonCorner = Instance.new("UICorner")
                PlayerButtonCorner.CornerRadius = UDim.new(0, 6)
                PlayerButtonCorner.Parent = PlayerButton
                
                local PlayerButtonStroke = Instance.new("UIStroke")
                PlayerButtonStroke.Color = Color3.fromRGB(100, 100, 100)
                PlayerButtonStroke.Thickness = 1
                PlayerButtonStroke.Parent = PlayerButton
                
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
                end)
            end
        end
        PlayerList.CanvasSize = UDim2.new(0, 0, 0, PlayerListLayout.AbsoluteContentSize.Y)
    end
    
    ESPButton.MouseButton1Click:Connect(toggleESP)
    NoClipButton.MouseButton1Click:Connect(toggleNoClip)
    TeleportButton.MouseButton1Click:Connect(function()
        TeleportFrame.Visible = not TeleportFrame.Visible
        updatePlayerList()
    end)
    
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
    
    -- Funzione per minimizzare la finestra
    local function minimizeWindow()
        MainFrame.Visible = false
        MinimizedFrame.Visible = true
    end
    
    -- Funzione per ripristinare la finestra
    local function restoreWindow()
        MainFrame.Visible = true
        MinimizedFrame.Visible = false
    end
    
    MinimizeButton.MouseButton1Click:Connect(minimizeWindow)
    -- Aggiungi la possibilità di trascinare il frame minimizzato
    local minimizedDragging
    local minimizedDragInput
    local minimizedDragStart
    local minimizedStartPos
    
    local function updateMinimizedPosition(input)
        local delta = input.Position - minimizedDragStart
        MinimizedFrame.Position = UDim2.new(minimizedStartPos.X.Scale, minimizedStartPos.X.Offset + delta.X, minimizedStartPos.Y.Scale, minimizedStartPos.Y.Offset + delta.Y)
    end
    
    MinimizedFrame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            local clickDuration = 0
            local connection
            
            minimizedDragging = true
            minimizedDragStart = input.Position
            minimizedStartPos = MinimizedFrame.Position
            
            connection = RunService.Heartbeat:Connect(function()
                clickDuration = clickDuration + RunService.Heartbeat:Wait()
                if clickDuration >= 0.3 then
                    connection:Disconnect()
                end
            end)
            
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    minimizedDragging = false
                    if clickDuration < 0.3 then
                        restoreWindow()
                    end
                    if connection then connection:Disconnect() end
                end
            end)
        end
    end)
    
    MinimizedFrame.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement then
            minimizedDragInput = input
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if input == minimizedDragInput and minimizedDragging then
            updateMinimizedPosition(input)
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