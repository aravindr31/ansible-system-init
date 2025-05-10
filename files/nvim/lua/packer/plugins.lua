local fn = vim.fn

-- Automatically install packer
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  PACKER_BOOTSTRAP = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  print("Installing packer close and reopen Neovim...")
end

-- Autocommand that reloads neovim whenever you save the plugins.lua file
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerSync
  augroup end
]])

-- Use a protected call so we don't error out on first use
local status_ok, packer = pcall(require, "packer")
if not status_ok then
  return
end

-- Have packer use a popup window
packer.init({
    display = {
      open_fn = function()
        return require('packer.util').float({ border = 'single' })
      end
    }
  }
)

return require('packer').startup(function(use)
    use 'wbthomason/packer.nvim'
    use 'tpope/vim-surround' -- Surrounding ()
    use 'ap/vim-css-color' -- CSS Color Preview
    use 'rafi/awesome-vim-colorschemes' -- Retro Scheme
    use 'tc50cal/vim-terminal' -- Vim Terminal
    use 'neovim/nvim-lspconfig' --neovim lsp
    use 'mbbill/undotree' -- undotree
    use 'nvim-lua/plenary.nvim' 
    use {'nvim-telescope/telescope.nvim', tag = '0.1.8' }
    use {'folke/tokyonight.nvim',  branch = 'main' } -- Color scheme
    use 'ctrlpvim/ctrlp.vim' --CtrlP
    use 'preservim/nerdcommenter' --commenter
    use {'neoclide/coc.nvim', branch =  'release'} --coc nvim
    use 'mattn/emmet-vim' 
    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate' }
    use {'pearofducks/ansible-vim', run = './UltiSnips/generate.sh' } 
    use 'rebelot/kanagawa.nvim'
    use 'jiangmiao/auto-pairs'
    use 'lukas-reineke/indent-blankline.nvim'
    use 'tpope/vim-fugitive'
    use 'lewis6991/gitsigns.nvim'
    use 'kdheepak/lazygit.nvim'
    use 'junegunn/fzf.vim'
    use {'akinsho/toggleterm.nvim',tag = '*'}
    use {'uZer/pywal16.nvim', as= 'pywal16' }
    use 'nvim-lualine/lualine.nvim'
    use 'nvim-tree/nvim-web-devicons'
    use 'nvim-tree/nvim-tree.lua'

    if PACKER_BOOTSTRAP then
      require('packer').sync()
    end
end)