function omzinfo(){
    echo "\nPlugin Infomation:"
    echo "  -> Name\tvirink (virink.plugin.zsh)"
    echo "  -> Author\tVirink"
    echo "  -> Email\tvirink@outlook.com"
    echo "  -> Github\thttps://github.com/virink"
}
############################
# ENV or PATH
############################
export HOMEBREW_BOTTLE_DOMAIN=https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles
export ELECTRON_MIRROR=http://npm.taobao.org/mirrors/electron/
export ANDROID_SDK_HOME=/usr/local/share/android-sdk
#   export PATH=${PATH}:${ANDROID_SDK_HOME}/tools
#   export PATH=${PATH}:${ANDROID_SDK_HOME}/platform-tools
export ANDROID_NDK_HOME=${ANDROID_SDK_HOME}/ndk-bundle
# antSword AS_WORKDIR
export AS_WORKDIR=/Users/virink/Workspace/antSword
# JAVA_HOME
export JAVA_HOME="/Library/Java/JavaVirtualMachines/jdk1.8.0_131.jdk/Contents/Home/"
export GOROOT="/usr/local/opt/go"
export GOROOT_BOOTSTRAP=GOROOT
export PATH=${PATH}:${GOROOT}/bin
export PATH=${PATH}:/Users/virink/Program
############################
# alias
############################
alias py='python2'
alias py3='python3'
alias cls='clear'
alias ll='ls -al'
alias vi='vim'
alias javac="javac -J-Dfile.encoding=utf8"
alias grep="grep --color=auto"
alias sshl='cat ~/.ssh/config | grep "Host "'
alias vv='source `pwd`/venv/bin/activate'
alias npm='cnpm'
# oh-my-zsh
alias szsh='source ~/.zshrc'
alias stzsh='st ~/.zshrc'
alias stvp='st ~/Workspace/ohmyzsh_custom/plugins/virink/virink.plugin.zsh'
alias stvt='st ~/Workspace/ohmyzsh_custom/themes/virink.zsh-theme'
# Masscan
alias masscan="/Users/virink/Program/masscan/bin/masscan"
# PHP Composer
# alias composer="php /Users/virink/Program/composer.phar"
# Tree
alias tree="find . -print | sed -e 's;[^/]*/;|____;g;s;____|; |;g'"
# Language
alias lgbk='export LANG=zh_CN.GBK'
# alias lutf8='export lang=zh_CN.UTF-8'
alias lutf8='export LANG=en_US.UTF-8'

############################
# Custom Function
############################
function clearpyc(){
    echo "list *.pyc"
    find `pwd` -name "*.pyc" -o -name "__pycache__"
    echo "Deleting *.pyc ..."
    find `pwd` -name "*.pyc" -delete
    echo "Deleting __pycache__ ..."
    find `pwd` -type d -name "__pycache__" -exec rm -rf {} \;
    echo "Successfully"
}
alias clspyc='clearpyc'

function lrsync(){
    ls -al ~/Workspace/Plists
}

function mrsync(){
    local fp="/Users/virink/Workspace/Plists/$2.plist"
    if [ "$1" = "load" ]; then
        launchctl load -w $fp
    elif [ "$1" = "unload" ]; then
        launchctl unload $fp
    else
        echo "mrsync [load,unload] filepath"
        lrsync()
        return
    fi
    echo "launchctl $1 [-w] $fp"
}

# OfficeThinner
function subl(){
    /Applications/Sublime\ Text.app/Contents/SharedSupport/bin/subl $@
}
alias st=subl

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

# weakfilescan
function wyspider() {
    cd /Users/virink/Workspace/weakfilescan/
    python wyspider.py $@
}

# show my ip
function myip(){
    curl myip.ipip.net
}

# String Helper
function hex2str () {
    I=0
    printf ${1:0:2}
    if ${1:0:2} = "0x";then
        I=2
    fi
    while [ $I -lt ${#1} ];
    do
    echo -en "\x"${1:$I:2}
    let "I += 2"
    done
    echo ""
}

function str2hex() {
    printf "0x"
    I=0
    while [ $I -lt ${#1} ];
    do
        printf "%x" "'"${1:$I:1}
        let "I += 1"
    done
    echo ""
}

# Hexo action
function ggd() {
    if [ "`pwd`" = "/Users/virink/Blog" ]; then
        hexo g && gulp && hexo d
    fi
}

# Socks5 Proxy
function ssup() {
    export ALL_PROXY=socks5://127.0.0.1:1080
}

function ssdown() {
    unset ALL_PROXY
}

# Chrome
function chromenoxss() {
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --disable-xss-auditor
}
function chromeport() {
    local port=$@
    /Applications/Google\ Chrome.app/Contents/MacOS/Google\ Chrome --args --explicitly-allowed-ports=${port}
}

# Drcom passwd
function dpwd() {
    local key=$@
    cat /Users/virink/Program/Other/CIDP/drcom/drcom_user_pwd.txt | grep "${key}"
}

# System
dec2hex () {
    local dex=$1
    printf '0x%x\n' "$dex"
}

hex2dec () {
    local hex=$1
    printf '%d\n' "$hex"
}

# IP Helper
ip2hex () {
    local a b c d ip=$@
    IFS=. read -r a b c d <<< "$ip"
    printf '0x%x\n' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}
hex2ip () {
    local ip dec=$@
    desc=$(($desc))
        for e in {3..0}
    do
        ((octet = dec / (256 ** e) ))
            ((dec -= octet * 256 ** e))
            ip+=$delim$octet
            delim=.
            done
            printf '%s\n' "$ip"
}
ip2dec () {
    local a b c d ip=$@
        IFS=. read -r a b c d <<< "$ip"
        printf '%d\n' "$((a * 256 ** 3 + b * 256 ** 2 + c * 256 + d))"
}
dec2ip () {
    local ip dec=$@
        for e in {3..0}
    do
        ((octet = dec / (256 ** e) ))
            ((dec -= octet * 256 ** e))
            ip+=$delim$octet
            delim=.
            done
            printf '%s\n' "$ip"
}
