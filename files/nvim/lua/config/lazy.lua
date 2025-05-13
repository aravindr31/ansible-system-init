local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo(
			{ { "Failed to clone lazy.nvim:\n", "ErrorMsg" }, { out, "WarningMsg" }, { "\nPress any key to exit..." } },
			true,
			{}
		)
		vim.fn.getchar()
		os.exit(1)
	end
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "

require("lazy").setup({
	"tpope/vim-surround", -- Surrounding ()
	"ap/vim-css-color", -- CSS Color Preview,
	"rafi/awesome-vim-colorschemes", -- Retro Scheme,
	"tc50cal/vim-terminal", -- Vim Terminal,
	"mbbill/undotree", -- undotree,
	{ "stevearc/conform.nvim", opt = {} },
	"nvim-lua/plenary.nvim",
	{
		"nvim-telescope/telescope.nvim",
		tag = "0.1.8",
	},
	{
		"folke/tokyonight.nvim",
		branch = "main",
	}, -- Color scheme,
	"ctrlpvim/ctrlp.vim", -- CtrlP,
	"preservim/nerdcommenter", -- commenter,
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			{
				"mason-org/mason.nvim",
				opts = {},
			},
			"mason-org/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{
				"j-hui/fidget.nvim",
				opts = {},
			},
			"saghen/blink.cmp",
		},
		config = function()
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("kickstart-lsp-attach", {
					clear = true,
				}),
				callback = function(event)
					local map = function(keys, func, desc, mode)
						mode = mode or "n"
						vim.keymap.set(mode, keys, func, {
							buffer = event.buf,
							desc = "LSP: " .. desc,
						})
					end

					-- Rename the variable under your cursor.
					--  Most Language Servers support renaming across files, etc.
					map("grn", vim.lsp.buf.rename, "[R]e[n]ame")

					-- Execute a code action, usually your cursor needs to be on top of an error
					-- or a suggestion from your LSP for this to activate.
					map("gra", vim.lsp.buf.code_action, "[G]oto Code [A]ction", { "n", "x" })

					-- Find references for the word under your cursor.
					map("grr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")

					-- Jump to the implementation of the word under your cursor.
					--  Useful when your language has ways of declaring types without an actual implementation.
					map("gri", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")

					-- Jump to the definition of the word under your cursor.
					--  This is where a variable was first declared, or where a function is defined, etc.
					--  To jump back, press <C-t>.
					map("grd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")

					-- WARN: This is not Goto Definition, this is Goto Declaration.
					--  For example, in C this would take you to the header.
					map("grD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

					-- Fuzzy find all the symbols in your current document.
					--  Symbols are things like variables, functions, types, etc.
					map("gO", require("telescope.builtin").lsp_document_symbols, "Open Document Symbols")

					-- Fuzzy find all the symbols in your current workspace.
					--  Similar to document symbols, except searches over your entire project.
					map("gW", require("telescope.builtin").lsp_dynamic_workspace_symbols, "Open Workspace Symbols")

					-- Jump to the type of the word under your cursor.
					--  Useful when you're not sure what type a variable is and you want to see
					--  the definition of its *type*, not where it was *defined*.
					map("grt", require("telescope.builtin").lsp_type_definitions, "[G]oto [T]ype Definition")

					-- This function resolves a difference between neovim nightly (version 0.11) and stable (version 0.10)
					---@param client vim.lsp.Client
					---@param method vim.lsp.protocol.Method
					---@param bufnr? integer some lsp support methods only in specific files
					---@return boolean
					local function client_supports_method(client, method, bufnr)
						if vim.fn.has("nvim-0.11") == 1 then
							return client:supports_method(method, bufnr)
						else
							return client.supports_method(method, {
								bufnr = bufnr,
							})
						end
					end

					local client = vim.lsp.get_client_by_id(event.data.client_id)
					if
						client
						and client_supports_method(
							client,
							vim.lsp.protocol.Methods.textDocument_documentHighlight,
							event.buf
						)
					then
						local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", {
							clear = false,
						})
						vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.document_highlight,
						})

						vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
							buffer = event.buf,
							group = highlight_augroup,
							callback = vim.lsp.buf.clear_references,
						})

						vim.api.nvim_create_autocmd("LspDetach", {
							group = vim.api.nvim_create_augroup("kickstart-lsp-detach", {
								clear = true,
							}),
							callback = function(event2)
								vim.lsp.buf.clear_references()
								vim.api.nvim_clear_autocmds({
									group = "kickstart-lsp-highlight",
									buffer = event2.buf,
								})
							end,
						})
					end

					if
						client
						and client_supports_method(client, vim.lsp.protocol.Methods.textDocument_inlayHint, event.buf)
					then
						map("<leader>th", function()
							vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({
								bufnr = event.buf,
							}))
						end, "[T]oggle Inlay [H]ints")
					end
				end,
			})

			vim.diagnostic.config({
				severity_sort = true,
				float = {
					border = "rounded",
					source = "if_many",
				},
				underline = {
					severity = vim.diagnostic.severity.ERROR,
				},
				signs = vim.g.have_nerd_font and {
					text = {
						[vim.diagnostic.severity.ERROR] = "󰅚 ",
						[vim.diagnostic.severity.WARN] = "󰀪 ",
						[vim.diagnostic.severity.INFO] = "󰋽 ",
						[vim.diagnostic.severity.HINT] = "󰌶 ",
					},
				} or {},
				virtual_text = {
					source = "if_many",
					spacing = 2,
					format = function(diagnostic)
						local diagnostic_message = {
							[vim.diagnostic.severity.ERROR] = diagnostic.message,
							[vim.diagnostic.severity.WARN] = diagnostic.message,
							[vim.diagnostic.severity.INFO] = diagnostic.message,
							[vim.diagnostic.severity.HINT] = diagnostic.message,
						}
						return diagnostic_message[diagnostic.severity]
					end,
				},
			})

			local capabilities = require("blink.cmp").get_lsp_capabilities()

			local servers = {

				lua_ls = {

					settings = {
						Lua = {
							completion = {
								callSnippet = "Replace",
							},
						},
					},
				},
			}

			local ensure_installed = vim.tbl_keys(servers or {})
			vim.list_extend(ensure_installed, {
				"stylua", -- Used to format Lua code
			})
			require("mason-tool-installer").setup({
				ensure_installed = ensure_installed,
			})

			require("mason-lspconfig").setup({
				ensure_installed = {}, -- explicitly set to an empty table (Kickstart populates installs via mason-tool-installer)
				automatic_installation = false,
				handlers = {
					function(server_name)
						local server = servers[server_name] or {}

						server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
						require("lspconfig")[server_name].setup(server)
					end,
				},
			})
		end,
	},
	"mattn/emmet-vim",
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
	},
	{
		"pearofducks/ansible-vim",
		build = "./UltiSnips/generate.sh",
	},
	"rebelot/kanagawa.nvim",
	"jiangmiao/auto-pairs",
	"lukas-reineke/indent-blankline.nvim",
	"tpope/vim-fugitive",
	"lewis6991/gitsigns.nvim",
	"kdheepak/lazygit.nvim",
	"junegunn/fzf.vim",
	{
		"akinsho/toggleterm.nvim",
		tag = "*",
	},
	{
		"uZer/pywal16.nvim",
		as = "pywal16",
	},
	"nvim-lualine/lualine.nvim",
	"nvim-tree/nvim-web-devicons",
	"nvim-tree/nvim-tree.lua",
	{
		"stevearc/oil.nvim",
		---@module 'oil'
		---@type oil.SetupOpts
		opts = {},

		dependencies = { "nvim-tree/nvim-web-devicons" },
		use_deault_keymaps = false,
		view_options = {
			show_hidden = true,
			highlight_filename = function(entry, is_hidden, is_link_target, is_link_orphan)
				return nil
			end,
		},
		keymaps = {
			["g?"] = {
				"actions.show_help",
				mode = "n",
			},
			["<CR>"] = "actions.select",
			["<C-s>"] = {
				"actions.select",
				opts = {
					vertical = true,
				},
			},
			["<C-h>"] = {
				"actions.select",
				opts = {
					horizontal = true,
				},
			},
			["<C-t>"] = {
				"actions.select",
				opts = {
					tab = true,
				},
			},
			["<C-p>"] = "actions.preview",
			["<C-c>"] = {
				"actions.close",
				mode = "n",
			},
			["<C-l>"] = "actions.refresh",
			["["] = {
				"actions.parent",
				mode = "n",
			},
			["{"] = {
				"actions.open_cwd",
				mode = "n",
			},
			["]"] = {
				"actions.cd",
				mode = "n",
			},
			["}"] = {
				"actions.cd",
				opts = {
					scope = "tab",
				},
				mode = "n",
			},
			["gs"] = {
				"actions.change_sort",
				mode = "n",
			},
			["fx"] = "actions.open_external",
			["f."] = {
				"actions.toggle_hidden",
				mode = "n",
			},
			["f\\"] = {
				"actions.toggle_trash",
				mode = "n",
			},
		},

		lazy = false,
	},
})
