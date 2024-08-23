local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Teleport = {}

function Teleport.toggleTeleport()
    TeleportFrame.Visible = not TeleportFrame.Visible
    UI.updatePlayerList()
end

return Teleport