-- fxmanifest.lua
fx_version 'cerulean'
game 'gta5'

author 'Matias'
description 'matias_leveringsjob'
version '1.0.0'

-- Afhængigheder
dependencies {
    'ox_lib',
    'ox_target',
}

-- Scripts
client_scripts {
    '@ox_lib/init.lua', -- Inkluderer ox_lib funktioner
    'config.lua',
    'client.lua'
}

server_scripts {
    '@ox_lib/init.lua', -- Inkluderer ox_lib funktioner
    'config.lua',
    'server.lua'
}

lua54 'yes' -- Aktiverer Lua 5.4 support
