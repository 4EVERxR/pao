local Version = "1.6.41"
local WindUI = loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/download/" .. Version .. "/main.lua"))()
local Window = WindUI:CreateWindow({
    Title = "KRAKEN HUB!",
    Icon = "list",
    Author = "MR.Yuttana",
    Size = UDim2.new(0,300,0,400),
    Transparent = true,
    Theme = "Dark",
    SideBarWidth = 200,
    BackgroundImageTransparency = 0.42,
    HideSearchBar = true,
    ScrollBarEnabled = false,
    User = {
        Enabled = true,
        Anonymous = false,
        Callback = function() end,
    },
})


local Tabs = {
    MainTab = Window:Tab({ Title = "|ㅤMain", Icon = "app-window-mac"}), 
}

local Players = game:GetService("Players")
local HttpService = game:GetService("HttpService")

local LocalPlayer = Players.LocalPlayer
local webhookUrl = nil
local sendWebhookEnabled = false

Tabs.MainTab:Input({
    Title = "Link Webhook : ",
    Placeholder = "https://discord.com/api/webhooks/....",
    Callback = function(value)
        webhookUrl = value
    end
})

Tabs.MainTab:Toggle({
    Title = "Send Webhook",
    Default = false,
    Callback = function(state)
        sendWebhookEnabled = state
    end
})

local function sendWebhook()
    if not webhookUrl or webhookUrl == "" then return end

    local scrollingFrame = LocalPlayer:WaitForChild("PlayerGui")
        :WaitForChild("ScreenStorage")
        :WaitForChild("Frame")
        :WaitForChild("Content")
        :WaitForChild("ScrollingFrame")

    local eggCount = {}
    for _, child in ipairs(scrollingFrame:GetChildren()) do
        if child:IsA("Frame") and child.Name ~= "Item" and child.Visible then
            local valueLabel = child:FindFirstChild("BTN") 
                                and child.BTN:FindFirstChild("Stat")
                                and child.BTN.Stat:FindFirstChild("NAME")
                                and child.BTN.Stat.NAME:FindFirstChild("Value")
            if valueLabel and valueLabel:IsA("TextLabel") then
                local eggName = valueLabel.Text
                if eggName and eggName ~= "" then
                    eggCount[eggName] = (eggCount[eggName] or 0) + 1
                end
            end
        end
    end

    local eggStrings = {}
    for name, count in pairs(eggCount) do
        table.insert(eggStrings, name.." "..count.."x")
    end

    if #eggStrings > 0 then
        local data = {
            content = nil,
            embeds = {{
                color = 0x87CEEB,
                fields = {
                    {
                        name = "Roblox Name :",
                        value = LocalPlayer.Name
                    },
                    {
                        name = "Eggs",
                        value = table.concat(eggStrings, "\n")
                    }
                },
                image = {
                    url = "https://cdn.discordapp.com/attachments/1410491458405924864/1413912288146227271/noFilter_2.webp"
                }
            }},
            attachments = {}
        }

        local body = HttpService:JSONEncode(data)

        if typeof(request) == "function" then
            pcall(function()
                request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            end)
        elseif syn and syn.request then
            pcall(function()
                syn.request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            end)
        elseif http_request then
            pcall(function()
                http_request({Url = webhookUrl, Method = "POST", Headers = {["Content-Type"] = "application/json"}, Body = body})
            end)
        end
    end
end

task.spawn(function()
    while true do
        if sendWebhookEnabled then
            sendWebhook()
        end
        task.wait(3600)
    end
end)

local VirtualInputManager = game:GetService("VirtualInputManager")
local antiAFK = false
local jumpLoop

Tabs.MainTab:Toggle({
    Title = "Anti-AFK (Jump Every 15 Min)",
    StartingState = false,
    Callback = function(state)
        antiAFK = state
        if antiAFK then
            jumpLoop = task.spawn(function()
                while antiAFK do

                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Space, false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.Space, false, game)
                    
                    task.wait(1)
                end
            end)
        else
            if jumpLoop then
                task.cancel(jumpLoop)
                jumpLoop = nil
            end
        end
    end
})



WindUI:Notify({
    Title = "Notification",
    Content = "Script by. MR.Yuttana",
    Duration = 10,
    Icon = "megaphone",
})

WindUI:Notify({
    Title = "Notification",
    Content = "Have fun for script!!",
    Duration = 14,
    Icon = "folder-code",
})
