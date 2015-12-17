# tmux is not my favorite software when it comes to configuration file management
# no way to source a relative file
# by the way probably also no way to determine the actual path to tmux.conf
# and no way to wildcard-source multiple configuration files (what is this madness?)
#
# also for the sake of your own sanity, don't check tmux' source code

BITS := $(shell find ./rc -name "*.conf" | sort --version-sort)

tmux.conf: $(BITS)
	cat $(BITS) > $@

