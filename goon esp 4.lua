-- Create the GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Parent = game:GetService("CoreGui")

-- Create a container frame to hold all the elements in the center
local containerFrame = Instance.new("Frame")
containerFrame.Parent = ScreenGui
containerFrame.Size = UDim2.new(0, 300, 0, 400)  -- Size of the box
containerFrame.Position = UDim2.new(0.5, -150, 0.5, -200)  -- Centered position
containerFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
containerFrame.BorderSizePixel = 2
containerFrame.BorderColor3 = Color3.fromRGB(255, 255, 255)

-- Create the Tab Section
local tabFrame = Instance.new("Frame")
tabFrame.Parent = containerFrame
tabFrame.Size = UDim2.new(1, 0, 0, 40)
tabFrame.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
tabFrame.BorderSizePixel = 0

-- Create "ESP" Tab
local espTabButton = Instance.new("TextButton")
espTabButton.Parent = tabFrame
espTabButton.Size = UDim2.new(0.5, 0, 1, 0)
espTabButton.Text = "ESP"
espTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
espTabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
espTabButton.BorderSizePixel = 0

-- Create "Hitbox Expander" Tab
local hitboxTabButton = Instance.new("TextButton")
hitboxTabButton.Parent = tabFrame
hitboxTabButton.Size = UDim2.new(0.5, 0, 1, 0)
hitboxTabButton.Text = "Hitbox Expander"
hitboxTabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxTabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
hitboxTabButton.BorderSizePixel = 0

-- Create ESP Content Frame
local espContentFrame = Instance.new("Frame")
espContentFrame.Parent = containerFrame
espContentFrame.Size = UDim2.new(1, 0, 1, -40)  -- Take up the remaining space
espContentFrame.Position = UDim2.new(0, 0, 0, 40)
espContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)

-- ESP Toggle Button
local Button = Instance.new("TextButton")
Button.Parent = espContentFrame
Button.Size = UDim2.new(0, 200, 0, 40)
Button.Position = UDim2.new(0.5, -100, 0, 50)
Button.Text = "Toggle ESP"
Button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
Button.TextColor3 = Color3.fromRGB(255, 255, 255)
Button.BorderSizePixel = 2
Button.BorderColor3 = Color3.fromRGB(255, 0, 0)

-- Team ESP Toggle Button
local TeamButton = Instance.new("TextButton")
TeamButton.Parent = espContentFrame
TeamButton.Size = UDim2.new(0, 200, 0, 40)
TeamButton.Position = UDim2.new(0.5, -100, 0, 100)
TeamButton.Text = "Toggle Team ESP"
TeamButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
TeamButton.TextColor3 = Color3.fromRGB(255, 255, 255)
TeamButton.BorderSizePixel = 2
TeamButton.BorderColor3 = Color3.fromRGB(0, 0, 255)

-- Hitbox Expander Content Frame
local hitboxContentFrame = Instance.new("Frame")
hitboxContentFrame.Parent = containerFrame
hitboxContentFrame.Size = UDim2.new(1, 0, 1, -40)  -- Take up the remaining space
hitboxContentFrame.Position = UDim2.new(0, 0, 0, 40)
hitboxContentFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
hitboxContentFrame.Visible = false  -- Initially hidden

-- Hitbox Size TextBox
local hitboxSizeInput = Instance.new("TextBox")
hitboxSizeInput.Parent = hitboxContentFrame
hitboxSizeInput.Size = UDim2.new(0, 200, 0, 40)
hitboxSizeInput.Position = UDim2.new(0.5, -100, 0, 50)
hitboxSizeInput.Text = "3"  -- Default size (1-6)
hitboxSizeInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxSizeInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
hitboxSizeInput.BorderSizePixel = 2
hitboxSizeInput.BorderColor3 = Color3.fromRGB(255, 165, 0)
hitboxSizeInput.PlaceholderText = "Hitbox Size (1-6)"

-- Transparency TextBox
local hitboxTransparencyInput = Instance.new("TextBox")
hitboxTransparencyInput.Parent = hitboxContentFrame
hitboxTransparencyInput.Size = UDim2.new(0, 200, 0, 40)
hitboxTransparencyInput.Position = UDim2.new(0.5, -100, 0, 100)
hitboxTransparencyInput.Text = "0"  -- Default transparency (0-100)
hitboxTransparencyInput.TextColor3 = Color3.fromRGB(255, 255, 255)
hitboxTransparencyInput.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
hitboxTransparencyInput.BorderSizePixel = 2
hitboxTransparencyInput.BorderColor3 = Color3.fromRGB(255, 165, 0)
hitboxTransparencyInput.PlaceholderText = "Transparency (0-100)"

-- Function to switch between tabs
local function switchTab(tab)
    if tab == "ESP" then
        espContentFrame.Visible = true
        hitboxContentFrame.Visible = false
        espTabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
        hitboxTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
    elseif tab == "Hitbox Expander" then
        espContentFrame.Visible = false
        hitboxContentFrame.Visible = true
        espTabButton.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
        hitboxTabButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
    end
end

-- Set default tab to "ESP"
switchTab("ESP")

-- When ESP tab is clicked, switch to ESP settings
espTabButton.MouseButton1Click:Connect(function()
    switchTab("ESP")
end)

-- When Hitbox Expander tab is clicked, switch to Hitbox settings
hitboxTabButton.MouseButton1Click:Connect(function()
    switchTab("Hitbox Expander")
end)

-- Function to create ESP for a player
local function createESP(player)
    if player.Character and player.Character:FindFirstChild("HumanoidRootPart") then
        local highlight = Instance.new("Highlight")
        highlight.Parent = player.Character
        highlight.FillColor = Color3.fromRGB(255, 0, 0)  -- Red color for enemies
        highlight.OutlineColor = Color3.fromRGB(255, 255, 255)  -- White outline
        highlight.FillTransparency = 0.5
        highlight.OutlineTransparency = 0
    end
end

-- Toggle ESP function
local function toggleESP()
    for _, player in pairs(game.Players:GetPlayers()) do
        if player.Character then
            createESP(player)
        end
    end
end

-- Toggle Team ESP function
local function toggleTeamESP()
    -- Update the ESP based on team settings
end

-- Button functions
Button.MouseButton1Click:Connect(toggleESP)
TeamButton.MouseButton1Click:Connect(toggleTeamESP)

-- Draggable functionality
local dragInput, dragStart, startPos

local function update(input)
    local delta = input.Position - dragStart
    containerFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
end

local function onInputBegan(input, gameProcessed)
    if gameProcessed then return end
    if input.UserInputType == Enum.UserInputType.MouseButton1 then
        dragStart = input.Position
        startPos = containerFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then
                dragInput = nil
            end
        end)
        dragInput = input.Changed:Connect(update)
    end
end

local function onInputEnded(input)
    if dragInput then
        dragInput:Disconnect()
    end
end

containerFrame.InputBegan:Connect(onInputBegan)
containerFrame.InputEnded:Connect(onInputEnded)
