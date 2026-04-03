
# NEOVIM KILLED TMUX

# WHY TMUX + NVIM KINDA SUCKS

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

# MAKING NEOVIM A GOOD MULTIPLEXER

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

# RUNNING THE DEMOS

Each demo environment is defined as a flavor in `.cqfdrc`. The flavors use
[cqfd](https://github.com/savoirfairelinux/cqfd) (included as a git submodule
at `scripts/cqfd/`) to spin up an Arch Linux Docker container with the
appropriate config files mounted in.

## Setup

Initialize the cqfd submodule:

```sh
git submodule update --init
```

Build the Docker image:

```sh
./scripts/cqfd/cqfd init
```

## Flavors

Each flavor in `.cqfdrc` corresponds to a stage in the demo. Run any of them
with `make <flavor>` or `./scripts/cqfd/cqfd -b <flavor>`:

| Flavor | What it shows |
|---|---|
| `tmux` | Baseline tmux setup — demonstrates its limitations |
| `nvim-first-issue` | Raw `nvim +terminal` with no fixes applied |
| `nvim-second-issue` | Escape keybind fixed (`first-issue-fix.lua`) |
| `nvim-third-issue` | Escape + cwd sync via `--server` (`second-issue-fix.lua` + `server-bashrc`) |
| `nvim-fourth-issue` | Above + nested nvim prevention (`v` script) |
| `full` | Full solution: server-based cwd sync, bash, `v-attach` for sessions |
| `osc7` | Full solution using OSC 7 for cwd sync instead of `--server` |
| `zsh` | Full server-based solution using zsh |
| `osc7-zsh` | Full OSC 7 solution using zsh |

`make` with no arguments runs the `full` flavor.

## How `.cqfdrc` defines the environments

`.cqfdrc` is an INI-style config file read by `cqfd`. Each section (other than
`[project]`) is a named flavor. Two keys control each environment:

- **`command`** — the process launched inside the container (e.g. `bash`,
  `zsh`, `nvim +terminal`, `tmux -f /tmux.conf`)
- **`docker_run_args`** — extra arguments passed to `docker run`, used here
  exclusively to bind-mount local config files into the container at the exact
  paths where the shell or Neovim will look for them

For example, the `osc7-zsh` flavor:

```ini
[osc7-zsh]
command="zsh"
docker_run_args=" \
    --volume=./nvim-stuff/osc7-zsh.lua:/home/$USER/.config/nvim/init.lua \
    --volume=./nvim-stuff/v-attach:/usr/local/bin/v \
    --volume=./zsh-stuff/osc7-zshrc:/home/$USER/.zshrc \
"
```

This launches `zsh` in a container with:
- `osc7-zsh.lua` mounted as the Neovim init file
- `v-attach` mounted as the `v` command
- `osc7-zshrc` mounted as the zsh rc file

To add or modify a demo environment, edit `.cqfdrc`.

## Recommended Neovim settings for terminal buffers

It can be useful to set these in your init file:

```lua
vim.opt.shell = "/bin/zsh"        -- or whatever your shell is
vim.opt.scrollback = 1000000      -- max scrollback (default 10000)
vim.opt.path = ".,**"             -- gf searches recursively if file isn't in pwd
```

`scrollback` (`scbk`) controls how many lines are kept beyond the visible
screen in a terminal buffer before lines at the top are discarded. The default
is 10000; the maximum is 1000000.

`path` is the list of directories searched by `gf` (and `:find`). The default
only includes the current file's directory and the working directory. Setting
it to `.,**` adds a recursive wildcard so `gf` will search recursively in your
current working directory.
