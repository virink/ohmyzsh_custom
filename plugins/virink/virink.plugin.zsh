############################
# ENV or PATH
############################
. $ZSH_CUSTOM/z.sh

C_END="\033[0m"
C_BRED="\033[31m\033[01m"
C_GREEN="\033[32m"

if [ -f "${HOME}/.gpg-agent-info" ]; then
  . "${HOME}/.gpg-agent-info"
  export GPG_AGENT_INFO
fi
export GPG_TTY=$(tty)

# SSH Agent
eval $(ssh-agent -s) > /dev/null
for i in $(ls ~/.ssh/*rsa | grep -E '.*?rsa$'); do
    ssh-add $i > /dev/null 2>&1
done
trap 'test -n "$SSH_AGENT_PID" && eval `/usr/bin/ssh-agent -k` > /dev/null' 0

# export MANPATH="/usr/local/opt/coreutils/libexec/gnuman:$MANPATH"

# Homebrew
# export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.ustc.edu.cn/homebrew-bottles
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
export HOMEBREW_NO_AUTO_UPDATE=true
export HOMEBREW_GITHUB_API_TOKEN="89270d1b8578e9be02fd54a292c201d818bf6ee2"
export ELECTRON_MIRROR=http://npm.taobao.org/mirrors/electron/
# export ANDROID_SDK_HOME=/Users/virink/Library/Android/sdk
export ANDROID_SDK_ROOT="/usr/local/share/android-sdk"
export ANDROID_NDK_HOME="/usr/local/share/android-ndk"
# export ANDROID_NDK_HOME=${ANDROID_SDK_ROOT}/ndk-bundle

# antSword AS_WORKDIR
export AS_WORKDIR=/Users/virink/Workspace/antSword/Core

# JAVA_HOME
export JAVA_HOME=/Library/Java/JavaVirtualMachines/jdk1.8.0_181.jdk/Contents/Home
export JRE_HOME=$JAVA_HOME/jre
export CLASSPAHT=.:$JAVA_HOME/lib/dt.jar:$JAVA_HOME/lib/tools.jar

# GO
export GOROOT="/usr/local/opt/go/libexec"
export GOPATH="/usr/local/src/go"
export GOROOT_BOOTSTRAP=GOROOT
export GO111MODULE=on
export GOPROXY=https://goproxy.io
# export CSC_IDENTITY_AUTO_DISCOVERY=false

export TOMCAT_HOME=/usr/local/opt/tomcat@8/libexec
export CATALINA_HOME=$TOMCAT_HOME

# FLUTTER
export PUB_HOSTED_URL=https://pub.flutter-io.cn
export FLUTTER_STORAGE_BASE_URL=https://storage.flutter-io.cn
export OBJC_DISABLE_INITIALIZE_FORK_SAFETY=YES

#set env for pwntools
export TERM=xterm-256color
export TERMINFO=/etc/terminfo

############################
# Env Path
############################
# Java
export PATH=$JAVA_HOME/bin:$PATH
export PATH=$JAVA_HOME/bin:$PATH
# flutter
export PATH=/Users/virink/Program/flutter/bin:$PATH
# Android
export PATH=${ANDROID_SDK_ROOT}/tools:${PATH}
export PATH=${ANDROID_SDK_ROOT}/platform-tools:${PATH}
# gnubin
# export PATH="$(brew --prefix coreutils)/libexec/gnubin:/usr/local/bin:$PATH"
# Golang
export PATH=$GOROOT/bin:$GOPATH/bin:$PATH
# Virink
if [[ $PATH =~ "/usr/local/vbin" ]];then
else
  export PATH="/usr/local/vbin:$PATH"
fi

############################
# alias
############################
alias cls='clear'
alias ll='ls -alh'
alias grep="grep --color=auto"
alias vi='vim'
alias rm='trash'
alias sed='LANG=C LC_CTYPE=C sed'
# alias electron='/Applications/Electron.app/Contents/MacOS/Electron'
# oh-my-zsh
alias szsh='source ~/.zshrc'
alias stzsh='st ~/.zshrc'
alias stvp='st $ZSH_CUSTOM/plugins/virink/virink.plugin.zsh'
alias stvt='st $ZSH_CUSTOM/themes/virink.zsh-theme'
alias pc4='proxychains4'
alias py='python3'
alias py2='python2'
alias javac="javac -J-Dfile.encoding=utf8"
alias service='brew services'
# Tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
# Language
alias lgbk='export LANG=zh_CN.GBK'
# alias lutf8='export lang=zh_CN.UTF-8'
alias lutf8='export LANG=en_US.UTF-8'
# Nasm
alias nasmd='nasm -f macho64'
alias ldd='ld -e _start'

alias gchrome="/Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome"
alias pcscli='pcs-console'
alias dcp='docker-compose'

# alias sqlmap='python2 /usr/local/bin/sqlmap'
alias onpm=/usr/local/bin/npm
alias npm=/usr/local/bin/cnpm

alias luarocks='luarocks --lua-dir=/usr/local/opt/lua@5.1'
alias luarocks51='luarocks --lua-dir=/usr/local/opt/lua@5.1'

alias vv='source `pwd`/venv/bin/activate'
alias stpc4='st /usr/local/etc/proxychains.conf'

alias codeql='/Users/virink/Program/codeql/codeql'
############################
# Custom Scripts
############################
# vCommand add to alias
eval $($(which vcommand) _alias)

############################
# Custom Function
############################
function command_not_found_handler(){
    if {which vcommand > /dev/null} {
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
    if [ -d "~/.acme.sh" ]; then
        echo "acme.sh --issue -d \"$domain\" --dns dns_ali"
        echo "acme.sh --install-cert -d \"$domain\" --key-file \"/etc/nginx/certs/$domain.key\" --fullchain-file \"/etc/nginx/certs/$domain.pem\" --reloadcmd \"service nginx restart\""
    fi
}

alias stpac="st ~/.vproxy/pac/user-rules.txt"
function pac(){
    local pacfile="~/.vproxy/pac/user-rules.txt"
    if [ ! -f $pacfile ]; then
        eval touch $pacfile
    fi
    # genpac --pac-proxy "SOCKS5 127.0.0.1:1080" --gfwlist-disabled \
    # genpac --pac-proxy "http 127.0.0.1:3213;" \
    genpac --pac-proxy "SOCKS5 127.0.0.1:1080; SOCKS 127.0.0.1:1080;DIRECT;" \
        --gfwlist-proxy="SOCKS5 127.0.0.1:1080" \
        --gfwlist-url="https://raw.githubusercontent.com/gfwlist/gfwlist/master/gfwlist.txt" \
        --gfwlist-local "~/.vproxy/pac/gfwlist.txt" \
        --gfwlist-update-local \
        --user-rule-from="~/.vproxy/pac/user-rules.txt" \
        --output="~/.vproxy/proxy.pac"
}
alias vproxy="~/.vproxy/vproxy_sysconf"
function proxy(){
    if [[ "$1" = "t" ]]; then
        local url=""
        if [[ "$2" = "" ]]; then
            url="https://www.google.com"
        else
            url="$2"
        fi
        # echo "[+] Generate random file (1M)..."
        dd if=/dev/urandom of=/tmp/testbin bs=1024 count=1024 2>/dev/null >/dev/null
        # curl -vv -o /dev/null -s -w '%{time_namelookup} %{time_connect} %{time_starttransfer} %{time_total} %{speed_upload} %{speed_download}' -F file=@/tmp/testbin 
        # echo "[+] Start curl $url ..."
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
        _dir="/usr/local/etc/v2ray"
        ls $_dir
    else
        echo -e "t\ttest\nc\tchange\nl\tlist\n"
    fi
    return $?
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
alias clspjt='clearpjt'

function clearnpm(){
    echo "Deleting node_modules ..."
    find `pwd` -type d -name "node_modules" -exec rm -rf {} \;
    echo "Successfully"
}
alias clsnpm='clearnpm'

function stvh(){
    st ~/SourceCodes/vhost
}

function filenum(){
    echo "There are `ls -lR|grep "^-"|wc -l`   files in `pwd`"
}

alias vscode="/Applications/Visual Studio Code.app/Contents/Resources/app/bin/code"
alias vsc=vscode

# show my ip
function myip(){
    if [[ ! -n $1 ]]; then
        curl myip.ipip.net
    else
        curl -vv myip.ipip.net
    fi
}

# Hexo action
function mgd() {
    local ori_path=$(pwd)
    cd /Users/virink/Workspace/Blog
    source `pwd`/venv/bin/activate
    ./mweblog.py gd
    deactivate
    cd $ori_path
}

# Socks5 Proxy
function ssup() {
    export ALL_PROXY=http://127.0.0.1:1086
    # export ALL_PROXY=http://127.0.0.1:3213
}

function ssdown() {
    unset ALL_PROXY
}

# Chrome
alias chromenossl="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome --args --ignore-certificate-errors --allow-running-insecure-content"
alias chromeport="/Applications/Google Chrome.app/Contents/MacOS/Google Chrome --args --explicitly-allowed-ports="

# function chromeport() {
#     local port=$@
#     /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --explicitly-allowed-ports=${port}
# }


# source `pwd`/myself.sh
function gi() { 
    curl -o .gitignore -L -s "https://www.gitignore.io/api/$@" ;
}

# OfficeThinner
function clearoffice(){
    sudo bash -c "curl -s https://raw.githubusercontent.com/goodbest/OfficeThinner/master/OfficeThinner.sh | bash"
}

# dex2jar
function dex2jar (){
    /Users/virink/Program/dex2jar21/d2j-dex2jar.sh "$@"
}

# DiffMerge
function diffmerge() {
    exec /Applications/DiffMerge.app/Contents/MacOS/DiffMerge --nosplash  "$@"
}
