require("nvim-treesitter.configs").setup {
  ensure_installed = {
    "typescript",
    "javascript",
    "php",
    "go",
    "lua",
    "bash",
    "html",
    "css",
    "vue",
    "vim",
    "yaml",
    "toml",
    "ini",
    "json",
    "dockerfile",
    "markdown",
    "diff",
    -- "gitconfig",
    "gitignore"
  },
  highlight = {
    enable = true,
  },
  indent = {
    enable = false, -- disable builtin indent module
  },
  autotag = {
    enable = true,
  }
}
