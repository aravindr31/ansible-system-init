local wezterm = require("wezterm")

local home = os.getenv("HOME")
wezterm.add_to_config_reload_watch_list(home.."/.cache/wal")
config = wezterm.config_builder()

function tab_title(tab_info)
  local title = tab_info.tab_title
  if title and #title > 0 then
    return title
  end
  return tab_info.active_pane.title
end

wezterm.on(
  'format-tab-title',
  function(tab, tabs, panes, config, hover, max_width)
    local edge_background = '#0b0022'
    local background = '#1b1032'
    local foreground = '#808080'

    if tab.is_active then
      background = '#2b2042'
      foreground = '#c0c0c0'
    elseif hover then
      background = '#3b3052'
      foreground = '#909090'
    end

    local edge_foreground = background

    local title = tab_title(tab)

    title = wezterm.truncate_right(title, max_width - 2)

    return {
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
      { Background = { Color = background } },
      { Foreground = { Color = foreground } },
      { Text = title },
      { Background = { Color = edge_background } },
      { Foreground = { Color = edge_foreground } },
    }
  end
)

config = {
    automatically_reload_config = true,
    enable_tab_bar = false,
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",
    default_cursor_style = "BlinkingBlock",
    color_scheme = 'Gruvbox dark, hard (base16)',
    font = wezterm.font("Iosevka NF",{weight = "Bold"}),
    window_background_opacity = 0.70,
    macos_window_background_blur = 50,
    font_size = 18,
    colors = {
      cursor_bg = "#ffffff",
      cursor_border = "#ffffff",
    },
    window_padding = {
      left = 3,
      right = 3,
      top = 5,
      bottom = 0,
    }
  }

return config
