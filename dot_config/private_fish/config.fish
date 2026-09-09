starship init fish | source

if status is-interactive
    alias v='nvim'

    # Shortcuts
    alias cl='clear'
    alias ..='cd ..'
    alias ...='cd ../..'
    alias ....='cd ../../..'

    # ls
    alias l='eza -la' # eza is a modern ls replacement
    alias ll='eza -l'
    alias la='eza -a'
    alias lt='eza --tree'

    # git
    alias g='git'
    alias gs='git status'
    alias gd='git diff'
    alias ga='git add'
    alias gc='git commit'
    alias gp='git push'
    alias gl='git log --oneline --graph'
    alias gco='git checkout'
    alias gb='git branch'

    # safety
    alias rm='rm -i'
    alias cp='cp -i'
    alias mv='mv -i'

    # misc
    alias cat='bat'
    alias df='df -h'
    alias du='du -h'
    alias mkdir='mkdir -p'

    # apps
    alias y='yazi'
    alias oc='opencode'
end

# Zoxide (smarter cd)
zoxide init fish | source

# Tmux Sessionizer Binding (Ctrl+F)
function fish_user_key_bindings
    bind \cf 'tmux-sessionizer; commandline -f repaint'
end

fish_add_path ~/.local/bin
fish_add_path ~/go/bin


# Added by Antigravity CLI installer
set -gx PATH "/home/ani/.local/bin" $PATH
