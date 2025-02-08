-- Services
local player = game.Players.LocalPlayer
local userInputService = game:GetService("UserInputService")
local tweenService = game:GetService("TweenService")
local gui = player:WaitForChild("PlayerGui"):WaitForChild("MainUI")
local runService = game:GetService("RunService")
local camera = workspace.CurrentCamera

-- UI elements for ESP
local toggleESPButton = gui:WaitForChild("ToggleESPButton")
local toggleTeamESPButton = gui:WaitForChild("ToggleTeamESPButton")
local espKeyInput = gui:WaitForChild("ESPKeyInput")
local teamCheckKeyInput = gui:WaitForChild("TeamCheckKeyInput")
local espStatusLabel = gui:WaitForChild("ESPStatusLabel")

-- UI elements for Aimbot
local aimbotKeyInput = gui:WaitForChild("AimbotKeyInput")
local aimbotFOVInput = gui:WaitForChild("AimbotFOVInput")
local drawFOVCheckbox = gui:WaitForChild("DrawFOVCheckbox")
local toggleAimbotButton = gui:WaitForChild("ToggleAimbotButton")
local aimbotStatusLabel = gui:WaitForChild("AimbotStatusLabel")
local aimbotTabButton = gui:WaitForChild("AimbotTabButton")
local aimbotTargetPartDropdown = gui:WaitForChild("AimbotTargetPartDropdown")

-- UI elements for Hitbox Expander
local hitboxSizeInput = gui:WaitForChild("HitboxSizeInput")
local transparencyInput = gui:WaitForChild("TransparencyInput")
local toggleHitboxButton = gui:WaitForChild("ToggleHitboxButton")
local hitboxStatusLabel = gui:WaitForChild("HitboxStatusLabel")

-- Variables for ESP
local espEnabled = false
local teamESPEnabled = false
local espKey = Enum.KeyCode.F
local teamCheckKey = Enum.KeyCode.T

-- Variables for Aimbot
local aimbotEnabled = false
local aimbotFOV = 50
local aimbotKey = Enum.KeyCode.F
local aimbotTarget = nil
local aimbotTargetPart = "HumanoidRootPart"  -- Default target part

-- Variables for Hitbox Expander
local hitboxEnabled = false
local hitboxSize = 3
local transparency = 0.5

-- Function to toggle ESP
local function toggleESP()
	espEnabled = not espEnabled
	espStatusLabel.Text = espEnabled and "ESP: ON" or "ESP: OFF"
end

-- Function to toggle Aimbot
local function toggleAimbot()
	aimbotEnabled = not aimbotEnabled
	aimbotStatusLabel.Text = aimbotEnabled and "Aimbot: ON" or "Aimbot: OFF"
end

-- Function to toggle Hitbox Expander
local function toggleHitbox()
	hitboxEnabled = not hitboxEnabled
	hitboxStatusLabel.Text = hitboxEnabled and "Hitbox Expander: ON" or "Hitbox Expander: OFF"
end

-- Aimbot Targeting Logic
local function getClosestEnemy()
	local closestDistance = aimbotFOV
	local closestEnemy = nil

	for _, enemy in pairs(game.Players:GetPlayers()) do
		if enemy.Team ~= player.Team and enemy.Character and enemy.Character:FindFirstChild(aimbotTargetPart) then
			local distance = (player.Character.HumanoidRootPart.Position - enemy.Character[aimbotTargetPart].Position).magnitude
			if distance <= closestDistance then
				closestDistance = distance
				closestEnemy = enemy
			end
		end
	end

	return closestEnemy
end

-- Function to aim at target
local function aimAtTarget(target)
	if target and target.Character and target.Character:FindFirstChild(aimbotTargetPart) then
		local targetPosition = target.Character[aimbotTargetPart].Position
		local direction = (targetPosition - player.Character.HumanoidRootPart.Position).unit
		camera.CFrame = CFrame.new(camera.CFrame.Position, camera.CFrame.Position + direction)  -- Adjust camera to aim
	end
end

-- Draw FOV circle
local function drawFOVCircle()
	if drawFOVCheckbox.Checked then
		local fovCircle = Instance.new("Frame")
		fovCircle.Size = UDim2.new(0, aimbotFOV * 2, 0, aimbotFOV * 2)
		fovCircle.Position = UDim2.new(0.5, -aimbotFOV, 0.5, -aimbotFOV)
		fovCircle.AnchorPoint = Vector2.new(0.5, 0.5)
		fovCircle.BackgroundColor3 = Color3.fromRGB(255, 0, 0)
		fovCircle.BackgroundTransparency = 0.5
		fovCircle.Parent = gui
	end
end

-- Update FOV value from the textbox
aimbotFOVInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		aimbotFOV = tonumber(aimbotFOVInput.Text) or 50  -- Default to 50 if invalid input
		aimbotFOV = math.clamp(aimbotFOV, 20, 100)  -- Clamp between 20 and 100
	end
end)

-- Update aimbot key from the textbox
aimbotKeyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		aimbotKey = Enum.KeyCode[aimbotKeyInput.Text:upper()] or Enum.KeyCode.F
	end
end)

-- Update aimbot target part
aimbotTargetPartDropdown.Changed:Connect(function()
	aimbotTargetPart = aimbotTargetPartDropdown.Text == "Head" and "Head" or "HumanoidRootPart"
end)

-- Button Events
toggleESPButton.MouseButton1Click:Connect(toggleESP)
toggleTeamESPButton.MouseButton1Click:Connect(function()
	teamESPEnabled = not teamESPEnabled
	toggleESP()  -- Optionally toggle ESP too when team check is toggled
end)
toggleAimbotButton.MouseButton1Click:Connect(toggleAimbot)
toggleHitboxButton.MouseButton1Click:Connect(toggleHitbox)

-- Handling Key Bindings
userInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end  -- Ignore if the game already processed the input

	-- Toggle ESP
	if input.KeyCode == espKey then
		toggleESP()
	end

	-- Toggle Aimbot
	if input.KeyCode == aimbotKey then
		toggleAimbot()
	end

	-- Toggle Team Check ESP
	if input.KeyCode == teamCheckKey then
		teamESPEnabled = not teamESPEnabled
		toggleESP()
	end
end)

-- Update Hitbox size
hitboxSizeInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		hitboxSize = tonumber(hitboxSizeInput.Text) or 3  -- Default to 3 if invalid input
	end
end)

-- Update transparency for hitbox
transparencyInput.FocusLost:Connect(function(enterPressed)
	if enterPressed then
		transparency = tonumber(transparencyInput.Text) or 0.5  -- Default to 0.5 if invalid input
	end
end)

-- Aimbot logic
runService.Heartbeat:Connect(function()
	if aimbotEnabled then
		aimbotTarget = getClosestEnemy()
		if aimbotTarget then
			aimAtTarget(aimbotTarget)
		end
	end
end)

-- Make the UI draggable (as before)
local dragInput, dragStart, startPos
local function onDrag(input)
	local delta = input.Position - dragStart
	gui.Position = UDim2.new(gui.Position.X.Scale, gui.Position.X.Offset + delta.X, gui.Position.Y.Scale, gui.Position.Y.Offset + delta.Y)
end

gui.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragStart = input.Position
		dragInput = input.InputChanged:Connect(onDrag)
	end
end)

gui.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragInput:Disconnect()
	end
end)
















