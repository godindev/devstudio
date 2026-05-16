local wezterm = require 'wezterm'
local config = wezterm.config_builder()

-- ====================================
-- SHELL
-- ====================================

-- Shell padrão
if wezterm.target_triple == 'x86_64-pc-windows-msvc' then
    config.default_prog = { 'pwsh.exe', '-NoLogo' }
else
    config.default_prog = { 'pwsh', '-NoLogo' }
end
-- ====================================
-- Editor
-- ====================================
config.font = wezterm.font 'JetBrainsMono NFM ExtraBold'
config.color_scheme = 'Vs Code Dark+ (Gogh)'



return config
