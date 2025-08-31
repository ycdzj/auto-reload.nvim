local config = require('auto-reload.config')

local M = {}

---@param opts AutoReloadOptions
function M.setup(opts)
  config.update(opts or {})
  require('auto-reload.buffers')
  require('auto-reload.commands')
  vim.opt.autoread = true
end

return M
