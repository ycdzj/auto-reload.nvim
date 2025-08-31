local config = require('auto-reload.config')
local cooldown = require('auto-reload.cooldown')
local watcher = require('auto-reload.watcher')

local M = {}

---@param opts AutoReloadConfig
function M.setup(opts)
  config.update(opts or {})
end

return M
