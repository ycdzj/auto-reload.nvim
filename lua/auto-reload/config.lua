---@class AutoReloadReloadOptions
---@field cooldown_ms integer

---@class AutoReloadOptions
---@field reload AutoReloadReloadOptions

---@type AutoReloadOptions
local opts = {
  reload = {
    -- Milliseconds between reloads. Set to 0 to reload immediately on every file change.
    cooldown_ms = 100,
  },
}

local M = {}

---@param new_opts AutoReloadOptions|table
---@return nil
function M.update(new_opts)
  local merged_opts = vim.tbl_deep_extend('force', opts, new_opts)
  if merged_opts.reload.cooldown_ms < 0 then
    error('reload.cooldown_ms must be non-negative')
  end
  opts = merged_opts
end

---@return AutoReloadOptions
function M.get()
  return opts
end

return M
