-- Main.lua
-- Carica gli altri moduli
local createGUI = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/UI.lua"))()
local toggleESP = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/ESP.lua"))()
local toggleNoClip = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/NoClip.lua"))()
local updatePlayerList = loadstring(game:HttpGet("https://raw.githubusercontent.com/Zard-Studios/UNIHAX/main/Teleport.lua"))()

local Players = game:GetService("Players")
local UserInputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local guiComponents = createGUI()
local ESPButton = guiComponents.ESPButton
local NoClipButton = guiComponents.NoClipButton
local TeleportButton = guiComponents.TeleportButton
local TeleportFrame = guiComponents.TeleportFrame
local PlayerList = guiComponents.PlayerList

local espEnabled = false
local noClipEnabled = false

local function onESPButtonClick()
    toggleESP(espEnabled, ESPButton)
    espEnabled = not espEnabled
end

local function onNoClipButtonClick()
    toggleNoClip(noClipEnabled, NoClipButton, Character)
    noClipEnabled = not noClipEnabled
end

local function onTeleportButtonClick()
    TeleportFrame.Visible = not TeleportFrame.Visible
    updatePlayerList(PlayerList, LocalPlayer)
end

ESPButton.MouseButton1Click:Connect(onESPButtonClick)
NoClipButton.MouseButton1Click:Connect(onNoClipButtonClick)
TeleportButton.MouseButton1Click:Connect(onTeleportButtonClick)

local dragging
local dragInput
local dragStart
local startPos

local function update(input)
    local delta = input.Position - dragStart
    guiComponents.ScreenGui.MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

guiComponents.ScreenGui.MainFrame.TitleBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragging = true
        dragStart = input.Position
        startPos = guiComponents.ScreenGui.MainFrame.Position

        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragging = false
            end
        end)
    end
end)

guiComponents.ScreenGui.MainFrame.TitleBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement then
        dragInput = input
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        update(input)
    end
end)

guiComponents.ScreenGui.CloseButton.MouseButton1Click:Connect(function()
    guiComponents.ScreenGui:Destroy()
end)

UserInputService.InputBegan:Connect(function(input, gameProcessed)
    if not gameProcessed and input.KeyCode == Enum.KeyCode.RightAlt then
        guiComponents.ScreenGui.Enabled = not guiComponents.ScreenGui.Enabled
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
    updatePlayerList(PlayerList, LocalPlayer)
end)

Players.PlayerRemoving:Connect(function()
    updatePlayerList(PlayerList, LocalPlayer)
end)

guiComponents.ScreenGui.Enabled = true