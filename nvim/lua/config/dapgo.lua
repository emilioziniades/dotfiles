local dapgo = require("dap-go")

dapgo.setup()

-- todo: only do this for .go files with an autocmd
vim.keymap.set("n", "<leader>dt", dapgo.debug_test)
