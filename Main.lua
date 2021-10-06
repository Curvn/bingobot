while not game:IsLoaded() or not game:GetService("CoreGui") or not game:GetService("Players").LocalPlayer or not game:GetService("Players").LocalPlayer.PlayerGui do wait() end

local fuckbutton = game:GetService("Players").LocalPlayer.PlayerGui.Bingo.Menu.MainMenu.Header.PlayButton
local Bullshit = {"MouseButton1Click", "MouseButton1Down", "Activated"}

for i,v in pairs(Bullshit) do
    for i,v in pairs(getconnections(fuckbutton[v])) do
        v:Fire()
    end
end

local LPlayer = game:GetService("Players").LocalPlayer
local LPG = LPlayer.PlayerGui

local BingoGui = LPG.Bingo
local CardsHolder = BingoGui.StaticDisplayArea.Cards.PlayerArea.Cards.Container.SubContainer
local NumberCallInfo = BingoGui.TopBar.Communicator.Display.BingoCalls.InfoText.CallNo

BingoGui.DisplayArea.Visible = false

NumberCallInfo:GetPropertyChangedSignal("Text"):Connect(function()
    print(NumberCallInfo.Text)
    if NumberCallInfo.Text == "Call 1" then
        print("RESTARTED AUTOMATIC BINGO.")
        
        for i,v in pairs(CardsHolder:GetDescendants()) do
            if v.ClassName == "TextLabel" and v.Name == "ToGoText" then
                v:GetPropertyChangedSignal("Text"):Connect(function()
                    if v.Text == "BINGO!" then
                        wait(0.1)
                        keypress(0x0d)
                        wait(1)
                        keyrelease(0x0d)
                        print(v.Text)
                    end
                end)
            end
        end
        
    end
end)

for i,v in pairs(CardsHolder:GetDescendants()) do
    if v.ClassName == "TextLabel" and v.Name == "ToGoText" then
        v:GetPropertyChangedSignal("Text"):Connect(function()
            if v.Text == "BINGO!" then
                wait(0.1)
                keypress(0x0d)
                wait(1)
                keyrelease(0x0d)
                print(v.Text)
            end
        end)
    end
end
-- END OF AUTOMATIC BINGO

function FindNewServer()
    if syn.queue_on_teleport then
        syn.queue_on_teleport('game:GetService("ReplicatedFirst"):RemoveDefaultLoadingScreen()')
        local loadstringy = "https://raw.githubusercontent.com/Curvn/bingobot/main/Main.lua"
        syn.queue_on_teleport('loadstring(game:HttpGet("'..loadstringy..'"))()')
    end
    local GUIDs = {}
    local maxPlayers = 70
    local pagesToSearch = 100
    local Http = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&cursor="))
    for i = 1,pagesToSearch do
        for i,v in pairs(Http.data) do
            if v.playing <= v.maxPlayers and v.id ~= game.JobId then
                maxPlayers = v.maxPlayers
                table.insert(GUIDs, {id = v.id, users = v.playing})
            end
        end
        if Http.nextPageCursor ~= null then Http = game:GetService("HttpService"):JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100&cursor="..Http.nextPageCursor)) else break end
    end
    game:GetService("TeleportService"):TeleportToPlaceInstance(game.PlaceId, GUIDs[math.random(1,#GUIDs)].id, LPlayer)
end

local Players, UserInputService, TweenService, CoreGui = game:GetService("Players"), game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("CoreGui")

spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Curvn/bingobot/main/TimeServer.lua"))() end)

wait(1)
CoreGui.RobloxGui:WaitForChild("TimeServer")
local Guis = {TimeServer = CoreGui.RobloxGui.TimeServer.ScrollComplex.header}
wait(1)
CoreGui.RobloxGui.TimeServer:TweenPosition(UDim2.new(0.92, 0, 0.91, 0), "In", "Quint", 1)
wait(2.5)

spawn(function()
    for i = 0, 1 do
        Guis.TimeServer.Text = tostring(1 - i)
        wait(60)
    end
    FindNewServer()
end)
