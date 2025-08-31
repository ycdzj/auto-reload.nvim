local watcher = require('auto-reload.watcher')

vim.api.nvim_create_user_command('AutoReloadStatus', function()
  local watched_files = watcher.list_watched_files()
  if #watched_files == 0 then
    vim.notify('No files are currently being watched', vim.log.levels.INFO)
    return
  end

  local message = 'Currently watching ' .. #watched_files .. ' file(s):\n'
  for _, filename in ipairs(watched_files) do
    message = message .. '  ' .. filename .. '\n'
  end
  vim.notify(message, vim.log.levels.INFO)
end, {
  desc = 'List all files currently being watched by auto-reload',
})
