local gears = require("gears")
local awful = require("awful")


local clientkeys = gears.table.join(
-- ------------------------------------------------------------------------- --
-- --------------------------------- Client -------------------------------- --
-- ------------------------------------------------------------------------- --
    awful.key(
        { Mod,},
        "f",
        function (c)
            c.fullscreen = not c.fullscreen
            c:raise()
        end,
        {   description = "Set client fullscreen",
            group       = "Client"}
    ),
    awful.key(
        { Mod, Shift},
        "q",
        function (c)
            c:kill()
        end,
        {   description = "Kill focused client",
            group       = "Client"}
    ),
    awful.key(
        { Mod,},
        "t",
        function (c)
            c.ontop = not c.ontop
        end,
        {   description = "Set client on-top",
            group       = "Client"}
    ),
    awful.key({ Mod,},
        "n",
        function (c)
            -- The client currently has the input focus, so it cannot be
            -- minimized, since minimized clients can't have the focus.
            c.minimized = true
        end,
        {   description = "Minimize client",
            group       = "Client"}
    ),
    -- TODO: idk what this does..
    awful.key({ Mod, Shift},
        "m",
        function (c)
            c.maximized = not c.maximized
            c:raise()
        end ,
        {   description = "Maximize client",
            group       = "Client"}
    ),
    awful.key(
        { Mod,},
        "m",
        function (c)
            c.maximized_vertical = not c.maximized_vertical
            c:raise()
        end ,
        {   description = "Maximize client vertically",
            group       = "Client"}
    ),
    awful.key(
        { Mod, Ctrl},
        "m",
        function (c)
            c.maximized_horizontal = not c.maximized_horizontal
            c:raise()
        end ,
        {   description = "Maximize client horizontally",
            group       = "Client"}
    ),

-- ------------------------------------------------------------------------- --
-- -------------------------- Layout modification -------------------------- --
-- ------------------------------------------------------------------------- --
    awful.key(
        { Mod,},
        "o",
        function (c)
            c:move_to_screen()
        end,
        {   description = "Send client to next screen",
            group       = "Layout modification"}
    ),
    awful.key(
        { Mod,},
        "space",
        awful.client.floating.toggle,
        {   description = "Toggle client floating status",
            group       = "Layout modification"}
    ),
    awful.key(
        { Mod, Ctrl },
        "Return",
        function (c)
            c:swap(awful.client.getmaster())
        end,
        {   description = "Swap focused client with master",
            group       = "Layout modification"}
    )

)

return clientkeys
