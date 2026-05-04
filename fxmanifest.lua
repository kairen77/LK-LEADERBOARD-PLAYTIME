fx_version 'cerulean'
game 'gta5'

name 'playing time tracker'
author 'developer exclusive'
description 'Playtime Tracker + Discord Webhook (Edit Message)'
version '1.0.0'

server_scripts {
    '@oxmysql/lib/MySQL.lua',
    '@ox_lib/init.lua',
    'config.lua',
    'server.lua'
}