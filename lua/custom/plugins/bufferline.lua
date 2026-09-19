-- Display open buffers as tabs across the top of the editor.
-- https://github.com/akinsho/bufferline.nvim
return {
  'akinsho/bufferline.nvim',
  event = 'VeryLazy',
  dependencies = { 'nvim-tree/nvim-web-devicons' },
  config = function()
    require('bufferline').setup {
      options = {
        mode = 'buffers',
        numbers = 'ordinal', -- show 1, 2, 3 … so <leader><n> jumps make sense
        diagnostics = 'nvim_lsp', -- show LSP error/warn counts on each tab
        always_show_bufferline = true,
        separator_style = 'thin', -- plain '│', safe without a Nerd Font
        -- No Nerd Font (vim.g.have_nerd_font = false), so keep it text-only:
        show_buffer_icons = false,
        show_buffer_close_icons = false,
        show_close_icon = false,
      },
    }

    -- Cycle through buffers (LazyVim convention; no clash with the jumplist).
    vim.keymap.set('n', '<S-l>', '<cmd>BufferLineCycleNext<CR>', { desc = 'Next buffer' })
    vim.keymap.set('n', '<S-h>', '<cmd>BufferLineCyclePrev<CR>', { desc = 'Prev buffer' })

    -- Buffer management under the <leader>b prefix.
    vim.keymap.set('n', '<leader>bd', '<cmd>bdelete<CR>', { desc = '[B]uffer [D]elete' })
    vim.keymap.set('n', '<leader>bp', '<cmd>BufferLineTogglePin<CR>', { desc = '[B]uffer [P]in' })

    -- Jump straight to a buffer by its ordinal number.
    for i = 1, 9 do
      vim.keymap.set('n', '<leader>' .. i, function()
        require('bufferline').go_to(i, true)
      end, { desc = 'Go to buffer ' .. i })
    end

    -- Make a bare `:q` close only the current buffer, while `:q!` (and `:wq`,
    -- `:qa`, …) keep their built-in behaviour. We inspect the whole command
    -- line on <CR> so `q` and `q!` are cleanly distinguished. Note: to force
    -- close a single modified buffer, use `:bd!`.
    vim.keymap.set('c', '<CR>', function()
      if vim.fn.getcmdtype() == ':' and vim.fn.getcmdline() == 'q' then
        return '<C-u>bd<CR>'
      end
      return '<CR>'
    end, { expr = true, desc = ':q closes current buffer' })
  end,
}
