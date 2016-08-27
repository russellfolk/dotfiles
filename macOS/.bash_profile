# Russell Folk's Bash Profile
# contains functions and aliases that are specific to macOS

# make sure to load my bashrc
if [ -f ~/.bashrc ]; then
	source ~/.bashrc
fi

# set the path
export PATH=/usr/local/bin:$PATH

# grep output
alias grep='grep --color=auto'
alias egrep='egrep --color=auto'
alias fgrep='fgrep --color=auto'
# ls stuff
alias ls='ls -G'
alias ll='ls -Galh'
# human readability helps
alias df='df -H'
alias du='du -ch'

# History Control
export HISTCONTROL=ignoreboth:erasedups
export HISTSIZE=10000
shopt -s histappend

prompt_command ()
{
	local TIME=`fmt_time`
	local CPU=`cpu_util`
	local MEM=`mem_util`
	local RESET="\e[0;39m\]"
	local BOLD_BLUE="\e[1;34m\]"
	local BLUE="\e[0;34m\]"
	local LIGHT_BLUE="\e[0;94m\]"
	local LIGHT_GREY="\e[0;37m\]"
	local BRIGHT_LBLUE="\e[1;94m\]"
	local WHITE="\e[0;97m\]"
	local MAGENTA="\e[0;35m\]"
	local CYAN="\e[0;36m\]"

	export PS1="${LIGHT_GREY}[ ${BRIGHT_LBLUE}\u${LIGHT_GREY}@${CYAN}\h \
$CPU $MEM ${WHITE}${TIME} ${LIGHT_GREY}] ${MAGENTA}\w${RESET}\n\$ "
}
PROMPT_COMMAND=prompt_command

cpu_util () { # macOS specific
	local RED="\e[0;31m\]"
	local GREEN="\e[0;32m\]"
	local YELLOW="\e[0;93m\]"
	# grab the total cpu utilization
	local UTIL=`ps -A -o %cpu | awk '{s+=$1} END {print s}'`
	# count the number of cpus in a given mac
	local NUM_CPU=`sysctl hw.ncpu | awk '{ print $2 }'`
	# normalize utilization based on the number of cpus
	UTIL=`awk -v n=$UTIL -v d=$NUM_CPU 'BEGIN{ print (n/d) }'`
	
	local FLOOR=$(printf "%.0f" ${UTIL})
	if [ $FLOOR -gt 80 ]; then
		printf "${RED}"
	elif [ $FLOOR -gt 50 ]; then
		printf "${YELLOW}"
	else
		printf "${GREEN}"
	fi
	printf "%.1f%%" $UTIL
}

mem_util () { # macOS specific
	local RED="\e[0;31m\]"
	local GREEN="\e[0;32m\]"
	local YELLOW="\e[0;93m\]"
	
	# grab the number of pages free
	local FREE_PAGES=`sysctl -a vm | grep page_free_count | awk '{ print $2}'`
	local PAGE_SIZE=`pagesize`
	local GB=1073741824 # 1024^3

	local UTIL=`awk -v n=$FREE_PAGES -v nn=$PAGE_SIZE -v d=$GB 'BEGIN{ print (n*nn/d) }'`
	local FLOOR=$(printf "%.0f" ${UTIL})
	if [ $FLOOR -lt 1 ]; then
		printf "${RED}"
	elif [ $FLOOR -lt 3 ]; then
		printf "${YELLOW}"
	else
		printf "${GREEN}"
	fi
	printf "MEM"
}