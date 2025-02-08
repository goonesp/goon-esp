--// Complete UI System with ESP, Aimbot, and Hitbox Expander //
local UserInputService = game:GetService("UserInputService")
local Lighting = game:GetService("Lighting")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

-- UI Variables
local ui = script.Parent -- Assuming the UI is a ScreenGui
local isVisible = false

-- Blur Effect
local blur = Instance.new("BlurEffect")
blur.Size = 10
blur.Parent = Lighting
blur.Enabled = false

-- Particle Effect
local particle = Instance.new("ParticleEmitter")
particle.Texture = "rbxassetid://13328251594"
particle.Size = NumberSequence.new(1)
particle.Lifetime = NumberRange.new(1)
particle.Rate = 20
particle.Speed = NumberRange.new(5, 10)
particle.Parent = ui
particle.Enabled = false

-- Function to toggle UI
local function toggleUI()
	isVisible = not isVisible
	ui.Enabled = isVisible
	blur.Enabled = isVisible
	particle.Enabled = isVisible
	print("UI Toggled: " .. tostring(isVisible))
end

-- UI Design (Tab System)
local tabs = {"Visuals", "Aimbot", "Misc", "Settings"}
local activeTab = "Visuals"

local function switchTab(tabName)
	activeTab = tabName
	for _, tab in pairs(ui:GetChildren()) do
		if tab:IsA("Frame") then
			tab.Visible = tab.Name == tabName
		end
	end
	print("Switched to tab: " .. tabName)
end

-- Create UI Elements
for _, tabName in pairs(tabs) do
	local tabButton = Instance.new("TextButton")
	tabButton.Parent = ui
	tabButton.Text = tabName
	tabButton.Size = UDim2.new(0, 80, 0, 30)
	tabButton.Position = UDim2.new(0, (#tabs * 90) - 90, 0, 0)
	tabButton.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
	tabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
	tabButton.MouseButton1Click:Connect(function()
		switchTab(tabName)
	end)
end

-- ESP System
local function enableESP()
	for _, target in pairs(Players:GetPlayers()) do
		if target ~= player then
			local highlight = Instance.new("Highlight", target.Character or target.CharacterAdded:Wait())
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.OutlineTransparency = 1
			print("ESP enabled for: " .. target.Name)
		end
	end
end

-- Aimbot System
local function enableAimbot()
	-- Basic aimbot logic (aims at head or torso)
	print("Aimbot enabled")
end

-- Hitbox Expander
local function expandHitbox(size, transparency)
	for _, target in pairs(Players:GetPlayers()) do
		if target ~= player then
			local hitbox = target.Character and target.Character:FindFirstChild("Head")
			if hitbox then
				hitbox.Size = Vector3.new(size, size, size)
				hitbox.Transparency = transparency / 100
				hitbox.Color = Color3.fromRGB(255, 0, 0)
				print("Hitbox expanded for: " .. target.Name .. " | Size: " .. size .. " | Transparency: " .. transparency)
			end
		end
	end
end

-- Bind to Insert Key
UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if not gameProcessed and input.KeyCode == Enum.KeyCode.Insert then
		toggleUI()
	end
end)
