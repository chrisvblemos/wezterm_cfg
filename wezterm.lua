local wezterm = require("wezterm")
local mux = wezterm.mux
local act = wezterm.action

local config = {}
local keys = {}
local mouse_bindings = {}
local launch_menu = {}

if wezterm.config_builder then
	config = wezterm.config_builder()
end

config.color_scheme = "Catppuccin Mocha"
config.font = wezterm.font("JetBrains Mono Regular")
config.font_size = 10
config.launch_menu = launch_menu
config.default_cursor_style = "BlinkingBar"
config.disable_default_key_bindings = true
config.keys = { { key = "V", mods = "CTRL", action = act.PasteFrom("Clipboard") } }
config.mouse_bindings = mouse_bindings

-- There are mouse binding to mimc Windows Terminal and let you copy
-- To copy just highlight something and right click. Simple
mouse_bindings = {
	{
		event = { Down = { streak = 3, button = "Left" } },
		action = wezterm.action.SelectTextAtMouseCursor("SemanticZone"),
		mods = "NONE",
	},
	{
		event = { Down = { streak = 1, button = "Right" } },
		mods = "NONE",
		action = wezterm.action_callback(function(window, pane)
			local has_selection = window:get_selection_text_for_pane(pane) ~= ""
			if has_selection then
				window:perform_action(act.CopyTo("ClipboardAndPrimarySelection"), pane)
				window:perform_action(act.ClearSelection, pane)
			else
				window:perform_action(act({ PasteFrom = "Clipboard" }), pane)
			end
		end),
	},
}

-- setting up options in the launch
config.launch_menu = {
	{ label = "PowerShell", args = { "pwsh.exe" } },
	{ label = "Ubuntu WSL", args = { "wsl", "--cd", "~" } },
}

config.keys = {
	-- Reload configuration
	{ key = "r", mods = "ALT", action = wezterm.action.ReloadConfiguration },

	-- Handles panes
	{ key = "v", mods = "ALT", action = wezterm.action.SplitVertical },
	{ key = "h", mods = "ALT", action = wezterm.action.SplitHorizontal },
	{ key = "w", mods = "ALT", action = wezterm.action.CloseCurrentPane({ confirm = false }) },
	{ key = "t", mods = "ALT", action = wezterm.action.PaneSelect },
	{ key = "LeftArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Left", 5 }) },
	{ key = "DownArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Down", 5 }) },
	{ key = "RightArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Right", 5 }) },
	{ key = "UpArrow", mods = "ALT", action = wezterm.action.AdjustPaneSize({ "Up", 5 }) },

	-- Handles tabs
	{ key = "\\", mods = "ALT", action = wezterm.action.ShowLauncher },
	{ key = "p", mods = "ALT", action = wezterm.action.CloseCurrentTab({ confirm = true }) },
	{ key = "[", mods = "ALT", action = wezterm.action.ActivateTabRelative(-1) },
	{ key = "]", mods = "ALT", action = wezterm.action.ActivateTabRelative(1) },
}

config.default_domain = "local"
config.default_prog = { "pwsh.exe", "-NoLogo" }

-- config.default_domain = "WSL:Ubuntu"

return config
