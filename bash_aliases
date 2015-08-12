alias c='cd /cygdrive/c/'

alias upgrade="ansible -m command -a 'pacman -Syu --noconfirm' --sudo -K all"

alias json="python -m json.tool | less"
alias xml="xmllint -format - | less"

