local config = require('auto-reload.config')
local cooldown = require('auto-reload.cooldown')
local watcher = require('auto-reload.watcher')

---@param filename string
local function checktime(filename)
  local cooldown_ms = config.get().reload.cooldown_ms
  cooldown.call(filename, cooldown_ms, function()
    vim.cmd('checktime ' .. filename)
  end)
end

---@param bufnr integer
local function handle_load(bufnr)
  local buftype = vim.api.nvim_get_option_value('buftype', { buf = bufnr })
  if buftype ~= '' then
    return
  end

  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == '' then
    return
  end

  local ok = watcher.watch_file(filename, checktime)
  if not ok then
    vim.notify('Failed to watch file: ' .. filename, vim.log.levels.ERROR)
  end
end

---@param bufnr integer
local function handle_unload(bufnr)
  local filename = vim.api.nvim_buf_get_name(bufnr)
  if filename == '' then
    return
  end
  local ok = watcher.unwatch_file(filename)
  if not ok then
    vim.notify('Failed to unwatch file: ' .. filename, vim.log.levels.ERROR)
  end
end

vim.api.nvim_create_autocmd({ 'BufReadPost', 'BufWritePost' }, {
  callback = function(args)
    handle_load(args.buf)
  end,
  desc = 'Start watching file when buffer is loaded or written',
})

vim.api.nvim_create_autocmd({ 'BufUnload', 'BufFilePre' }, {
  callback = function(args)
    handle_unload(args.buf)
  end,
  desc = 'Stop watching file when buffer is unloaded',
})

vim.api.nvim_create_autocmd('FileChangedShellPost', {
  callback = function(event)
    vim.notify('"' .. event.file .. '" changed on disk. Buffer reloaded.', vim.log.levels.INFO)
  end,
})
