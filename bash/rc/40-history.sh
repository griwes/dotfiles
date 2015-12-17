# ignore duplicate lines and lines starting with space
HISTCONTROL=ignoreboth

# append history instead of overwriting
shopt -s histappend

# size of history and history file
HISTSIZE=1024
HISTFILESIZE=2048

# save everything in ~/.bash_eternal_history
PROMPT_COMMAND="history -a; ${PROMPT_COMMAND:+$PROMPT_COMMAND ; }"'echo $$ $USER \
    $(HISTTIMEFORMAT="%s " history 1) >> ~/.bash_eternal_history'

