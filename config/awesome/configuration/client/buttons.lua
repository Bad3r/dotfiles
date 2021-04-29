local awful = require('awful')
local Mod = require('configuration.keys.mod').mod_key

return awful.util.table.join(
	awful.button(
		{},
		1,
		function(c)
			c:emit_signal('request::activate')
			c:raise()
		end
	),
	awful.button(
		{Mod},
		1,
		awful.mouse.client.move
	),
	awful.button(
		{Mod},
		3,
		awful.mouse.client.resize
	),
	awful.button(
		{Mod},
		4,
		function()
			awful.layout.inc(1)
		end
	),
	awful.button(
		{Mod},
		5,
		function()
			awful.layout.inc(-1)
		end
	)
)
