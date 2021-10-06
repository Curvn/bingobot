while not game:IsLoaded() or not game:GetService("CoreGui") or not game:GetService("Players").LocalPlayer or not game:GetService("Players").LocalPlayer.PlayerGui or not game:GetService("Players").LocalPlayer.PlayerGui.Bingo.Menu.MainMenu.Header.PlayButton do wait() end
wait(2)

local Players = game:GetService("Players")
local LPlayer = Players.LocalPlayer
local LPG = LPlayer.PlayerGui
local UserInputService, TweenService, CoreGui = game:GetService("UserInputService"), game:GetService("TweenService"), game:GetService("CoreGui")
local ChatEvent = game:GetService("ReplicatedStorage").DefaultChatSystemChatEvents.SayMessageRequest

local BingoGui = LPG.Bingo
local CardsHolder = BingoGui.StaticDisplayArea.Cards.PlayerArea.Cards.Container.SubContainer
local NumberCallInfo = BingoGui.TopBar.Communicator.Display.BingoCalls.InfoText.CallNo

local fuckbutton = LPG.Bingo.Menu.MainMenu.Header.PlayButton
local bingobutton = LPG.Bingo.StaticDisplayArea.Cards.PlayerArea.Cards.Container.SubContainer.Buttons.ClaimButton
local Bullshit = {"MouseButton1Click", "MouseButton1Down", "Activated"}

for i,v in pairs(Bullshit) do
    for i,v in pairs(getconnections(fuckbutton[v])) do
        v:Fire()
    end
end

local WinnerSayings = { -- CHAT WHEN BINGO, SAYS A RANDOM CHAT WHEN YOU GET A BINGO.
	"Well that was easy. #BINGO #EZ",
	"OMG I GOT BINGO! :D",
	"BINNNNGGOOOO!!!",
	"HAHA I GOT BINGO! YAY!",
	"I GOT BINGO CAUSE I'M COOL!",
	"Imagine not getting bingo lol #EZ #BINGO",
	"Yayy i got bingo :D"
}

local JokeStartChat = "JOTG: "
local JokerSayings = { -- JOKE OF THE GAME, TELLS A RANDOM JOKE WHEN THE GAME STARTS.
	JokeStartChat.. "What type of cloud is so lazy, because it will never get up? Fog!",
	JokeStartChat.. "Why was the belt sent to jail? For holding up a pair of pants!",
	JokeStartChat.. "Which bear is the most condescending? A pan-duh!",
	JokeStartChat.. "Whats 9+10? 21",
	JokeStartChat.. "What kind of noise does a witch’s vehicle make? Brrrroooom, brrroooom.",
	JokeStartChat.. "Why are elevator jokes so classic and good? They work on many levels.",
	JokeStartChat.. "Why do bees have sticky hair? Because they use a honeycomb.",
	JokeStartChat.. "What’s the most detail-oriented ocean? The Pacific.",
	JokeStartChat.. "Why is Peter Pan always flying? Because he Neverlands.",
	JokeStartChat.. "Why did the coach go to the bank? To get his quarterback.",
	JokeStartChat.. "How do celebrities stay cool? They have many fans.",
	JokeStartChat.. "Sundays are always a little sad, but the day before is a sadder day.",
	JokeStartChat.. "5/4 of people admit they’re bad at fractions.",
	JokeStartChat.. "Dogs can’t operate MRI machines. But catscan."
}

BingoGui.DisplayArea.Visible = false

NumberCallInfo:GetPropertyChangedSignal("Text"):Connect(function()
    print(NumberCallInfo.Text)
    if NumberCallInfo.Text == "Call 1" then
        print("RESTARTED AUTOMATIC BINGO.")
        ChatEvent:FireServer(JokerSayings[math.random(1,#JokerSayings)],"All")
        for i,v in pairs(CardsHolder:GetDescendants()) do
            if v.ClassName == "TextLabel" and v.Name == "ToGoText" then
                v:GetPropertyChangedSignal("Text"):Connect(function()
                    if v.Text == "BINGO!" then
                        ChatEvent:FireServer(WinnerSayings[math.random(1,#WinnerSayings)],"All")
                        for i,v in pairs(Bullshit) do
                            for i,v in pairs(getconnections(bingobutton[v])) do
                                v:Fire()
                            end
                        end
                        print(v.Text)
                    end
                end)
            end
        end
        
    end
end)

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

Players.LocalPlayer.Idled:Connect(function()
	game:GetService("VirtualUser"):Button2Down(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
	wait()
	game:GetService("VirtualUser"):Button2Up(Vector2.new(0,0),workspace.CurrentCamera.CFrame)
end)

spawn(function() loadstring(game:HttpGet("https://raw.githubusercontent.com/Curvn/bingobot/main/TimeServer.lua"))() end)

wait(1)
CoreGui.RobloxGui:WaitForChild("TimeServer")
local Guis = {TimeServer = CoreGui.RobloxGui.TimeServer.ScrollComplex.header}
wait(1)
CoreGui.RobloxGui.TimeServer:TweenPosition(UDim2.new(0.92, 0, 0.91, 0), "In", "Quint", 1)
wait(2.5)

spawn(function()
    for i = 0, 60 do
        Guis.TimeServer.Text = tostring(60 - i)
        wait(60)
    end
    FindNewServer()
end)

repeat wait()
    if #Players:GetPlayers() < 20 then
        FindNewServer()
    end
until nil
