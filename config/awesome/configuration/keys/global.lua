local awful         = require('awful')
local beautiful     = require('beautiful')

require('awful.autofocus')

local hotkeys_popup = require('awful.hotkeys_popup').widget
local apps          = require('configuration.apps')
--                                                                           --
--                                                                           --
-- ------------------------------- Modifiers ------------------------------- --
--                                                                           --
--                                                                           --
local Mod           = require('configuration.keys.mod').mod_key
local Alt           = require('configuration.keys.mod').alt_key
local Shift         = 'Shift'
local Ctrl          = 'Control'
--                                                                           --
--                                                                           --
-- ----------------------------- direction keys ---------------------------- --
--                                                                           --
--                                                                           --
local Up            = 'k'
local Down          = 'j'
local Left          = 'h'
local Right         = 'l'
--                                                                           --
--                                                                           --
-- ------------------------------ Key bindings ----------------------------- --
--                                                                           --
--                                                                           --
local global_keys   = awful.util.table.join(
    -- Group:awesome
    awful.key(
        {Mod},
        'F1',
        hotkeys_popup.show_help,
        {   description	= "Show currently assigned key bindings",
            group		= "awesome"}
    ),
    awful.key(
        {Mod, Shift},
        'r',
        awesome.restart,
        {   description	= "Restart Awesome",
            group		= "awesome"}
    ),
    awful.key(
        {Mod, Shift}, 
        'x',
        function ()
            awful.prompt.run {
                prompt       = "Run Lua code: ",
                textbox      = awful.screen.focused().mypromptbox.widget,
                exe_callback = awful.util.eval,
                history_path = awful.util.get_cache_dir() .. "/history_eval"
            }
        end,
        {   description = "Run Lua code prompt",
            group       = "awesome"}
    ),

    -- Group:layout
    awful.key(
        {Alt, Shift},
        Right,
        function()
            awful.tag.incmwfact(0.05)
        end,
        {   description = 'increase master width factor',
            group       = 'layout'}
    ),
    awful.key(
        {Alt, Shift},
        Left,
        function()
            awful.tag.incmwfact(-0.05)
        end,
        {   description = 'decrease master width factor',
            group       = 'layout'}
    ),
    awful.key(
        {Mod, Shift},
        Up,
        function()
            awful.tag.incnmaster(1, nil, true)
        end,
        {   description = 'increase the number of master clients',
            group       = 'layout'}
    ),
    awful.key(
        {Mod, Shift},
        Down,
        function()
            awful.tag.incnmaster(-1, nil, true)
        end,
        {   description = 'decrease the number of master clients',
            group       = 'layout'}
    ),
    awful.key(
        {Mod},
        '+',
        function()
            awful.tag.incncol(1, nil, true)
        end,
        {   description = 'increase the number of columns',
            group       = 'layout'}
    ),
    awful.key(
        {Mod, Ctrl},
        '-',
        function()
            awful.tag.incncol(-1, nil, true)
        end,
        {   description = 'decrease the number of columns',
            group       = 'layout'}
    ),
    awful.key(
        {Mod, Shift},
        'space',
        function()
            awful.layout.inc(1)
        end,
        {   description = 'select next layout',
            group       = 'layout'}
    ),
    -- awful.key(
    --     {Mod, Shift},
    --     'space',
    --     function()
    --         awful.layout.inc(-1)
    --     end,
    --     {   description = 'select previous layout',
    --         group       = 'layout'}
    -- ),
    awful.key(
        {Mod, Shift},
        '+',
        function()
            awful.tag.incgap(1)
        end,
        {   description = 'increase gap',
            group       = 'layout'}
    ),
    awful.key(
        {Mod, Shift},
        '-',
        function()
            awful.tag.incgap(-1)
        end,
        {   description = 'decrease gap',
            group       = 'layout'}
    ),
    awful.key(
        {Mod}, 
        'w', 
        awful.tag.viewprev, 
        {   description = 'view previous tag',
            group       = 'tag'}
    ),
    awful.key(
        {Mod}, 
        's', 
        awful.tag.viewnext, 
        {   description = 'view next tag',
            group       = 'tag'}
    ),
    awful.key(
        {Mod}, 
        'Escape', 
        awful.tag.history.restore, 
        {   description = 'alternate between current and previous tag',
            group       = 'tag'}
    ),
    awful.key({ Mod, Ctrl }, 
        'w',
        function ()
            -- tag_view_nonempty(-1)
            local focused = awful.screen.focused()
            for i = 1, #focused.tags do
                awful.tag.viewidx(-1, focused)
                if #focused.clients > 0 then
                    return
                end
            end
        end, 
        {   description = 'view previous non-empty tag',
            group       = 'tag'}
    ),
    awful.key({ Mod, Ctrl }, 
        's',
        function ()
            -- tag_view_nonempty(1)
            local focused =  awful.screen.focused()
            for i = 1, #focused.tags do
                awful.tag.viewidx(1, focused)
                if #focused.clients > 0 then
                    return
                end
            end
        end, 
        {   description = 'view next non-empty tag',
            group       = 'tag'}
    ),
    awful.key(
        {Alt, Shift}, 
        Left,  
        function() 
            awful.screen.focus_relative(-1) 
        end,
        { description = 'focus the previous screen',
            group       = 'screen'}
    ),
    awful.key(
        {Alt, Shift}, 
        Right, 
        function()
            awful.screen.focus_relative(1)
        end,
        { description = 'focus the next screen',
            group       = 'screen'}
    ),
    awful.key(
        {Mod, Ctrl},
        'n',
        function()
            local c = awful.client.restore()
            -- Focus restored client
            if c then
                c:emit_signal('request::activate')
                c:raise()
            end
        end,
        {   description = 'restore minimized',
            group       = 'screen'}
    ),
    awful.key(
        {},
        'XF86MonBrightnessUp',
        function()
            awful.spawn('light -A 10', false)
            awesome.emit_signal('widget::brightness')
            awesome.emit_signal('module::brightness_osd:show', true)
        end,
        {   description = 'increase brightness by 10%',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86MonBrightnessDown',
        function()
            awful.spawn('light -U 10', false)
            awesome.emit_signal('widget::brightness')
            awesome.emit_signal('module::brightness_osd:show', true)
        end,
        {   description = 'decrease brightness by 10%',
            group       = 'hotkeys'}
    ),
    -- ALSA volume control
    awful.key(
        {},
        'XF86AudioRaiseVolume',
        function()
            awful.spawn('amixer -D pulse sset Master 5%+', false)
            awesome.emit_signal('widget::volume')
            awesome.emit_signal('module::volume_osd:show', true)
        end,
        {   description = 'increase volume up by 5%',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86AudioLowerVolume',
        function()
            awful.spawn('amixer -D pulse sset Master 5%-', false)
            awesome.emit_signal('widget::volume')
            awesome.emit_signal('module::volume_osd:show', true)
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
    awful.key(
        {},
        'XF86AudioNext',
        function()
            awful.spawn('mpc next', false)
        end,
        {   description = 'next music',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86AudioPrev',
        function()
            awful.spawn('mpc prev', false)
        end,
        {   description = 'previous music',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86AudioPlay',
        function()
            awful.spawn('mpc toggle', false)
        end,
        {   description = 'play/pause music',
            group       = 'hotkeys'}

    ),
    awful.key(
        {},
        'XF86AudioMicMute',
        function()
            awful.spawn('amixer set Capture toggle', false)
        end,
        {   description = 'mute microphone',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86PowerDown',
        function()
            --
        end,
        {   description = 'shutdown skynet',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86PowerOff',
        function()
            awesome.emit_signal('module::exit_screen:show')
        end,
        {   description = 'toggle exit screen',
            group       = 'hotkeys'}
    ),
    awful.key(
        {},
        'XF86Display',
        function()
            awful.spawn.single_instance('arandr', false)
        end,
        {   description = 'arandr',
            group       = 'hotkeys'}
    ),
    awful.key(
        {Mod, Shift},
        'e',
        function()
            awesome.emit_signal('module::exit_screen:show')
        end,
        {   description = 'toggle exit screen',
            group       = 'hotkeys'}
    ),
    awful.key(
        {Mod},
        '`',
        function()
            awesome.emit_signal('module::quake_terminal:toggle')
        end,
        {   description = 'dropdown application',
            group       = 'launcher'}
    ),
    awful.key(
        { }, 
        'Print',
        function ()
            awful.spawn.easy_async_with_shell(apps.utils.full_screenshot,function() end)
        end,
        {   description = 'fullscreen screenshot',
            group       = 'Utility'}
    ),
    awful.key(
        {Mod, Shift}, 
        's',
        function ()
            awful.spawn.easy_async_with_shell(apps.utils.area_screenshot,function() end)
        end,
        {   description = 'area/selected screenshot',
            group       = 'Utility'}
    ),
    awful.key(
        {Mod},
        'x',
        function()
            awesome.emit_signal('widget::blur:toggle')
        end,
        {   description = 'toggle blur effects',
            group       = 'Utility'}
    ),
    awful.key(
        {Mod},
        ']',
        function()
            awesome.emit_signal('widget::blur:increase')
        end,
        {   description = 'increase blur effect by 10%',
            group       = 'Utility'}
    ),
    awful.key(
        {Mod},
        '[',
        function()
            awesome.emit_signal('widget::blur:decrease')
        end,
        {   description = 'decrease blur effect by 10%',
            group       = 'Utility'}
    ),
    awful.key(
        {Mod},
        't',
        function() 
            awesome.emit_signal('widget::blue_light:toggle')
        end,
        {   description = 'toggle redshift filter',
            group       = 'Utility'}
    ),
    awful.key(
        { Ctrl }, 
        'Escape', 
        function ()
            if screen.primary.systray then
                if not screen.primary.tray_toggler then
                    local systray = screen.primary.systray
                    systray.visible = not systray.visible
                else
                    awesome.emit_signal('widget::systray:toggle')
                end
            end
        end, 
        {   description = 'toggle systray visibility',
            group       = 'Utility'}
    ),
    awful.key(
        {Mod},
        'l',
        function()
            awful.spawn(apps.default.lock, false)
        end,
        {   description = 'lock the screen',
            group       = 'Utility'}
    ),
    awful.key(
        {Mod}, 
        'Return',
        function()
            awful.spawn(apps.default.terminal)
        end,
        {   description = 'open default terminal',
            group       = 'launcher'}
    ),
    awful.key(
        {Mod, Shift}, 
        'f',
        function()
            awful.spawn(apps.default.file_manager)
        end,
        {   description = 'open default file manager',
            group       = 'launcher'}
    ),
    awful.key(
        {Mod, Shift}, 
        'w',
        function()
            awful.spawn(apps.default.web_browser)
        end,
        {   description = 'open default web browser',
            group       = 'launcher'}
    ),
    awful.key(
        {Ctrl, Shift}, 
        'Escape',
        function()
            awful.spawn(apps.default.sysmonitor)
        end,
        {   description = 'open system monitor',
            group       = 'launcher'}
    ),
    awful.key(
        {Mod}, 
        'd',
        function()
            local focused = awful.screen.focused()

            if focused.control_center then
                focused.control_center:hide_dashboard()
                focused.control_center.opened = false
            end
            if focused.info_center then
                focused.info_center:hide_dashboard()
                focused.info_center.opened    = false
            end
            awful.spawn(apps.default.rofi_appmenu, false)
        end,
        {   description = 'open application drawer',
            group       = 'launcher'}
    ),
    awful.key(
        {}, 
        'XF86Launch1',
        function()
            local focused = awful.screen.focused()

            if focused.control_center then
                focused.control_center:hide_dashboard()
                focused.control_center.opened = false
            end
            if focused.info_center then
                focused.info_center:hide_dashboard()
                focused.info_center.opened = false
            end
            awful.spawn(apps.default.rofi_appmenu, false)
        end,
        {   description = 'open application drawer',
            group       = 'launcher'}
    ),
    awful.key(
        {Mod},
        'space',
        function()
            awful.spawn(apps.default.rofi_global, false)
        end,
        {   description = 'open global search',
            group       = 'launcher'}
    ),
    awful.key(
        {Mod},
        'r',
        function()
            local focused = awful.screen.focused()
            if focused.info_center and focused.info_center.visible then
                focused.info_center:toggle()
            end
            focused.control_center:toggle()
        end,
        {   description = 'open control center',
            group       = 'launcher'}
    ),
    awful.key(
        {Alt},
        'Escape',
        function()
            local focused = awful.screen.focused()
            if focused.control_center and focused.control_center.visible then
                focused.control_center:toggle()
            end
            focused.info_center:toggle()
        end,
        {   description = 'open info center',
            group       = 'launcher'}
    )
)

for i = 1, 9 do
	local descr_view, descr_toggle, descr_move, descr_toggle_focus

	if i == 1 or i == 9 then
		descr_view    = {
            description = 'view tag #',
            group       = 'tag'
        }
		descr_toggle  = {
            description = 'toggle tag #',
            group       = 'tag'
        }
		descr_move    = {
            description = 'move focused client to tag #',
            group       = 'tag'
        }
		descr_toggle_focus = {
            description = 'toggle focused client on tag #',
            group       = 'tag'
        }
	end
	global_keys =
		awful.util.table.join(
		global_keys,
		-- View tag only.
		awful.key(
			{Mod},
			'#' .. i + 9,
			function()
				local focused   = awful.screen.focused()
				local tag       = focused.tags[i]
				if tag then
					tag:view_only()
				end
			end,
			descr_view
		),
		-- Toggle tag display.
		awful.key(
			{Mod, Ctrl},
			'#' .. i + 9,
			function()
				local focused   = awful.screen.focused()
				local tag       = focused.tags[i]
				if tag then
					awful.tag.viewtoggle(tag)
				end
			end,
			descr_toggle
		),
		-- Move client to tag.
		awful.key(
			{Mod, Shift},
			'#' .. i + 9,
			function()
				if client.focus then
					local tag   = client.focus.screen.tags[i]
					if tag then
						client.focus:move_to_tag(tag)
					end
				end
			end,
			descr_move
		),
		-- Toggle tag on focused client.
		awful.key(
			{Mod, Ctrl, Shift},
			'#' .. i + 9,
			function()
				if client.focus then
					local tag = client.focus.screen.tags[i]
					if tag then
						client.focus:toggle_tag(tag)
					end
				end
			end,
			descr_toggle_focus
		)
	)
end

return global_keys
