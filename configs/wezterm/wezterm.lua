local wezterm = require 'wezterm'
local act = wezterm.action
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

-- ====================================
-- Keymaps
-- ====================================
config.disable_default_key_bindings = true
config.leader = { key = 'k', mods = 'ALT', timeout_milliseconds = 2000 }
config.keys = {
    -- Tabs
    { key = 't', mods = 'LEADER', action = wezterm.action.SpawnTab 'CurrentPaneDomain' },
    { key = 'F4', mods = 'LEADER', action = wezterm.action.CloseCurrentTab { confirm = false } },
    { key = 'n', mods = 'LEADER', action = wezterm.action.SpawnWindow },
    { key = '1', mods = 'LEADER', action = act.MoveTabRelative(-1) },
    { key = '2', mods = 'LEADER', action = act.MoveTabRelative(1) },
    -- Paneis
    { key = ']', mods = 'LEADER', action = wezterm.action.SplitHorizontal { domain = 'CurrentPaneDomain' } },
    { key = '[', mods = 'LEADER', action = wezterm.action.SplitVertical { domain = 'CurrentPaneDomain' } },
    { key = 'w', mods = 'LEADER', action = wezterm.action.CloseCurrentPane { confirm = false } },
    { key = 'h', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Left' },
    { key = 'l', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Right' },
    { key = 'j', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Down' },
    { key = 'k', mods = 'LEADER', action = wezterm.action.ActivatePaneDirection 'Up' },
    -- Editor
    { key = 'r', mods = 'LEADER', action = wezterm.action.ReloadConfiguration },
    { key = 'c', mods = 'LEADER', action = wezterm.action.CopyTo 'Clipboard' },
    { key = 'v', mods = 'LEADER', action = wezterm.action.PasteFrom 'Clipboard' },
    { key = 'd', mods = 'LEADER', action = wezterm.action.ShowDebugOverlay },
    -- Zoom
    { key = '=', mods = 'LEADER', action = wezterm.action.IncreaseFontSize },
    { key = '-', mods = 'LEADER', action = wezterm.action.DecreaseFontSize },
    { key = '0', mods = 'LEADER', action = wezterm.action.ResetFontSize },
}
return config
