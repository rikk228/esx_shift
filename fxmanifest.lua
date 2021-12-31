fx_version 'cerulean'
game 'gta5'

author 'rikk228.js'
description 'Esx Shift managment'
version '1.0.0'

shared_script 'config.lua'

client_scripts {
    'nui.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'server.lua'
}

ui_page 'html/index.html'

files {
    'html/index.html',
    'html/index.js',
    'html/index.css',
    'html/reset.css'
}
