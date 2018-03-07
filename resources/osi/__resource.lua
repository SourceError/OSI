resource_type 'gametype' { name = 'Freeroam' }

ui_page "gui/index.html"

client_scripts {
    'main/client.lua'
}

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'main/config.lua'
    'main/server.lua',
    'main/sql.lua',
}

files {
    "gui/scripts/main.js",
    "gui/scripts/selection.js",
    "gui/scripts/attributes.js",
    "gui/scripts/templates.js",
    "gui/stylesheets/selection.css",
    "gui/stylesheets/application.css",
    "gui/stylesheets/information.css",
    "gui/stylesheets/common.css",
    "gui/images/osi_character_application.png",
    "gui/images/osi_character_selection.png",
    "gui/index.html"
}