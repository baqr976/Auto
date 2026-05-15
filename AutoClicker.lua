--// Auto Clicker / Auto Tap System
--// للـ Roblox (Mobile + PC)

local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

--// الإعدادات
local Settings = {
    ClickInterval = 0.05,      -- سرعة الضغط (ثواني)
    ClickDuration = 0.02,      -- مدة الضغطة الواحدة
    MinimizedSize = UDim2.new(0, 50, 0, 50),   -- حجم المصغر
    NormalSize = UDim2.new(0, 200, 0, 280),    -- الحجم العادي
    CircleSize = 40,           -- حجم النقطة الدائرية
    MaxCircles = 10            -- أقصى عدد نقاط
}

--// المتغيرات
local AutoClicker = {
    Active = false,
    Circles = {},              -- {GUI, Position, Active, Connection}
    IsMinimized = false,
    IsDraggingMenu = false,
    DragStart = nil,
    MenuStartPos = nil
}

--// إنشاء واجهة المستخدم
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoClickerPro"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Parent = PlayerGui

--// القائمة الرئيسية
local MainFrame = Instance.new("Frame")
MainFrame.Name = "MainMenu"
MainFrame.Size = Settings.NormalSize
MainFrame.Position = UDim2.new(0.5, -100, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 35)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = false
MainFrame.Parent = ScreenGui

--// زوايا دائرية
local UICorner = Instance.new("UICorner")
UICorner.CornerRadius = UDim.new(0, 12)
UICorner.Parent = MainFrame

--// Stroke
local UIStroke = Instance.new("UIStroke")
UIStroke.Thickness = 2
UIStroke.Color = Color3.fromRGB(0, 170, 255)
UIStroke.Parent = MainFrame

--// العنوان
local Title = Instance.new("TextLabel")
Title.Name = "Title"
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(30, 30, 45)
Title.BorderSizePixel = 0
Title.Text = "⚡ Auto Clicker"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.TextSize = 16
Title.Font = Enum.Font.GothamBold
Title.Parent = MainFrame

local TitleCorner = Instance.new("UICorner")
TitleCorner.CornerRadius = UDim.new(0, 12)
TitleCorner.Parent = Title

--// زر التصغير/التكبير
local MinimizeBtn = Instance.new("TextButton")
MinimizeBtn.Name = "MinimizeBtn"
MinimizeBtn.Size = UDim2.new(0, 30, 0, 30)
MinimizeBtn.Position = UDim2.new(1, -35, 0, 2)
MinimizeBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 70)
MinimizeBtn.BorderSizePixel = 0
MinimizeBtn.Text = "−"
MinimizeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinimizeBtn.TextSize = 20
MinimizeBtn.Font = Enum.Font.GothamBold
MinimizeBtn.Parent = Title

local MinimizeCorner = Instance.new("UICorner")
MinimizeCorner.CornerRadius = UDim.new(0, 8)
MinimizeCorner.Parent = MinimizeBtn

--// زر الإغلاق
local CloseBtn = Instance.new("TextButton")
CloseBtn.Name = "CloseBtn"
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -68, 0, 2)
CloseBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
CloseBtn.BorderSizePixel = 0
CloseBtn.Text = "×"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.TextSize = 20
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.Parent = Title

local CloseCorner = Instance.new("UICorner")
CloseCorner.CornerRadius = UDim.new(0, 8)
CloseCorner.Parent = CloseBtn

--// منطقة الأزرار
local ButtonsContainer = Instance.new("Frame")
ButtonsContainer.Name = "Buttons"
ButtonsContainer.Size = UDim2.new(1, -20, 1, -50)
ButtonsContainer.Position = UDim2.new(0, 10, 0, 45)
ButtonsContainer.BackgroundTransparency = 1
ButtonsContainer.Parent = MainFrame

local UIListLayout = Instance.new("UIListLayout")
UIListLayout.Padding = UDim.new(0, 10)
UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
UIListLayout.Parent = ButtonsContainer

--// زر تشغيل/توقيف (الرئيسي)
local ToggleBtn = Instance.new("TextButton")
ToggleBtn.Name = "ToggleBtn"
ToggleBtn.Size = UDim2.new(1, 0, 0, 45)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
ToggleBtn.BorderSizePixel = 0
ToggleBtn.Text = "▶ تشغيل"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.TextSize = 16
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.LayoutOrder = 1
ToggleBtn.Parent = ButtonsContainer

local ToggleCorner = Instance.new("UICorner")
ToggleCorner.CornerRadius = UDim.new(0, 10)
ToggleCorner.Parent = ToggleBtn

--// زر إضافة نقطة
local AddBtn = Instance.new("TextButton")
AddBtn.Name = "AddBtn"
AddBtn.Size = UDim2.new(1, 0, 0, 45)
AddBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
AddBtn.BorderSizePixel = 0
AddBtn.Text = "➕ إضافة نقطة"
AddBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AddBtn.TextSize = 16
AddBtn.Font = Enum.Font.GothamBold
AddBtn.LayoutOrder = 2
AddBtn.Parent = ButtonsContainer

local AddCorner = Instance.new("UICorner")
AddCorner.CornerRadius = UDim.new(0, 10)
AddCorner.Parent = AddBtn

--// زر إزالة نقطة
local RemoveBtn = Instance.new("TextButton")
RemoveBtn.Name = "RemoveBtn"
RemoveBtn.Size = UDim2.new(1, 0, 0, 45)
RemoveBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
RemoveBtn.BorderSizePixel = 0
RemoveBtn.Text = "➖ إزالة نقطة"
RemoveBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RemoveBtn.TextSize = 16
RemoveBtn.Font = Enum.Font.GothamBold
RemoveBtn.LayoutOrder = 3
RemoveBtn.Parent = ButtonsContainer

local RemoveCorner = Instance.new("UICorner")
RemoveCorner.CornerRadius = UDim.new(0, 10)
RemoveCorner.Parent = RemoveBtn

--// عداد النقاط
local CounterLabel = Instance.new("TextLabel")
CounterLabel.Name = "Counter"
CounterLabel.Size = UDim2.new(1, 0, 0, 30)
CounterLabel.BackgroundTransparency = 1
CounterLabel.Text = "النقاط: 0"
CounterLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
CounterLabel.TextSize = 14
CounterLabel.Font = Enum.Font.Gotham
CounterLabel.LayoutOrder = 4
CounterLabel.Parent = ButtonsContainer

--// سرعة الضغط
local SpeedLabel = Instance.new("TextLabel")
SpeedLabel.Name = "SpeedLabel"
SpeedLabel.Size = UDim2.new(1, 0, 0, 20)
SpeedLabel.BackgroundTransparency = 1
SpeedLabel.Text = "سرعة الضغط (مللي ثانية)"
SpeedLabel.TextColor3 = Color3.fromRGB(180, 180, 180)
SpeedLabel.TextSize = 12
SpeedLabel.Font = Enum.Font.Gotham
SpeedLabel.LayoutOrder = 5
SpeedLabel.Parent = ButtonsContainer

local SpeedSlider = Instance.new("TextBox")
SpeedSlider.Name = "SpeedSlider"
SpeedSlider.Size = UDim2.new(1, 0, 0, 35)
SpeedSlider.BackgroundColor3 = Color3.fromRGB(40, 40, 55)
SpeedSlider.BorderSizePixel = 0
SpeedSlider.Text = "50"
SpeedSlider.TextColor3 = Color3.fromRGB(255, 255, 255)
SpeedSlider.TextSize = 14
SpeedSlider.Font = Enum.Font.Gotham
SpeedSlider.ClearTextOnFocus = false
SpeedSlider.LayoutOrder = 6
SpeedSlider.Parent = ButtonsContainer

local SpeedCorner = Instance.new("UICorner")
SpeedCorner.CornerRadius = UDim.new(0, 8)
SpeedCorner.Parent = SpeedSlider

--// زر الإخفاء/إظهار النقاط
local ShowCirclesBtn = Instance.new("TextButton")
ShowCirclesBtn.Name = "ShowCirclesBtn"
ShowCirclesBtn.Size = UDim2.new(1, 0, 0, 35)
ShowCirclesBtn.BackgroundColor3 = Color3.fromRGB(80, 80, 100)
ShowCirclesBtn.BorderSizePixel = 0
ShowCirclesBtn.Text = "👁 إخفاء النقاط"
ShowCirclesBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ShowCirclesBtn.TextSize = 14
ShowCirclesBtn.Font = Enum.Font.Gotham
ShowCirclesBtn.LayoutOrder = 7
ShowCirclesBtn.Parent = ButtonsContainer

local ShowCorner = Instance.new("UICorner")
ShowCorner.CornerRadius = UDim.new(0, 8)
ShowCorner.Parent = ShowCirclesBtn

--// دوال المساعدة

local function Tween(obj, properties, duration)
    local tween = TweenService:Create(obj, TweenInfo.new(duration or 0.3, Enum.EasingStyle.Quad), properties)
    tween:Play()
    return tween
end

local function UpdateCounter()
    CounterLabel.Text = "النقاط: " .. #AutoClicker.Circles .. " / " .. Settings.MaxCircles
end

local function CreateCircle()
    if #AutoClicker.Circles >= Settings.MaxCircles then
        return
    end
    
    local circle = Instance.new("Frame")
    circle.Name = "ClickPoint_" .. (#AutoClicker.Circles + 1)
    circle.Size = UDim2.new(0, Settings.CircleSize, 0, Settings.CircleSize)
    circle.Position = UDim2.new(0.5, -Settings.CircleSize/2, 0.5, -Settings.CircleSize/2)
    circle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    circle.BorderSizePixel = 0
    circle.Active = true
    circle.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(1, 0) -- دائرة كاملة
    corner.Parent = circle
    
    local stroke = Instance.new("UIStroke")
    stroke.Thickness = 2
    stroke.Color = Color3.fromRGB(255, 255, 255)
    stroke.Parent = circle
    
    --// رقم النقطة
    local number = Instance.new("TextLabel")
    number.Size = UDim2.new(1, 0, 1, 0)
    number.BackgroundTransparency = 1
    number.Text = tostring(#AutoClicker.Circles + 1)
    number.TextColor3 = Color3.fromRGB(255, 255, 255)
    number.TextSize = 14
    number.Font = Enum.Font.GothamBold
    number.Parent = circle
    
    --// حالة النقطة
    local isActive = false
    local isDragging = false
    local dragStart = nil
    local circleStart = nil
    local clickConnection = nil
    
    --// سحب النقطة
    circle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            
            if not isActive then
                isDragging = true
                dragStart = input.Position
                circleStart = circle.Position
                circle.BackgroundColor3 = Color3.fromRGB(255, 200, 50) -- أصفر أثناء السحب
            end
        end
    end)
    
    circle.InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or 
                           input.UserInputType == Enum.UserInputType.Touch) then
            local delta = input.Position - dragStart
            circle.Position = UDim2.new(
                circleStart.X.Scale, 
                circleStart.X.Offset + delta.X,
                circleStart.Y.Scale, 
                circleStart.Y.Offset + delta.Y
            )
        end
    end)
    
    circle.InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or 
           input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
            if not isActive then
                circle.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- أحمر = غير نشط
            end
        end
    end)
    
    --// تخزين بيانات النقطة
    local circleData = {
        GUI = circle,
        Number = number,
        IsActive = false,
        IsDragging = false,
        ClickConnection = nil,
        Position = function() 
            return circle.AbsolutePosition + (circle.AbsoluteSize / 2)
        end
    }
    
    table.insert(AutoClicker.Circles, circleData)
    UpdateCounter()
    
    --// تأثير ظهور
    circle.Size = UDim2.new(0, 0, 0, 0)
    Tween(circle, {Size = UDim2.new(0, Settings.CircleSize, 0, Settings.CircleSize)}, 0.3)
end

local function RemoveCircle()
    if #AutoClicker.Circles == 0 then
        return
    end
    
    local circleData = table.remove(AutoClicker.Circles)
    
    --// إيقاف الضغط التلقائي
    if circleData.ClickConnection then
        circleData.ClickConnection:Disconnect()
    end
    
    --// تأثير اختفاء
    local tween = Tween(circleData.GUI, {Size = UDim2.new(0, 0, 0, 0)}, 0.2)
    tween.Completed:Connect(function()
        circleData.GUI:Destroy()
    end)
    
    --// إعادة ترقيم
    for i, data in ipairs(AutoClicker.Circles) do
        data.Number.Text = tostring(i)
    end
    
    UpdateCounter()
end

local function StartClicking()
    AutoClicker.Active = true
    
    for _, circleData in ipairs(AutoClicker.Circles) do
        if not circleData.IsActive then
            circleData.IsActive = true
            circleData.GUI.BackgroundColor3 = Color3.fromRGB(50, 255, 100) -- أخضر = نشط
            
            --// إنشاء connection للضغط التلقائي
            circleData.ClickConnection = task.spawn(function()
                while AutoClicker.Active and circleData.IsActive do
                    local pos = circleData.Position()
                    
                    --// محاكاة ضغطة شاشة
                    local vim = Instance.new("VirtualInputManager")
                    vim:SendTouchEvent(pos.X, pos.Y, 0, true, game, 0)
                    task.wait(Settings.ClickDuration)
                    vim:SendTouchEvent(pos.X, pos.Y, 0, false, game, 0)
                    
                    task.wait(Settings.ClickInterval)
                end
            end)
        end
    end
end

local function StopClicking()
    AutoClicker.Active = false
    
    for _, circleData in ipairs(AutoClicker.Circles) do
        circleData.IsActive = false
        circleData.GUI.BackgroundColor3 = Color3.fromRGB(255, 50, 50) -- أحمر = متوقف
        
        if circleData.ClickConnection then
            --// الإيقاف يتم عبر التحقق من AutoClicker.Active
        end
    end
end

local function ToggleClicking()
    if AutoClicker.Active then
        StopClicking()
        ToggleBtn.Text = "▶ تشغيل"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(0, 200, 100)
    else
        if #AutoClicker.Circles == 0 then
            --// رسالة تنبيه
            ToggleBtn.Text = "⚠ أضف نقطة أولاً!"
            task.wait(1.5)
            ToggleBtn.Text = "▶ تشغيل"
            return
        end
        StartClicking()
        ToggleBtn.Text = "⏹ توقيف"
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    end
end

local function MinimizeMenu()
    AutoClicker.IsMinimized = not AutoClicker.IsMinimized
    
    if AutoClicker.IsMinimized then
        --// تصغير
        ButtonsContainer.Visible = false
        Title.Visible = false
        Tween(MainFrame, {
            Size = Settings.MinimizedSize,
            Position = UDim2.new(MainFrame.Position.X.Scale, MainFrame.Position.X.Offset, 
                                  MainFrame.Position.Y.Scale, MainFrame.Position.Y.Offset)
        })
        MinimizeBtn.Text = "+"
        
        --// زر عائم صغير
        local floatBtn = Instance.new("TextButton")
        floatBtn.Name = "FloatBtn"
        floatBtn.Size = UDim2.new(1, 0, 1, 0)
        floatBtn.BackgroundTransparency = 1
        floatBtn.Text = "⚡"
        floatBtn.TextSize = 24
        floatBtn.Parent = MainFrame
        AutoClicker.FloatBtn = floatBtn
        
        floatBtn.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                MinimizeMenu()
            end
        end)
    else
        --// تكبير
        if AutoClicker.FloatBtn then
            AutoClicker.FloatBtn:Destroy()
            AutoClicker.FloatBtn = nil
        end
        
        ButtonsContainer.Visible = true
        Title.Visible = true
        Tween(MainFrame, {Size = Settings.NormalSize})
        MinimizeBtn.Text = "−"
    end
end

--// سحب القائمة الرئيسية
MainFrame.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        
        --// لا تسحب لو ضغط على زر
        if input.Target == MinimizeBtn or input.Target == CloseBtn then
            return
        end
        
        AutoClicker.IsDraggingMenu = true
        AutoClicker.DragStart = input.Position
        AutoClicker.MenuStartPos = MainFrame.Position
    end
end)

MainFrame.InputChanged:Connect(function(input)
    if AutoClicker.IsDraggingMenu and 
       (input.UserInputType == Enum.UserInputType.MouseMovement or 
        input.UserInputType == Enum.UserInputType.Touch) then
        
        local delta = input.Position - AutoClicker.DragStart
        MainFrame.Position = UDim2.new(
            AutoClicker.MenuStartPos.X.Scale,
            AutoClicker.MenuStartPos.X.Offset + delta.X,
            AutoClicker.MenuStartPos.Y.Scale,
            AutoClicker.MenuStartPos.Y.Offset + delta.Y
        )
    end
end)

MainFrame.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or 
       input.UserInputType == Enum.UserInputType.Touch then
        AutoClicker.IsDraggingMenu = false
    end
end)

--// ربط الأزرار
ToggleBtn.MouseButton1Click:Connect(ToggleClicking)

AddBtn.MouseButton1Click:Connect(function()
    CreateCircle()
    --// تأثير نبضة
    AddBtn.BackgroundColor3 = Color3.fromRGB(100, 200, 255)
    task.wait(0.1)
    AddBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 255)
end)

RemoveBtn.MouseButton1Click:Connect(function()
    RemoveCircle()
    --// تأثير نبضة
    RemoveBtn.BackgroundColor3 = Color3.fromRGB(255, 100, 100)
    task.wait(0.1)
    RemoveBtn.BackgroundColor3 = Color3.fromRGB(200, 60, 60)
end)

MinimizeBtn.MouseButton1Click:Connect(MinimizeMenu)

CloseBtn.MouseButton1Click:Connect(function()
    --// إيقاف كل شيء
    StopClicking()
    ScreenGui:Destroy()
end)

SpeedSlider.FocusLost:Connect(function()
    local speed = tonumber(SpeedSlider.Text)
    if speed and speed >= 10 and speed <= 1000 then
        Settings.ClickInterval = speed / 1000
    else
        SpeedSlider.Text = tostring(Settings.ClickInterval * 1000)
    end
end)

local circlesVisible = true
ShowCirclesBtn.MouseButton1Click:Connect(function()
    circlesVisible = not circlesVisible
    for _, data in ipairs(AutoClicker.Circles) do
        data.GUI.Visible = circlesVisible
    end
    ShowCirclesBtn.Text = circlesVisible and "👁 إخفاء النقاط" or "👁 إظهار النقاط"
end)

--// إعدادات إضافية
UpdateCounter()

--// إشعار بدء التشغيل
local notify = Instance.new("TextLabel")
notify.Size = UDim2.new(0, 200, 0, 40)
notify.Position = UDim2.new(0.5, -100, 0, -50)
notify.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
notify.BorderSizePixel = 0
notify.Text = "✅ Auto Clicker جاهز!"
notify.TextColor3 = Color3.fromRGB(255, 255, 255)
notify.TextSize = 14
notify.Font = Enum.Font.GothamBold
notify.Parent = ScreenGui

local notifyCorner = Instance.new("UICorner")
notifyCorner.CornerRadius = UDim.new(0, 10)
notifyCorner.Parent = notify

Tween(notify, {Position = UDim2.new(0.5, -100, 0, 20)}, 0.5)
task.wait(3)
Tween(notify, {Position = UDim2.new(0.5, -100, 0, -50)}, 0.5).Completed:Connect(function()
    notify:Destroy()
end)

print("✅ Auto Clicker Pro loaded successfully!")
