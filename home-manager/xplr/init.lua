version = "0.21.2"

local xplr = xplr

local home = os.getenv("HOME")
package.path = home
.. "/.config/xplr/plugins/?/init.lua;"
.. home
.. "/.config/xplr/plugins/?.lua;"
.. package.path

require("nuke").setup{
  open = {
    custom = {
      {mime_regex = "^video/.*", command = "nohup mpv {} &"},
      {mime_regex = ".*", command = "xdg-open {}"}
    }
  },
}

xplr.config.general.show_hidden = true

local kb = xplr.config.modes.builtin.default.key_bindings
kb.on_key["i"] = kb.on_key["up"]
kb.on_key["j"] = kb.on_key["left"]
kb.on_key["k"] = kb.on_key["down"]
kb.on_key["l"] = kb.on_key["right"]

local key = xplr.config.modes.builtin.default.key_bindings.on_key
key.v = {
  help = "nuke",
  messages = {"PopMode", {SwitchModeCustom = "nuke"}}
}
key["f3"] = xplr.config.modes.custom.nuke.key_bindings.on_key.v
key["enter"] = xplr.config.modes.custom.nuke.key_bindings.on_key.o
