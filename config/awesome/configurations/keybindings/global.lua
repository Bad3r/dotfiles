local gears         = require("gears");
local awful         = require("awful");
local beautiful     = require("beautiful")
local hotkeys_popup = require("awful.hotkeys_popup")
local default_apps  = require("configurations.default-apps")
require('awful.autofocus')

--[[

--]]

local globalkeys = gears.table.join(
-- ------------------------------------------------------------------------- --
-- ---------------------------------- Meta --------------------------------- --
-- ------------------------------------------------------------------------- --

    awful.key(
        { Mod,},
        "s",
        hotkeys_popup.show_help,
        {   description     ="Show currently assigned key bindings",
            group           ="Meta"}
    ),

    awful.key(
        { Mod, Shift },
        "r",
        awesome.restart,
        {   description     = "Restart Awesome",
            group           = "Meta"}
    ),

    awful.key(
        { Mod, Shift }, 
        "x",
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {   description = "Run Lua code prompt",
            group       = "Meta"}
    ),

    awful.key(
        { Mod,},
        "Return",
        function ()
            awful.spawn(terminal)
        end,
        {   description = "Spawn terminal emulator",
            group       = "Meta"}
    ),

    awful.key(
        { Mod,},
        "d",
        function()
            awful.spawn(default_apps.app_menu, false)
        end,
        {   description = "Open main menu",
            group       = 'Meta'}
    ),

    awful.key(
        { Mod,},
        "r",
        function ()
            awful.screen.focused().mypromptbox:run()
        end,
        {   description = "Run prompt",
            group       = "Meta"}
    ),

    awful.key(
        { Mod,},
        "x",
        function ()
            awesome.emit_signal('module::exit_screen:show')
        end,
        {   description = "Open exit screen",
            group       = "Meta"}
    ),

        -- TODO: Set $mod+Shift+e to suspend
    -- awful.key(
    --     { Mod, Shift},
    --     "e",
    --     function ()
    --         awful.spawn(default_apps.suspend)
    --     end,
    --     {   description = "Suspend System",
    --         group       = "Meta"}
    -- ),
    
    awful.key(
        { Mod, Shift},
        "f",
        function ()
            awful.spawn(default_apps.filemanager)
        end,
        {   description = "Launch FileManager",
            group       = "launcher"}
    ),

-- ------------------------------------------------------------------------- --
-- --------------------------------- client -------------------------------- --
-- ------------------------------------------------------------------------- --
    -- Layout manipulation
    -- Swap client
    awful.key(
        { Mod, Shift},
        "j",
        function ()
            awful.client.swap.byidx(1)
        end,
        {   description = "swap with next client by index", 
            group       = "client"}
    ),
    awful.key(
        { Mod, Shift},
        "Left",
        function ()
            awful.client.swap.byidx(1)
        end,
        {   description = "swap with next client by index",
            group       = "client"}
    ),
    awful.key(
        { Mod, Shift},
        "k",
        function ()
            awful.client.swap.byidx(-1)
        end,
        {   description = "swap with previous client by index",
            group       = "client"}
    ),
    awful.key(
        { Mod, Shift},
        "Right",
        function ()
            awful.client.swap.byidx(-1)
        end,
        {description    = "swap with previous client by index",
        group           = "client"}
    ),
    -- Focus client
    awful.key(
        { Mod,},
        "j",
        function ()
            awful.client.focus.byidx(1)
        end,
        {   description = "focus next by index",
            group       = "client"}
    ),
    awful.key(
        { Mod,}, 
        "Right",
        function ()
            awful.client.focus.byidx(1)
        end,
        {   description = "focus next by index",
            group       = "client"}
    ),
    awful.key(
        { Mod,}, 
        "k",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {   description = "focus previous by index",
            group       = "client"}
    ),
    awful.key(
        { Mod,}, "Left",
        function ()
            awful.client.focus.byidx(-1)
        end,
        {   description = "focus previous by index",
            group       = "client"}
    ),
    -- Focus previous
    awful.key(
        { Mod,},
        "Tab",
        function ()
            awful.client.focus.history.previous()
            if client.focus then
                client.focus:raise()
            end
        end,
        {   description = "go back",
            group       = "client"}
    ),
    awful.key(
        { Mod,},
        "u", awful.client.urgent.jumpto,
        {   description = "jump to urgent client",
            group       = "client"}
    ),
    awful.key(
        { Mod, Ctrl },
        "n",
        function ()
            local c     = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal(
                    "request::activate", "key.unminimize", {raise = true}
                )
            end
        end,
        {   description = "restore minimized",
            group       = "client"}
    ),

    -- Group:layout
    -- Client resize master
    awful.key(
        { Mod, Ctrl},
        "Right",
        function ()
            awful.tag.incmwfact( 0.05)
        end,
        {   description = "increase master width factor",
            group       = "layout"}
    ),
    awful.key({ Mod, Ctrl},
        "Left",
        function ()
            awful.tag.incmwfact(-0.05)
        end,
        {   description = "decrease master width factor",
            group       = "layout"}
    ),
    -- Client resize
    awful.key({ Mod, Ctrl},
        "Up",
        function ()
            awful.client.incwfact(0.50)
        end,
        {   description = "decrease master width factor",
            group       = "layout"}
    ),
    awful.key({ Mod, Ctrl},
        "Down",
        function ()
            awful.client.incwfact(-0.50)
        end,
        {   description = "decrease master width factor",
            group       = "layout"}
    ),
    -- Increase/Decrease numbers of master
    awful.key(
        { Mod, Shift},
        "h",
        function ()
            awful.tag.incnmaster( 1, nil, true)
        end,
        {   description = "increase the number of master clients",
            group       = "layout"}
    ),
    awful.key(
        { Mod, Shift},
        "l",
        function ()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {   description = "decrease the number of master clients",
            group       = "layout"}
    ),

    -- Increase/Decrease numbers of columns
    awful.key(
        { Mod, Ctrl },
        "+",
        function ()
            awful.tag.incncol( 1, nil, true)
        end,
        {   description = "increase the number of columns",
            group       = "layout"}
    ),
    awful.key(
        { Mod, Ctrl },
        "-",
        function () 
            awful.tag.incncol(-1, nil, true)
        end,
        {   description = "decrease the number of columns",
            group       = "layout"}
    ),

    -- Next layout
    awful.key(
        { Mod, Shift},
        "space",
        function ()
            awful.layout.inc(1)
        end,
        {   description = "select next",
            group       = "layout"}
    ),

    -- Previous layout
    awful.key(
        { Mod, Ctrl},
        "space",
        function ()
            awful.layout.inc(-1)
        end,
        {description    = "select previous", group = "layout"}
    ),

    -- Group:hotkeys
--                                                                           --
-- --------------------------------- Audio --------------------------------- --
--                                                                           --
    awful.key(
        {},
        'XF86AudioPlay',
        function()
            awful.spawn('playerctl play-pause', false)
        end,
        {   description = 'Play/Pause',
            group       = 'hotkeys'}
    ),

    awful.key(
        {},
        'XF86AudioNext',
        function()
            awful.spawn('playerctl next', false)
        end,
        {   description = 'Play Next',
            group       = 'hotkeys'}
    ),

    awful.key(
        {},
        'XF86AudioPrev',
        function()
            awful.spawn('playerctl previous', false)
        end,
        {   description = 'Play Previous',
            group       = 'hotkeys'}
    ),

    awful.key(
        {},
        'XF86AudioStop',
        function()
            awful.spawn('amixer -D pulse sset Master 5%+', false)
        end,
        {   description = 'Stop Playback',
            group       = 'hotkeys'}
    ),

    awful.key(
        {},
        'XF86AudioRvaiseVolume',
        function()
            awful.spawn('amixer -D pulse sset Master 5%+', false)
        end,
        {   description = 'increase volume up by 5%',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86AudioLowerVolume',
        function()
            awful.spawn('amixer -D pulse sset Master 5%-', false)
        end,
        {   description = 'decrease volume up by 5%',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86AudioMute',
        function()
            awful.spawn('amixer -D pulse set Master 1+ toggle', false)
        end,
        {   description = 'toggle mute',
            group       = 'hotkeys'}
    ),
--                                                                           --
-- ------------------------------- Backlight ------------------------------- --
--                                                                           --
    awful.key(
        {},
        'XF86MonBrightnessUp',
        function()
            awful.spawn('xbacklight -inc 10', false)
        end,
        {   description = 'increase brightness by 10%',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86MonBrightnessDown',
        function()
            awful.spawn('xbacklight -dec 10', false)
        end,
        {   description = 'decrease brightness by 10%',
            group       = 'hotkeys'}
    ),
--                                                                           --
-- ----------------------------- Screen Settings --------------------------- --
--                                                                           --
    awful.key(
        {},
        'XF86Display',
        function()
            awful.spawn.single_instance('kcmshell5 kcm_kscreen', false)
        end,
        {   description = 'Display configuration',
            group       = 'hotkeys'}
    ),

    -- Group:screen
    -- Relative focus
    awful.key(
        { Alt, Shift},
        "2",
        function ()
            awful.screen.focus_relative(1)
        end,
        {   description = "focus the next screen",
            group       = "screen"}
    ),
    awful.key(
        { Alt, Shift},
        "1",
        function () awful.screen.focus_relative(-1) end,
        {   description = "focus the previous screen",
            group       = "screen"}
    ),    
    -- Group:tag
    awful.key(
        { Mod,},
        "Escape",
        awful.tag.history.restore,
        {   description = "go back",
            group       = "tag"}
    )
)

return globalkeys
