require('nvim-stuff.second-issue-fix')

vim.api.nvim_create_autocmd({ 'TermRequest' }, {
    desc = 'Handles OSC 7 dir change requests',
    callback = function(ev)
        local pwd, n = string.gsub(ev.data.sequence, '\027]7;file://[^/]*', '')
        if n <= 0 then return end
        if vim.fn.isdirectory(pwd) == 0 then return end
        if vim.api.nvim_get_current_buf() ~= ev.buf then return end
        vim.cmd.cd(pwd)
    end
})
