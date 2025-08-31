---@class AutoReloadReloadConfig
---@field cooldown_ms integer

---@class AutoReloadPollConfig
---@field enable boolean
---@field interval_ms integer

---@class AutoReloadConfig
---@field enable boolean
---@field reload AutoReloadReloadConfig
---@field poll AutoReloadPollConfig

---@type AutoReloadConfig
local config = {
  -- Whether this plugin is enabled by default.
  enable = true,
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

---@param new_config AutoReloadConfig|table
---@return nil
function M.update(new_config)
  local merged_config = vim.tbl_deep_extend('force', config, new_config)
  if merged_config.reload.cooldown_ms < 0 then
    error('reload.cooldown_ms must be non-negative')
  end
  if merged_config.poll.interval_ms < 1000 then
    error('poll.interval_ms must be at least 1000')
  end
  config = merged_config
end

---@return AutoReloadConfig
function M.get()
  return config
end

return M
