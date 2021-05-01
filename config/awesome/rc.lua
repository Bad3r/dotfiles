-- If LuaRocks is installed, make sure that packages installed through it are

-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
--                                                                           --
--                                                                           --
-- ------------------------ Standard awesome library ----------------------- --
--                                                                           --
--                                                                           --
local gears = require('gears')
local awful = require('awful')
require('awful.autofocus')
--                                                                           --
--                                                                           --
-- ------------------------- Theme handling library ------------------------ --
--                                                                           --
--                                                                           --
local beautiful = require('beautiful')
--                                                                           --
--                                                                           --
-- ----------------------------- Error Handling ---------------------------- --
--                                                                           --
--                                                                           --
-- Check if awesome encountered an error during startup and
-- fell back to another config
-- (This code will only ever execute for the fallback config)
if awesome.startup_errors then
    naughty.notify({
        preset  = naughty.config.presets.critical,
        title   = "Oops, there were errors during startup!",
        text    = awesome.startup_errors
    })
end
-- Handle runtime errors after startup
do
    local in_error  = false
    awesome.connect_signal("debug::error", function(err)
        if in_error then
            return
        end
        in_error    = true
        naughty.notify({
                preset  = naughty.config.presets.critical,
                title   = "Oops, an error happened!",
                text    = tostring(err)
            })
        in_error    = false
    end)
end
--                                                                           --
--                                                                           --
-- --------------------------------- Shell --------------------------------- --
--                                                                           --
--                                                                           --
awful.util.shell = 'sh'
--                                                                           --
--                                                                           --
-- --------------------------------- Theme --------------------------------- --
--                                                                           --
--                                                                           --
beautiful.init(require('theme'))
--                                                                           --
--                                                                           --
-- --------------------------------- Layout -------------------------------- --
--                                                                           --
--                                                                           --
require('layout')
--                                                                           --
--                                                                           --
-- --------------------------------- Config -------------------------------- --
--                                                                           --
--                                                                           --
require('config.client')
require('config.root')
require('config.tags')
root.keys(require('config.keys.global'))
--                                                                           --
--                                                                           --
-- -------------------------------- Modules -------------------------------- --
--                                                                           --
--                                                                           --
require('module.notifications')
require('module.auto-start')
require('module.exit-screen')
require('module.quake-terminal')
require('module.menu')
require('module.titlebar')
require('module.brightness-osd')
require('module.volume-osd')
require('module.lockscreen')
require('module.dynamic-wallpaper')

--                                                                           --
--                                                                           --
-- ------------------------------- Wallpaper ------------------------------- --
--                                                                           --
--                                                                           --
screen.connect_signal(
    'request::wallpaper',
    function(s)
        -- If wallpaper is a function, call it with the screen
        if beautiful.wallpaper then
            if type(beautiful.wallpaper) == 'string' then

                -- Check if beautiful.wallpaper is color/image
                if beautiful.wallpaper:sub(1, #'#') == '#' then
                    -- If beautiful.wallpaper is color
                    gears.wallpaper.set(beautiful.wallpaper)

                elseif beautiful.wallpaper:sub(1, #'/') == '/' then
                    -- If beautiful.wallpaper is path/image
                    gears.wallpaper.maximized(beautiful.wallpaper, s,true)
                end
            else
                beautiful.wallpaper(s)
            end
        end
    end
)
