repeat task.wait() until game:IsLoaded()
repeat task.wait() until game:GetService("Players")
repeat task.wait() until game.Players.LocalPlayer.Character
repeat task.wait() until game.Players.LocalPlayer.Character.HumanoidRootPart
repeat task.wait() until game:GetService("Players").LocalPlayer.Character and workspace.Camera.CameraSubject == game:GetService("Players").LocalPlayer.Character:WaitForChild("Humanoid")

if game.PlaceId ~= 17503543197 then
    print("Must go to World 3 for Auto Prison Key to work.")
    while task.wait(10000000000) do task.wait(1) end
end

repeat task.wait() until workspace:FindFirstChild("Map3")
repeat task.wait() until workspace.Map3:FindFirstChild("201 | Prison Block")
if not workspace.Map3["201 | Prison Block"]:FindFirstChild("INTERACT") then
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map3["201 | Prison Block"].PERSISTENT.Teleport.CFrame + Vector3.new(0, 10, 0)
    repeat task.wait() until workspace.Map3["201 | Prison Block"]:FindFirstChild("INTERACT")
end

-- Auto Lootbags & Orbs
game:GetService("Workspace").__THINGS:FindFirstChild("Lootbags").ChildAdded:Connect(function(lootbag)
    task.wait()
    if lootbag then
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("Lootbags_Claim"):FireServer(unpack( { [1] = { [1] = lootbag.Name, }, } ))
        lootbag:Destroy()
    end
end)
game:GetService("Workspace").__THINGS:FindFirstChild("Orbs").ChildAdded:Connect(function(orb)
    task.wait()
    if orb then
        game:GetService("ReplicatedStorage"):WaitForChild("Network"):FindFirstChild("Orbs: Collect"):FireServer(unpack( { [1] = { [1] = tonumber(orb.Name), }, } ))
        orb:Destroy()
    end
end)

-- Auto Prison Key
while getgenv().autoPrisonKey and game.PlaceId == 17503543197 do
    OldCFrame = game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame
    for i = 1, 8 do
        local args = {
            [1] = ("Cell" .. tostring(i)),
            [2] = getgenv().PrisonKey
        }
        a,b = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("PrisonKey_Use"):InvokeServer(unpack(args))

        if b == "You're doing this too fast!" then
            repeat task.wait()
                a,b = game:GetService("ReplicatedStorage"):WaitForChild("Network"):WaitForChild("PrisonKey_Use"):InvokeServer(unpack(args)) 
            until b ~= "You're doing this too fast!"
        end

        if b == nil then
            print("Cell" .. tostring(i).. " Unlocked!")
            task.wait(1)

            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map3["201 | Prison Block"].INTERACT.Cells:FindFirstChild("Cell" .. tostring(i)).PrisonChest.PrimaryPart.CFrame
            repeat task.wait()
                a, b = game:GetService("ReplicatedStorage").Network.PrisonCell_ChestUnlock:InvokeServer("Cell" .. tostring(i))
            until a
            print("Cell" .. tostring(i).. " Chest Claimed!")
            workspace.Map3["201 | Prison Block"].INTERACT.Cells:FindFirstChild("Cell" .. tostring(i)).PrisonChest.Bottom.Transparency = 1
            workspace.Map3["201 | Prison Block"].INTERACT.Cells:FindFirstChild("Cell" .. tostring(i)).PrisonChest.Top.Transparency = 1
        elseif b == "You already have this cell unlocked!" and workspace.Map3["201 | Prison Block"].INTERACT.Cells:FindFirstChild("Cell" .. tostring(i)).PrisonChest.Bottom.Transparency == 0 then
            task.wait(0.5)
            game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = workspace.Map3["201 | Prison Block"].INTERACT.Cells:FindFirstChild("Cell" .. tostring(i)).PrisonChest.PrimaryPart.CFrame
            task.wait(0.5)
            a, b = game:GetService("ReplicatedStorage").Network.PrisonCell_ChestUnlock:InvokeServer("Cell" .. tostring(i))
            if a then
                print("Cell" .. tostring(i).. " Chest Claimed!")
                workspace.Map3["201 | Prison Block"].INTERACT.Cells:FindFirstChild("Cell" .. tostring(i)).PrisonChest.Bottom.Transparency = 1
                workspace.Map3["201 | Prison Block"].INTERACT.Cells:FindFirstChild("Cell" .. tostring(i)).PrisonChest.Top.Transparency = 1
            end
        end
    end
    game.Players.LocalPlayer.Character.HumanoidRootPart.CFrame = OldCFrame
    task.wait(1)
end
