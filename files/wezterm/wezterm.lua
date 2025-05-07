local wezterm = require("wezterm")

config = wezterm.config_builder()

config = {
    automatically_reload_config = true,
    enable_tab_bar = false,
    window_close_confirmation = "NeverPrompt",
    window_decorations = "RESIZE",
    default_cursor_style = "BlinkingBar",
    color_scheme = 'Gruvbox dark, medium (base16)',
    font = wezterm.font("JetBrains Mono",{weight = "Bold"}),
    font_size = 13,
    window_padding = {
      left = 3,
      right = 3,
      top = 0,
      bottom = 0,
    }
  }

return config
