# ======== GLOBALS ========
export SERVER_IP=`hostname -I` # for browser sync
export JAVA_HOME=/etc/alternatives/jre_1.8.0_openjdk
export LUA_PATH="/usr/share/lua/5.4/?.lua;/usr/share/lua/5.4/?/init.lua;/usr/lib64/lua/5.4/?.lua;/usr/lib64/lua/5.4/?/init.lua;./?.lua;./?/init.lua;/home/xdkn1ght/.luarocks/share/lua/5.4/?.lua;/home/xdkn1ght/.luarocks/share/lua/5.4/?/init.lua;/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua"
export LUA_CPATH="/usr/lib64/lua/5.4/?.so;/usr/lib64/lua/5.4/loadall.so;./?.so;/home/xdkn1ght/.luarocks/lib64/lua/5.4/?.so;/usr/local/share/lua/5.4/?.lua;/usr/local/share/lua/5.4/?/init.lua"
if command -v most > /dev/null 2>&1; then
    export PAGER="most"
fi
export GOPATH="$HOME/go"
export GOBIN="$GOPATH/bin"
export GOROOT="/usr/lib/golang"
export PATH="\
:/usr/lib64/ccache\
:/usr/local/bin\
:/usr/bin\
:/bin\
:/usr/local/sbin\
:/usr/sbin\
:$HOME/.local/bin\
:$HOME/bin\
:$HOME/.cargo/bin\
:$HOME/.luarocks/bin\
:$HOME/.config/lua-lsp/bin\
:$GOBIN\
:/opt/gradle/gradle-9.3.1/bin"

export EDITOR=/usr/bin/vim
export VIEWER=/usr/bin/less
export PAGER=/usr/bin/less
export PLAYDATE_SDK_PATH="$HOME/Apps/PlaydateSDK"
export PLAYDATE_LUACATS_PATH="$HOME/.config/playdate-luacats"
export PATH="$HOME/.config/lua-lsp/bin:$PATH"
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
yt2mp3() {
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
