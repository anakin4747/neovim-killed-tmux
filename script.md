
# NEOVIM KILLED TMUX

```vim
nnoremap <PageDown> zM/{{{<cr>zozt<C-y>
nnoremap <PageUp> zM?{{{<cr>zozt<C-y>
set scrolloff=0
```

# <!-- {{{ -->  INTRO

   If you are a Neovim + Tmux user, after this video you won't be using Tmux
   anymore. This video actually really applies to any terminal multiplexer. So
   if you are using Neovim with terminator, Zellij or whatever.

   Neovim does everything terminal multiplexers can do and more.

   For hardcore terminal users, hardcore Neovim users, its a pretty common
   practice to use a terminal multiplexer like tmux to complement Neovim.

<!-- }}} -->

# <!-- {{{ -->    WHY TMUX + NVIM KINDA SUCKS

   And I had done this for years using Tmux + Neovim

   But it always kinda ate away at me how annoying it was to have to configure
   both neovim and tmux to get them to kind of work in sync.

   You had to install this plugin twice just to get tmux and Neovim to try to
   play nice but it always felt very hacky to me.
   https://github.com/christoomey/vim-tmux-navigator.git

   Back when I used this plugin I even took it a step further and rewrote the
   plugin to do the same for my window manager AwesomeWM too:
   https://github.com/anakin4747/vim-tmux-nav-lua

   And this just kinda sucked, I felt like I had to spend forever changing all
   my tmux keymaps to act as vimlike as possible.

   So I have this tmux config here that tries to get you as close as possible
   to vimlike but its still so limited because its tmux

   issues:
   - even with vi mode still missing so much:
     - no visual mode support only line and block
     - no text object support
     - no gf or gx
     - no <C-o> or <C-i>
     - no zt or zb
   - needs a tmux plugin and a vim plugin just to get windows to act similar
   - duplicated window management

    ./tmux-stuff/tmux.conf

<!-- }}} -->

# <!-- {{{ -->    MAKING NEOVIM A GOOD MULTIPLEXER

   Neovim is a much better terminal multiplexer than tmux because Neovim is
   already integrated Neovim.

   I won't lie Neovim is a bit of a pain to configure as well but the benefits
   it brings makes it well worth it in my opinion.

   So of course we have to start with `:terminal` (see :h :terminal).

   It spawns a terminal in a Neovim buffer. If you are based on Neovim nightly
   then you can get the nice most recent default options for the terminal
   buffers.

   So there are some issues that need to be solved with making `:terminal` user
   friendly:

  First issue:

   The default keybind to exit terminal mode (which is equivalent to entering
   copy mode in tmux) is fairly annoying to remember is `<C-b><C-\>`.

   So I always remap it to <esc><esc> but just be aware that this will cause
   you to wait for 'timeoutlen' when you just want to press a single <esc> in
   terminal mode (like when interacting with CLI tools like lazygit). This is
   an acceptable trade-off in my opinion:

    ./nvim-stuff/init.lua:5

  Second issue:

   Vim also has a pwd (see :h :pwd) which is no longer in sync if you change
   directories. When you have multiple terminal buffers you'll want an autocmd
   so that Vim's pwd always matches the terminal buffer you are in. This only
   works on Linux because it relies on procfs:

    ./nvim-stuff/init.lua:9

   There are a two solutions to this, osc7 and using `--server`. Both solutions
   need require shell configure. I have a nix develop shell for both. For the
   `--server` option you can run the following command:

   ```sh
   nix develop .\#nvim
   ```

   Add these snippets to your shell's rc file to use this solution:

   ```sh
   # zshrc
   chpwd() {
       [[ -S "$NVIM" ]] || return
       nohup nvim --server "$NVIM" --remote-expr "chdir('$PWD')" > /dev/null 2>&1
   }
   ```
   ```sh
   # bashrc
   cd() {
       builtin cd "$@"
       [[ -S "$NVIM" ]] || return
       nohup nvim --server "$NVIM" --remote-expr "chdir('$PWD')" > /dev/null 2>&1
   }
   ```

   For the osc7 solution you can run the associated devShell:

   ```sh
   nix develop .\#nvim-osc7
   ```

   This solution needs an extra snippet of Neovim config:

       ./nvim-stuff/osc7.lua

   Add these snippets to your shell's rc file to use this solution:

   ```sh
   # zshrc
   chpwd() {
       printf '\033]7;file://%s\033\\' "$PWD"
   }
   ```

   ```sh
   # bashrc
   cd() {
       builtin cd "$@"
       printf '\033]7;file://%s\033\\' "$PWD"
   }
   ```

  Third issue: Nested Neovim

   When I first switched to using `:terminal` this issue led me to try and
   train myself to avoid opening files from the CLI. Which was actually pretty
   beneficial. I became more reliant on `:edit` and `gf` for opening files.
   But I could never kick the habit of running the `nvim` cli.

  Fourth issue: Sessions

   People also heavily use tmux for session management.

   To solve both Third and Fourth issue I wrote my own script called `v` which
   allows me to use `nvim` from the CLI and use Neovim's server as a way to
   implement tmux-like sessions.

    ./scripts/v

   issues:
   - how to escape
   - syncing pwd
   - nested nvim
   - sessions

    ./nvim-stuff/init.lua + ./nvim-stuff/v + shell config

   benefits:
   - terminals can be treated exactly the same as files
   - full vim motion support in terminals
     - visual mode support
     - text object support
     - <C-o> and <C-i>
     - zt and zb
   - gf makes a file tree obsolete

   - gx makes a command launcher obsolete
   - tmux-like session management

   downside:
   - requires a bit of configuration

<!-- }}} -->

```neovim_messages
defaults.lua: Did not detect DSR response from terminal. This results in a slower startup time.
"flake.nix" 56L, 1789B written
"flake.nix" 56L, 1789B written
E384: Search hit TOP without match for: {{{
5 lines yanked
"script.md" 192L, 5642B written
"script.md" 192L, 5644B written
"README.md" 50L, 1111B written
"script.md" 193L, 5706B written
"script.md" 193L, 5706B written
Decoration provider "range" (ns=nvim.treesitter.highlighter):
Lua: ...rapped-7a8d316/share/nvim/runtime/lua/vim/treesitter.lua:223: Index out of bounds
stack traceback:
	[C]: in function 'nvim_buf_get_text'
	...rapped-7a8d316/share/nvim/runtime/lua/vim/treesitter.lua:223: in function 'get_node_text'
	...-7a8d316/share/nvim/runtime/lua/vim/treesitter/query.lua:554: in function 'handler'
	...-7a8d316/share/nvim/runtime/lua/vim/treesitter/query.lua:878: in function '_match_predicates'
	...-7a8d316/share/nvim/runtime/lua/vim/treesitter/query.lua:1016: in function 'iter'
	...16/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:402: in function 'fn'
	...16/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:245: in function 'for_each_highlight_state'
	...16/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:361: in function <...16/share/nvim/runtime/lua/vim/treesitter/highlighter.lua:335>
```
