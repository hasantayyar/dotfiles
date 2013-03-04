ZSH=$HOME/.oh-my-zsh
ZSH_THEME="robbyrussell"

alias ctest="git checkout test"
alias cdev="git checkout dev"
alias cunstable="git checkout unstable"
alias ainstall="sudo apt-get install"
alias aupdate="sudo apt-get update"
alias apurge="sudo apt-get purge"
alias push="git push origin $1"
alias pull="git pull origin $1"

alias deploy="git push origin unstable"

alias mergedev="git merge dev"
alias testpush="git push origin test"
alias gd="git diff"
alias gc="git commit"
alias gl="git log --graph --full-history --all --color"

alias lr='ls -R | grep ":$" | sed -e '\''s/:$//'\'' -e '\''s/[^-][^\/]*\//--/g'\'' -e '\''s/^/   /'\'' -e '\''s/-/|/'\'''
alias servethis="python -c 'import SimpleHTTPServer; SimpleHTTPServer.test()'"

#ubuntu udate
alias update='sudo apt-get update && sudo apt-get upgrade && sudo apt-get clean'

#find and kill
fkill(){
	ps aux | grep "$1" | grep -v grep | awk '{print $2;}' | while read p; do kill -9 $p; done
}

mp3(){
	youtube-dl $1 --extract-audio --title --audio-format mp3	
}
extract_links(){
	lynx -dump $1
}

extract () {
    if [ -f $1 ] ; then
      case $1 in
        *.tar.bz2)   tar xjf $1     ;;
        *.tar.gz)    tar xzf $1     ;;
        *.bz2)       bunzip2 $1     ;;
        *.rar)       unrar e $1     ;;
        *.gz)        gunzip $1      ;;
        *.tar)       tar xf $1      ;;
        *.tbz2)      tar xjf $1     ;;
        *.tgz)       tar xzf $1     ;;
        *.zip)       unzip $1       ;;
        *.Z)         uncompress $1  ;;
        *.7z)        7z x $1        ;;
        *)     echo "'$1' cannot be extracted via extract()" ;;
         esac
     else
         echo "'$1' is not a valid file"
     fi
}

function watch_progress {
  local file=$1
  local size=`sudo du -b $file | awk '{print $1}'`
  local pid=${2:-`
    sudo lsof -F p $file | cut -c 2- | head -n 1
  `}

  local watcher=/tmp/watcher-$$
  cat <<EOF > $watcher
file=$file
size=$size
pid=$pid
EOF

  cat <<'EOF' >> $watcher
line=`sudo lsof -o -o 0 -p $pid | grep $file`
position=`echo $line | awk '{print $7}' | cut -c 3-`
progress=`echo "scale=2; 100 * $position / $size" | bc`
echo pid $pid reading $file: $progress% done
EOF

  chmod +x /tmp/watcher-$$
  watch /tmp/watcher-$$
}

COMPLETION_WAITING_DOTS="true"


# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
plugins=(git jira pip git-extras)

source $ZSH/oh-my-zsh.sh

# Customize to your needs...
export PATH=/usr/lib/lightdm/lightdm:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/usr/games:/usr/local/games


#powerline

function powerline_precmd() {
  export PS1="$(~/powerline-bash.py $? --shell zsh)"
}

function install_powerline_precmd() {
  for s in "${precmd_functions[@]}"; do
    if [ "$s" = "powerline_precmd" ]; then
      return
    fi
  done
  precmd_functions+=(powerline_precmd)
}

install_powerline_precmd
