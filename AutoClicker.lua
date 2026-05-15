--// Auto Key Spammer
--// F = ضرب
--// Q = KI
--// V = ضغط

local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// حذف القديم
pcall(function()
	PlayerGui.AutoKeySpam:Destroy()
end)

--// الإعدادات
local Settings = {
	Delay = 0.05
}

--// الحالات
local CurrentMode = "ضرب"
local Running = false

local Keys = {
	["ضرب"] = Enum.KeyCode.F,
	["KI"] = Enum.KeyCode.Q,
	["ضغط"] = Enum.KeyCode.V
}

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoKeySpam"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,230,0,220)
Main.Position = UDim2.new(0.5,-115,0.5,-110)
Main.BackgroundColor3 = Color3.fromRGB(25,25,35)
Main.BorderSizePixel = 0
Main.Active = true
Main.Draggable = true
Main.Parent = ScreenGui

Instance.new("UICorner", Main).CornerRadius = UDim.new(0,12)

--// عنوان
local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,35)
Title.BackgroundColor3 = Color3.fromRGB(35,35,50)
Title.BorderSizePixel = 0
Title.Text = "⚡ Auto Spam"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Main

Instance.new("UICorner", Title).CornerRadius = UDim.new(0,12)

--// الحالة الحالية
local Status = Instance.new("TextLabel")
Status.Size = UDim2.new(1,-20,0,30)
Status.Position = UDim2.new(0,10,0,50)
Status.BackgroundTransparency = 1
Status.Text = "الحالة الحالية: ضرب"
Status.TextColor3 = Color3.new(1,1,1)
Status.Font = Enum.Font.GothamBold
Status.TextSize = 15
Status.TextXAlignment = Enum.TextXAlignment.Left
Status.Parent = Main

--// زر تشغيل
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1,-20,0,45)
ToggleBtn.Position = UDim2.new(0,10,0,90)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,100)
ToggleBtn.Text = "▶ تشغيل"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 15
ToggleBtn.Parent = Main

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,10)

--// زر ضرب
local HitBtn = Instance.new("TextButton")
HitBtn.Size = UDim2.new(0.3,0,0,40)
HitBtn.Position = UDim2.new(0.03,0,0,150)
HitBtn.BackgroundColor3 = Color3.fromRGB(200,70,70)
HitBtn.Text = "ضرب"
HitBtn.TextColor3 = Color3.new(1,1,1)
HitBtn.Font = Enum.Font.GothamBold
HitBtn.TextSize = 14
HitBtn.Parent = Main

Instance.new("UICorner", HitBtn).CornerRadius = UDim.new(0,10)

--// زر KI
local KiBtn = Instance.new("TextButton")
KiBtn.Size = UDim2.new(0.3,0,0,40)
KiBtn.Position = UDim2.new(0.35,0,0,150)
KiBtn.BackgroundColor3 = Color3.fromRGB(70,120,255)
KiBtn.Text = "KI"
KiBtn.TextColor3 = Color3.new(1,1,1)
KiBtn.Font = Enum.Font.GothamBold
KiBtn.TextSize = 14
KiBtn.Parent = Main

Instance.new("UICorner", KiBtn).CornerRadius = UDim.new(0,10)

--// زر ضغط
local PressBtn = Instance.new("TextButton")
PressBtn.Size = UDim2.new(0.3,0,0,40)
PressBtn.Position = UDim2.new(0.67,0,0,150)
PressBtn.BackgroundColor3 = Color3.fromRGB(70,200,120)
PressBtn.Text = "ضغط"
PressBtn.TextColor3 = Color3.new(1,1,1)
PressBtn.Font = Enum.Font.GothamBold
PressBtn.TextSize = 14
PressBtn.Parent = Main

Instance.new("UICorner", PressBtn).CornerRadius = UDim.new(0,10)

--// تغيير الحالة
local function SetMode(mode)
	CurrentMode = mode
	Status.Text = "الحالة الحالية: "..mode
end

HitBtn.MouseButton1Click:Connect(function()
	SetMode("ضرب")
end)

KiBtn.MouseButton1Click:Connect(function()
	SetMode("KI")
end)

PressBtn.MouseButton1Click:Connect(function()
	SetMode("ضغط")
end)

--// تشغيل وإيقاف
ToggleBtn.MouseButton1Click:Connect(function()

	Running = not Running

	if Running then
		ToggleBtn.Text = "⏹ توقيف"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
	else
		ToggleBtn.Text = "▶ تشغيل"
		ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,100)
	end
end)

--// السبام
task.spawn(function()

	while true do
		task.wait(Settings.Delay)

		if Running then

			local Key = Keys[CurrentMode]

			pcall(function()

				VirtualInputManager:SendKeyEvent(
					true,
					Key,
					false,
					game
				)

				task.wait(0.01)

				VirtualInputManager:SendKeyEvent(
					false,
					Key,
					false,
					game
				)

			end)
		end
	end
end)

print("✅ Auto Spam Loaded")
