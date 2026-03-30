
cd() {
    builtin cd "$@" || return
    [[ -S "$NVIM" ]] || return
    # nohup is used to avoid the job number being displayed from the &
    nohup nvim --server "$NVIM" --remote-expr "chdir('$PWD')" > /dev/null 2>&1
}
