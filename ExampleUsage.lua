local KeyWindow = Library:CreateWindow("Key System", UDim2.fromOffset(300, 180))
local UpdateWindow = Library:CreateWindow("Updates", UDim2.fromOffset(300, 300))
UpdateWindow.Outer.Position = UDim2.new(0.7, 0, 0.5, 0)

local KeyBox = KeyWindow:AddTextBox("Enter Key...", UDim2.new(0.1, 0, 0.15, 0))
local RememberToggle = KeyWindow:AddToggle("Remember Key", UDim2.new(0.1, 0, 0.36, 0), false)

local KeyPath = "DisabledHubConfigs/Key"
local FileName = "SavedKey.lua"

local SavedKey = Library:LoadKey(KeyPath, FileName)
if SavedKey then
    KeyBox.Text = SavedKey
    RememberToggle.SetState(true)
end

local SubmitButton = KeyWindow:AddButton("Submit", UDim2.new(0.1, 0, 0.65, 0), function()
    if KeyBox.Text == "Skibi-nfpw" then
        if RememberToggle.GetState() then
            Library:SaveKey(KeyPath, FileName, KeyBox.Text)
        end
        KeyWindow:Close()
        UpdateWindow:Close()
    else
        local player = game.Players.LocalPlayer
        player:Kick("Invalid Key")
        if player then
            player:Destroy()
        end
    end
end)

local GetKeyButton = KeyWindow:AddButton("Get Key", UDim2.new(0.55, 0, 0.65, 0), function()
    if setclipboard then
        setclipboard("https://yourwebsite.com/getkey")
    else
        warn("setclipboard is not available.")
    end
end)

local ScrollFrame = Library:Create('ScrollingFrame', {
    Position = UDim2.new(0.05, 0, 0.05, 0),
    Size = UDim2.new(0.9, 0, 0.9, 0),
    BackgroundTransparency = 1,
    BorderSizePixel = 0,
    ScrollBarThickness = 3,
    ScrollBarImageColor3 = Library.AccentColor,
    Parent = UpdateWindow.Outer.Frame.Frame
})

function CreateUpdateItem(Icon, Title, Content, YPosition)
    local Container = Library:Create('Frame', {
        Position = UDim2.new(0, 0, 0, YPosition),
        Size = UDim2.new(1, 0, 0, 30),
        BackgroundTransparency = 1,
        Parent = ScrollFrame
    })

    local IconLabel = Library:CreateLabel({
        Position = UDim2.new(0, 5, 0, 0),
        Size = UDim2.new(0, 20, 0, 20),
        Text = Icon,
        TextSize = 16,
        Parent = Container
    })

    local TitleLabel = Library:CreateLabel({
        Position = UDim2.new(0, 30, 0, 0),
        Size = UDim2.new(0.9, -30, 0, 20),
        Text = Title,
        TextColor3 = Library.AccentColor,
        TextSize = 14,
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Container
    })

    local ContentLabel = Library:CreateLabel({
        Position = UDim2.new(0, 30, 0, 20),
        Size = UDim2.new(0.9, -30, 0, 20),
        Text = Content,
        TextSize = 13,
        TextColor3 = Color3.new(0.8, 0.8, 0.8),
        TextXAlignment = Enum.TextXAlignment.Left,
        Parent = Container
    })

    return 45
end

local YOffset = 0

YOffset = YOffset + CreateUpdateItem("🆕", "New Features", "Modern UI design with enhanced", YOffset)
YOffset = YOffset + CreateUpdateItem("", "", "colors and smoother animations", YOffset - 25)

YOffset = YOffset + CreateUpdateItem("⚡", "Improvements", "Enhanced button animations and", YOffset)
YOffset = YOffset + CreateUpdateItem("", "", "interactions with better feedback", YOffset - 25)

YOffset = YOffset + CreateUpdateItem("🔧", "Bug Fixes", "Fixed dragging functionality", YOffset)
YOffset = YOffset + CreateUpdateItem("", "", "and various UI improvements", YOffset - 25)

ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, YOffset + 20)
