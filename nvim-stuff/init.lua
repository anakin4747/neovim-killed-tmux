
vim.o.scrollback = 1000000
vim.o.shell = "zsh"

vim.keymap.set('t', '<esc><esc>', '<C-\\><C-n>')

-- I also recommend the following autocmds so that when you switch between
-- several terminal buffers that the :cd follows along
vim.api.nvim_create_autocmd({ 'BufEnter', 'TermEnter', 'TermLeave' }, {
    desc = 'cd to terminal cwd on enter',
    pattern = 'term://*',
    callback = function()
        local cwd = vim.fn.resolve('/proc/' .. vim.b.terminal_job_pid .. '/cwd')
        if vim.fn.isdirectory(cwd) == 0 then return end
        vim.fn.chdir(cwd)
    end,
})
