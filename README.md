
# NEOVIM KILLED TMUX

# <!-- {{{ -->  WHY TMUX + NVIM KINDA SUCKS

   issues:
   - even with vi mode still missing so much:
     - no visual mode support only line and block
     - no text object support
     - no gf or gx
     - no <C-o> or <C-i>
     - no zt or zb
     - no yanking or pasting from registers
     - no macros
   - needs a tmux plugin and a vim plugin just to get windows to act similar
   - duplicated window management

    ./tmux-stuff/tmux.conf

<!-- }}} -->

# <!-- {{{ -->    MAKING NEOVIM A GOOD MULTIPLEXER

   issues:
   - how to escape
   - syncing pwd
   - nested nvim
   - sessions

    ./nvim-stuff/init.lua + ./nvim-stuff/v + shell config

   benefits:
   - terminals can be treated exactly the same as files
   - full vim motion support in terminals
   - gf makes a file tree obsolete
   - gx makes a command launcher obsolete
   - tmux-like session management

   downside:
   - requires a bit of configuration

<!-- }}} -->


<!--
    vim: nonumber:norelativenumber:nohlsearch:foldmethod=marker:noruler:laststatus=0
-->
