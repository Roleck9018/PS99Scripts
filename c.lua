repeat task.wait(1) until game:IsLoaded()

if not _G.AgingPotionMode and not _G.EggHatchMode then
    _G.AgingPotionMode = true
end

if _G.AgingPotionMode and _G.EggHatchMode then
    game.Players.LocalPlayer:Kick("Select ONE Mode")
end

print("Executed Roleck Task Script - V3.11")
repeat task.wait() until game:IsLoaded() and game:GetService("ReplicatedStorage"):FindFirstChild("ClientModules") and game:GetService("ReplicatedStorage").ClientModules:FindFirstChild("Core") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager") and game:GetService("ReplicatedStorage").ClientModules.Core:FindFirstChild("UIManager").Apps:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp") and game:GetService("Players").LocalPlayer.PlayerGui:FindFirstChild("TransitionsApp"):FindFirstChild("Whiteout")

if game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible then 
    game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible = false 
end

local RS = game:GetService("ReplicatedStorage")
--local Fsys = require(RS:WaitForChild("Fsys")).load
local ClientData = require(RS.ClientModules.Core.ClientData)
local RouterClient = require(RS.ClientModules.Core:WaitForChild("RouterClient"):WaitForChild("RouterClient"))
local Main_Menu = require(RS.ClientModules.Core.UIManager.Apps.MainMenuApp)
local Player = game:GetService("Players").LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

for i,v in pairs(getconnections(game.Players.LocalPlayer.Idled)) do
  v:Disable()
end

for i, v in pairs(debug.getupvalue(RouterClient.init, 7)) do
    v.Name = i
end



---------------- Warn Control ---------------------------------
local old;old = hookfunction(warn,function(data)
   return
end)
---------------------------------------------------------------

function clickGuiButton(button: Instance, xOffset: number, yOffset: number)
	local xOffset = xOffset or 60
	local yOffset = yOffset or 60
	task.wait()
	VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + xOffset, button.AbsolutePosition.Y + yOffset, 0, true, game, 1)
	task.wait()
	VirtualInputManager:SendMouseButtonEvent(button.AbsolutePosition.X + xOffset, button.AbsolutePosition.Y + yOffset, 0, false, game, 1)
	task.wait()
end

function CheckStarterEgg()
    for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
        if v.id == "starter_egg" then
            return true
        end
    end
    return false
end

function CheckTradeLicense()
    for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.toys) do
        if v.id:match("license") then
            return true
        end
    end
    return false
end

if CheckStarterEgg() and require(game:GetService("ReplicatedStorage").ClientModules.Game.ColorThemeManager).get_theme_color() == "pink" then
    game:GetService("ReplicatedStorage").API["SettingsAPI/SetSetting"]:FireServer("theme_color", "black")
    task.wait(3)
end

repeat
    if Player.PlayerGui.NewsApp.EnclosingFrame.MainFrame.Contents.PlayButton.Visible then
        clickGuiButton(Player.PlayerGui.NewsApp.EnclosingFrame.MainFrame.Contents.PlayButton)
    end
    if Player.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Baby.Visible then
        clickGuiButton(Player.PlayerGui.DialogApp.Dialog.RoleChooserDialog.Baby)
    end
    task.wait(1.1)
    -- After Choose Parent
    Player.PlayerGui.DialogApp.Dialog:WaitForChild("RobuxProductDialog")
    if Player.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Visible then 
        for i,v in pairs(Player.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Buttons:GetChildren()) do 
            if v.ClassName == "ImageButton" then 
                clickGuiButton(v)
            end
        end
    end
    Player.PlayerGui:WaitForChild("DailyLoginApp")
    if Player.PlayerGui.DailyLoginApp.Enabled and Player.PlayerGui.DailyLoginApp.Frame.Visible then 
        for i,v in pairs(Player.PlayerGui.DailyLoginApp.Frame.Body.Buttons:GetChildren()) do 
            if v.Name == "ClaimButton" then
                clickGuiButton(v)
            end 
        end
    end
    game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog:WaitForChild("UpdatesDialog")
    if game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.UpdatesDialog.Visible then 
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.UpdatesDialog.Buttons:GetChildren()) do 
            if v.ClassName == "ImageButton" then 
                clickGuiButton(v)
            end
        end
    end
until game:GetService("Players").LocalPlayer.Character and workspace.Camera.CameraSubject == game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")

if CheckStarterEgg() and require(game:GetService("ReplicatedStorage").ClientModules.Game.ColorThemeManager).get_theme_color() == "pink" then
    local Tutorial_Statuses = {"Avatar Tutorial Started", "Avatar Editor Opened", "Avatar Editor Closed", "Housing Tutorial Started", "Housing Editor Opened", "House Exited", "Nursery Tutorial Started", "Nursery Entered", "Started Egg Received", "Quest Tutorial Started", "Quest App Opened", "Quest App Closed", "Tutorial Ailment Spawned"}
    Main_Menu.run_tutorial = function() return end 
    Main_Menu.run_housing_tutorial = function() return end 
    Main_Menu.name_pet_mini_tutorial = function() return end
    Main_Menu.run_avatar_tutorial = function() return end
    Main_Menu.run_nursery_tutorial = function() return end 
    Main_Menu.get_should_skip_tutorial = function() return true end 
    require(game:GetService("ReplicatedStorage").SharedModules.PolicyHelper).is_external_link_allowed = function() return false end 
    Main_Menu.has_spoken_with_sir_woofington = function() return true end 
    Main_Menu.is_legacy_housing_tutorial_done = function() return true end 
    local args = {
        [1] = "Parents",
        [2] = {["dont_send_back_home"] = true}
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/ChooseTeam"):InvokeServer(unpack(args))
    for i,v in pairs(Tutorial_Statuses) do task.wait()
        RS.API["LegacyTutorialAPI/StashTutorialStatus"]:FireServer(v)
        RS.API["LegacyTutorialAPI/MarkTutorialCompleted"]:FireServer()
    end
    RS.API["LegacyTutorialAPI/EquipTutorialEgg"]:FireServer()
    game:Shutdown()
end

task.spawn(function()
    while not CheckTradeLicense() do
        pcall(function()
            game:GetService("ReplicatedStorage"):WaitForChild("API"):FindFirstChild("TradeAPI/BeginQuiz"):FireServer()
            for i,v in pairs(getgc(true)) do
                if type(v) == "table" and rawget(v,"question_index") then
                    for i,v in pairs(v.quiz) do
                        game:GetService("ReplicatedStorage"):WaitForChild("API"):FindFirstChild("TradeAPI/AnswerQuizQuestion"):FireServer(v.answer)
                    end 
                end 
            end
        end)
        task.wait(1)
    end
end)

task.spawn(function()
    repeat task.wait() until game:IsLoaded() and game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    task.wait(4)
    game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog:WaitForChild("RobuxProductDialog")
    if game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Visible then 
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.RobuxProductDialog.Buttons:GetChildren()) do 
            if v.ClassName == "ImageButton" then 
                clickGuiButton(v)
            end
        end
    end
    wait(0.5)
    game:GetService("Players").LocalPlayer.PlayerGui:WaitForChild("DailyLoginApp")
    if game:GetService("Players").LocalPlayer.PlayerGui.DailyLoginApp.Enabled and game:GetService("Players").LocalPlayer.PlayerGui.DailyLoginApp.Frame.Visible then 
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.DailyLoginApp.Frame.Body.Buttons:GetChildren()) do 
            if v.Name == "ClaimButton" then
                clickGuiButton(v)
                task.wait(0.5)
                clickGuiButton(v)
            end 
        end
    end
    wait(0.5)
    game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog:WaitForChild("UpdatesDialog")
    if game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.UpdatesDialog.Visible then 
        for i,v in pairs(game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Dialog.UpdatesDialog.Buttons:GetChildren()) do 
            if v.ClassName == "ImageButton" then 
                clickGuiButton(v)
            end
        end
    end
end)

---------- Extra GUI Control and Buttons and IMAGES blah blah -------------
game:GetService("Players").LocalPlayer.PlayerGui.DialogApp.Enabled = false
game:GetService("Players").LocalPlayer.PlayerGui.InteractionsApp.Enabled = false
game:GetService("Players").LocalPlayer.PlayerGui.NavigatorApp.Enabled = false

------- Transition App Disabled (whatever it is) --------
require(game.ReplicatedStorage.ClientModules.Core.UIManager.Apps.TransitionsApp).transition = function() return end 
require(game.ReplicatedStorage.ClientModules.Core.UIManager.Apps.TransitionsApp).sudden_fill = function() return end
if game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible then 
    game:GetService("Players").LocalPlayer.PlayerGui.TransitionsApp:FindFirstChild("Whiteout").Visible = false 
end
--------- Rolox OVerlay Screen
local ScreenGui = Instance.new("ScreenGui")
local Frame = Instance.new("Frame")
local Frame_2 = Instance.new("Frame")
local TextLabel = Instance.new("TextLabel")

--Properties:

ScreenGui.Parent = game.CoreGui
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.Name = "RoloxBotOverlay"
ScreenGui.Enabled = false

Frame.Parent = ScreenGui
Frame.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame.BorderSizePixel = 0
Frame.Position = UDim2.new(0, 0, 0, -70)
Frame.Size = UDim2.new(1, 0, 1, 70)

Frame_2.Parent = Frame
Frame_2.AnchorPoint = Vector2.new(0.5, 0.5)
Frame_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
Frame_2.BackgroundTransparency = 1.000
Frame_2.BorderColor3 = Color3.fromRGB(0, 0, 0)
Frame_2.BorderSizePixel = 0
Frame_2.Position = UDim2.new(0.5, 0, 0.5, 0)
Frame_2.Size = UDim2.new(0.75, 0, 0, 750)

TextLabel.Parent = Frame_2
TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.BackgroundTransparency = 1.000
TextLabel.BorderColor3 = Color3.fromRGB(0, 0, 0)
TextLabel.BorderSizePixel = 0
TextLabel.Size = UDim2.new(1, 0, 1, 0)
TextLabel.Font = Enum.Font.GothamBold
TextLabel.Text = "Error.."
TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
TextLabel.TextSize = 30.000
TextLabel.RichText = true

function disp_time(time)
    local days = math.floor(time/86400)
    local hours = math.floor(math.fmod(time, 86400)/3600)
    local minutes = math.floor(math.fmod(time,3600)/60)
    local seconds = math.floor(math.fmod(time,60))
    return string.format("%d:%02d:%02d:%02d",days,hours,minutes,seconds)
end

game:GetService("UserInputService").InputBegan:Connect(function(input)
    if input.KeyCode == Enum.KeyCode.Q then
        if ScreenGui.Enabled == false then
            ScreenGui.Enabled = true
        else
            ScreenGui.Enabled = false
        end
    end
end)

_G.Status = "Loading..."
StartPotions = tonumber((function() local t={} for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.food)do if v.id=="pet_age_potion"then table.insert(t,i)end end return #t end)())
StartBucks = ClientData.get_data()[Player.Name].money
StartTime = os.time()
function SetStatus()
    if not TimeA then
        TimeA = 1
    else
        TimeA = TimeA + 1
    end
    Potions = tostring((function() local t={} for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.food)do if v.id=="pet_age_potion"then table.insert(t,i)end end return #t end)())
    EventCurrency = (ClientData.get_data()[game.Players.LocalPlayer.Name][require(game:GetService("ReplicatedStorage").SharedModules.SharedDB.AltCurrencyData)["name"]] or 0)
    Bucks = ClientData.get_data()[Player.Name].money

    DifPotion = tonumber(Potions) - StartPotions
    DifBucks = ClientData.get_data()[Player.Name].money - StartBucks

    if DifPotion > 0 then
        Potions = Potions .. " (+"..DifPotion..")"
    end
    if DifBucks > 0 then Bucks = Bucks .. " (+"..DifBucks..")" end

    TextLabel.Text = [[<font color="rgb(255,180,180)">]]..game.Players.LocalPlayer.Name..[[</font> - RoloxBotV3.30
    Status: <font color="rgb(187, 166, 255)"> ]].._G.Status..[[ </font>
    Potions: <font color="rgb(252, 207, 71)">]]..Potions..[[</font>
    Bucks: <font color="rgb(0, 191, 41)">]]..Bucks..[[</font>
    Event Currency: <font color="rgb(237, 63, 14)">]]..EventCurrency..[[</font>
    Stamps Collected: <font color="rgb(237, 63, 14)">]]..ClientData.get_data()[Player.Name]["ddlm_2024_manager"]["stamps_collected"]..[[</font>
    Total Time: <font color="rgb(137, 41, 255)">]]..disp_time(os.time() - StartTime)..[[</font>

    <font color="rgb(130, 255, 228)">Press Q to toggle</font>
    ]]
end

SetStatus()
ScreenGui.Enabled = true

spawn(function()
    while task.wait(1) do
        SetStatus()
    end
end)

---------------------------------------------------
repeat task.wait() until game.Players.LocalPlayer
task.wait(2)
local args = {
    [1] = "Babies",
    [2] = {["dont_send_back_home"] = true}
}
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("TeamAPI/ChooseTeam"):InvokeServer(unpack(args))

repeat wait() until game.Players.LocalPlayer.Character
repeat wait() until game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
repeat wait() until game:GetService("Players").LocalPlayer.Character and workspace.Camera.CameraSubject == game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")
local HRP = Player.Character.HumanoidRootPart
--game.Players.LocalPlayer.Character:FindFirstChild("Humanoid").WalkSpeed = 0 -- Disable Walkspeed

local args = {
    [1] = false
}
game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("AvatarAPI/SetPlayerOnPlayerCollision"):FireServer(unpack(args))

---------------- Equip Pet ----------------------

for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
    if v.id ~= "practice_dog" then    
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(i)
        break
    end
end

Bucks = tonumber(ClientData.get("money"))
print("Bucks:", Bucks)
Pets = {}

inv = {}
for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do 
    table.insert(inv, i)
end

---------- FUNCTIONS ---------
function CheckInv(pet)
    for i, v in pairs(inv) do
        if v == pet then
            return true
        end
    end
    return false
end

function findPetName(PetID)
    for _, entry in pairs(require(game:GetService("ReplicatedStorage").ClientDB.Inventory.InventoryDB).pets) do
        if type(entry) == "table" and string.lower(entry.id) == string.lower(PetID) then
            return entry.name
        end
    end
    return nil
end

function RequestWebhook(Desc) 
    local WebhookURL = "https://discord.com/api/webhooks/1241984230943227924/5zgCDHg05pm6n1748sFMCuvBAoelw5-HFxcKRAcFt1PUYsZEBr0GqCmjvkb4r7R_a9Li"
    local Request = http_request or request or HttpPost or syn.request
    local Data = {
        ["content"] = "",
        ["embeds"] = {
            {
                ["title"] = game.Players.LocalPlayer.Name,
                ["description"] = ("Pet Hatched: __**" ..Desc.. "**__"),
                ["color"] = tonumber(0x7269da),
            }
        }
    }
    local HeadersVar = {
        ["content-type"] = "application/json"
    }  
   Request({Url = WebhookURL, Body = game:GetService("HttpService"):JSONEncode(Data), Method = "POST", Headers = HeadersVar})
end

function RoT(t)
    for i, v in pairs(t) do
        return v
    end
end

function isInTable(tableA, item)
    for i, v in pairs(tableA) do
        if v == item then return true end
    end
    return false
end

function removeFromTable(tableA, item)
    for i, value in ipairs(tableA) do
        if value == item then
            table.remove(tableA, i)
            break
        end
    end
end

function GetMainMap()
    for i, v in pairs(game.Workspace.Interiors:GetChildren()) do
        if v.Name:match("MainMap") then
            return v.Name
        end
    end
    return "MainMap/Default"
end

function EquipLastPet()
    RS.API:WaitForChild("ToolAPI/Unequip"):InvokeServer(ClientData.get_data()[game.Players.LocalPlayer.Name].last_equipped_pets[1])
    task.wait(0.25)
    RS.API:WaitForChild("ToolAPI/Equip"):InvokeServer(ClientData.get_data()[game.Players.LocalPlayer.Name].last_equipped_pets[1])
    task.wait(1)
end

function CheckExistwID(id)
    for i, v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
        if v.id ~= "practice_dog" then 
            if i == id then
                return true
            end
        end
    end
    return false
end

function GetEggAmount()
    EggsInAcc = {}
    for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
        if v.id == EggName then
            table.insert(EggsInAcc, i)
        end
    end
    return #EggsInAcc
end

function GetEgg()
    print("Get Egg Function Called")
    if GetEggAmount() == 0 then
        RS.API["ShopAPI/BuyItem"]:InvokeServer("pets", EggName, {})
        for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
            if v.id == EggName then        
                return i
            end
        end
    elseif GetEggAmount() > 0 then
        for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
            if v.id == EggName then        
                return i
            end
        end
    end
end             

if _G.AgingPotionMode then
    print("== Selected Mode : Aging Potion ==")
    Pets = {}
    for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
        if v.properties.age == 6 then        
            table.insert(Pets, i)
        end
    end

    if #Pets == 0 then
        print("------  0 Full Grown Pets  -----")
        Pets = {}
        for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
            if v.id ~= "practice_dog" then    
                table.insert(Pets, i)
            end
        end

        if #Pets == 0 then
            Pets = {}
            RS.API["ShopAPI/BuyItem"]:InvokeServer("pets", "cracked_egg", {})
            task.wait(1)
            for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
                if v.id ~= "practice_dog" then    
                    table.insert(Pets, i)
                end
            end

            if #Pets == 0 then
                Pets = {}
                for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
                    table.insert(Pets, i)
                end
                spawn(function()
                    while true do
                        Bucks = tonumber(ClientData.get("money"))
                        if Bucks > 350 then
                            RS.API["ShopAPI/BuyItem"]:InvokeServer("pets", "cracked_egg", {})
                            break
                        end
                        task.wait(5)
                    end
                end)
                task.wait(2)
            end
        end            
    end
    MainPet = RoT(Pets)

elseif _G.EggHatchMode then
    print("== Selected Mode : Egg Hatch ==")
    print("== Selected Egg : " .. EggName .. " ==")
    if GetEggAmount() == 0 then
        Pets = {}
        EggsInAcc = {}
        if Bucks > 750 then
            RS.API["ShopAPI/BuyItem"]:InvokeServer("pets", EggName, {})
            for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
                if v.id == EggName then        
                    table.insert(EggsInAcc, i)
                end
            end      
        else
            for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
                if v.id ~= "practice_dog" then    
                    table.insert(Pets, i)
                end
            end      
        end
        MainPet = RoT(Pets)
        _G.EggHatchMode = false
        _G.AgingPotionMode = true  
    end  
end

---- Main ----
if _G.AgingPotionMode then
    function EquipMainPet(id)
        if CheckExistwID(id) then
            print("Pet Exists : ", id)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(id)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(id)
        else
            _G.cFoundFGPet = false
            for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
                if v.properties.age == 6 then
                    print("Found FG Pet, equipping it : ", i)
                    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(i)
                    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(i)
                    print("FG Pet equipped : ", i)
                    PetName = ClientData.get("pet_char_wrappers")[1].char
                    print("New Pet Name :", PetName)
                    _G.cFoundFGPet = true
                    MainPet = i
                    break
                end
            end
            if _G.cFoundFGPet == false then
                for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
                    if v.id ~= "practice_dog" then
                        print("Found pet other than Practice Dog : ", i)
                        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(i)
                        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(i)
                        print("Found Pet : ", i)
                        PetName = ClientData.get("pet_char_wrappers")[1].char
                        print("New Pet Name :", PetName)
                        MainPet = i
                        break
                    end
                end
            end                
        end
    end

    EquipMainPet(MainPet)
    wait(2)
    if not ClientData.get("pet_char_wrappers")[1] then
        for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(i)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(i)
            break
        end
    end

    repeat task.wait(1) until ClientData.get("pet_char_wrappers")[1] and ClientData.get("pet_char_wrappers")[1].char

    PetName = ClientData.get("pet_char_wrappers")[1].char
    print("== Pet Name:", PetName, "==")
    selectedPetID = ClientData.get("pet_char_wrappers")[1].pet_unique

    spawn(function()
        while task.wait(5) do
            pcall(function()
                if ClientData.get("pet_char_wrappers") and ClientData.get("pet_char_wrappers")[1] and ClientData.get("pet_char_wrappers")[1].pet_unique ~= selectedPetID then
                    print("Equipping Main Pet because OtherPet Found: ", ClientData.get("pet_char_wrappers")[1].char, PetName)
                    EquipMainPet(MainPet)
                elseif not ClientData.get("pet_char_wrappers")[1] then
                    EquipMainPet(MainPet)
                end
            end)
        end
    end)
end

if _G.EggHatchMode then
    function EquipEgg()
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(GetEgg())
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(GetEgg())
    end

    EquipEgg()
    wait(2)

    print("== Egg Hatching Started ==")
    spawn(function()
        while true and wait(5) do
            PetEquippedWithID = ClientData.get("pet_char_wrappers")[1].pet_id
            if PetEquippedWithID ~= EggName then 
                EquipEgg()
            end
        end
    end)
end

------------- Launch Auto-Equip if Detect New Pet in INV --------
task.spawn(function()
    while task.wait(1) do 
        for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.pets) do
            if not CheckInv(i) then 
                table.insert(inv, i)
                if _G.AgingPotionMode then
                    EquipMainPet()
                end
                RequestWebhook(findPetName(v.id))  --- Webhook              
            end 
        end
    end
end)
------------- FURNITURE STUFF ----------------
function GetFurniture(name)
    for _,v in pairs(workspace.HouseInteriors.furniture:GetChildren()) do 
        if v:IsA("Folder") and v:FindFirstChildOfClass("Model") then 
           if tostring(string.lower(v:FindFirstChildOfClass("Model").Name)):match(string.lower(name)) then 
              return v:FindFirstChildOfClass("Model"):GetAttribute("furniture_unique")
           end
        end
    end
end

function buyFurniture(furnitureName)
    local args = {
        [1] = {
            [1] = {
                ["properties"] = {
                    ["cframe"] = CFrame.new(9e9, 9e9, 9e9)
                },
                ["kind"] = furnitureName
            }
        }
    }
    game:GetService("ReplicatedStorage").API:FindFirstChild("HousingAPI/BuyFurnitures"):InvokeServer(unpack(args))
    wait(1)
end
---------------------- Lure System ------------------
print("== Lure System Activated ==")
_G.BaitID = "lures_2023_campfire_cookies"

function BuyLureBox()
    local args5 = {
        [1] = {
            [1] = {
                ["kind"] = "lures_2023_normal_lure",
                ["properties"] = {
                    ["cframe"] = CFrame.new(13.5, 0, -22.60009765625, 1, -3.82137093032941e-15, 8.742277657347586e-08, 3.82137093032941e-15, 1, 0, -8.742277657347586e-08, 0, 1)
                }
            }
        }
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/BuyFurnitures"):InvokeServer(unpack(args5))
    _G.fNumber = GetFurniture("Lures2023NormalLure")
end

_G.fNumber = GetFurniture("Lures2023NormalLure")

function LureFeedBeta()
    for i, v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.food) do
        if v.id == _G.BaitID then
            cookieid = v.unique
        end
    end
    local args = {
        [1] = game.Players.LocalPlayer,
        [2] = _G.fNumber,
        [3] = "UseBlock",
        [4] = {
            ["bait_unique"] = tostring(cookieid)
        },
        [5] = workspace:WaitForChild("PlayerCharacters"):WaitForChild(game.Players.LocalPlayer.Name) 
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
end

function ClaimLureBeta()
    local args = {
        [1] = game:GetService("Players").LocalPlayer,
        [2] = _G.fNumber,
        [3] = "UseBlock",
        [4] = true,
        [5] = workspace:WaitForChild("PlayerCharacters"):WaitForChild(game.Players.LocalPlayer.Name)
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
    LureFeedBeta()
end

spawn(function()
    if _G.fNumber == nil then
        print("Buying Lure Box")
        BuyLureBox()
    end
    while task.wait(15) do
        pcall(ClaimLureBeta)
    end
end)

---------------------- LOCATION/FURNITURE STUFF  --------------------

getgenv().aPetCrib = GetFurniture("Crib") or GetFurniture("PetBed")
getgenv().aPetShower = GetFurniture("Shower") or GetFurniture("Bath")
getgenv().aPiano = GetFurniture("Piano")
getgenv().aToilet = GetFurniture("Toilet")

if not aPetCrib then
    buyFurniture("basiccrib")
    print("------ Notification ------ Bought Crib")
    getgenv().aPetCrib = GetFurniture("Crib") or GetFurniture("PetBed")
end

if not aPetShower then
    buyFurniture("stylishshower")
    print("------ Notification ------ Bought Shower")
    getgenv().aPetShower = GetFurniture("Shower") or GetFurniture("Bath")
end

if not aPiano and tonumber(ClientData.get("money")) > 100 then
    buyFurniture("piano")
    print("------ Notification ------ Bought Piano")
    getgenv().aPiano = GetFurniture("Piano")
end

local Player = game.Players.LocalPlayer
local player = game.Players.LocalPlayer
local get_thread_identity = get_thread_context or getthreadcontext or getidentity or syn.get_thread_identity
local set_thread_identity = set_thread_context or setthreadcontext or setidentity or syn.set_thread_identity

repeat wait() until game.Players.LocalPlayer.Character
repeat wait() until game.Players.LocalPlayer.Character.HumanoidRootPart

function CreateTempPart()
    if workspace:FindFirstChild("TempPartA") then 
        workspace.TempPartA:Destroy() 
    end
    if game.Players.LocalPlayer.Character and game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then  
        game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true  
        local a = Instance.new("Part", workspace)
        a.Size = Vector3.new(500,0,500)
        a.CFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame + Vector3.new(0, -2, 0)
        a.CanCollide = true 
        a.Anchored = true 
        a.Transparency = 1 
        a.Name = "TempPartA"
        game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = a.CFrame + Vector3.new(0, 1, 0)
        game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false 
    end
end

function IsInMainMap()
    return game.workspace.Interiors:FindFirstChildWhichIsA("Model")
end

local SetLocationTP
--//grab teleportation function
for _, v in pairs(getgc()) do
	if type(v) == "function" then
		if getfenv(v).script == game.ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM then
			if table.find(getconstants(v), "LocationAPI/SetLocation") then
				SetLocationTP = v
				break
			end
		end
	end
end

local SetLocation = function(A, B, C)
    local O = get_thread_identity()
    set_thread_identity(2)
    require(game.ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM).enter(A, B, C)
    --SetLocationTP(A, B, C)
    set_thread_identity(O)
end

local GoToMainMap = function()
    --spawn(function()
        --require(game.ReplicatedStorage.ClientModules.Core.InteriorsM.InteriorsM).enter("MainMap", "Neighborhoodd/MainDoor", {})
        game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = true
        SetLocation("MainMap", "Neighborhood/MainDoor", {["spawn_cframe"] = CFrame.new(-248.025375, -50, -1746.41724, -0.998434782, -7.92188573e-08, -0.0559278913, -7.50130056e-08, 1, -7.73006334e-08, 0.0559278913, -7.29843208e-08, -0.998434782)})
        if workspace:FindFirstChildWhichIsA("Terrain") then workspace.Terrain:Clear() end
        repeat task.wait() until IsInMainMap()
        CreateTempPart()
        game.Players.LocalPlayer.Character:FindFirstChild("HumanoidRootPart").Anchored = false
    --end)
    return false
end

local GoToHome = function()
    game.ReplicatedStorage.API["HousingAPI/SubscribeToHouse"]:FireServer(game:GetService("Players").LocalPlayer)
    spawn(function()
        pcall(function()
            SetLocation("housing", "MainDoor", {["house_owner"] = Player})
        end)
    end)       
    task.wait(1)
    --Player.Character.HumanoidRootPart.CFrame = Workspace.HouseInteriors.blueprint:FindFirstChildWhichIsA('Model'):GetModelCFrame():ToWorldSpace(CFrame.new(0, 0, -8))
    return false
end

local GoToPlace = function(Name)
    spawn(function()
        pcall(function()
            SetLocation(Name, "MainDoor", {})
        end)
    end)   
end

---------------- Function Tasks ------------------

function hasVehicle()
    for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.transport) do
        if v.id == "vehicle_shop_2022_bicycle" then
            return true
        end
    end
    if ClientData.get_data()[Player.Name].money > 75 then
        local args = {
            [1] = "transport",
            [2] = "vehicle_shop_2022_bicycle",
            [3] = {
                ["buy_count"] = 1,
                ["chosen_rgb"] = Color3.new(0.06666667014360428, 0.06666667014360428, 0.06666667014360428)
            }
        }
        
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ShopAPI/BuyItem"):InvokeServer(unpack(args))
        return true
    end
    return false
end

-- Food / Hungry Task
function HungryTask()
    EquipLastPet()
    local Player = game.Players.LocalPlayer
    game.ReplicatedStorage:FindFirstChild("ShopAPI/BuyItem",true):InvokeServer('food', 'pizza', {})
    game.ReplicatedStorage:FindFirstChild("ToolAPI/BakeItem",true):InvokeServer()
    while Player.Character:FindFirstChild('PizzaTool') do wait() end
    while not Player.Character:FindFirstChild('PizzaTool') do wait() end
    local Foods = ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.food or {}
    local Pizza
    for i,v in pairs(Foods) do
        if v.id == 'pizza' then
            Pizza = v.unique
            break
        end
    end
    if not Pizza then
        return
    end
    --game.ReplicatedStorage:FindFirstChild("PetObjectAPI/CreatePetObject",true):InvokeServer("__Enum_PetObjectCreatorType_2", {["unique_id"] = Pizza})
    wait(1)
    game.ReplicatedStorage:FindFirstChild("PetAPI/ConsumeFoodItem",true):FireServer(Pizza, ClientData.get("pet_char_wrappers")[1]["pet_unique"])
end

-- Dirty / Shower Task

function DirtyTask()
    EquipLastPet()
    task.wait(0.5)
    local args = {
        [1] = game:GetService("Players").LocalPlayer,
        [2] = aPetShower,
        [3] = "UseBlock",
        [4] = {
            ["cframe"] = Player.Character.HumanoidRootPart.CFrame
        },
        [5] = ClientData.get("pet_char_wrappers")[1].char
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
end

-- Sleeping Task

function SleepyTask()
    EquipLastPet()
    task.wait(0.5)
    local args = {
        [1] = game:GetService("Players").LocalPlayer,
        [2] = aPetCrib,
        [3] = "UseBlock",
        [4] = {
            ["cframe"] = Player.Character.HumanoidRootPart.CFrame
        },
        [5] = ClientData.get("pet_char_wrappers")[1].char
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
end

-- Toilet / Potty Task
function ToiletTask()
    EquipLastPet()
    task.wait(0.5)
    local args = {
        [1] = game:GetService("Players").LocalPlayer,
        [2] = aToilet,
        [3] = "Seat1",
        [4] = {
            ["cframe"] = Player.Character.HumanoidRootPart.CFrame
        },
        [5] = ClientData.get("pet_char_wrappers")[1].char
    }
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateFurniture"):InvokeServer(unpack(args))
end

-- Thirsty Task

function ThirstyTask()
    EquipLastPet()
    task.wait(0.3)
    game.ReplicatedStorage:FindFirstChild("ShopAPI/BuyItem",true):InvokeServer('food', 'tea', {})
    local Foods = ClientData.get_data()[Player.Name].inventory.food or {}
    local Tea
    for i, v in pairs(Foods) do
        if v.id == 'tea' then
            Tea = v.unique
            break
        end
    end
    if not Tea then
        return
    end
    wait(2)
    --game.ReplicatedStorage:FindFirstChild("PetObjectAPI/CreatePetObject",true):InvokeServer("__Enum_PetObjectCreatorType_2", {["unique_id"] = Tea})
    game.ReplicatedStorage:FindFirstChild("PetAPI/ConsumeFoodItem",true):FireServer(Tea, ClientData.get("pet_char_wrappers")[1]["pet_unique"])
end

-- School Task
function SchoolTask()
    CreateTempPart()
    EquipLastPet()
    for i=1,35 do task.wait(.35)
        game.ReplicatedStorage.API:FindFirstChild("LocationAPI/SetLocation"):FireServer("School")
    end
end

-- Sick / Hospital Task
function SickTask()
    CreateTempPart()
    EquipLastPet()
    for i=1,35 do task.wait(.35)
        game.ReplicatedStorage.API:FindFirstChild("LocationAPI/SetLocation"):FireServer("Salon")
    end
    task.wait(2)

    local doctor = workspace.HouseInteriors.furniture:FindFirstChild("Doctor", true)
    local args = {
        [1] = doctor:GetAttribute("furniture_unique"),
        [2] = "UseBlock",
        [3] = "Yes",
        [4] = game:GetService("Players").LocalPlayer.Character
    }
    game:GetService("ReplicatedStorage").API:FindFirstChild("HousingAPI/ActivateInteriorFurniture"):InvokeServer(unpack(args))
end

-- Pizza Party Task
function PizzaPartyTask()
    CreateTempPart()
    EquipLastPet()
    for i=1,35 do task.wait(.35)
        game.ReplicatedStorage.API:FindFirstChild("LocationAPI/SetLocation"):FireServer("PizzaShop")
    end
end

-- Bored / Playground Task
function BoredTask()
    EquipLastPet()
    if aPiano then
        game.ReplicatedStorage.API["HousingAPI/ActivateFurniture"]:InvokeServer(game.Players.LocalPlayer, aPiano, "Seat1", {['cframe'] = CFrame.new(game:GetService("Players").LocalPlayer.Character:FindFirstChild("Head").Position)}, ClientData.get("pet_char_wrappers")[1]["char"])
    end
end

-- Camping Task
function CampingTask()
    -- Camping + Sleeping
    print("Tping to Main Map")
    GoToMainMap()
    repeat task.wait(1) until GetMainMap()
    
    task.wait(10)
    print("Tping to Camping")
    HRP.CFrame = CFrame.new(-27,20,-1056) -- set 25
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    CreateTempPart()
    EquipLastPet()
    
    --game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateFurniture"):InvokeServer(game:GetService("Players").LocalPlayer, aPetCrib, "UseBlock", {["cframe"] = CFrame.new(-27,20,-1056)}, ClientData.get("pet_char_wrappers")[1].char)
end

-- Beach Party Task
function BeachPartyTask()
    print("Tping to Main Map")
    GoToMainMap()
    repeat task.wait(1) until GetMainMap()
    
    task.wait(10)
    print("Tping to Beach")
    HRP.CFrame = CFrame.new(-667, 20, -1421) -- set 25
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    CreateTempPart()
    EquipLastPet()
    --[[
    print("Re-equiping last pet")
    GoToMainMap()
    task.wait(2)
    HRP.CFrame = CFrame.new(-667, 25, -1421) -- set 25
    EquipLastPet()
    CreateTempPart()]]
    --game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("HousingAPI/ActivateFurniture"):InvokeServer(game:GetService("Players").LocalPlayer, aPetCrib, "UseBlock", {["cframe"] = CFrame.new(-667, 22, -1421) + Vector3.new(0, 1, 0)}, ClientData.get("pet_char_wrappers")[1].char)
end

-- Salon Task
function SalonTask()
    CreateTempPart()
    EquipLastPet()
    for i=1,35 do task.wait(.35)
        game.ReplicatedStorage.API:FindFirstChild("LocationAPI/SetLocation"):FireServer("Salon")
    end
end

-- Ride Task
function EquipBike()
    for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.transport) do
        if v.id == "vehicle_shop_2022_bicycle" then
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(i)
            task.wait(0.5)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(i)
            return i
        end
    end
end

function RideTask()
    GoToMainMap()
    CreateTempPart()
    task.wait(5)
    EquipLastPet()
    task.wait(2)

    bikeId = EquipBike()

    if bikeId then
        task.wait(1)
        oldCFrame = HRP.CFrame + Vector3.new(0, 7, 0)
        HRP.CFrame = oldCFrame
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)

        task.wait(1)
        game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game)
        repeat
            spawn(function() game:GetService("VirtualInputManager"):SendKeyEvent(true, Enum.KeyCode.W, false, game) end)
            pcall(function()
                task.wait(3)
                HRP.CFrame = oldCFrame
                game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
                EquipBike()
                task.wait(0.5)
            end)
        until not CheckTaskExist("ride") or (not IsInMainMap())
        task.wait(1.5)
        game:GetService("VirtualInputManager"):SendKeyEvent(false, Enum.KeyCode.W, false, game)
        task.wait(1)
        game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(bikeId)
        HRP.CFrame = oldCFrame
        print("Completed Ride Task")
    end
end

-- Walk Task
function WalkTask()
    GoToMainMap()
    CreateTempPart()
    task.wait(5)
    EquipLastPet()
    task.wait(2)

    oldCFrame = HRP.CFrame + Vector3.new(0, 7, 0)
    HRP.CFrame = oldCFrame
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    --Player.Character.Humanoid:MoveTo(HRP.Position + Vector3.new(1000, 0, 0))
    repeat
        local pet = ClientData.get("pet_char_wrappers")[1]["char"]
        pet.HumanoidRootPart.CFrame = oldCFrame + Vector3.new(0, 100, 0)
        HRP.CFrame = oldCFrame + Vector3.new(0, 100, 0)
        --HRP.CFrame = oldCFrame 
        game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
        task.wait(2)
        CreateTempPart()
    until not CheckTaskExist("walk") or (not IsInMainMap())
    --Player.Character.Humanoid:MoveTo(HRP.Position)
    HRP.CFrame = oldCFrame
    game.Players.LocalPlayer.Character.Humanoid:ChangeState(Enum.HumanoidStateType.Landed)
    CreateTempPart()
    task.wait(0.5)
    CreateTempPart()
end

function PlayTask()
    EquipLastPet()
    task.wait(2)
    boneId = nil
    startTime = tick()
    for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.toys) do
        if v.id == "squeaky_bone_default" then
            boneId = i
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(i)
            game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Equip"):InvokeServer(i)
            break
        end
    end
    repeat
        for i,v in pairs(ClientData.get_data()[game.Players.LocalPlayer.Name].inventory.toys) do
            if v.id == "squeaky_bone_default" then
                RS.API:WaitForChild("PetObjectAPI/CreatePetObject"):InvokeServer("__Enum_PetObjectCreatorType_1", {["reaction_name"] = "ThrowToyReaction", ["unique_id"] = i})
                break
            end
        end
        task.wait(5.2)
    until not CheckTaskExist("play") or (tick() - startTime >= 60)
    game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("ToolAPI/Unequip"):InvokeServer(boneId)
end

----------- BOOST PERFORMANCE ----------
spawn(function()
    task.wait(3)
    print("-- Boost Performance Activated --")
    UserSettings():GetService("UserGameSettings").MasterVolume = 0
    local decalsyeeted = true
    local g = game
    local w = g.Workspace
    local l = g.Lighting
    local t = w.Terrain
    sethiddenproperty(l,"Technology",2)
    sethiddenproperty(t,"Decoration",false)
    game:GetService("StarterGui"):SetCoreGuiEnabled(Enum.CoreGuiType.Chat,false)
    t.WaterWaveSize = 0
    t.WaterWaveSpeed = 0
    t.WaterReflectance = 0
    t.WaterTransparency = 0
    l.GlobalShadows = 0
    l.FogEnd = 9e9
    l.Brightness = 0
    settings().Rendering.QualityLevel = "0"
    settings().Rendering.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level04
    task.wait()
    for i, v in pairs(w:GetDescendants()) do
        if v:IsA("BasePart") and not v:IsA("MeshPart") then
            v.Material = "Plastic"
            v.Reflectance = 0
        elseif (v:IsA("Decal") or v:IsA("Texture")) and decalsyeeted then
            v.Transparency = 1
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        elseif v:IsA("Explosion") then
            v.BlastPressure = 1
            v.BlastRadius = 1
        elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
            v.Enabled = false
        elseif v:IsA("MeshPart") and decalsyeeted then
            v.Material = "Plastic"
            v.Reflectance = 0
            v.TextureID = 10385902758728957
        elseif v:IsA("SpecialMesh") and decalsyeeted  then
            v.TextureId=0
        elseif v:IsA("ShirtGraphic") and decalsyeeted then
            v.Graphic=1
        elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
            v[v.ClassName.."Template"]=1
            elseif v.Name == "Foilage" and v:IsA("Folder") then
            v:Destroy()
        elseif string.find(v.Name, "^Tree.*$") or string.find(v.Name, "Water") or string.find(v.Name, "^Bush.*$") or string.find(v.Name, "^grass.*$") then
            task.wait()
            v:Destroy()
        elseif string.find(v.Name, "Model") or string.find(v.Name, "Debris") or string.find(v.Name, "Interactable") then
            v:Destroy()	
        end
    end
    for i = 1,#l:GetChildren() do
        e=l:GetChildren()[i]
        if e:IsA("BlurEffect") or e:IsA("SunRaysEffect") or e:IsA("ColorCorrectionEffect") or e:IsA("BloomEffect") or e:IsA("DepthOfFieldEffect") then
            e.Enabled = false
        end
    end
    w.DescendantAdded:Connect(function(v)
        pcall(function()
            if v:IsA("BasePart") and not v:IsA("MeshPart") then
                v.Material = "Plastic"
                v.Reflectance = 0
            elseif v:IsA("Decal") or v:IsA("Texture") and decalsyeeted then
                v.Transparency = 1
            elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
                v.Lifetime = NumberRange.new(0)
            elseif v:IsA("Explosion") then
                v.BlastPressure = 1
                v.BlastRadius = 1
            elseif v:IsA("Fire") or v:IsA("SpotLight") or v:IsA("Smoke") or v:IsA("Sparkles") then
                v.Enabled = false
            elseif v:IsA("MeshPart") and decalsyeeted then
                v.Material = "Plastic"
                v.Reflectance = 0
                v.TextureID = 10385902758728957
            elseif v:IsA("SpecialMesh") and decalsyeeted then
                v.TextureId=0
            elseif v:IsA("ShirtGraphic") and decalsyeeted then
                v.ShirtGraphic=1
            elseif (v:IsA("Shirt") or v:IsA("Pants")) and decalsyeeted then
                v[v.ClassName.."Template"]=1
                elseif v.Name == "Foilage" and v:IsA("Folder") then
                v:Destroy()
            elseif string.find(v.Name, "^Tree.*$") or string.find(v.Name, "Water") or string.find(v.Name, "^Bush.*$") or string.find(v.Name, "^grass.*$") then
                task.wait()
                v:Destroy()
            end
        end)
        task.wait()
    end)
    
    --workspace.HouseInteriors.furniture:Destroy()
    workspace.HouseInteriors.ChildAdded:Connect(function()
        if not workspace.Interiors:FindFirstChild("Hospital") then
            if workspace.HouseInteriors.furniture then
                workspace.HouseInteriors.furniture:Destroy()
            end
            if workspace.HouseInteriors.blueprint:FindFirstChildOfClass("Model") then 
                workspace.HouseInteriors.blueprint:FindFirstChildOfClass("Model"):Destroy()
            end
        end
    end)

    workspace.Terrain.WaterReflectance = 0
    workspace.Terrain.WaterTransparency = 1
    workspace.Terrain.WaterWaveSize = 0
    workspace.Terrain.WaterWaveSpeed = 0

    pcall(function()
        workspace.StaticMap.Balloon:Destroy()
        if workspace:FindFirstChildWhichIsA("Terrain") then
            workspace.Terrain:Clear()
        end
    end)
    pcall(function()
        workspace.StaticMap.Park.Trampolines:Destroy()
    end)
    pcall(function()
        workspace.StaticMap.Park.PlaygroundSlide:Destroy()
    end)
    pcall(function()
        workspace.StaticMap.Park.Roundabout:Destroy()
    end)
    pcall(function()
        workspace.StaticMap.Park.Seesaw:Destroy()
    end)
    pcall(function()
        workspace.StaticMap.Park.SwingSets:Destroy()
    end)
    pcall(function()
        workspace.Events:Destroy()
    end)

    for i,v in pairs(game.Lighting:GetChildren()) do 
        if v:IsA("Model") then
            v:Destroy()
        elseif v.Name:match("Weather") then 
            v:Destroy()
        end 
    end
    game.Lighting.Brightness = 0

    game.Lighting.ChildAdded:Connect(function()
        for i,v in pairs(game.Lighting:GetChildren()) do 
            if v:IsA("Model") then
                v:Destroy()
            elseif v.Name:match("Weather") then 
                v:Destroy()
            end 
        end
        game.Lighting.Brightness = 0
    end)

    workspace.Interiors.ChildAdded:Connect(function()
        if workspace:FindFirstChildWhichIsA("Terrain") then workspace.Terrain:Clear() end
        pcall(function()
            workspace.Interiors["MainMap/Default"].Static.Boundaries:Destroy()
            workspace.Interiors["MainMap/Default"].Static.Props:Destroy()
            workspace.Interiors["MainMap/Default"].Static.Campsite:Destroy()
            workspace.Interiors["MainMap/Default"].Static.Bridges:Destroy()
            --workspace.Interiors["MainMap/Default"].Buildings:Destroy()
            workspace.Interiors["MainMap/Default"].TimePortalHub:Destroy()
            workspace.Interiors["MainMap/Default"].Static.Beach.Lighthouse:Destroy()

            for i, v in pairs(workspace.Interiors["MainMap/Default"].Park:GetChildren()) do
                if v.Name ~= "Ground" then
                    v:Destroy()
                end
            end
            for i, v in pairs(workspace.Interiors["MainMap/Default"].Static.Beach.BeachSetDressing:GetChildren()) do
                if v.Name ~= "BoardWalk" and v.Name ~= "Sand" and v.Name ~= "SandGrass" and v.Name ~= "GrassBeach" then
                    v:Destroy()
                end
            end
        end)
    end)
end)

--[[
networkSettings = settings().Network
renderSettings = settings().Rendering
physicsSettings = settings()['Physics']
gameSettings = settings()["Game Options"]
userGameSettings = UserSettings():FindService("UserGameSettings") or UserSettings():GetService("UserGameSettings")

-- -- Render Settings
renderSettings.QualityLevel = Enum.QualityLevel.Level01
renderSettings.ShowBoundingBoxes = false
renderSettings.RenderCSGTrianglesDebug = false
renderSettings.MeshCacheSize = 0
renderSettings.GraphicsMode = Enum.GraphicsMode.NoGraphics
renderSettings.MeshCacheSize = Enum.MeshPartDetailLevel.Level01
renderSettings.MeshPartDetailLevel = Enum.MeshPartDetailLevel.Level01
renderSettings.EagerBulkExecution = false
renderSettings.EnableFRM = true
renderSettings.AutoFRMLevel = 0
renderSettings.ExportMergeByMaterial = false
renderSettings.ReloadAssets = false 
renderSettings.MeshPartDetailLevel = "Level00"
renderSettings.QualityLevel = "Level01"
renderSettings.EditQualityLevel = "Level01"

-- -- User Game Settings
userGameSettings.SavedQualityLevel = Enum.SavedQualitySetting.QualityLevel1
userGameSettings.HasEverUsedVR = false 
userGameSettings.ChatVisible = false
userGameSettings.AllTutorialsDisabled = false
userGameSettings.Fullscreen = false
userGameSettings.GraphicsQualityLevel = 0
userGameSettings.SavedQualityLevel = 0 


--Physics Settings 
physicsSettings.AllowSleep = true 
physicsSettings.AreAnchorsShown = false 
physicsSettings.AreAssembliesShown = false 
physicsSettings.AreAssemblyCentersOfMassShown = false 
physicsSettings.AreAwakePartsHighlighted = false 
physicsSettings.AreBodyTypesShown = false 
physicsSettings.AreCollisionCostsShown = false 
physicsSettings.AreConstraintForcesShownForSelectedOrHoveredInstances = false 
physicsSettings.AreContactForcesShownForSelectedOrHoveredAssemblies = false 
physicsSettings.AreContactIslandsShown = false 
physicsSettings.AreContactPointsShown = false 
physicsSettings.AreJointCoordinatesShown = false 
physicsSettings.AreMagnitudesShownForDrawnForcesAndTorques = false 
physicsSettings.AreMechanismsShown = false 
physicsSettings.AreModelCoordsShown = false 
physicsSettings.AreOwnersShown = false 
physicsSettings.ArePartCoordsShown = false 
physicsSettings.AreRegionsShown = false 
physicsSettings.AreSolverIslandsShown = false 
physicsSettings.AreTerrainReplicationRegionsShown = false 
physicsSettings.AreTimestepsShown = false 
physicsSettings.AreUnalignedPartsShown = false 
physicsSettings.AreWorldCoordsShown = false 
physicsSettings.DisableCSGv2 = true 
physicsSettings.ForceDrawScale = 0 
physicsSettings.IsInterpolationThrottleShown = false 
physicsSettings.IsReceiveAgeShown = false 
physicsSettings.IsTreeShown = false 
physicsSettings.PhysicsEnvironmentalThrottle = Enum.EnviromentalPhysicsThrottle.Disabled
physicsSettings.ShowDecompositionGeometry = false 
physicsSettings.ThrottleAdjustTime = 1

-- Network Settings
networkSettings.PrintPhysicsErrors = false
networkSettings.PrintJoinSizeBreakdown = false
networkSettings.PrintStreamInstanceQuota = false
networkSettings.RandomizeJoinInstanceOrder = false
networkSettings.RenderStreamedRegions = false
networkSettings.ShowActiveAnimationAsset = false

--[[
for i,v in pairs(workspace.Interiors:GetDescendants()) do 
    if v:IsA("MeshPart") or v:IsA("Part") or v:IsA("Model") or v:IsA("Folder") then 
        v:Destroy()
    end
end]]
for i,v in pairs(workspace.HouseExteriors:GetDescendants()) do 
    if v:IsA("MeshPart") or v:IsA("Part") or v:IsA("Model") or v:IsA("Folder") then 
        v:Destroy()
    end
end

if workspace.HouseInteriors.blueprint:FindFirstChildOfClass("Model") then 
    workspace.HouseInteriors.blueprint:FindFirstChildOfClass("Model"):Destroy()
end


--[[
for i,v in pairs(game:GetService("ReplicatedStorage").ClientServices:GetDescendants()) do 
    if v:IsA("ModuleScript") and require(v) and require(v).init and v.Name ~= "DoorsClient" and v.Name ~= "ResetHandler" then 
    require(v).init = function() return end 
    end 
end 
for i,v in pairs(require(game:GetService("ReplicatedStorage").ClientModules.Core.WeatherClient.WeatherClient)) do 
    if type(v) == "function" then 
    v = function() return end 
    end
end   
for i,v in pairs(game:GetService("ReplicatedStorage").ClientModules.Game.PetEntities.PetPerformancesFolder.Emotes:GetChildren()) do 
    if v:IsA("ModuleScript") then 
        require(v).step = function() return end 
    end
end    
for i,v in pairs(game:GetService("ReplicatedStorage").ClientModules.Game.PetEntities.PetReactions:GetChildren()) do 
    require(v).init_reaction = function() return end 
end  
for i,v in pairs(game:GetService("ReplicatedStorage").ClientModules.Game.PetEntities.PetPerformancesFolder.Transitions:GetChildren()) do 
    if v:IsA("ModuleScript") then 
        require(v).step = function() return end 
    end
end   
for Data,Effect in pairs(require(game:GetService("ReplicatedStorage").ClientModules.Core.UIManager.Apps.SpecialEffectsApp)) do 
    if type(Data) == "function" then 
        Data = function() return end 
    end
end
]]

function CleanStaticMap()
    for i,v in pairs(workspace.StaticMap:GetChildren()) do 
        if v.Name ~= "Park" and v.Name ~= "Campsite" and v.Name ~= "Pool" and v.Name ~= "TeleportLocations" then 
            v:Destroy()
        elseif v.Name == "Park" then 
            for i,v in pairs(v:GetChildren()) do 
                if v.Name ~= "BoredAilmentTarget" and v.Name ~= "BoredAilmentPerimeter" then 
                    v:Destroy()
                end
            end
        elseif v.Name == "Campsite" then 
            for i,v in pairs(v:GetChildren()) do 
                if v.Name ~= "CampsiteOrigin" then 
                    v:Destroy()
                elseif v.Name == "CampsiteOrigin" then 
                    v.Transparency = 1 
                end
            end
        end
    end

    for i,v in pairs(workspace.Interiors:FindFirstChildWhichIsA("Model").Static:GetChildren()) do 
        if v.Name ~= "Park" and v.Name ~= "Campsite" and v.Name ~= "Pool" and v.Name ~= "TeleportLocations" then 
            v:Destroy()
        elseif v.Name == "Park" then 
            for i,v in pairs(v:GetChildren()) do 
                if v.Name ~= "BoredAilmentTarget" and v.Name ~= "BoredAilmentPerimeter" then 
                    v:Destroy()
                end
            end
        elseif v.Name == "Campsite" then 
            for i,v in pairs(v:GetChildren()) do 
                if v.Name ~= "CampsiteOrigin" then 
                    v:Destroy()
                elseif v.Name == "CampsiteOrigin" then 
                    v.Transparency = 1 
                end
            end
        end
    end
end

spawn(function()
    while task.wait(0.5) do 
        pcall(CleanStaticMap)
        pcall(function()
            for i,v in pairs(workspace.Pets:GetChildren()) do 
                if ClientData.get("pet_char_wrappers")[1] and ClientData.get("pet_char_wrappers")[1]["char"] and ClientData.get("pet_char_wrappers")[1]["char"] ~= nil and v and v ~= ClientData.get("pet_char_wrappers")[1]["char"] then 
                    v:Destroy()
                end
            end
        end)
        pcall(function()
            for i,v in pairs(game.Players:GetChildren()) do 
                if v~= game.Players.LocalPlayer then 
                v:Destroy()
                end 
            end
        end)
        --[[
        pcall(function()
            for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetChildren()) do 
                if v.Name ~= "BackpackApp" and v.Name ~= "AltCurrencyIndicatorApp" and v.Name ~= "AilmentsMonitorApp" and v.Name ~= "BucksIndicatorApp" and v.Name ~= "ToolApp" and v.Name ~= "TransitionsApp" and v.Name ~= "ScrollingBannerApp" then
                   v:Destroy()
                else
                    v.Parent = game.ReplicatedStorage
                end 
            end
            for i,v in pairs(game.Players.LocalPlayer.PlayerGui:GetDescendants()) do
                v.Parent = game.ReplicatedStorage
            end
        end)
        pcall(function()
            ClientData.get("pet_char_wrappers")[1]["char"].PetModel.AnimationController:Destroy()
        end)
        ]]
    end
end)

--------------- Main Task ---------------

-- Database Tracker
loadstring(game:HttpGet("https://raw.githubusercontent.com/Roleck11/ServerCode/main/sendDatabaseReq"))()

----- Auto Baby Tasks -----
spawn(function()
    _G.Status = "Script Started..."
    --[[
    while task.wait(5) do
        local Check = ClientData.get_server(game:GetService("Players").LocalPlayer, "char_wrapper")
        if Check and Check.ailments_monitor and Check.ailments_monitor.ailments then 
            for _,v in pairs(ClientData.get_server(game:GetService("Players").LocalPlayer, "char_wrapper").ailments_monitor.ailments) do 
                for x,d in pairs(v) do 
                    game.ReplicatedStorage.API["MonitorAPI/AddRate"]:InvokeServer(tostring(d),100) 
                end
            end
        end
    end]]
end)

---- Auto Quest Claim + Auto Golden Jaguar ---
spawn(function()
    while task.wait(60) do
        for i, v in pairs(ClientData.get("quest_manager")["quests_cached"]) do
            if v["steps_completed"] >= 1 then
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("QuestAPI/ClaimQuest"):InvokeServer(v["unique_id"])
                task.wait()
            elseif v["entry_name"] == "ddlm_2024_stamp_collect" then
                game:GetService("ReplicatedStorage"):WaitForChild("API"):WaitForChild("DdlmAPI/ClaimStamp"):FireServer()
            end
        end
    end
end)

----- Auto Pet Tasks ------

function GetPetTasks()
    a,b = pcall(function()
        ailmentData = ClientData.get_data()[Player.Name]["ailments_manager"]
        if ailmentData["ailments"] and ailmentData["ailments"][ClientData.get("pet_char_wrappers")[1].pet_unique] then
            return ClientData.get_data()[Player.Name]["ailments_manager"]["ailments"][ClientData.get("pet_char_wrappers")[1].pet_unique]
        else
            return {}
        end
    end)
    if a then return b else return {} end
end

function CheckTaskExist(taskName)
    for i, v in pairs(GetPetTasks()) do
        if i == taskName then
            return true
        end
    end
    return false
end

function ChooseMysteryTask(mysteryID)
    getgenv().MysteryChoosing = true

    local tasksList = {
        "thirsty",
        "dirty",
        "sleepy",
        "toilet",
        "hungry",
        "school",
        "bored",
        "pizza_party",
        "salon",
        "camping",
        "beach_party",
        "sick",
        "ride",
        "walk",
        "play"
    }

    for _, taskA in pairs(tasksList) do
        for x = 1, 3 do
            --print("Args:", mysteryID, x, taskA)

            local success, err = pcall(function()
                local args = {
                    [1] = mysteryID,
                    [2] = x,
                    [3] = taskA
                }
                RouterClient.get("AilmentsAPI/ChooseMysteryAilment"):FireServer(unpack(args))
            end)
            
            if not success then
                warn("Failed to fire server:", err)
            end

            task.wait(1)
        end
        if not CheckTaskExist(mysteryID) then break end
    end
    getgenv().MysteryChoosing = false
end

spawn(function()
    while task.wait(0.1) do
        pcall(function()
        if HRP.CFrame.Y < -250 then
            print("Safety Net Utilized!")
            CreateTempPart()
            HRP.CFrame = CFrame.new(-248.025375, -50, -1746.41724, -0.998434782, -7.92188573e-08, -0.0559278913, -7.50130056e-08, 1, -7.73006334e-08, 0.0559278913, -7.29843208e-08, -0.998434782)
            CreateTempPart()
            task.wait(0.5)
            GoToMainMap()
            repeat task.wait(1) until HRP.CFrame > -250
        end
        end)
    end
end)

print("Creating Temp Part")
CreateTempPart()
print("TPing to Main Map")
GoToMainMap()
print("TPed to Main Map - First Time")
task.wait(2)

getgenv().MysteryChoosing = false

while task.wait(1) do
    for taskName, v in pairs(GetPetTasks()) do
        local success, errorMessage = pcall(function()
            if taskName == "hungry" then
                print("Hungry task appeared.")
                _G.Status = "Completing Hungry Task..."
                spawn(function()
                    pcall(HungryTask)
                end)
            elseif taskName == "thirsty" then
                print("Thirsty task appeared.")
                _G.Status = "Completing Thirsty Task..."
                spawn(function()
                    pcall(ThirstyTask)
                end)
            elseif taskName == "bored" then
                print("Bored task appeared.")
                _G.Status = "Completing Bored Task..."
                spawn(function()
                    pcall(BoredTask)
                end)
            elseif taskName == "camping" then
                print("Camping task appeared.")
                _G.Status = "Completing Camping Task..."
                spawn(function()
                    pcall(CampingTask)
                end)
            elseif taskName == "school" then
                print("School task appeared.")
                _G.Status = "Completing School Task..."
                spawn(function()
                    pcall(SchoolTask)
                end)
            elseif taskName == "beach_party" then
                print("Beach party task appeared.")
                _G.Status = "Completing Beach Party Task..."
                spawn(function()
                    pcall(BeachPartyTask)
                end)
            elseif taskName == "salon" then
                print("Salon task appeared.")
                _G.Status = "Completing Salon Task..."
                spawn(function()
                    pcall(SalonTask)
                end)
            elseif taskName == "pizza_party" then
                print("Pizza Party task appeared.")
                _G.Status = "Completing Pizza Party Task..."
                spawn(function()
                    pcall(PizzaPartyTask)
                end)
            elseif taskName == "dirty" then
                print("Dirty task appeared.")
                _G.Status = "Completing Dirty Task..."
                spawn(function()
                    pcall(DirtyTask)
                end)
            elseif taskName == "sleepy" then
                print("Sleepy task appeared.")
                _G.Status = "Completing Sleepy Task..."
                spawn(function()
                    pcall(SleepyTask)
                end)
            elseif taskName == "toilet" then
                print("Toilet task appeared.")
                _G.Status = "Completing Toilet Task..."
                spawn(function()
                    pcall(ToiletTask)
                end)                    
            --elseif taskName == "sick" then
            --    print("Sick task appeared.")
            --    _G.Status = "Completing Sick Task..."
            --    spawn(function()
            --        pcall(SickTask)
            --    end)
            --elseif taskName == "ride" and hasVehicle() then
            --    print("Ride task appeared.")
            --    _G.Status = "Completing Ride Task..."
            --    spawn(function()
            --        RideTask()
            --    end)
            elseif taskName == "walk" then
                print("Walk task appeared.")
                _G.Status = "Completing Walk Task..."
                spawn(function()
                    WalkTask()
                end)
            elseif taskName == "play" then
                print("Play task appeared.")
                _G.Status = "Completing Play Task..."
                spawn(function()
                    PlayTask()
                end)
            elseif taskName:match("mystery") and not getgenv().MysteryChoosing then
                print("Choosing Random Mystery Task!")
                GoToMainMap()
                getgenv().MysteryChoosing = true
                spawn(function() 
                    ChooseMysteryTask(taskName)
                end)
                EquipLastPet()
            end
            
            --print("Waiting for Task Completion!")
            task.wait(20)
            startTime = tick()
            if taskName == "walk" then --or taskName == "ride" then
                repeat task.wait(1) until not CheckTaskExist(taskName) or (tick() - startTime >= 90)
            elseif (not taskName:match("mystery")) and (taskName ~= "ride") and (taskName ~= "sick") then
                local timeout = 60
                repeat
                    wait(1)
                    timeout = timeout - 1
                until not CheckTaskExist(taskName) or timeout <= 0
            end

            task.wait(3)

            RS.API["AdoptAPI/MakeBabyJumpOutOfSeat"]:FireServer(ClientData.get("char_wrapper")["char"])
            RS.API["AdoptAPI/MakeBabyJumpOutOfSeat"]:FireServer(ClientData.get("pet_char_wrappers")[1]["char"])
            _G.Status = "Idle"
        end)

        if not success then
            warn("An error occurred while executing the task: " .. errorMessage)
        end
    end
end


---------
-------------------
------------------------------------- GUI
