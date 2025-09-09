-- telescope
vim.keymap.set("n", "<leader>fs", ":Telescope find_files<cr>")
vim.keymap.set("n", "<leader>fp", ":Telescope git_files<cr>")
vim.keymap.set("n", "<leader>fg", ":Telescope live_grep<cr>")
vim.keymap.set("n", "<leader>fo", ":Telescopmaplfiles<cr>")

--tree
vim.keymap.set("n", "<leader>e", ":NvimTreeFindFileToggle<cr>")

--markdown
vim.keymap.set("n", "<leader>mp", ":MarkdownPreviewToggle<cr>")
vim.keymap.set("n", "<leader>ms", ":MarkdownPreviewStop<cr>")

-- comment
vim.keymap.set({"n", "v"}, "<leader>/", ":CommentToggle<cr>")


-- harper
vim.keymap.set('n', '<leader>hf', ':lua vim.diagnostic.open_float()<CR>') -- Open diagnostic float
vim.keymap.set('n', '<leader>hl', ':lua vim.diagnostic.setloclist()<CR>') -- Populate location list with diagnostics
vim.keymap.set('n', '<leader>ha', ':lua vim.lsp.buf.code_action()<CR>' )


-- gitsigns
vim.keymap.set('n', '<leader>gp', ':Gitsigns preview_hunk<CR>' )
vim.keymap.set('n', '<leader>gl', ':Gitsigns preview_hunk_inline<CR>' )
vim.keymap.set('n', '<leader>gr', ':Gitsigns reset_hunk<CR>' )


--twilight
vim.keymap.set('n', '<leader>te', ':TwilightEnable<CR>' )
vim.keymap.set('n', '<leader>td', ':TwilightDisable<CR>' )
