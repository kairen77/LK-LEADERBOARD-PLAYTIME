Config = {}

-- =========================
-- 📊 LEADERBOARD
-- =========================
Config.TopPlayingTime = 10

-- =========================
-- 🌐 DISCORD WEBHOOK
-- =========================
Config.Webhooks = "https://discord.com/api/webhooks/1500416690343645254/M-YXqc2ywsho49obpQiqRpqUL1UAaz4qCM9VQ-McAuE3Vj7ZNZSabdZU_SysxBAhBd2E"

-- ⚠️ auto save message id (jangan isi manual)
Config.WebhookMessageId = nil

-- =========================
-- ⏱️ PLAYTIME SYSTEM
-- =========================
-- tambahan waktu tiap interval (detik)
Config.AddTimeInterval = 60 -- 1 menit

-- =========================
-- 🔄 WEBHOOK UPDATE
-- =========================
Config.UpdateInterval = 10000 -- 10 detik (anti rate limit aman)

-- =========================
-- 💾 AUTO SAVE DATABASE
-- =========================
Config.AutoSaveInterval = 60000 -- 1 menit

-- =========================
-- 🎮 PLAYER TRACKING
-- =========================

-- update webhook saat join/quit
Config.UpdateOnJoinQuit = true

-- update saat waktu bertambah
Config.UpdateOnTimeAdd = true

-- =========================
-- 🧠 AFK SYSTEM (BARU - CONNECT SERVER.LUA)
-- =========================

-- aktifkan anti AFK system
Config.AFKEnabled = true

-- waktu diam sampai dianggap AFK (detik)
Config.AFKTime = 600 -- 10 menit

-- interval cek AFK (ms)
Config.AFKCheckInterval = 5000 -- 5 detik

-- kalau kendaraan bergerak → TIDAK AFK
Config.IgnoreAFKInMovingVehicle = true

-- minimal speed kendaraan dianggap "bergerak"
Config.VehicleMoveSpeed = 1.0

-- =========================
-- 🧾 DEBUG
-- =========================
Config.Debug = false