local filesystem            = require('gears.filesystem')
local theme_dir             = filesystem.get_configuration_dir() .. '/theme'

local theme                 = {}

theme.icons                 = theme_dir .. '/icons/'
theme.font                  = 'Inter Regular 10'
theme.font_bold             = 'Inter Bold 10'

-- Colorscheme
theme.system_black_dark     = '#21222C'
theme.system_black_light    = '#6272A4'

theme.system_red_dark       = '#FF5555'
theme.system_red_light      = '#FF6E6E'

theme.system_green_dark     = '#50FA7B'
theme.system_green_light    = '#69FF94'

theme.system_yellow_dark    = '#F1FA8C'
theme.system_yellow_light   = '#FFFFA5'

theme.system_blue_dark      = '#BD93F9'
theme.system_blue_light     = '#D6ACFF'

theme.system_magenta_dark   = '#FF79C6'
theme.system_magenta_light  = '#FF92DF'

theme.system_cyan_dark      = '#8BE9FD'
theme.system_cyan_light     = '#A4FFFF'

theme.system_white_dark     = '#F8F8F2'
theme.system_white_light    = '#F8F8F2'

theme.icons                 = theme_dir ..'/icons/'
-- Accent color
theme.accent                = theme.system_blue_dark

-- Background color
theme.background            = '#282A36'
theme.background_light      = '#F8F8F2'

-- Transparent
theme.transparent           = '#00000000'

-- Awesome icon
theme.awesome_icon          = theme.icons .. 'awesome.svg'

local awesome_overrides     = function(theme) end

return {
    theme                   = theme,
     awesome_overrides      = awesome_overrides
}
