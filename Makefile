
.PHONY: nvim
nvim:
	nix develop .\#nvim

.PHONY: osc7
osc7:
	nix develop .\#nvim-osc7

.PHONY: tmux
tmux:
	nix develop .\#tmux
