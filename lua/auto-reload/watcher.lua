---@type table<string, uv.uv_fs_event_t>
local handles = {}

local M = {}

--- Watches a file for changes
---@param filename string
---@param callback fun(filename: string, events: uv.fs_event_start.callback.events): nil
---@return boolean
function M.watch_file(filename, callback)
  filename = vim.fs.abspath(filename)
  if handles[filename] then
    return false
  end

  local handle = vim.uv.new_fs_event()
  if handle == nil then
    return false
  end

  local process_events = function(err, _, events)
    if err then
      vim.notify('Error watching file: ' .. filename .. ' - ' .. err, vim.log.levels.ERROR)
      return
    end
    callback(filename, events)
  end

  local result = handle:start(filename, {}, process_events)
  if result ~= 0 then
    handle:close()
    return false
  end

  table.insert(handles, handle)
  return true
end

--- Stops watching a file
---@param filename string
---@return boolean
function M.unwatch_file(filename)
  filename = vim.fs.abspath(filename)
  if not handles[filename] then
    return false
  end
  handles[filename]:close()
  handles[filename] = nil
  return true
end

return M
