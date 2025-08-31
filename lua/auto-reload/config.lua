---@class AutoReloadReloadOptions
---@field cooldown_ms integer

---@class AutoReloadPollOptions
---@field enable boolean
---@field interval_ms integer

---@class AutoReloadOptions
---@field reload AutoReloadReloadOptions
---@field poll AutoReloadPollOptions

---@type AutoReloadOptions
local opts = {
  reload = {
    -- Milliseconds between reloads. Set to 0 to reload immediately on every file change.
    cooldown_ms = 100,
  },
  poll = {
    -- If watch fails, the plugin will fall back to polling.
    -- If polling is disabled, the plugin will do nothing if watch fails.
    enable = true,
    -- Milliseconds between polling attempts. It must be at least 1000.
    interval_ms = 5000,
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
  if merged_opts.poll.interval_ms < 1000 then
    error('poll.interval_ms must be at least 1000')
  end
  opts = merged_opts
end

---@return AutoReloadOptions
function M.get()
  return opts
end

return M
