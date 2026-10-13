-- Make Neo-tree (and other file managers) rename/move files *through the LSP*,
-- so that imports/references in other files get updated automatically.
--
-- This listens to Neo-tree's file operation events and sends
-- `workspace/willRenameFiles` to any attached language server that supports it.
-- The server must advertise the capability -- see `default_capabilities()` which
-- is merged into the LSP capabilities in init.lua.
return {
  'antosha417/nvim-lsp-file-operations',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-neo-tree/neo-tree.nvim',
  },
  config = function()
    require('lsp-file-operations').setup()
  end,
}
