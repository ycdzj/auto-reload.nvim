---@type table<string, fun():nil>
local pending_functions = {}

---@param key string
---@param cooldown_ms integer
---@return nil
local function schedule(key, cooldown_ms)
  local callback = function()
    local fn = pending_functions[key]
    pending_functions[key] = nil
    fn()
  end
  vim.defer_fn(callback, cooldown_ms)
end

local M = {}

--- Executes a callback and cool down for cooldown_ms. If the previous cooldown of the same key
--- hasn't finished, the callback will be scheduled to run after the previous cooldown.
--- If there's already a pending callback for the same key, it will be replaced with the new one.
--- @param key string
--- @param cooldown_ms integer
--- @param callback fun():nil
--- @return nil
function M.call(key, cooldown_ms, callback)
  if cooldown_ms == 0 then
    callback()
    return
  end

  local fn = function()
    callback()
    pending_functions[key] = function() end
    schedule(key, cooldown_ms)
  end

  if not pending_functions[key] then
    fn()
  else
    pending_functions[key] = fn
  end
end

return M
