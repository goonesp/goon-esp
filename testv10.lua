-- LocalScript in StarterPlayerScripts

local player = game.Players.LocalPlayer
local camera = game.Workspace.CurrentCamera
local mouse = player:GetMouse()

local espEnabled = false
local aimbotEnabled = false
local hitboxEnabled = false
local teamCheckEnabled = true

-- UI Setup (BillboardGui)
local billboardGui = Instance.new("BillboardGui")
billboardGui.Parent = player.PlayerGui
billboardGui.Adornee = player.Character:WaitForChild("Head") -- Attach to player's head
billboardGui.Size = UDim2.new(0, 300, 0, 150) -- Set size of the BillboardGui
billboardGui.StudsOffset = Vector3.new(0, 2, 0) -- Offset above the player's head
billboardGui.AlwaysOnTop = true -- Ensure it is always visible above the player

-- Create Background Frame for the UI
local backgroundFrame = Instance.new("Frame")
backgroundFrame.Parent = billboardGui
backgroundFrame.Size = UDim2.new(1, 0, 1, 0)
backgroundFrame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
backgroundFrame.BackgroundTransparency = 0.6

-- Create Tab Buttons
local tabs = {"Aimbot", "ESP", "Hitbox Expander"}
local activeTab = "Aimbot" -- Default active tab

-- Create Tab Buttons
local function createTabButton(text, position)
	local button = Instance.new("TextButton")
	button.Parent = backgroundFrame
	button.Size = UDim2.new(1/3, 0, 0, 30) -- Split into three tabs
	button.Position = position
	button.Text = text
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 20
	button.MouseButton1Click:Connect(function()
		activeTab = text
		updateTabVisibility()
	end)
end

-- Create a function to switch between tabs
local function updateTabVisibility()
	-- Hide all sections
	for _, section in pairs(backgroundFrame:GetChildren()) do
		if section:IsA("TextButton") then
			section.Visible = false
		end
	end

	-- Show active tab buttons
	for _, section in pairs(backgroundFrame:GetChildren()) do
		if section.Name == activeTab then
			section.Visible = true
		end
	end
end

-- Create each tab button
createTabButton("Aimbot", UDim2.new(0, 0, 0, 0))
createTabButton("ESP", UDim2.new(1/3, 0, 0, 0))
createTabButton("Hitbox Expander", UDim2.new(2/3, 0, 0, 0))

-- Toggle Aimbot
local function toggleAimbot()
	aimbotEnabled = not aimbotEnabled
	print("Aimbot Toggled: " .. tostring(aimbotEnabled))
end

-- Toggle ESP
local function toggleESP()
	espEnabled = not espEnabled
	print("ESP Toggled: " .. tostring(espEnabled))
end

-- Toggle Hitbox Expander
local function toggleHitbox()
	hitboxEnabled = not hitboxEnabled
	print("Hitbox Expander Toggled: " .. tostring(hitboxEnabled))
end

-- Create buttons inside the active tab
local function createFeatureButton(tabName, text, position, callback)
	local button = Instance.new("TextButton")
	button.Parent = backgroundFrame
	button.Size = UDim2.new(1, 0, 0, 30)
	button.Position = position
	button.Text = text
	button.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 20
	button.MouseButton1Click:Connect(callback)

	-- Add the tab as the button's name for organizing
	button.Name = tabName
end

-- Create buttons for each feature
createFeatureButton("Aimbot", "Toggle Aimbot", UDim2.new(0, 0, 0, 35), toggleAimbot)
createFeatureButton("ESP", "Toggle ESP", UDim2.new(0, 0, 0, 35), toggleESP)
createFeatureButton("Hitbox Expander", "Toggle Hitbox", UDim2.new(0, 0, 0, 35), toggleHitbox)

-- Initially hide all tabs and show only the "Aimbot" tab
updateTabVisibility()

-- Core logic for features

-- ESP: Highlight all other players, except teammates
local function enableESP()
	for _, target in pairs(game.Players:GetPlayers()) do
		if target ~= player and target.Character and target.Character:FindFirstChild("Head") then
			if teamCheckEnabled and target.Team == player.Team then
				-- If team check is enabled, don't highlight teammates
				continue
			end

			local highlight = Instance.new("Highlight")
			highlight.Parent = target.Character
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.OutlineTransparency = 1
			print("ESP enabled for: " .. target.Name)
		end
	end
end

-- Aimbot: Aim at nearest player's head
local function enableAimbot()
	if not aimbotEnabled then return end
	local closestTarget = nil
	local shortestDistance = math.huge

	-- Loop through all players
	for _, target in pairs(game.Players:GetPlayers()) do
		if target ~= player and target.Character and target.Character:FindFirstChild("Head") then
			local targetPos = target.Character.Head.Position
			local distance = (camera.CFrame.Position - targetPos).Magnitude
			if distance < shortestDistance then
				closestTarget = target
				shortestDistance = distance
			end
		end
	end

	-- Aim at the closest player
	if closestTarget then
		local targetHeadPos = closestTarget.Character.Head.Position
		camera.CFrame = CFrame.new(camera.CFrame.Position, targetHeadPos)
	end
end

-- Hitbox Expander: Expand target's head hitbox with transparency
local function enableHitboxExpander()
	for _, target in pairs(game.Players:GetPlayers()) do
		if target ~= player and target.Character and target.Character:FindFirstChild("Head") then
			local head = target.Character.Head
			head.Size = Vector3.new(10, 10, 10) -- Expand hitbox size
			head.Transparency = 0 -- Fully visible red hitbox
			head.Color = Color3.fromRGB(255, 0, 0)
			print("Hitbox expanded for: " .. target.Name)
		end
	end
end

-- Update the feature logic based on toggles
game:GetService("RunService").Heartbeat:Connect(function()
	if espEnabled then
		enableESP()
	end
	if aimbotEnabled then
		enableAimbot()
	end
	if hitboxEnabled then
		enableHitboxExpander()
	end
end)

-- Keybinds for toggling features (e.g., F1, F2, F3)
game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.F1 then
		toggleAimbot()
	elseif input.KeyCode == Enum.KeyCode.F2 then
		toggleESP()
	elseif input.KeyCode == Enum.KeyCode.F3 then
		toggleHitbox()
	end
end)

-- Debug message
print("Script executed successfully! Press F1 for Aimbot, F2 for ESP, F3 for Hitbox Expander.")
