local colors = require "colors"

local config = {}

config.use_background = true
config.use_xft = true

config.margin = 15
config.padding = 20
config.base_voffset = 120
config.voffset_line_height = 18

config.font = 'Terminus:size=12'

config.xftalpha = 0.3
config.update_interval = 1.0
config.total_run_times = 0
config.double_buffer = true
config.minimum_width = 300
config.minimum_height = 200
config.maximum_width = 400
config.border_inner_margin = 20
config.draw_shades = false
config.draw_outline = false
config.draw_borders = true
config.draw_graph_borders = false

config.own_window = true
config.own_window_type = 'desktop'
config.own_window_argb_visual = true
-- config.own_window_transparent = true
config.own_window_hints = 'undecorated,below,sticky,skip_taskbar,skip_pager'
config.own_window_argb_value = colors.argb
config.own_window_colour = colors.bg
config.default_color = colors.fg
config.default_shade_color = colors.shadow
config.default_outline_color = colors.outline

config.no_buffers = true
config.uppercase = false
config.cpu_avg_samples = 2
config.override_utf8_locale = false

return config
