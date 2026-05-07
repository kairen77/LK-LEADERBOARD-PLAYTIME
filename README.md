# 🏆 leaderboard-playingtime

**leaderboard-playingtime** adalah script leaderboard playtime untuk FiveM yang dikembangkan dengan inspirasi dari **PSR-PLAYINGTIME**, namun telah mengalami banyak penyesuaian, perbaikan, dan inovasi sistem.

Tujuan dari pengembangan ulang penuh ini adalah untuk menciptakan versi yang:
- Lebih stabil
- Lebih optimal
- Lebih ringan
- Lebih mudah dipahami
- Lebih mudah dikembangkan ke depannya

---

# ✨ Features

## 🔥 Alpha System

### ✅ Anti AFK System
Jika player diam selama 10 menit maka player akan dianggap AFK dan playtime otomatis berhenti.

Playtime akan otomatis lanjut kembali saat player mulai bergerak lagi.

Sistem ini juga mendukung kendaraan, sehingga selama kendaraan bergerak player tidak akan dianggap AFK.

---

### ✅ Blacklist System
Memungkinkan kamu untuk mem-blacklist Citizen ID tertentu agar tidak muncul di leaderboard Discord webhook.

---

### ✅ Auto Save & Load System
Playtime otomatis tersimpan ke database dan dimuat kembali saat player join.

Data tetap aman meskipun:
- Server restart
- Script restart
- Resource di ensure ulang

---

### ✅ Real-Time Leaderboard
Leaderboard akan otomatis update dengan interval tertentu tanpa perlu restart script.

Data leaderboard selalu sinkron dengan total playtime terbaru.

---

### ✅ Optimized Update System
Menggunakan sistem cooldown dan interval untuk:
- Mengurangi spam SQL query
- Menjaga performa server tetap stabil
- Mengurangi beban database

---

### ✅ Persistent Discord Webhook
Leaderboard Discord menggunakan sistem **edit message**.

Bukan spam mengirim webhook baru setiap update.

Hasil:
- Lebih rapi
- Lebih ringan
- Lebih efisien

---

### ✅ Rank & Medal System
Leaderboard dilengkapi ranking otomatis:

- 🥇 Rank 1
- 🥈 Rank 2
- 🥉 Rank 3

Berdasarkan total playtime player.

---

### ✅ Auto Edit Message
Webhook Discord akan otomatis mengedit 1 pesan yang sama setiap ada perubahan atau sesuai interval update.

Tidak spam webhook message baru.

---

# 📁 Installation

1. Download resource ini
2. Masukkan folder ke dalam `resources`
3. Import SQL yang sudah disediakan
4. Edit webhook di `config.lua`
5. Jika ingin ada blacklist ada di `server.lua`
