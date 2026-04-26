-- ── Bootstrap lazy.nvim ─────────────────────────────────────────────────────
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- ── Plugins ──────────────────────────────────────────────────────────────────
require("lazy").setup({
  -- Catppuccin theme
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },

  -- File tree
  { "nvim-tree/nvim-tree.lua", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Status line
  { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

  -- Syntax highlighting
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- Fuzzy finder
  { "nvim-telescope/telescope.nvim", dependencies = { "nvim-lua/plenary.nvim" } },

  -- Auto pairs
  { "windwp/nvim-autopairs", event = "InsertEnter" },

  -- Git signs in gutter
  { "lewis6991/gitsigns.nvim" },
})

-- ── Theme ────────────────────────────────────────────────────────────────────
require("catppuccin").setup({ flavour = "frappe" })
vim.cmd.colorscheme "catppuccin"

-- ── Options ──────────────────────────────────────────────────────────────────
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.termguicolors = true
vim.opt.scrolloff = 8
vim.opt.wrap = false
vim.opt.cursorline = true

-- ── Keybinds ─────────────────────────────────────────────────────────────────
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>")
vim.keymap.set("n", "<leader>ff", ":Telescope find_files<CR>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<CR>")

-- ── Plugin Setup ─────────────────────────────────────────────────────────────
require("nvim-tree").setup()
require("lualine").setup({ options = { theme = "catppuccin-frappe" } })
require("nvim-autopairs").setup()
require("gitsigns").setup()
