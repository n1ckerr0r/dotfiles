# Interactive zsh configuration loaded through ZDOTDIR=~/.config/zsh.
autoload -Uz colors
colors

autoload -Uz vcs_info

if command -v go >/dev/null 2>&1; then
  export PATH="$(go env GOPATH)/bin:$PATH"
fi

setopt auto_cd
setopt interactive_comments
setopt hist_ignore_all_dups
setopt hist_reduce_blanks
setopt prompt_subst
setopt share_history

HISTFILE="${XDG_STATE_HOME:-$HOME/.local/state}/zsh/history"
HISTSIZE=10000
SAVEHIST=10000
mkdir -p "${HISTFILE:h}" 2>/dev/null

autoload -Uz compinit
ZSH_COMPDUMP="${XDG_CACHE_HOME:-$HOME/.cache}/zsh/zcompdump"
mkdir -p "${ZSH_COMPDUMP:h}" 2>/dev/null
compinit -d "$ZSH_COMPDUMP"
zstyle ':completion:*' menu select

bindkey -e
WORDCHARS=''
bindkey '^H' backward-char
bindkey '^L' forward-char
bindkey '^[h' backward-word
bindkey '^[b' backward-word
bindkey '^[f' forward-word
bindkey '^[[1;3D' backward-word
bindkey '^[[1;3C' forward-word
bindkey '^W' backward-kill-word
bindkey '^[^?' backward-kill-word
bindkey '^[d' kill-word

alias ll='ls -la'
alias la='ls -A'
alias l='ls -CF'
alias ..='cd ..'
alias ...='cd ../..'
alias c='clear'
alias hs='history | grep'
alias grep='grep --color=auto'
alias proj='cd /home/n1ckerr0r/maindir/projects/'
alias educ='cd /home/n1ckerr0r/maindir/education/'
alias test='cd /tmp/test/'
alias itmo='cd /home/n1ckerr0r/maindir/itmo/'
alias work='cd /home/n1ckerr0r/maindir/work'
alias v='adguardvpn-cli connect -f'
alias vd='adguardvpn-cli disconnect'

alias nvimconf='cd /home/n1ckerr0r/.config/nvim/ && code . &'
alias cdnvim='cd /home/n1ckerr0r/.config/nvim/'
alias obsidianconf='cd /home/n1ckerr0r/obsidian-storage/ && code . &'
alias cdobsidian='cd /home/n1ckerr0r/obsidian-storage/'
alias nixconf='cd /home/n1ckerr0r/nixos-config && code . &'
alias cdnix='cd /home/n1ckerr0r/nixos-config'
alias nixcheck='nixos-rebuild dry-build --flake /home/n1ckerr0r/nixos-config#laptop'
alias nixrebuild='sudo nixos-rebuild switch --flake /home/n1ckerr0r/nixos-config#laptop'
alias nixtest='sudo nixos-rebuild test --flake /home/n1ckerr0r/nixos-config#laptop'
alias nixup='cd /home/n1ckerr0r/nixos-config && nix flake update'
alias nixfmtconf='cd /home/n1ckerr0r/nixos-config && nix fmt'
alias nixgc='sudo nix-collect-garbage --delete-older-than 7d'

alias npminstall='npm install typescript --save-dev'
alias open='xdg-open'
alias nvim-tui='command nvim'
alias nvim='neovide'
alias qwen='ollama run qwen3.5:4b-q4_K_M'

clipimg() {
  local image_dir="${XDG_CACHE_HOME:-$HOME/.cache}/codex-images"
  local image_path="$image_dir/clipboard-$(date +%Y%m%d-%H%M%S).png"

  mkdir -p "$image_dir" || return 1

  if command -v wl-paste >/dev/null 2>&1; then
    wl-paste --type image/png >"$image_path" || {
      rm -f "$image_path"
      echo "No PNG image in Wayland clipboard" >&2
      return 1
    }
  elif command -v xclip >/dev/null 2>&1; then
    xclip -selection clipboard -target image/png -out >"$image_path" || {
      rm -f "$image_path"
      echo "No PNG image in X11 clipboard" >&2
      return 1
    }
  else
    echo "Install wl-clipboard or xclip first" >&2
    return 1
  fi

  if [[ ! -s "$image_path" ]]; then
    rm -f "$image_path"
    echo "Clipboard does not contain an image" >&2
    return 1
  fi

  print -r -- "$image_path"
}

codeximg() {
  local image_path
  image_path="$(clipimg)" || return 1

  if (( $# )); then
    codex --image "$image_path" "$@"
  else
    codex --image "$image_path"
  fi
}

csvpretty() {
  if [[ $# -ne 1 ]]; then
    echo "Usage: csvpretty <file.csv>" >&2
    return 1
  fi

  if ! command -v mlr >/dev/null 2>&1; then
    echo "miller (mlr) is not installed" >&2
    return 1
  fi

  mlr --icsv --opprint cat "$1"
}

alias -s png='xdg-open'
alias -s jpg='xdg-open'
alias -s jpeg='xdg-open'
alias -s webp='xdg-open'
alias -s gif='xdg-open'
alias -s svg='xdg-open'
alias -s pdf='xdg-open'

source_first_readable() {
  local plugin_path
  for plugin_path in "$@"; do
    if [[ -n "$plugin_path" && -r "$plugin_path" ]]; then
      source "$plugin_path"
      return 0
    fi
  done
  return 1
}

source_first_readable \
  "${ZSH_AUTOSUGGESTIONS:-}" \
  "$HOME/.nix-profile/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/etc/profiles/per-user/$USER/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  "/run/current-system/sw/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh" \
  /nix/store/*-zsh-autosuggestions-*/share/zsh/plugins/zsh-autosuggestions/zsh-autosuggestions.zsh(N)

source_first_readable \
  "${ZSH_SYNTAX_HIGHLIGHTING:-}" \
  "$HOME/.nix-profile/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/etc/profiles/per-user/$USER/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  "/run/current-system/sw/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" \
  /nix/store/*-zsh-syntax-highlighting-*/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh(N)

zstyle ':vcs_info:git:*' formats ' %F{magenta}(%b)%f'
zstyle ':vcs_info:git:*' actionformats ' %F{magenta}(%b|%a)%f'

precmd() {
  vcs_info
}

PROMPT='%F{cyan}╭─%f %F{green}%~%f${vcs_info_msg_0_}
%F{cyan}╰─❯%f '
