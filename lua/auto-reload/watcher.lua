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
    if not M.unwatch_file(filename) then
      return false
    end
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

  local result = handle:start(filename, {}, vim.schedule_wrap(process_events))
  if result ~= 0 then
    handle:close()
    return false
  end

  handles[filename] = handle
  return true
end

--- Stops watching a file
---@param filename string
---@return boolean
function M.unwatch_file(filename)
  filename = vim.fs.abspath(filename)
  local handle = handles[filename]
  if handle then
    if not handle:stop() then
      return false
    end
    handle:close()
    handles[filename] = nil
  end
  return true
end

--- Lists all currently watched files
---@return string[]
function M.list_watched_files()
  local watched_files = vim.tbl_keys(handles)
  table.sort(watched_files)
  return watched_files
end

return M
