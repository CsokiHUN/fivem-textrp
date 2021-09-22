fx_version("cerulean")
game("gta5")
author("Csoki")

dependency("es_extended")

shared_script("@es_extended/imports.lua")

client_script("client.lua")
shared_script("shared.lua")
server_script("server.lua")

ui_page("ui/index.html")

files({
	"ui/*",
})
