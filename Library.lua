local Library = {}
Library.MainColor = Color3.new(0.098, 0.098, 0.098)
Library.BackgroundColor = Color3.new(0.137, 0.137, 0.137)
Library.AccentColor = Color3.new(0.298, 0.447, 0.894)
Library.OutlineColor = Color3.new(0.176, 0.176, 0.176)
Library.TextColor = Color3.new(0.9, 0.9, 0.9)
Library.Font = Enum.Font.Gotham
Library.RegistryMap = {}

local ProtectGui = protectgui or (syn and syn.protect_gui) or (function(gui)
    gui.Parent = cloneref(game:GetService("CoreGui"))
end)

local TweenService = game:GetService("TweenService")
local UserInputService = cloneref(game:GetService("UserInputService"))
local HttpService = cloneref(game:GetService("HttpService"))
local CoreGui = cloneref(game:GetService("CoreGui"))

local ScreenGui = Instance.new("ScreenGui")
ProtectGui(ScreenGui)
ScreenGui.Name = "KeySystem"
ScreenGui.Parent = CoreGui

function Library:SaveKey(KeyPath, FileName, key)
    if not (isfolder and makefolder and writefile) then
        warn("File system functions are not available.")
        return
    end
    if not isfolder(KeyPath) then
        makefolder(KeyPath)
    end
    writefile(KeyPath .. "/" .. FileName, HttpService:JSONEncode({key = key}))
end

function Library:LoadKey(KeyPath, FileName)
    if not (isfolder and readfile) then
        warn("File system functions are not available.")
        return nil
    end
    if isfolder(KeyPath) and isfile(KeyPath .. "/" .. FileName) then
        local data = HttpService:JSONDecode(readfile(KeyPath .. "/" .. FileName))
        return data.key
    end
    return nil
end

function Library:Create(Class, Properties)
    local Object = Instance.new(Class)
    for Property, Value in next, Properties do
        Object[Property] = Value
    end
    return Object
end

function Library:CreateLabel(Properties)
    local Label = self:Create('TextLabel', {
        BackgroundTransparency = 1,
        Font = self.Font,
        TextColor3 = self.TextColor,
        TextSize = 14,
        TextStrokeTransparency = 1,
    })
    
    for Property, Value in next, Properties do
        Label[Property] = Value
    end
    
    return Label
end

function Library:AddToRegistry(Object, Properties)
    self.RegistryMap[Object] = { Properties = Properties }
end

function Library:AnimateButton(Button)
    local OriginalColor = Button.BackgroundColor3
    
    Button.MouseEnter:Connect(function()
        local Tween = TweenService:Create(Button, TweenInfo.new(0.3), {
            BackgroundColor3 = self.AccentColor,
            TextColor3 = Color3.new(1, 1, 1)
        })
        Tween:Play()
    end)

    Button.MouseLeave:Connect(function()
        local Tween = TweenService:Create(Button, TweenInfo.new(0.3), {
            BackgroundColor3 = OriginalColor,
            TextColor3 = self.TextColor
        })
        Tween:Play()
    end)
end

function Library:Destroy()
    cloneref(game:GetService("CoreGui")):FindFirstChild("KeySystem"):Destroy()
end

function Library:MakeDraggable(Frame)
    local Dragging, DragInput, DragStart, StartPos

    Frame.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then
            Dragging = true
            DragStart = Input.Position
            StartPos = Frame.Position

            Input.Changed:Connect(function()
                if Input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    Frame.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then
            DragInput = Input
        end
    end)

    UserInputService.InputChanged:Connect(function(Input)
        if Input == DragInput and Dragging then
            local Delta = Input.Position - DragStart
            Frame.Position = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + Delta.X, StartPos.Y.Scale, StartPos.Y.Offset + Delta.Y)
        end
    end)
end

function Library:CreateWindow(Title, Size)
    local Window = {}
    local Library = self

    local Outer = Library:Create('Frame', {
        AnchorPoint = Vector2.new(0.5, 0.5),
        BackgroundColor3 = Library.OutlineColor,
        BorderSizePixel = 0,
        Position = UDim2.fromScale(0.5, 0.5),
        Size = Size or UDim2.fromOffset(300, 150),
        Visible = true,
        ZIndex = 1,
        Parent = ScreenGui
    })

    Library:MakeDraggable(Outer)

    local Inner = Library:Create('Frame', {
        BackgroundColor3 = Library.MainColor,
        BorderColor3 = Library.OutlineColor,
        BorderMode = Enum.BorderMode.Inset,
        Position = UDim2.new(0, 1, 0, 1),
        Size = UDim2.new(1, -2, 1, -2),
        ZIndex = 1,
        Parent = Outer
    })

    local TitleLabel = Library:CreateLabel({
        Position = UDim2.new(0, 10, 0, 0),
        Size = UDim2.new(0, 0, 0, 25),
        Text = Title,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 1,
        Parent = Inner
    })

    local MainSection = Library:Create('Frame', {
        BackgroundColor3 = Library.BackgroundColor,
        BorderColor3 = Library.OutlineColor,
        Position = UDim2.new(0, 8, 0, 25),
        Size = UDim2.new(1, -16, 1, -33),
        ZIndex = 1,
        Parent = Inner
    })

    function Window:Close()
        Outer:Destroy()
    end

    function Window:AddTextBox(Text, Position)
        local TextBoxContainer = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.OutlineColor,
            Position = Position,
            Size = UDim2.new(0.8, 0, 0, 30),
            ZIndex = 2,
            Parent = MainSection
        })

        local Corner = Library:Create('UICorner', {
            CornerRadius = UDim.new(0, 4),
            Parent = TextBoxContainer
        })

        local TextBox = Library:Create('TextBox', {
            BackgroundTransparency = 1,
            Position = UDim2.new(0, 10, 0, 0),
            Size = UDim2.new(1, -20, 1, 0),
            Font = Library.Font,
            PlaceholderText = Text,
            PlaceholderColor3 = Color3.new(0.7, 0.7, 0.7),
            Text = "",
            TextColor3 = Library.TextColor,
            TextSize = 14,
            ZIndex = 3,
            Parent = TextBoxContainer
        })
        
        TextBox.Focused:Connect(function()
            local Tween = TweenService:Create(TextBoxContainer, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.AccentColor,
                BorderColor3 = Library.AccentColor
            })
            Tween:Play()
        end)

        TextBox.FocusLost:Connect(function()
            local Tween = TweenService:Create(TextBoxContainer, TweenInfo.new(0.2), {
                BackgroundColor3 = Library.MainColor,
                BorderColor3 = Library.OutlineColor
            })
            Tween:Play()
        end)
        
        return TextBox
    end
    
    function Window:AddButton(Text, Position, Callback)
        local Button = Library:Create('TextButton', {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.OutlineColor,
            Position = Position,
            Size = UDim2.new(0.35, 0, 0, 30),
            Font = Library.Font,
            Text = Text,
            TextColor3 = Library.TextColor,
            TextSize = 14,
            ZIndex = 2,
            AutoButtonColor = false,
            Parent = MainSection
        })
        
        local Corner = Library:Create('UICorner', {
            CornerRadius = UDim.new(0, 4),
            Parent = Button
        })

        function StartAnimation()
            local Tween = TweenService:Create(Button, TweenInfo.new(0.3), {
                BackgroundColor3 = Library.AccentColor,
                TextColor3 = Color3.new(1, 1, 1)
            })
            Tween:Play()
        end
    
        function EndAnimation()
            local Tween = TweenService:Create(Button, TweenInfo.new(0.3), {
                BackgroundColor3 = Library.MainColor,
                TextColor3 = Library.TextColor
            })
            Tween:Play()
        end
    
        Button.InputBegan:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                StartAnimation()
            end
        end)
    
        Button.InputEnded:Connect(function(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                EndAnimation()
                Callback()
            end
        end)
    
        Button.MouseEnter:Connect(StartAnimation)
        Button.MouseLeave:Connect(EndAnimation)
        
        return Button
    end

    function Window:AddToggle(Text, Position, DefaultState)
        local Toggle = Library:Create('TextButton', {
            BackgroundTransparency = 1,
            Position = UDim2.new(Position.X.Scale, Position.X.Offset, Position.Y.Scale, Position.Y.Offset + 10),
            Size = UDim2.new(0.8, 0, 0, 20),
            Text = "",
            ZIndex = 2,
            Parent = MainSection
        })
    
        local Checkbox = Library:Create('Frame', {
            BackgroundColor3 = Library.MainColor,
            BorderColor3 = Library.OutlineColor,
            Position = UDim2.new(0, 0, 0, 0),
            Size = UDim2.new(0, 20, 0, 20),
            ZIndex = 3,
            Parent = Toggle
        })
    
        local CheckboxCorner = Library:Create('UICorner', {
            CornerRadius = UDim.new(0, 4),
            Parent = Checkbox
        })
    
        local Checkmark = Library:Create('TextLabel', {
            BackgroundTransparency = 1,
            Position = UDim2.new(0.1, 0, 0.1, 0),
            Size = UDim2.new(0.8, 0, 0.8, 0),
            Font = Enum.Font.GothamBold,
            Text = "✓",
            TextColor3 = Library.AccentColor,
            TextSize = 14,
            TextTransparency = DefaultState and 0 or 1,
            ZIndex = 4,
            Parent = Checkbox
        })
    
        local Label = Library:CreateLabel({
            Position = UDim2.new(0, 30, 0, 0),
            Size = UDim2.new(0.7, 0, 1, 0),
            Text = Text,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 3,
            Parent = Toggle
        })
    
        local State = DefaultState
        local IsAnimating = false

        local function ToggleState(input)
            if input.UserInputType == Enum.UserInputType.MouseButton1 or 
               input.UserInputType == Enum.UserInputType.Touch then
                if not IsAnimating then
                    IsAnimating = true
                    State = not State
                    
                    local Tween = TweenService:Create(Checkmark, TweenInfo.new(0.2), {
                        TextTransparency = State and 0 or 1
                    })
                    
                    Tween.Completed:Connect(function()
                        IsAnimating = false
                    end)
                    
                    Tween:Play()

                    if input.UserInputType == Enum.UserInputType.Touch and UserInputService.TouchEnabled then
                        if UserInputService.VibrationMotor then
                            UserInputService.VibrationMotor:Vibrate(0.1)
                        end
                    end
                end
            end
        end
    
        Toggle.InputBegan:Connect(ToggleState)
    
        return {
            GetState = function() return State end,
            SetState = function(NewState)
                if not IsAnimating then
                    IsAnimating = true
                    State = NewState
                    
                    local Tween = TweenService:Create(Checkmark, TweenInfo.new(0.2), {
                        TextTransparency = State and 0 or 1
                    })
                    
                    Tween.Completed:Connect(function()
                        IsAnimating = false
                    end)
                    
                    Tween:Play()
                end
            end,
            Destroy = function()
                Toggle:Destroy()
            end
        }
    end    

    Window.Outer = Outer
    return Window
end

return Library
