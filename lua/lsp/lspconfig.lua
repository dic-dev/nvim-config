capabilities = vim.lsp.protocol.make_client_capabilities()
require('mason').setup()
require('mason-lspconfig').setup({
  ensure_installed = {
    'intelephense',
    'ts_ls',
    'tailwindcss',
    'emmet_ls',
    'gopls'
  },
})

-- require('lspconfig').intelephense.setup({
--   -- Looks like root_dir has to be a function that takes the filename and returns the root.
--   -- This function I made searches up the filepath for each option in turn,
--   -- so if you have a .thisIsDocRoot somewhere in the hierarchy this is used in preference
--   -- to a deeper .git, for example.
--   root_dir = function(startPath)
--     local rp = (require 'lspconfig.util').root_pattern
--     for _, pattern in pairs({ ".thisIsDocRoot", "index.php", ".git", "node_modules",
--       "index.php",
--       "composer.json" }) do
--       local found = rp({ pattern })(startPath)
--       -- print(pattern, found)
--       if (found and found ~= '') then return found end
--     end
--     return nil
--   end,
--   settings = {
--     editor = {
--       tabSize = 2,
--       -- spaces not tabs
--       insertSpaces = true,
--       -- the detection is annoying, but this line doesn't seem to stop it.
--       detectIndentation = false,
--     },
--     -- https://github.com/bmewburn/intelephense-docs/blob/master/installation.md
--     intelephense = {
--       files = { associations = { "*.php", "*.module", "*.inc" } },
--       format = { braces = "k&r" }, -- alternative values: psr12 or allman

--       diagnostics = {
--         undefinedTypes = false,
--         undefinedMethods = false,
--       },
--     },
--   }
-- })
require('lspconfig').ts_ls.setup({})
require('lspconfig').tailwindcss.setup({})
require('lspconfig').emmet_ls.setup({})
require('lspconfig').gopls.setup({})

local null_ls = require('null-ls')
null_ls.setup({
  sources = {
    -- null_ls.builtins.formatting.black, -- python formatter
    -- null_ls.builtins.formatting.isort, -- python import sort
    -- null_ls.builtins.diagnostics.flake8, -- python linter
    -- null_ls.builtins.formatting.stylua, -- lua formatter
    -- null_ls.builtins.diagnostics.luacheck, -- lua linter
  },
})
