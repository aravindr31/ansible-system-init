local fn = vim.fn
local autocmd = vim.api.nvim_create_autocmd
local autogrp = vim.api.nvim_create_autogrp
--lsp.diagnostics.globals : ["vim"]

autocmd("BufWritePre", {
	pattern = "*",
	callback = function(args)
		require("conform").format({ bufnr = args.buf })
	end,
})

--autocmd("ModeChanged", {
--callback = function()
--if fn.getcmdtype() == "/" or fn.getcmdtype() == "?" then
--vim.opt.hlsearch = true
--else
--vim.opt.hlsearch = false
--end
--end,
--group = general,
--desc = "Highlighting matched words when searching",
--})
