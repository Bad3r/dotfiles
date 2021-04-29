local awful     = require("awful")
local beautiful = require("beautiful")

-- Rules to apply to new clients (through the "manage" signal)
awful.rules.rules = {
--                                                                           --
--                                                                           --
-- ------------------------------------------------------------------------- --
-- ------------------------------ All clients ------------------------------ --
-- ------------------------------------------------------------------------- --
--                                                                           --
--                                                                           --
    {
        rule = { },
            properties = {
                border_width    = beautiful.border_width,
                border_color    = beautiful.border_normal,
                focus           = awful.client.focus.filter,
                raise           = true,
                keys            = clientkeys,
                buttons         = clientbuttons,
                screen          = awful.screen.preferred,
                placement       = awful.placement.no_overlap 
                                + awful.placement.no_offscreen
            }
    },
--                                                                           --
--                                                                           --
-- ------------------------------------------------------------------------- --
-- ---------------------------- Floating clients --------------------------- --
-- ------------------------------------------------------------------------- --
--                                                                           --
--                                                                           --
    {
        rule_any = {
            instance = {
                -- Firefox addon DownThemAll
                "DTA",
                -- Includes session name in class
                "copyq",
                "pinentry",
            },
            class = {
                "Arandr",
                "Blueman-manager",
                "Gpick",
                "Kruler",
                -- kalarm
                "MessageWin",
                "Sxiv",
                -- Needs a fixed window size to avoid fingerprinting by
                --  screen size
                "Tor Browser",
                "Wpa_gui",
                "veromix",
                "xtightvncviewer"
            },
            -- Note that the name property shown in xprop might be set
            --  slightly after creation of the client and the name shown
            --  there might not match defined rules here.
            name = {
                -- xev
                "Event Tester",
            },
            role = {
                -- Thunderbird's calendar
                "AlarmWindow",
                -- Thunderbird's about:config
                "ConfigManager",
                -- e.g. Firefox's (detached) Developer Tools
                "pop-up",
            }
      },
      properties    = { floating = true }
    },
    -- Add titlebars to normal clients and dialogs
    {
        rule_any    = {
            type    = { "normal", "dialog" }
        },
    properties      = { titlebars_enabled = true }
    },
    -- Set Firefox to always map on the tag named "2" 
    -- on the primary screen 1.
    {
        rule        = { class = "Firefox" },
        properties  = { screen = 1, tag = "1" }
    },
    {
      rule          = { instance = "plugin-container" },
        properties  = { floating = true } 
    },
    {
      rule          = { role = "_NET_WM_STATE_FULLSCREEN" },
      properties    = { floating = true } 
    },

}
