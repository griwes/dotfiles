# Bashrc SSH-tmux wrapper | Spencer Tipping
# Licensed under the terms of the MIT source code license
# See https://github.com/spencertipping/bashrc-tmux for details.

# modified to also do the same for local sessions

if [[ -z "$TMUX" ]] && which tmux >& /dev/null && [[ `tty` =~ /dev/pts/[0-9]+ ]]
then
    export TERM=screen-256color

    if ! tmux ls -F '#{session_name}' | grep "^ssh-$USER$" > /dev/null
    then
        tmux new-session -s tmux-$USER \; detach
    fi

    # Allocating a session ID: always just bump the counter. Because of
    # differences between bash and zsh, working with arrays to densely pack
    # session IDs is cumbersome.

    session_max=$(tmux ls -F '#{session_name}' \
        | egrep "^tmux-$USER-[0-9]+$" \
        | sed "s/^tmux-$USER-//" \
        | sort -rn \
        | head -n1)
    session_index=$((${session_max:--1} + 1))

    exec tmux new-session -s tmux-$USER-$session_index -t tmux-$USER
fi

