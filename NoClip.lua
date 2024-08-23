-- NoClip.lua
local RunService = game:GetService("RunService")

local function toggleNoClip(enabled, button, character)
    if enabled then
        button.Text = "Disable NoClip"
        RunService:BindToRenderStep("NoClip", Enum.RenderPriority.Camera.Value, function()
            if character and character:IsDescendantOf(workspace) then
                for _, part in ipairs(character:GetDescendants()) do
                    if part:IsA("BasePart") then
                        part.CanCollide = false
                    end
                end
            end
        end)
    else
        RunService:UnbindFromRenderStep("NoClip")
        if character and character:IsDescendantOf(workspace) then
            for _, part in ipairs(character:GetDescendants()) do
                if part:IsA("BasePart") and part.Name ~= "HumanoidRootPart" then
                    part.CanCollide = true
                end
            end
        end
    end
end

return toggleNoClip