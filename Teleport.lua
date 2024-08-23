-- Teleport.lua
local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")

local function updatePlayerList(PlayerList, LocalPlayer)
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

return updatePlayerList