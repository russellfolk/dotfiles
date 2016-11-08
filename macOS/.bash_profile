# Russell Folk's Bash Profile
# contains functions and aliases that are specific to macOS
prompt_command ()
{
	if [ $? -eq 0 ]; then # set a green checkmark
		local BOLD_GREEN="\033[1;92m\]"
		local STATUS="${BOLD_GREEN}✓"
		local ERROR_MSG=""
	else
		local ERROR_CODE=$?
		local BOLD_RED="\033[1;31m\]"
		local LIGHT_GREY="\033[0;37m\]"
		local ERROR_MSG="${LIGHT_GREY}(${BOLD_RED}${ERROR_CODE}${LIGHT_GREY}) ${RESET}"
		local STATUS="${BOLD_RED}✗"
	fi

	local TIME=`fmt_time`
	local CPU=`cpu_util`
	local MEM=`mem_util`
	local RESET="\033[0;39m\]"
	local LIGHT_GREY="\033[0;37m\]"
	local YELLOW="\033[0;33m\]"
	local BRIGHT_LBLUE="\033[1;94m\]"
	local WHITE="\033[0;97m\]"
	local MAGENTA="\033[0;35m\]"
	local CYAN="\033[0;36m\]"
	
	export PS1="${STATUS} ${LIGHT_GREY}[ ${BRIGHT_LBLUE}\u${YELLOW}@${CYAN}\h \
${CPU} ${MEM} ${WHITE}${TIME} ${LIGHT_GREY}] ${ERROR_MSG}${MAGENTA}\w${RESET}\n\
\$ "
}
PROMPT_COMMAND=prompt_command

cpu_util () { # macOS specific
	local RED="\033[0;31m\]"
	local GREEN="\033[0;32m\]"
	local YELLOW="\033[0;93m\]"
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
	local RED="\033[2;31m\]"
	local GREEN="\033[2;32m\]"
	local YELLOW="\033[2;93m\]"
	
	# grab the number of pages free
	local FREE_PAGES=`sysctl -a vm | grep page_free_count | awk '{ print $2}'`
	local PAGE_SIZE=`pagesize`
	local GB=1073741824 # 1024^3

	local UTIL=`awk -v n=$FREE_PAGES -v nn=$PAGE_SIZE -v d=$GB 'BEGIN{ print (n*nn/d) }'`
	local FLOOR=$(printf "%.0f" ${UTIL})
	if [ $FLOOR -eq 0 ]; then
		printf "${RED}"
	elif [ $FLOOR -lt 1 ]; then
		printf "${YELLOW}"
	else
		printf "${GREEN}"
	fi
	printf "MEM"
}

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

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
