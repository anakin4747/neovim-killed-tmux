{
  description = "Dev shell with neovim-nightly and tmux";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    neovim-nightly-overlay.url = "github:nix-community/neovim-nightly-overlay";
  };

  outputs = { self, nixpkgs, neovim-nightly-overlay }:
    let
      system = "x86_64-linux";
      pkgs = import nixpkgs { inherit system; };
      nvim-nightly = neovim-nightly-overlay.packages.${system}.default;
      buildInputs = [ nvim-nightly pkgs.tmux pkgs.lsof ];
    in
    {
      devShells.${system} = {
        nvim = pkgs.mkShell {
          inherit buildInputs;
          shellHook = ''
            export SHELL=/run/current-system/sw/bin/bash
            #--8<---bashrc---------
            cd() {
                builtin cd "$@"
                [[ -S "$NVIM" ]] || return
                nohup nvim --server "$NVIM" --remote-expr "chdir('$PWD')" > /dev/null 2>&1
            }
            #--8<------------------
            export -f cd # only needed because of nix
            exec nvim -u nvim-stuff/init.lua +terminal
          '';
        };
        nvim-osc7 = pkgs.mkShell {
          inherit buildInputs;
          shellHook = ''
            export SHELL=/run/current-system/sw/bin/bash
            #--8<---bashrc---------
            cd() {
                builtin cd "$@"
                printf '\033]7;file://%s\033\\' "$PWD"
            }
            #--8<------------------
            export -f cd # only needed because of nix
            exec nvim -u nvim-stuff/osc7.lua +terminal
          '';
        };
        tmux = pkgs.mkShell {
          inherit buildInputs;
          shellHook = ''
            export SHELL=/run/current-system/sw/bin/bash
            exec tmux -f tmux-stuff/tmux.conf
          '';
        };
      };
    };
}
