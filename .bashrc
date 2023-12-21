# ======== GLOBALS ========
export SERVER_IP=`hostname -I` # for browser sync
export JAVA_HOME=/etc/alternatives/jre_1.8.0_openjdk
export LUA_PATH='/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;/usr/lib64/lua/5.4/?.lua;/usr/lib64/lua/5.4/?/init.lua;./?.lua;./?/init.lua;/home/xdkn1ght/.luarocks/share/lua/5.4/?.lua;/home/xdkn1ght/.luarocks/share/lua/5.4/?/init.lua'
export LUA_CPATH='/usr/lib64/lua/5.4/?.so;/usr/lib64/lua/5.4/loadall.so;./?.so;/home/xdkn1ght/.luarocks/lib64/lua/5.4/?.so'
if command -v most > /dev/null 2>&1; then
    export PAGER="most"
fi
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOROOT="/usr/lib/golang"
export PATH="/home/xdkn1ght/.luarocks/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:$HOME/.local/bin:$HOME/bin:$GOBIN"
export VIM="$HOME/.config/nvim"
export LYNX_CFG="$HOME/lab/dotfiles/lynx.cfg"
AUGUSTUS_CONFIG_PATH="$HOME/games/augustus/config"

# ======== ALIASES ========
alias python=python3
alias pip=pip3
alias resres="xrandr --output eDP-1 --mode 1920x1080"
alias tmux="TERM=xterm-256color tmux"
alias cal='cal -m'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias l.='ls -d .* --color=auto'
alias serve="browser-sync $1"
alias vim=nvim
alias vi=nvim

# ======== COSMETICS ========
[ -n "$XTERM_VERSION" ] && transset-df -a 0.98 --id "$WINDOWID" >/dev/null
[ -z "$TMUX" ] && export TERM=xterm-256color

# ======== USEFUL ========
# Shortcut to download mp3 from youtube.
yt2mp3() {
	youtube-dl --extract-audio --audio-format mp3 $1
}

# No ttyctl, so we need to save and then restore terminal settings.
# Diabled stopping interpretation of terminal for Vim
# vim() {
# 	# osx users, use stty -g
# 	local STTYOPTS="$(stty --save)"
# 	stty stop '' -ixoff
# 	command vimx "$@"
# 	stty "$STTYOPTS"
# }

# TODO: write a program?
colors() {
	for i in {0..255}; do
		printf "\x1b[38;5;${i}mcolor${i} "
	done
	echo
}

clear_node_modules() {
	find . -name 'node_modules' -type d -prune -exec rm -rf '{}' +
}

stopfirewall() {
	echo "Stopping firewall service"
	sudo systemctl stop firewalld.service
	echo "Stopped firewall! You are at security risk!"
}

# Set title of Xterm
tlt() {
    local title=$1
    if [ -z "$title" ]; then
        title="@XTerm"
    fi
    echo -ne "\033]0;${title}\007"
}

# CPU load in percent
cpuld() {
	top -bn1 | grep "Cpu(s)" | \
        sed "s/.*, *\([0-9.]*\)%* id.*/\1/" | \
		awk '{printf 100 - $1 "%"}'
}

# Node and webdev realted stuff.

# pnpm
export PNPM_HOME="/home/xdkn1ght/.local/share/pnpm"
case ":$PATH:" in
  *":$PNPM_HOME:"*) ;;
  *) export PATH="$PNPM_HOME:$PATH" ;;
esac
# pnpm end


export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

# Load Angular CLI autocompletion.
source <(ng completion script)


# Load Angular CLI autocompletion.
source <(ng completion script)
