local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer

-- Variabili globali per le impostazioni
local espOpacity = 0.5
local espColor = Color3.fromRGB(255, 0, 0)
local flySpeed = 50

local function createGUI()
    local existingGui = LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("ESPControl")
    if existingGui then
        existingGui:Destroy()
    end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ESPControl"
    ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
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
    
    local function createButton(name, position, hasGear)
        local Button = Instance.new("TextButton")
        Button.Name = name
        Button.Size = UDim2.new(0.9, 0, 0, 50)
        Button.Position = position
        Button.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        
        -- Cambia il testo per il pulsante Spin
        local displayName = name == "CharacterSpin" and "Spin" or name
        Button.Text = "Enable " .. displayName
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
        
        -- Aggiungi ingranaggio se necessario
        if hasGear then
            local GearButton = Instance.new("TextButton")
            GearButton.Name = name .. "Gear"
            GearButton.Size = UDim2.new(0, 40, 0, 40)
            GearButton.Position = UDim2.new(1, -45, 0.5, -20)
            GearButton.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
            GearButton.Text = "⚙️"
            GearButton.TextColor3 = Color3.fromRGB(255, 255, 255)
            GearButton.TextSize = 20
            GearButton.Font = Enum.Font.GothamBold
            GearButton.Parent = Button
            
            local GearCorner = Instance.new("UICorner")
            GearCorner.CornerRadius = UDim.new(0, 6)
            GearCorner.Parent = GearButton
            
            local GearStroke = Instance.new("UIStroke")
            GearStroke.Color = Color3.fromRGB(120, 120, 120)
            GearStroke.Thickness = 1
            GearStroke.Parent = GearButton
        end
        
        return Button
    end
    
    local ESPButton = createButton("ESP", UDim2.new(0.05, 0, 0.15, 0), true)
    local NoClipButton = createButton("NoClip", UDim2.new(0.05, 0, 0.3, 0), false)
    local TeleportButton = createButton("Teleport", UDim2.new(0.05, 0, 0.45, 0), false)
    local FlyButton = createButton("Fly", UDim2.new(0.05, 0, 0.6, 0), true)
    local SpinButton = createButton("CharacterSpin", UDim2.new(0.05, 0, 0.75, 0), false)
    
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
    PlayerList.ScrollBarThickness = 8
    PlayerList.ScrollBarImageColor3 = Color3.fromRGB(150, 150, 150)
    PlayerList.Parent = TeleportFrame
    
    local PlayerListLayout = Instance.new("UIListLayout")
    PlayerListLayout.Parent = PlayerList
    PlayerListLayout.SortOrder = Enum.SortOrder.Name
    PlayerListLayout.Padding = UDim.new(0, 5)
    
    local PlayerPadding = Instance.new("UIPadding")
    PlayerPadding.PaddingTop = UDim.new(0, 5)
    PlayerPadding.PaddingLeft = UDim.new(0, 5)
    PlayerPadding.PaddingRight = UDim.new(0, 5)
    PlayerPadding.Parent = PlayerList
    
    -- ESP Settings Frame
    local ESPSettingsFrame = Instance.new("Frame")
    ESPSettingsFrame.Name = "ESPSettingsFrame"
    ESPSettingsFrame.Size = UDim2.new(0, 250, 0, 200)
    ESPSettingsFrame.Position = UDim2.new(1, 10, 0, 0)
    ESPSettingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    ESPSettingsFrame.BorderSizePixel = 0
    ESPSettingsFrame.Visible = false
    ESPSettingsFrame.Parent = MainFrame
    
    local ESPSettingsCorner = Instance.new("UICorner")
    ESPSettingsCorner.CornerRadius = UDim.new(0, 8)
    ESPSettingsCorner.Parent = ESPSettingsFrame
    
    local ESPSettingsTitle = Instance.new("TextLabel")
    ESPSettingsTitle.Name = "Title"
    ESPSettingsTitle.Size = UDim2.new(1, 0, 0, 30)
    ESPSettingsTitle.BackgroundTransparency = 1
    ESPSettingsTitle.Text = "ESP Settings"
    ESPSettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    ESPSettingsTitle.TextSize = 16
    ESPSettingsTitle.Font = Enum.Font.GothamBold
    ESPSettingsTitle.Parent = ESPSettingsFrame
    
    -- Opacity Slider
    local OpacityLabel = Instance.new("TextLabel")
    OpacityLabel.Size = UDim2.new(1, -20, 0, 25)
    OpacityLabel.Position = UDim2.new(0, 10, 0, 40)
    OpacityLabel.BackgroundTransparency = 1
    OpacityLabel.Text = "Opacity: 50%"
    OpacityLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    OpacityLabel.TextSize = 14
    OpacityLabel.Font = Enum.Font.Gotham
    OpacityLabel.Parent = ESPSettingsFrame
    
    local OpacitySlider = Instance.new("Frame")
    OpacitySlider.Size = UDim2.new(1, -20, 0, 20)
    OpacitySlider.Position = UDim2.new(0, 10, 0, 70)
    OpacitySlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    OpacitySlider.Parent = ESPSettingsFrame
    
    local OpacitySliderCorner = Instance.new("UICorner")
    OpacitySliderCorner.CornerRadius = UDim.new(0, 10)
    OpacitySliderCorner.Parent = OpacitySlider
    
    local OpacityHandle = Instance.new("TextButton")
    OpacityHandle.Size = UDim2.new(0, 20, 1, 0)
    OpacityHandle.Position = UDim2.new(0.5, -10, 0, 0)
    OpacityHandle.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    OpacityHandle.Text = ""
    OpacityHandle.Parent = OpacitySlider
    
    local OpacityHandleCorner = Instance.new("UICorner")
    OpacityHandleCorner.CornerRadius = UDim.new(0, 10)
    OpacityHandleCorner.Parent = OpacityHandle
    
    -- Color Buttons
    local ColorLabel = Instance.new("TextLabel")
    ColorLabel.Size = UDim2.new(1, -20, 0, 25)
    ColorLabel.Position = UDim2.new(0, 10, 0, 100)
    ColorLabel.BackgroundTransparency = 1
    ColorLabel.Text = "Color:"
    ColorLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    ColorLabel.TextSize = 14
    ColorLabel.Font = Enum.Font.Gotham
    ColorLabel.Parent = ESPSettingsFrame
    
    local ColorFrame = Instance.new("Frame")
    ColorFrame.Size = UDim2.new(1, -20, 0, 40)
    ColorFrame.Position = UDim2.new(0, 10, 0, 130)
    ColorFrame.BackgroundTransparency = 1
    ColorFrame.Parent = ESPSettingsFrame
    
    local ColorLayout = Instance.new("UIListLayout")
    ColorLayout.FillDirection = Enum.FillDirection.Horizontal
    ColorLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ColorLayout.Padding = UDim.new(0, 5)
    ColorLayout.Parent = ColorFrame
    
    local colors = {
        {Color3.fromRGB(255, 0, 0), "Red"},
        {Color3.fromRGB(0, 255, 0), "Green"},
        {Color3.fromRGB(0, 0, 255), "Blue"},
        {Color3.fromRGB(255, 255, 0), "Yellow"},
        {Color3.fromRGB(255, 0, 255), "Purple"}
    }
    
    -- Creo i pulsanti colore e salvo i riferimenti
    local colorButtons = {}
    for i, colorData in ipairs(colors) do
        local ColorButton = Instance.new("TextButton")
        ColorButton.Size = UDim2.new(0, 35, 0, 35)
        ColorButton.BackgroundColor3 = colorData[1]
        ColorButton.Text = ""
        ColorButton.Parent = ColorFrame
        
        local ColorButtonCorner = Instance.new("UICorner")
        ColorButtonCorner.CornerRadius = UDim.new(0, 6)
        ColorButtonCorner.Parent = ColorButton
        
        local ColorButtonStroke = Instance.new("UIStroke")
        ColorButtonStroke.Color = Color3.fromRGB(255, 255, 255)
        ColorButtonStroke.Thickness = 2
        ColorButtonStroke.Parent = ColorButton
        
        -- Salvo il riferimento e aggiungo il click handler
        colorButtons[i] = ColorButton
        ColorButton.MouseButton1Click:Connect(function()
            espColor = colorData[1]
            -- Reset tutti i bordi
            for _, btn in pairs(colorButtons) do
                local stroke = btn:FindFirstChild("UIStroke")
                if stroke then
                    stroke.Color = Color3.fromRGB(255, 255, 255)
                    stroke.Thickness = 2
                end
            end
            -- Evidenzia il colore selezionato
            local selectedStroke = ColorButton:FindFirstChild("UIStroke")
            if selectedStroke then
                selectedStroke.Color = Color3.fromRGB(0, 255, 0)
                selectedStroke.Thickness = 3
            end
        end)
    end
    
    -- Fly Settings Frame
    local FlySettingsFrame = Instance.new("Frame")
    FlySettingsFrame.Name = "FlySettingsFrame"
    FlySettingsFrame.Size = UDim2.new(0, 250, 0, 120)
    FlySettingsFrame.Position = UDim2.new(1, 10, 0, 0)
    FlySettingsFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    FlySettingsFrame.BorderSizePixel = 0
    FlySettingsFrame.Visible = false
    FlySettingsFrame.Parent = MainFrame
    
    local FlySettingsCorner = Instance.new("UICorner")
    FlySettingsCorner.CornerRadius = UDim.new(0, 8)
    FlySettingsCorner.Parent = FlySettingsFrame
    
    local FlySettingsTitle = Instance.new("TextLabel")
    FlySettingsTitle.Name = "Title"
    FlySettingsTitle.Size = UDim2.new(1, 0, 0, 30)
    FlySettingsTitle.BackgroundTransparency = 1
    FlySettingsTitle.Text = "Fly Settings"
    FlySettingsTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    FlySettingsTitle.TextSize = 16
    FlySettingsTitle.Font = Enum.Font.GothamBold
    FlySettingsTitle.Parent = FlySettingsFrame
    
    -- Speed Slider
    local SpeedLabel = Instance.new("TextLabel")
    SpeedLabel.Size = UDim2.new(1, -20, 0, 25)
    SpeedLabel.Position = UDim2.new(0, 10, 0, 40)
    SpeedLabel.BackgroundTransparency = 1
    SpeedLabel.Text = "Speed: 50"
    SpeedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    SpeedLabel.TextSize = 14
    SpeedLabel.Font = Enum.Font.Gotham
    SpeedLabel.Parent = FlySettingsFrame
    
    local SpeedSlider = Instance.new("Frame")
    SpeedSlider.Size = UDim2.new(1, -20, 0, 20)
    SpeedSlider.Position = UDim2.new(0, 10, 0, 70)
    SpeedSlider.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    SpeedSlider.Parent = FlySettingsFrame
    
    local SpeedSliderCorner = Instance.new("UICorner")
    SpeedSliderCorner.CornerRadius = UDim.new(0, 10)
    SpeedSliderCorner.Parent = SpeedSlider
    
    local SpeedHandle = Instance.new("TextButton")
    SpeedHandle.Size = UDim2.new(0, 20, 1, 0)
    SpeedHandle.Position = UDim2.new(0.5, -10, 0, 0)
    SpeedHandle.BackgroundColor3 = Color3.fromRGB(255, 165, 0)
    SpeedHandle.Text = ""
    SpeedHandle.Parent = SpeedSlider
    
    local SpeedHandleCorner = Instance.new("UICorner")
    SpeedHandleCorner.CornerRadius = UDim.new(0, 10)
    SpeedHandleCorner.Parent = SpeedHandle
    
    -- Funzioni per gestire gli slider (usano le variabili globali)
    local function updateOpacitySlider(value)
        espOpacity = math.clamp(value, 0, 1)
        OpacityHandle.Position = UDim2.new(espOpacity, -10, 0, 0)
        OpacityLabel.Text = "Opacity: " .. math.floor(espOpacity * 100) .. "%"
    end
    
    local function updateSpeedSlider(value)
        flySpeed = math.clamp(value, 10, 100)
        local normalizedValue = (flySpeed - 10) / 90
        SpeedHandle.Position = UDim2.new(normalizedValue, -10, 0, 0)
        SpeedLabel.Text = "Speed: " .. flySpeed
    end
    
    -- Gestione drag per opacity slider
    local opacityDragging = false
    OpacityHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            opacityDragging = true
        end
    end)
    
    OpacityHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            opacityDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if opacityDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local sliderPosition = OpacitySlider.AbsolutePosition.X
            local sliderSize = OpacitySlider.AbsoluteSize.X
            local mouseX = input.Position.X
            local relativeX = (mouseX - sliderPosition) / sliderSize
            updateOpacitySlider(math.clamp(relativeX, 0, 1))
        end
    end)
    
    -- Gestione drag per speed slider
    local speedDragging = false
    SpeedHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            speedDragging = true
        end
    end)
    
    SpeedHandle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            speedDragging = false
        end
    end)
    
    UserInputService.InputChanged:Connect(function(input)
        if speedDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
            local sliderPosition = SpeedSlider.AbsolutePosition.X
            local sliderSize = SpeedSlider.AbsoluteSize.X
            local mouseX = input.Position.X
            local relativeX = (mouseX - sliderPosition) / sliderSize
            local newSpeed = 10 + (relativeX * 90)
            updateSpeedSlider(newSpeed)
        end
    end)
    

    
    -- Gestione click degli ingranaggi
    local ESPGear = ESPButton:FindFirstChild("ESPGear")
    if ESPGear then
        ESPGear.MouseButton1Click:Connect(function()
            ESPSettingsFrame.Visible = not ESPSettingsFrame.Visible
            FlySettingsFrame.Visible = false -- Chiudi l'altro pannello
        end)
    end
    
    local FlyGear = FlyButton:FindFirstChild("FlyGear")
    if FlyGear then
        FlyGear.MouseButton1Click:Connect(function()
            FlySettingsFrame.Visible = not FlySettingsFrame.Visible
            ESPSettingsFrame.Visible = false -- Chiudi l'altro pannello
        end)
    end
    
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
    
    ScreenGui.Enabled = true
end

-- Funzioni per ottenere le impostazioni
local function getESPSettings()
    return {
        opacity = espOpacity,
        color = espColor
    }
end

local function getFlySpeed()
    return flySpeed
end

return {
    createGUI = createGUI,
    getESPSettings = getESPSettings,
    getFlySpeed = getFlySpeed
}