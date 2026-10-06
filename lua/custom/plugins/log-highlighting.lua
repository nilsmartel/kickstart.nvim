-- Syntax highlighting for .log files (log levels, timestamps, IPs, etc.).
-- https://github.com/MTDL9/vim-log-highlighting
--
-- Pure Vim syntax plugin: no dependencies, no build step, no LSP. It does not
-- clash with Treesitter since there is no `log` Treesitter parser.
return {
  'MTDL9/vim-log-highlighting',
  ft = 'log',
  init = function()
    -- Teach Neovim to recognise log files so lazy's `ft = 'log'` actually
    -- triggers. This runs at startup (cheap); the syntax plugin itself only
    -- loads once a log buffer is opened.
    vim.filetype.add {
      extension = { log = 'log' },
      pattern = {
        ['.*%.log%.%d+'] = 'log', -- rotated logs, e.g. app.log.1
      },
    }
  end,
}
