--// Auto Clicker Pro (Fixed Version)
--// Roblox Mobile + PC

local Players = game:GetService("Players")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")

local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// حذف النسخة القديمة إذا موجودة
pcall(function()
    PlayerGui.AutoClickerPro:Destroy()
end)

--// الإعدادات
local Settings = {
    ClickInterval = 0.05,
    ClickDuration = 0.01,
    CircleSize = 40,
    MaxCircles = 10,
}

--// المتغيرات
local AutoClicker = {
    Enabled = false,
    Circles = {},
    Hidden = false
}

--// GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.Parent = PlayerGui

--// القائمة
local Main = Instance.new("Frame")
Main.Size = UDim2.new(0,220,0,260)
Main.Position = UDim2.new(0.5,-110,0.5,-130)
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
Title.Text = "⚡ Auto Clicker"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 16
Title.Parent = Main

Instance.new("UICorner", Title).CornerRadius = UDim.new(0,12)

--// حاوية
local Container = Instance.new("Frame")
Container.BackgroundTransparency = 1
Container.Size = UDim2.new(1,-20,1,-50)
Container.Position = UDim2.new(0,10,0,45)
Container.Parent = Main

local Layout = Instance.new("UIListLayout")
Layout.Padding = UDim.new(0,8)
Layout.Parent = Container

--// زر تشغيل
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Size = UDim2.new(1,0,0,45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,100)
ToggleBtn.Text = "▶ تشغيل"
ToggleBtn.TextColor3 = Color3.new(1,1,1)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 15
ToggleBtn.Parent = Container

Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0,10)

--// إضافة نقطة
local AddBtn = Instance.new("TextButton")
AddBtn.Size = UDim2.new(1,0,0,45)
AddBtn.BackgroundColor3 = Color3.fromRGB(0,120,255)
AddBtn.Text = "➕ إضافة نقطة"
AddBtn.TextColor3 = Color3.new(1,1,1)
AddBtn.Font = Enum.Font.GothamBold
AddBtn.TextSize = 15
AddBtn.Parent = Container

Instance.new("UICorner", AddBtn).CornerRadius = UDim.new(0,10)

--// حذف نقطة
local RemoveBtn = Instance.new("TextButton")
RemoveBtn.Size = UDim2.new(1,0,0,45)
RemoveBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
RemoveBtn.Text = "➖ حذف نقطة"
RemoveBtn.TextColor3 = Color3.new(1,1,1)
RemoveBtn.Font = Enum.Font.GothamBold
RemoveBtn.TextSize = 15
RemoveBtn.Parent = Container

Instance.new("UICorner", RemoveBtn).CornerRadius = UDim.new(0,10)

--// إخفاء/إظهار
local HideBtn = Instance.new("TextButton")
HideBtn.Size = UDim2.new(1,0,0,40)
HideBtn.BackgroundColor3 = Color3.fromRGB(80,80,100)
HideBtn.Text = "👁 إخفاء النقاط"
HideBtn.TextColor3 = Color3.new(1,1,1)
HideBtn.Font = Enum.Font.GothamBold
HideBtn.TextSize = 14
HideBtn.Parent = Container

Instance.new("UICorner", HideBtn).CornerRadius = UDim.new(0,10)

--// السرعة
local SpeedBox = Instance.new("TextBox")
SpeedBox.Size = UDim2.new(1,0,0,35)
SpeedBox.BackgroundColor3 = Color3.fromRGB(45,45,60)
SpeedBox.Text = "50"
SpeedBox.PlaceholderText = "سرعة الضغط بالمللي ثانية"
SpeedBox.TextColor3 = Color3.new(1,1,1)
SpeedBox.Font = Enum.Font.Gotham
SpeedBox.TextSize = 14
SpeedBox.ClearTextOnFocus = false
SpeedBox.Parent = Container

Instance.new("UICorner", SpeedBox).CornerRadius = UDim.new(0,8)

--// عداد
local Counter = Instance.new("TextLabel")
Counter.Size = UDim2.new(1,0,0,25)
Counter.BackgroundTransparency = 1
Counter.TextColor3 = Color3.new(1,1,1)
Counter.Font = Enum.Font.Gotham
Counter.TextSize = 14
Counter.Text = "النقاط: 0"
Counter.Parent = Container

--// تحديث العداد
local function UpdateCounter()
    Counter.Text = "النقاط: "..#AutoClicker.Circles
end

--// إنشاء نقطة
local function CreateCircle()

    if #AutoClicker.Circles >= Settings.MaxCircles then
        return
    end

    local Circle = Instance.new("Frame")
    Circle.Size = UDim2.new(0,Settings.CircleSize,0,Settings.CircleSize)
    Circle.Position = UDim2.new(0.5,-20,0.5,-20)
    Circle.BackgroundColor3 = Color3.fromRGB(255,60,60)
    Circle.BorderSizePixel = 0
    Circle.Active = true
    Circle.Draggable = true
    Circle.Parent = ScreenGui

    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1,0)

    local Stroke = Instance.new("UIStroke")
    Stroke.Thickness = 2
    Stroke.Color = Color3.new(1,1,1)
    Stroke.Parent = Circle

    local Num = Instance.new("TextLabel")
    Num.Size = UDim2.new(1,0,1,0)
    Num.BackgroundTransparency = 1
    Num.Text = tostring(#AutoClicker.Circles + 1)
    Num.TextColor3 = Color3.new(1,1,1)
    Num.Font = Enum.Font.GothamBold
    Num.TextSize = 15
    Num.Parent = Circle

    local Data = {
        GUI = Circle,
        Enabled = false
    }

    table.insert(AutoClicker.Circles, Data)

    UpdateCounter()
end

--// حذف نقطة
local function RemoveCircle()

    if #AutoClicker.Circles <= 0 then
        return
    end

    local Last = table.remove(AutoClicker.Circles)

    if Last and Last.GUI then
        Last.GUI:Destroy()
    end

    UpdateCounter()
end

--// الضغط التلقائي
task.spawn(function()

    while true do
        task.wait()

        if AutoClicker.Enabled then

            for _,Data in ipairs(AutoClicker.Circles) do

                if Data.GUI and Data.GUI.Parent then

                    local Pos = Data.GUI.AbsolutePosition
                    local Size = Data.GUI.AbsoluteSize

                    local X = Pos.X + (Size.X / 2)
                    local Y = Pos.Y + (Size.Y / 2)

                    pcall(function()

                        VirtualInputManager:SendMouseButtonEvent(
                            X,
                            Y,
                            0,
                            true,
                            game,
                            0
                        )

                        task.wait(Settings.ClickDuration)

                        VirtualInputManager:SendMouseButtonEvent(
                            X,
                            Y,
                            0,
                            false,
                            game,
                            0
                        )

                    end)
                end
            end

            task.wait(Settings.ClickInterval)
        end
    end
end)

--// تشغيل/إيقاف
ToggleBtn.MouseButton1Click:Connect(function()

    AutoClicker.Enabled = not AutoClicker.Enabled

    if AutoClicker.Enabled then
        ToggleBtn.Text = "⏹ توقيف"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200,60,60)
    else
        ToggleBtn.Text = "▶ تشغيل"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0,170,100)
    end
end)

--// إضافة
AddBtn.MouseButton1Click:Connect(CreateCircle)

--// حذف
RemoveBtn.MouseButton1Click:Connect(RemoveCircle)

--// إخفاء
HideBtn.MouseButton1Click:Connect(function()

    AutoClicker.Hidden = not AutoClicker.Hidden

    for _,Data in ipairs(AutoClicker.Circles) do
        Data.GUI.Visible = not AutoClicker.Hidden
    end

    if AutoClicker.Hidden then
        HideBtn.Text = "👁 إظهار النقاط"
    else
        HideBtn.Text = "👁 إخفاء النقاط"
    end
end)

--// سرعة الضغط
SpeedBox.FocusLost:Connect(function()

    local Num = tonumber(SpeedBox.Text)

    if Num and Num >= 1 then
        Settings.ClickInterval = Num / 1000
    else
        SpeedBox.Text = tostring(Settings.ClickInterval * 1000)
    end
end)

--// إشعار
local Notify = Instance.new("TextLabel")
Notify.Size = UDim2.new(0,220,0,40)
Notify.Position = UDim2.new(0.5,-110,0,-50)
Notify.BackgroundColor3 = Color3.fromRGB(0,170,255)
Notify.Text = "✅ Auto Clicker جاهز"
Notify.TextColor3 = Color3.new(1,1,1)
Notify.Font = Enum.Font.GothamBold
Notify.TextSize = 14
Notify.Parent = ScreenGui

Instance.new("UICorner", Notify).CornerRadius = UDim.new(0,10)

TweenService:Create(
    Notify,
    TweenInfo.new(0.4),
    {Position = UDim2.new(0.5,-110,0,20)}
):Play()

task.delay(3,function()

    local t = TweenService:Create(
        Notify,
        TweenInfo.new(0.4),
        {Position = UDim2.new(0.5,-110,0,-50)}
    )

    t:Play()

    t.Completed:Wait()

    Notify:Destroy()
end)

print("✅ Auto Clicker Loaded")
