# ======== GLOBALS ========
export SERVER_IP=`hostname -I` # for browser sync
export JAVA_HOME=/etc/alternatives/jre_1.8.0_openjdk
if command -v most > /dev/null 2>&1; then
    export PAGER="most"
fi
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOROOT="/usr/lib/golang"
export PATH="$HOME/.luarocks/bin:/usr/lib64/ccache:/usr/local/bin:/usr/bin:/bin:/usr/local/sbin:/usr/sbin:$HOME/.local/bin:$HOME/bin:$GOBIN:$HOME/.cargo/bin:$HOME/.config/lua-lsp/bin"
export EDITOR=/usr/bin/vim
export VIEWER=/usr/bin/less
export PAGER=/usr/bin/less
export VIM="$HOME/.config/nvim"

# ======== ALIASES ========
alias python=python3
alias pip=pip3
alias cal='cal -m'
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'
alias l.='ls -d .* --color=auto'
alias vim=nvim
alias vi=nvim

# ==== HTTP server
function serve() {
    ip=$2
    if [[ -z "$ip" ]]; then
        ip="127.0.0.1"
    fi
    python3 -m http.server -d "./$1" -b "$ip"
}

# ======== TMUX ========
[ -z "$TMUX" ] && export TERM=xterm-256color

# ======== USEFUL ========
# Shortcut to download mp3 from youtube.
yt2mp3() {
	# youtube-dl --extract-audio --audio-format mp3 $1
	yt-dlp --extract-audio --audio-format mp3 $1
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
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
