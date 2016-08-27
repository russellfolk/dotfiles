# Russell Folk's Bash bashrc
# contains common aliases and functions that can be used with ANY environment

# other exports
export CLICOLOR=1
export LSCOLORS=gxBxhxDxfxhxhxhxhxcxcx

# setup aliases
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias c='clear'
# generate sha1 digest
alias sha1='openssl sha1'

# Useful functions
extract() {
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

# courtesy of Brett Terpstra: http://brettterpstra.com/2009/11/17/my-new-favorite-bash-prompt/
fmt_time () { #format time just the way I likes it
    if [ `date +%p` = "PM" ]; then
        meridiem="pm"
    else
        meridiem="am"
    fi
    date +"%l:%M:%S$meridiem"|sed 's/ //g'
}