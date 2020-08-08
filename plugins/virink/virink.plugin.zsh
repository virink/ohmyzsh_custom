############################
# ENV or PATH
############################
. $ZSH_CUSTOM/z.sh

if [ -f "$ZSH_CUSTOM/config.sh" ]; then
    . $ZSH_CUSTOM/config.sh
fi

if [ -f "${HOME}/.gpg-agent-info" ]; then
    . "${HOME}/.gpg-agent-info"
    export GPG_AGENT_INFO
fi
export GPG_TTY=$(tty)

# SSH Agent
if [ -f "${HOME}/.ssh/.agent" ]; then
    source ${HOME}/.ssh/.agent
fi
ps -p $SSH_AGENT_PID > /dev/null
if [ $? -ne 0 ]; then
    eval $(ssh-agent -s) > /dev/null
    echo "export SSH_AUTH_SOCK=$SSH_AUTH_SOCK" > ${HOME}/.ssh/.agent
    echo "export SSH_AGENT_PID=$SSH_AGENT_PID" >> ${HOME}/.ssh/.agent  
fi
# export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Homebrew
# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
export HOMEBREW_NO_AUTO_UPDATE=true
# Android
export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"
# Electron
export ELECTRON_MIRROR=http://npm.taobao.org/mirrors/electron/
# JAVA_HOME
# jdk8
export JAVA_HOME=/Library/Java/Home
# jdk14
# export JAVA_HOME="/usr/local/opt/java/libexec/openjdk.jdk/Contents/Home"
export JRE_HOME=$JAVA_HOME/jre
export CLASSPAHT=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar
# Tomcat
export TOMCAT_HOME=/usr/local/opt/tomcat@8/libexec
export CATALINA_HOME=$TOMCAT_HOME
# RUST
export RUSTUP_DIST_SERVER=http://mirrors.ustc.edu.cn/rust-static
export RUSTUP_UPDATE_ROOT=http://mirrors.ustc.edu.cn/rust-static/rustup
# GO
export GOARCH=amd64
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="/usr/local/src/go"
export GOROOT_BOOTSTRAP=GOROOT
export GO111MODULE=on
export GOPROXY=https://goproxy.cn,https://goproxy.io,direct
# export CSC_IDENTITY_AUTO_DISCOVERY=false
# FLUTTER
# export PUB_HOSTED_URL=https://pub.flutter-io.cn
# export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export PUB_HOSTED_URL=https://mirrors.tuna.tsinghua.edu.cn/dart-pub/
export FLUTTER_STORAGE_BASE_URL=https://mirrors.tuna.tsinghua.edu.cn/flutter
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES
export ENABLE_FLUTTER_DESKTOP=true

#set env for pwntools
export TERM=xterm-256color
export TERMINFO=/etc/terminfo
# xray
export XRAY_LCIENSE_PATH=/opt/xray

############################
# Env Path
############################
# Java
export PATH=${JAVA_HOME}/bin:$PATH
# flutter
export PATH=/usr/local/flutter/bin:${PATH}
# Android
export PATH=${ANDROID_SDK_ROOT}/tools:${ANDROID_SDK_ROOT}/platform-tools:${PATH}
# Golang
export PATH=${GOROOT}/bin:${GOPATH}/bin:${PATH}

# gnubin
# export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"

# intratools
export INTRA_SESSION=vvvkkk


############################
# Custom Function
############################
function command_not_found_handler(){
    [[ -n $DEBUG ]] && echo "[D] Command: $@"
    if { which vcommand > /dev/null } {
        $(which vcommand) $@
    } else {
        echo "[!] zsh: command not found: $0"
    }
}

function pipupgrade(){
    if [[ -n $VIRTUAL_ENV ]]; then
        echo "Upgrade pip packages this virtual"
        pip freeze --local | grep -v '^-e' | cut -d = -f 1  | xargs -n1 pip install -U
    else
        echo "Upgrade pip packages (python3)"
        python3 -m pip freeze --local | grep -v '^-e' | cut -d = -f 1  | xargs -n1 python3 -m pip install -U
        echo "Upgrade pip packages (python2)"
        python2 -m pip freeze --local | grep -v '^-e' | cut -d = -f 1  | xargs -n1 python2 -m pip install -U
    fi
}

function sshl(){
    local n=$1
    if [[ -z "$n" ]]; then
        cat ~/.ssh/config | grep -A 2 "Host "
    else
        cat ~/.ssh/config | grep -A 2 "Host $n"
    fi
}

function acmehelp(){
    local domain="$1"
    if [ -d "~/.acme.sh/acme.sh" ]; then
        echo "acme.sh --issue -d \"$domain\" --dns dns_ali"
        echo "acme.sh --install-cert -d \"$domain\" --key-file \"/etc/nginx/certs/$domain.key\" --fullchain-file \"/etc/nginx/certs/$domain.pem\" --reloadcmd \"service nginx restart\""
    fi
}

function pac(){
    local pacfile="~/.vproxy/pac/user-rules.txt"
    if [ ! -f $pacfile ]; then
        eval touch $pacfile
    fi
    genpac --pac-proxy "SOCKS5 127.0.0.1:1080; SOCKS 127.0.0.1:1080;DIRECT;" \
        --gfwlist-proxy="SOCKS5 127.0.0.1:1080" \
        --gfwlist-url="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt" \
        --gfwlist-local "~/.vproxy/pac/gfwlist.txt" \
        --gfwlist-update-local \
        --user-rule-from="~/.vproxy/pac/user-rules.txt" \
        --output="~/.vproxy/proxy.pac"
}

function proxy(){
    if [[ "$1" = "t" ]]; then
        local url=""
        if [[ "$2" = "" ]]; then
            url="https://www.google.com"
        else
            url="$2"
        fi
        dd if=/dev/urandom of=/tmp/testbin bs=1024 count=1024 2>/dev/null >/dev/null
        data=$(curl -x "http://127.0.0.1:1086" -o /dev/null -k -s -w '%{time_namelookup} %{time_connect} %{time_starttransfer} %{time_total} %{speed_upload} %{speed_download}' -F file=@/tmp/testbin $url)
        rm -f /tmp/testbin
        dwi=0
        dw=("b/s" "kb/s" "mb/s" "gb/s")
        a1=$(echo $data | awk '{print $1}' )
        a2=$(echo $data | awk '{print $2}' )
        a3=$(echo $data | awk '{print $3}' )
        a4=$(echo $data | awk '{print $4}' )
        a5=$(echo $data | awk '{print $5}' )
        a6=$(echo $data | awk '{print $6}' )
        while [[ $a5 -ge 1024.0 ]];
        do
            let dwi=dwi+1
            a5=`echo "sclae=2; $a5/1024.0" | bc`
        done
        while [[ $a6 -ge 1024.0 ]];
        do
            let dwi=dwi+1
            a6=`echo "sclae=2; $a6/1024.0" | bc`
        done
        echo "\t===== Speed Test ====="
        printf "\t%10s : %-2.2f s\n" "DNS" $a1
        printf "\t%10s : %-2.2f s\n" "Connect" $a2
        printf "\t%10s : %-2.2f s\n" "Transfer" $a3
        printf "\t%10s : %-2.2f s\n" "Total" $a4
        printf "\t%10s : %-2.2f %4s\n" "Upload" $a5 ${dw[dwi]}
        printf "\t%10s : %-2.2f %4s\n" "Download" $a6 ${dw[dwi]}
        echo "\t======================"
    elif [[ "$1" = "c" && -n $2 ]]; then
        _dir="/usr/local/etc/v2ray"
        stat $_dir/$2.json >/dev/null 2>&1
        if [[ -n $? ]]; then
            rm $_dir/config.json
            ln -s $_dir/$2.json $_dir/config.json
            brew services restart v2ray-core
        fi
    elif [[ "$1" = "l" ]]; then
        ls -al /usr/local/etc/v2ray/*.json
    else
        echo -e "t\ttest\nc\tchange\nl\tlist\n"
    fi
    return $?
}

function v2log(){
    local cmd=$1
    if [[ $cmd == "clear" ]]; then
        echo -n "" > /opt/log/v2ray/access.log
        echo -n "" > /opt/log/v2ray/error.log
    fi
    tail -f /opt/log/v2ray/*.log
}

function rand(){
    min=$1
    if [ -z $min  ];then
        min=6
    fi
    max=$(($2-$min+1))
    num=$(cat /dev/urandom | head -n 10 | cksum | awk -F ' ' '{print $1}')
    echo $(($num%$max+$min))
}

function flushdns(){
    sudo killall -HUP mDNSResponder
    sudo dscacheutil -flushcache
}

function clearpjt(){
    echo "Deleting .DS_Store ..."
    find `pwd` -name ".DS_Store" -delete
    echo "Deleting *.pyc ..."
    find `pwd` -name "*.pyc" -delete
    echo "Deleting __pycache__ ..."
    find `pwd` -type d -name "__pycache__" -exec rm -rf {} \;
    echo "Deleting __MACOSX ..."
    find `pwd` -type d -name "__MACOSX" -exec rm -rf {} \;
    echo "Successfully"
}

function clearnpm(){
    echo "Deleting node_modules ..."
    find `pwd` -type d -name "node_modules" -exec rm -rf {} \;
    echo "Successfully"
}

function filenum(){
    echo "There are `ls -lR|grep "^-"|wc -l` files in `pwd`"
}

# show my ip
function myip(){
    if [[ ! -n $1 ]]; then
        curl myip.ipip.net
    else
        curl -vv myip.ipip.net
    fi
}

# Socks5 Proxy
function ss() {
    local proxy=$1
    if [[ -n "$proxy" ]]; then
        echo "Set ALL_PROXY=$proxy"
        export ALL_PROXY="$proxy"
    elif [ ! -n "$ALL_PROXY" ]; then
        echo "Set ALL_PROXY=http://127.0.0.1:1086"
        export ALL_PROXY=http://127.0.0.1:1086
    else
        echo "Unset ALL_PROXY"
        unset ALL_PROXY
    fi
}

# OfficeThinner
function clearoffice(){
    sudo bash -c "curl -s https://raw.githubusercontent.com/goodbest/OfficeThinner/master/OfficeThinner.sh | bash"
}

# dex2jar
function dex2jar (){
    ~/Program/dex2jar21/d2j-dex2jar.sh "$@"
}

# DiffMerge
function diffmerge() {
    exec /Applications/DiffMerge.app/Contents/MacOS/DiffMerge --nosplash  "$@"
}

function icns(){
    local pngName=$1
    local output=$2
    if [[ -n $pngName ]]; then
        mkdir $output.iconset
        sips -z 16 16     $pngName --out "$output".iconset/icon_16x16.png
        sips -z 32 32     $pngName --out "$output".iconset/icon_16x16@2x.png
        sips -z 32 32     $pngName --out "$output".iconset/icon_32x32.png
        sips -z 64 64     $pngName --out "$output".iconset/icon_32x32@2x.png
        sips -z 128 128   $pngName --out "$output".iconset/icon_128x128.png
        sips -z 256 256   $pngName --out "$output".iconset/icon_128x128@2x.png
        sips -z 256 256   $pngName --out "$output".iconset/icon_256x256.png
        sips -z 512 512   $pngName --out "$output".iconset/icon_256x256@2x.png
        # sips -z 512 512   pic.png --out tmp.iconset/icon_512x512.png
        # sips -z 1024 1024   pic.png --out tmp.iconset/icon_512x512@2x.png
        iconutil -c icns $output.iconset -o $output.icns
        rm -rf $output.iconset
    fi
}
newvkrc(){
    echo "export VKRC_COMMAND_LIST=(" > .vkrc
    echo ")" >> .vkrc
    echo "" >> .vkrc
    echo "reset_vkrc(){" >> .vkrc
    echo "    unfunction reset_vkrc" >> .vkrc
    echo "}" >> .vkrc
}
vkrcmod(){
    # .vkrc
    # FIXME: 子目录跳回上级目录
    if [[ -e .vkrc ]]; then
        export CURRENT_RC_PWD=$PWD
        showcmd(){
            # FIXME: not found $VKRC_COMMAND_LIST in loading
            echo "[+] ======================"
            for cmd in $VKRC_COMMAND_LIST; do
                echo "[*] $cmd"
            done
        }
        source .vkrc
        echo "[+] ======================"
        echo "[+] Found .vkrc and Loaded"
        showcmd
        typeset -F reset_vkrc || echo "Not Found reset_vkrc in this .vkrc"
    fi

    [[ $PWD != $CURRENT_RC_PWD* ]] && \
        typeset -F reset_vkrc && \
        unset CURRENT_RC_PWD && unset VKRC_COMMAND_LIST && reset_vkrc
}

function chpwd(){
    vkrcmod
}

function uniq_path(){
    local paths=($(echo $PATH | tr ':' " "))
    local new_path=()
    for p in $paths; do
        local skip=0
        for np in $new_path; do
            if [[ $np = $p ]]; then
                skip=1
                break
            fi
        done
        if [[ $skip = 1 ]]; then
            continue
        fi
        new_path=($new_path $p)
    done
    echo $new_path | tr ' ' ":"
}

############################
# Custom Scripts
############################
export PATH=$(uniq_path)

# vCommand add to alias
eval $($(which vcommand) _alias)

############################
# alias
############################
# oh-my-zsh
alias szsh='source ~/.zshrc'
alias stzsh='st ~/.zshrc'
alias stvp='st $ZSH_CUSTOM/plugins/virink/virink.plugin.zsh'
alias stvt='st $ZSH_CUSTOM/themes/virink.zsh-theme'
# bin
alias ll='ls -alh'
alias grep="grep --color=auto"
alias vi='vim'
alias rm='trash'
alias sed='LANG=C LC_CTYPE=C sed'
# Clear
alias cls='clear'
alias clspjt='clearpjt'
alias clsnpm='clearnpm'

# alias electron='/Applications/Electron.app/Contents/MacOS/Electron'
alias javac="javac -J-Dfile.encoding=utf8"
alias service='brew services'
# Language
alias lgbk='export LANG=zh_CN.GBK'
# alias lutf8='export lang=zh_CN.UTF-8'
alias lutf8='export LANG=en_US.UTF-8'
# Nasm
alias nasmd='nasm -f macho64'
alias ldd='ld -e _start'
# docker-compose
alias dcp='docker-compose'

# github
alias git=hub

# php composer
alias composer='composer -vvv'

# nodejs npm
alias onpm=/usr/local/bin/npm
alias npm=/usr/local/bin/cnpm

alias luarocks='luarocks --lua-dir=/usr/local/opt/lua@5.1'

# Proxy
alias stpac="st ~/.vproxy/pac/user-rules.txt"
alias vproxy="~/.vproxy/vproxy_sysconf"
alias pc4='proxychains4'
alias stpc4='st /usr/local/etc/proxychains.conf'

# Chrome
alias gchrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias chromenossl="gchrome --args --ignore-certificate-errors --allow-running-insecure-content"
alias chromeport="gchrome --args --explicitly-allowed-ports="

alias vv='source `pwd`/venv/bin/activate'

alias codeql='/opt/codeql/codeql'
alias vscode="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
alias vsc=vscode

alias xray=/opt/xray/xray
alias py3=/usr/local/bin/python3
alias py=py3
alias py2=/usr/local/bin/python2
alias virtualenv='python3 -m virtualenv'

alias gotmp='cd ~/Workspace/tmp/go-playground'
