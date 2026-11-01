export ZDOTDIR="$HOME/.config/zsh"

path=(
  "$HOME/.local/bin"
  ${path:#"$HOME/.local/bin"}
)
export PATH
