# colors are nice
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias fgrep='fgrep --color=auto'
alias egrep='egrep --color=auto'

# ls should be sane
alias ll='ls -l'
alias la='ls -A'
alias lla='ls -lA'
alias l='ls -CF'

NUM_CORES=$(cat /proc/cpuinfo | grep -c processor)
alias make="make -j$NUM_CORES -l$NUM_CORES"
alias clmake='make CC=clang-3.8 CXX=clang++-3.8 LD=clang++-3.8'

# thefuck
eval $(thefuck --alias)

# sensible clear
alias rclear='echo -e -n "\e[3J"'
alias clr='clear && rclear'

# make less slightly nicer
[ -x /usr/bin/lesspipe ] && eval "$(SHELL=/bin/sh lesspipe)"

