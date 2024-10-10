local augroup = vim.api.nvim_create_augroup
local aucmd = vim.api.nvim_create_autocmd

aucmd({'BufEnter', 'BufWinEnter'}, {
  callback = function()
    if vim.bo.filetype == 'php' then
      vim.bo.indentexpr = ''
      vim.bo.shiftwidth = 4
      vim.bo.tabstop = 4
      vim.bo.expandtab = true
      vim.bo.autoindent = true
      vim.bo.smartindent = true
    else
      -- vim.bo.indentexpr = ''
      vim.bo.shiftwidth = 2
      vim.bo.tabstop = 2
      vim.bo.expandtab = true
      vim.bo.autoindent = true
      vim.bo.smartindent = true
    end
  end,
})

--カーソル位置の保存設定をLua化したもの。
vim.api.nvim_create_autocmd({ 'BufReadPost' }, {
  pattern = { '*' },
  callback = function()
      vim.api.nvim_exec('silent! normal! g`"zv', false)
  end,
})
