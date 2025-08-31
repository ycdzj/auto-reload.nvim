# auto-reload.nvim

Auto reload neovim buffers on external changes.

This plugin automatically watches loaded buffers for file system changes and
reloads them when they are modified externally.

## Installation

### [lazy.nvim](https://github.com/folke/lazy.nvim)

```lua
{
  'ycdzj/auto-reload.nvim',
  opts = {}
}
```

### [vim-plug](https://github.com/junegunn/vim-plug)

```vim
Plug 'ycdzj/auto-reload.nvim'
```

Then in your `init.lua`:

```lua
require('auto-reload').setup({})
```

## Configuration

It's required to call the `setup` function before using the plugin.

### Default Configuration

Options not specified when calling `setup` will use the following defaults:

```lua
{
  reload = {
    -- Milliseconds between reloads. Set to 0 to reload immediately on every file change.
    cooldown_ms = 100,
  },
}
```

## Commands

- `:AutoReloadStatus` - Display the current status of the plugin.

## How It Works

The plugin uses `vim.uv` (libuv) to watch file system events efficiently. It
automatically:

1. Starts watching files when buffers are loaded or written
1. Stops watching files when buffers are unloaded
1. Runs `:checktime` when watched files change (with cooldown protection)

## License

See [LICENSE](LICENSE) file.
