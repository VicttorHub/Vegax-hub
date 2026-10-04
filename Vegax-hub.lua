--// Serviços
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local Workspace = game:GetService("Workspace")
local LocalPlayer = Players.LocalPlayer
local Camera = Workspace.CurrentCamera

--// Configurações
local Config = {
    Aimbot = false,
    FOV = 100,
    KillCheck = false,
    WallCheck = true,
    TeamCheck = true,
    Smoothness = 0.15,
    Key = Enum.UserInputType.MouseButton2, -- Botão direito do mouse
    Target = nil,
}

--// ========== CRIAÇÃO DA UI ========== //
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "PainelAimbot"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = game:GetService("CoreGui")

-- Painel Principal
local Main = Instance.new("Frame")
Main.Name = "Main"
Main.Size = UDim2.new(0, 260, 0, 320)
Main.Position = UDim2.new(0.5, -130, 0.5, -160)
Main.BackgroundColor3 = Color3.fromRGB(20, 20, 25)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 12)
MainCorner.Parent = Main

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Color3.fromRGB(60, 60, 80)
MainStroke.Thickness = 1.5
MainStroke.Parent = Main

-- Título
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1, 0, 0, 40)
Title.BackgroundTransparency = 1
Title.Text = "⚡ PAINEL AIMBOT"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Main

-- Botão Fechar (bolinha)
local CloseBtn = Instance.new("TextButton")
CloseBtn.Size = UDim2.new(0, 22, 0, 22)
CloseBtn.Position = UDim2.new(1, -30, 0, 9)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 70, 70)
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.BorderSizePixel = 0
CloseBtn.Parent = Main

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(1, 0)
CloseCorner.Parent = CloseBtn

CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Container dos Toggles
local List = Instance.new("Frame")
List.Size = UDim2.new(1, -20, 1, -60)
List.Position = UDim2.new(0, 10, 0, 50)
List.BackgroundTransparency = 1
List.Parent = Main

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = List

--// Função: Criar Toggle
local function CreateToggle(name, default, callback)
    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 36)
    Btn.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
    Btn.Text = ""
    Btn.AutoButtonColor = false
    Btn.BorderSizePixel = 0
    Btn.Parent = List

    local Corner = Instance.new("UICorner")
    Corner.CornerRadius = UDim.new(0, 8)
    Corner.Parent = Btn

    local Stroke = Instance.new("UIStroke")
    Stroke.Color = Color3.fromRGB(55, 55, 70)
    Stroke.Parent = Btn

    local Label = Instance.new("TextLabel")
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 12, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = name
    Label.TextColor3 = Color3.fromRGB(230, 230, 240)
    Label.Font = Enum.Font.GothamMedium
    Label.TextSize = 13
    Label.TextXAlignment = Enum.TextXAlignment.Left
    Label.Parent = Btn

    -- Indicador (bolinha)
    local Indicator = Instance.new("Frame")
    Indicator.Size = UDim2.new(0, 36, 0, 18)
    Indicator.Position = UDim2.new(1, -46, 0.5, -9)
    Indicator.BackgroundColor3 = default and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(60, 60, 75)
    Indicator.BorderSizePixel = 0
    Indicator.Parent = Btn

    local IndCorner = Instance.new("UICorner")
    IndCorner.CornerRadius = UDim.new(1, 0)
    IndCorner.Parent = Indicator

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 14, 0, 14)
    Knob.Position = default and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Indicator

    local KnobCorner = Instance.new("UICorner")
    KnobCorner.CornerRadius = UDim.new(1, 0)
    KnobCorner.Parent = Knob

    local state = default

    local function Toggle()
        state = not state
        Indicator.BackgroundColor3 = state and Color3.fromRGB(0, 170, 100) or Color3.fromRGB(60, 60, 75)
        Knob.Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)
        callback(state)
    end

    Btn.MouseButton1Click:Connect(Toggle)
    return {Set = function(v) if v ~= state then Toggle() end end}
end

--// Criar toggles
CreateToggle("Aimbot", Config.Aimbot, function(v) Config.Aimbot = v end)
CreateToggle("Kill Check", Config.KillCheck, function(v) Config.KillCheck = v end)
CreateToggle("Wall Check", Config.WallCheck, function(v) Config.WallCheck = v end)

--// Slider FOV
local FovFrame = Instance.new("Frame")
FovFrame.Size = UDim2.new(1, 0, 0, 50)
FovFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 45)
FovFrame.BorderSizePixel = 0
FovFrame.Parent = List

local FovCorner = Instance.new("UICorner")
FovCorner.CornerRadius = UDim.new(0, 8)
FovCorner.Parent = FovFrame

local FovStroke = Instance.new("UIStroke")
FovStroke.Color = Color3.fromRGB(55, 55, 70)
FovStroke.Parent = FovFrame

local FovLabel = Instance.new("TextLabel")
FovLabel.Size = UDim2.new(1, -20, 0, 20)
FovLabel.Position = UDim2.new(0, 10, 0, 4)
FovLabel.BackgroundTransparency = 1
FovLabel.Text = "FOV: " .. Config.FOV
FovLabel.TextColor3 = Color3.fromRGB(230, 230, 240)
FovLabel.Font = Enum.Font.GothamMedium
FovLabel.TextSize = 13
FovLabel.TextXAlignment = Enum.TextXAlignment.Left
FovLabel.Parent = FovFrame

local SliderBar = Instance.new("Frame")
SliderBar.Size = UDim2.new(1, -20, 0, 8)
SliderBar.Position = UDim2.new(0, 10, 0, 30)
SliderBar.BackgroundColor3 = Color3.fromRGB(50, 50, 65)
SliderBar.BorderSizePixel = 0
SliderBar.Parent = FovFrame

local BarCorner = Instance.new("UICorner")
BarCorner.CornerRadius = UDim.new(1, 0)
BarCorner.Parent = SliderBar

local SliderFill = Instance.new("Frame")
SliderFill.Size = UDim2.new((Config.FOV - 20) / 480, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(0, 170, 100)
SliderFill.BorderSizePixel = 0
SliderFill.Parent = SliderBar

local FillCorner = Instance.new("UICorner")
FillCorner.CornerRadius = UDim.new(1, 0)
FillCorner.Parent = SliderFill

local SliderBtn = Instance.new("TextButton")
SliderBtn.Size = UDim2.new(1, 0, 1, 0)
SliderBtn.BackgroundTransparency = 1
SliderBtn.Text = ""
SliderBtn.Parent = SliderBar

local dragging = false

local function UpdateSlider(input)
    local rel = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
    local value = math.floor(20 + rel * 480)
    Config.FOV = value
    FovLabel.Text = "FOV: " .. value
    SliderFill.Size = UDim2.new(rel, 0, 1, 0)
end

SliderBtn.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        UpdateSlider(input)
    end
end)

UserInputService.InputChanged:Connect(function(input)
    if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider(input)
    end
end)

UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = false
    end
end)

--// ========== CIRCULO DE FOV ========== //
local FovCircle = Instance.new("Frame")
FovCircle.Size = UDim2.new(0, Config.FOV * 2, 0, Config.FOV * 2)
FovCircle.Position = UDim2.new(0.5, -Config.FOV, 0.5, -Config.FOV)
FovCircle.BackgroundTransparency = 1
FovCircle.BorderSizePixel = 0
FovCircle.Parent = ScreenGui

local CircleStroke = Instance.new("UIStroke")
CircleStroke.Color = Color3.fromRGB(0, 255, 150)
CircleStroke.Thickness = 1
CircleStroke.Transparency = 0.4
CircleStroke.Parent = FovCircle

local CircleCorner = Instance.new("UICorner")
CircleCorner.CornerRadius = UDim.new(1, 0)
CircleCorner.Parent = FovCircle

--// ========== LÓGICA DO AIMBOT ========== //
local function IsVisible(target)
    if not Config.WallCheck then return true end
    local rayOrigin = Camera.CFrame.Position
    local rayDir = (target.Position - rayOrigin).Unit * (target.Position - rayOrigin).Magnitude
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, target.Parent}
    local result = Workspace:Raycast(rayOrigin, rayDir, params)
    return result == nil
end

local function GetTarget()
    local closest = nil
    local shortest = Config.FOV
    local mousePos = UserInputService:GetMouseLocation()
    local center = Vector2.new(Camera.ViewportSize.X / 2, Camera.ViewportSize.Y / 2)

    for _, plr in pairs(Players:GetPlayers()) do
        if plr ~= LocalPlayer and plr.Character and plr.Character:FindFirstChild("Head") then
            local hum = plr.Character:FindFirstChildOfClass("Humanoid")
            if hum and hum.Health > 0 then
                local head = plr.Character.Head
                local screenPos, onScreen = Camera:WorldToViewportPoint(head.Position)
                if onScreen then
                    local dist = (Vector2.new(screenPos.X, screenPos.Y) - center).Magnitude
                    if dist < shortest and IsVisible(head) then
                        shortest = dist
                        closest = head
                    end
                end
            end
        end
    end
    return closest
end

-- Atualizar círculo de FOV
RunService.RenderStepped:Connect(function()
    FovCircle.Size = UDim2.new(0, Config.FOV * 2, 0, Config.FOV * 2)
    FovCircle.Position = UDim2.new(0.5, -Config.FOV, 0.5, -Config.FOV)

    if Config.Aimbot and UserInputService:IsMouseButtonPressed(Enum.UserInputType.MouseButton2) then
        local target = GetTarget()
        if target then
            Camera.CFrame = Camera.CFrame:Lerp(
                CFrame.new(Camera.CFrame.Position, target.Position),
                Config.Smoothness
            )
        end
    end
end)
