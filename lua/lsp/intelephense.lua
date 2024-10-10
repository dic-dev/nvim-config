vim.api.nvim_create_autocmd('FileType', {
  pattern = 'php',
  callback = function()
    vim.lsp.start({
      name = 'intelephense',
      capabilities = vim.lsp.protocol.make_client_capabilities(),
      settings = {
        intelephense = {
          diagnostics = {
            undefinedClassConstants = false,
            undefinedConstants = false,
            undefinedFunctions = false,
            undefinedMethods = false,
            undefinedProperties = false,
            undefinedTypes = false,
          },
        },
      },
      init_options = {
          globalStoragePath = os.getenv('HOME') .. '/.local/share/intelephense'
      },
      cmd = {'intelephense', '--stdio'},
    })
  end,
})
