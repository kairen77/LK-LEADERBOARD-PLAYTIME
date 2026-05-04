local QBCore = exports['qb-core']:GetCoreObject()
local playerData = {}
local playerActivity = {}

local isUpdating = false
local lastUpdate = 0

local RESOURCE_NAME = GetCurrentResourceName()
local WEBHOOK_FILE = "webhook.json"


-- FILTER SYSTEM (KALAU EVENT KHUSUS WARGA, BLACKLIST CITIZENID ADMIN BIAR TIDAK MASUK LEADERBOARD) 
local BLACKLIST_CITIZENID = {
    ["AGR67206"] = true,
    ["AXK93169"] = true,
    ["AXI15588"] = true,
    ["BBN95311"] = true,
    ["DUH09774"] = true,
    ["DXW52901"] = true,
    ["FHD80859"] = true,
    ["IVT75569"] = true,
    ["JAF94374"] = true,
    ["JDT53066"] = true,
    ["LEM11381"] = true,
    ["MRC16966"] = true,
    ["ORF31848"] = true,
    ["TRZ39679"] = true,
    ["TVQ63773"] = true,
    ["UIK76789"] = true,
    ["WSU98851"] = true,
}


-- WEBHOOK SAVE/LOAD
local function LoadWebhookId()
    local file = LoadResourceFile(RESOURCE_NAME, WEBHOOK_FILE)
    if file then
        local data = json.decode(file)
        if data and data.id then
            Config.WebhookMessageId = data.id
        end
    end
end

local function SaveWebhookId(id)
    Config.WebhookMessageId = id
    SaveResourceFile(RESOURCE_NAME, WEBHOOK_FILE, json.encode({ id = id }), -1)
end


-- PLAYER
local function GetPlayer(src)
    return QBCore.Functions.GetPlayer(src)
end

local function GetName(Player)
    if not Player then return "Unknown" end
    local c = Player.PlayerData.charinfo
    return (c.firstname or "Unknown") .. " " .. (c.lastname or "")
end


-- FORMAT TIME
local function FormatTime(sec)
    sec = tonumber(sec) or 0
    local h = math.floor(sec / 3600)
    local m = math.floor((sec % 3600) / 60)

    if h > 0 then
        return h .. " Jam " .. m .. " Menit"
    else
        return m .. " Menit"
    end
end


-- SAFE AFK RESET FUNCTION

local function ResetAFK(src)
    if playerActivity[src] then
        playerActivity[src].isAFK = false
        playerActivity[src].lastMove = os.time()
    end
end


-- AFK TRACKING
RegisterNetEvent("playtime:activity", function(moved)
    local src = source

    if not playerActivity[src] then
        playerActivity[src] = {
            lastMove = os.time(),
            isAFK = false
        }
    end

    local data = playerActivity[src]

    if moved then
        data.lastMove = os.time()
        data.isAFK = false
    end
end)


-- AFK CHECK LOOP
CreateThread(function()
    while true do
        Wait(Config.AFKCheckInterval or 5000)

        for src, data in pairs(playerActivity) do
            local Player = GetPlayer(src)

            if Player then
                local now = os.time()

                if (now - (data.lastMove or now)) >= Config.AFKTime then
                    data.isAFK = true
                else
                    data.isAFK = false
                end
            end
        end
    end
end)


-- WEBHOOK FUNCTION
local function SendWebhook(desc, totalPlayers, totalTime)
    local payload = {
        username = "EXCLUSIVE ROLEPLAY",
        embeds = {{
            title = "🏆 LEADERBOARD PLAYTIME SERVER",
            description = "🔥 **TOP 10 PLAYTIME TERLAMA**\n\n" .. desc,
            color = 16711680,
            fields = {
                { name = "👥 Total Player", value = tostring(totalPlayers), inline = true },
                { name = "⏱️ Total Waktu", value = FormatTime(totalTime), inline = true }
            },
            footer = {
                text = "Auto Update • " .. os.date("%d/%m/%Y %H:%M:%S")
            }
        }}
    }

    local function CreateMessage()
        PerformHttpRequest(
            Config.Webhooks .. "?wait=true",
            function(_, res)
                local data = json.decode(res or "{}")
                if data and data.id then
                    SaveWebhookId(data.id)
                end
            end,
            'POST',
            json.encode(payload),
            { ['Content-Type'] = 'application/json' }
        )
    end

    if Config.WebhookMessageId then
        PerformHttpRequest(
            Config.Webhooks .. "/messages/" .. Config.WebhookMessageId,
            function(code)
                if code ~= 200 then
                    Config.WebhookMessageId = nil
                    CreateMessage()
                end
            end,
            'PATCH',
            json.encode(payload),
            { ['Content-Type'] = 'application/json' }
        )
    else
        CreateMessage()
    end
end

-- LOAD PLAYER 
local function LoadPlayer(src)
    local Player = GetPlayer(src)
    if not Player then return end

    local id = Player.PlayerData.citizenid

    local row = MySQL.single.await(
        'SELECT time FROM playtime WHERE identifier = ?',
        { id }
    )

    playerData[src] = {
        time = row and tonumber(row.time) or 0
    }

    if not row then
        MySQL.insert(
            'INSERT INTO playtime (identifier, name, time) VALUES (?, ?, ?)',
            { id, GetName(Player), 0 }
        )
    end
end


-- SAVE PLAYER
local function SavePlayer(src)
    local Player = GetPlayer(src)
    if not Player or not playerData[src] then return end

    MySQL.update(
        'UPDATE playtime SET time = ?, name = ? WHERE identifier = ?',
        {
            playerData[src].time,
            GetName(Player),
            Player.PlayerData.citizenid
        }
    )
end

-- LEADERBOARD
local function UpdateLeaderboard(force)
    local now = GetGameTimer()

    if not force and (now - lastUpdate) < Config.UpdateInterval then return end
    if isUpdating then return end

    isUpdating = true
    lastUpdate = now

    MySQL.query(
        'SELECT identifier, name, time FROM playtime WHERE time > 0 ORDER BY time DESC LIMIT ?',
        { Config.TopPlayingTime },
        function(result)

            local desc = ""
            local totalTime = 0
            local rank = 0

            if not result or #result == 0 then
                SendWebhook("📭 Belum ada data", 0, 0)
                isUpdating = false
                return
            end

            for i = 1, #result do
                local row = result[i]
                local time = tonumber(row.time) or 0

                -- NORMALIZE CITIZENID
                local cid = string.upper((row.identifier or ""):gsub("%s+", ""))

                -- FILTER
                if not BLACKLIST_CITIZENID[cid] then
                    rank = rank + 1
                    totalTime = totalTime + time

                    local medal = "🔹"
                    if rank == 1 then medal = "🥇"
                    elseif rank == 2 then medal = "🥈"
                    elseif rank == 3 then medal = "🥉"
                    end

                    desc = desc .. string.format(
                        "%s **#%d %s**\n⏱️ %s\n\n",
                        medal,
                        rank,
                        row.name or "Unknown",
                        FormatTime(time)
                    )
                end
            end

            SendWebhook(desc, rank, totalTime)
            isUpdating = false
        end
    )
end


-- JOIN
RegisterNetEvent('QBCore:Server:PlayerLoaded', function(Player)
    LoadPlayer(Player.PlayerData.source)
    UpdateLeaderboard(true)
end)

-- QUIT
AddEventHandler('playerDropped', function()
    local src = source

    SavePlayer(src)
    playerData[src] = nil
    playerActivity[src] = nil

    UpdateLeaderboard(true)
end)


-- LOAD EXISTING
CreateThread(function()
    Wait(2000)

    LoadWebhookId()

    for _, src in pairs(QBCore.Functions.GetPlayers()) do
        LoadPlayer(src)
    end

    UpdateLeaderboard(true)
end)


-- PLAYTIME LOOP
CreateThread(function()
    while true do
        Wait(Config.AddTimeInterval * 1000)

        for src in pairs(playerData) do
            if GetPlayer(src) then
                local afk = playerActivity[src] and playerActivity[src].isAFK

                if not afk then
                    playerData[src].time = playerData[src].time + Config.AddTimeInterval
                end
            end
        end

        UpdateLeaderboard()
    end
end)


-- AUTO SAVE
CreateThread(function()
    while true do
        Wait(Config.AutoSaveInterval)

        for src in pairs(playerData) do
            SavePlayer(src)
        end
    end
end)

-- START
CreateThread(function()
    Wait(2000)
    UpdateLeaderboard(true)
end)
