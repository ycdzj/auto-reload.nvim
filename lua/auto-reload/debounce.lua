---@type table<string, uv.uv_timer_t>
local pending_timers = {}

local M = {}

--- Debounces a callback function. If called multiple times with the same key within the debounce
--- period, only the last callback will be executed after the debounce delay.
--- @param key string
--- @param debounce_ms integer
--- @param callback fun():nil
--- @return nil
function M.call(key, debounce_ms, callback)
  if pending_timers[key] then
    pending_timers[key]:close()
  end

  pending_timers[key] = vim.defer_fn(function()
    pending_timers[key] = nil
    callback()
  end, debounce_ms)
end

return M
