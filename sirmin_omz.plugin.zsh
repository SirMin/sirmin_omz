for file in "${0:A:h}/components/"*.plugin.zsh; do
  source "$file"
done