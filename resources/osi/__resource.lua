ui_page "gui/index.html"
loadscreen "loadscreen/index.html"

server_scripts {
    '@mysql-async/lib/MySQL.lua',
    'main/config.lua',
    'main/server.lua',
    'main/sql.lua'
}

client_scripts {
    '@osi-math/vector.lua',
    '@osi-math/matrix.lua',
    '@osi-math/utility.lua',
    'main/client.lua'
    'main/context_menu.lua'
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
    "gui/index.html",
    "loadscreen/bankgothic.ttf",
    "loadscreen/loadscreen.jpg",
    "loadscreen/loadstyle.css",
    "loadscreen/index.html"
}