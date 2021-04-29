-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")
--                                                                           --
-- ------------------------ Standard awesome library ----------------------- --
--                                                                           --
local gears                     = require("gears")
local awful                     = require("awful")
require('awful.autofocus')
--                                                                           --
-- ----------------------- Widget and layout library ----------------------- --
--                                                                           --
local wibox                     = require("wibox")
--                                                                           --
-- ------------------------- Theme handling library ------------------------ --
--                                                                           --
local beautiful                 = require("beautiful")
--                                                                           --
-- -------------------------- Notification library ------------------------- --
--                                                                           --
local naughty                   = require("naughty")
--                                                                           --
-- ----------------------------- Enable hotkeys ---------------------------- --
--                                                                           --
require("awful.hotkeys_popup.keys")
--                                                                           --
-- ------------------------------- Set shell ------------------------------- --
--                                                                           --
awful.util.shell                = 'sh'


local has_fdo, freedesktop      = pcall(require, "freedesktop")
--                                                                           --
--                                                                           --
-- ------------------------------------------------------------------------- --
-- ----------------------------- Error handling ---------------------------- --
-- ------------------------------------------------------------------------- --
--                                                                           --
--                                                                           --
-- Check if awesome encountered an error during startup and fell back to     --
-- another config (This code will only ever execute for the fallback config) --
if awesome.startup_errors then
    naughty.notify(
        {   preset              = naughty.config.presets.critical,
            title               = "Oops, there were errors during startup!",
            text                = awesome.startup_errors})
end
--                                                                           --
-- ------------------------- Handle runtime errors ------------------------- --
--                                                                           --
do
    local in_error              = false
    awesome.connect_signal("debug::error", function (err)
--              Make sure we don't go into an endless error loop             --
        if in_error then return end
        in_error                = true
        naughty.notify(
            {   preset          = naughty.config.presets.critical,
                title           = "Oops, an error happened!",
                text            = tostring(err)})
        in_error                = false
    end)
end
--                                                                           --
--                                                                           --
-- ------------------------------------------------------------------------- --
-- -------------------------- Variable definitions ------------------------- --
-- ------------------------------------------------------------------------- --
--                                                                           --
--                                                                           --
-- --------------------------------- Theme --------------------------------- --
--                                                                           --
beautiful.init( 
    gears.filesystem.get_configuration_dir() .. "themes/default/theme.lua"
)
--                                                                           --
-- ------------------------------ Set Defaults ----------------------------- --
--                                                                           --
Mod                             = "Mod4"
Alt                             = "Mod1"
Shift                           = "Shift"
Ctrl                            = "Control"
terminal                        = "kitty"

editor                          = os.getenv("EDITOR") or "vim"
editor_cmd                      = terminal .. " -e " .. editor

-- ----------------------------- direction keys ---------------------------- --
up                              = "k"
down                            = "j"
left                            = "h"
right                           = "l"
--                                                                           --
-- ---- Table of layouts to cover with awful.layout.inc (order matters) ---- --
--                                                                           --
awful.layout.layouts            = {
    awful.layout.suit.tile,
    awful.layout.suit.floating,
    awful.layout.suit.max,
}
--                                                                           --
--                                                                           --
-- ------------------------------------------------------------------------- --
-- --------------------------------- Wibar --------------------------------- --
-- ------------------------------------------------------------------------- --
--                                                                           --
--                                                                           --
local function set_wallpaper(s)
    if beautiful.wallpaper then
        local wallpaper         = beautiful.wallpaper
    -- If wallpaper is a function, call it with the screen 
        if type(wallpaper)      == "function" then
            wallpaper           = wallpaper(s)
        end
        gears.wallpaper.maximized(wallpaper, s, true)
    end
end
-- Re-set wallpaper when a screen's geometry changes
screen.connect_signal("property::geometry", set_wallpaper)

awful.screen.connect_for_each_screen(function(s)
    --  Wallpaper
    set_wallpaper(s)
    --  Create a promptbox for each screen 
    s.mypromptbox               = awful.widget.prompt()
    -- Create the wibox
    s.mywibox                   = awful.wibar(
        {   position            = beautiful.wibar_position,
            screen              = s,
            height              = beautiful.wibar_height})
    -- Add widgets to the wibox
    s.mywibox:setup {
        layout                  = wibox.layout.align.horizontal,
        {
        -- Left widgets
            layout              = wibox.layout.fixed.horizontal,
            require("widgets.panel.menu"),
            require("widgets.panel.taglist")(s),
            s.mypromptbox,
        },
        -- Middle widget 
        require("widgets.panel.tasklist")(s),
        -- Right widgets
        {
            layout              = wibox.layout.fixed.horizontal,
            require("widgets.panel.systray"),
            require("widgets.panel.layoutbox")(s),
            require("widgets.clock")(),
            require("widgets.noti-center"),
            require("widgets.control-center"),
        },
    }
end)

awesome.connect_signal(
    "panel::show",
    function ()
        for s in screen do
            s.mywibox.visible   = true
        end
    end
)

awesome.connect_signal(
    "panel::hide",
    function ()
        for s in screen do
            s.mywibox.visible   = false
        end
    end
)
--                                                                           --
-- ----------------------------- Mouse bindings ---------------------------- --
--                                                                           --
root.buttons(gears.table.join(
    awful.button({ }, 4, awful.tag.viewnext),
    awful.button({ }, 5, awful.tag.viewprev)
))
--                                                                           --
-- ------------------------------ Key bindings ----------------------------- --
--                                                                           --
globalkeys = require("config.keybindings.global")
clientkeys = require("config.keybindings.client")
-- ---------------------- Bind all key numbers to tags --------------------- --
for i = 1, 9 do
    globalkeys = gears.table.join(globalkeys,
-- ----------------------------- View tag only ----------------------------- --
        awful.key(
            { Mod }, "#" .. i + 9,
            function ()
                local screen    = awful.screen.focused()
                local tag       = screen.tags[i]
                if tag then
                    tag:view_only()
                end
            end,
            {description        = "view tag #"..i, group = "tag"}
        ),
-- --------------------------- Toggle tag display -------------------------- --
        awful.key(
            { Mod, Ctrl }, "#" .. i + 9,
            function ()
                local screen    = awful.screen.focused()
                local tag       = screen.tags[i]
                if tag then
                    awful.tag.viewtoggle(tag)
                end
            end,
            {   description     = "toggle tag #" .. i,
                group           = "tag"}
        ),
-- --------------------------- Move client to tag -------------------------- --
        awful.key(
            { Mod, Shift }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag   = client.focus.screen.tags[i]
                    if tag then
                        client.focus:move_to_tag(tag)
                    end
               end
            end,
            {   description     = "move focused client to tag #"..i,
                group           = "tag"}
        ),
-- ---------------------- Toggle tag on focused client --------------------- --
        awful.key(
            { Mod, Ctrl, Shift }, "#" .. i + 9,
            function ()
                if client.focus then
                    local tag   = client.focus.screen.tags[i]
                    if tag then
                        client.focus:toggle_tag(tag)
                    end
                end
            end,
            {   description     = "toggle focused client on tag #" .. i,
                 group          = "tag"}
        )
    )
end

clientbuttons = gears.table.join(
    awful.button({ }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
    end),
    awful.button({ Mod }, 1, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.move(c)
    end),
    awful.button({ Mod }, 3, function (c)
        c:emit_signal("request::activate", "mouse_click", {raise = true})
        awful.mouse.client.resize(c)
    end)
)
--                                                                           --
-- -------------------------------- Set keys ------------------------------- --
--                                                                           --
root.keys(globalkeys)
--                                                                           --
-- --------------------------------- Rules --------------------------------- --
--                                                                           --
require("config.rules")
require("module.signals")
require("widgets.exit-screen")
require("module.notification")
require("module.autostart")
--                                                                           --
--                                                                           --
--                                                                           --
-- ------------------------------------------------------------------------- --

