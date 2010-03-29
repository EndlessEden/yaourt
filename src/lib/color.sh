#!/bin/bash
#===============================================================================
#
#          FILE: color.sh
# 
#   DESCRIPTION: yaourt's library to manage colors
# 
#       OPTIONS:  ---
#  REQUIREMENTS:  ---
#          BUGS:  ---
#         NOTES:  ---
#        AUTHOR:   Julien MISCHKOWITZ (wain@archlinux.fr) 
#       VERSION:  1.0
#===============================================================================
COLORMODES=( textonly nocolor lightbg )

initcolor(){
# no special caracter for textonly mode
if [ "$COLORMODE" = "textonly" ]; then
	TERMINALTITLE=0
	return 0
else
	# font type
	COL_BOLD="\033[1m"
	COL_INVERT="\033[7m"
	COL_BLINK="\033[5m"
	NO_COLOR="\033[0m"

	# No italic out of Xorg or under screen
	if [ ! -z "$DISPLAY" ] && [ "${TERM:0:6}" != "screen" ]; then
		COL_ITALIQUE="\033[3m"
		local _colitalique="\033[3m"
	fi
fi


# Color list
case $COLORMODE in
	"nocolor")
	COL_WHITE="\033[0m"
	COL_YELLOW="\033[0m"
	COL_RED="\033[0m"
	COL_CYAN="\033[0m"
	COL_GREEN="\033[0m"
	COL_PINK="\033[0m"
	COL_BLUE="\033[0m"
	COL_BLACK="\033[0m"
	COL_MAGENTA="\033[0m"
	;;
	"lightbg")
	COL_WHITE="\033[1;37m"
	COL_RED="\033[1;31m"
	COL_CYAN="\033[1;36m"
	COL_GREEN="\033[1;32m"
	COL_PINK="\033[1;35m"
	COL_BLUE="\033[1;34m"
	COL_BLACK="\033[1;30m"
	COL_MAGENTA="\033[1;35m"
	COL_YELLOW="$COL_CYAN"
	;;
	*)
	COL_WHITE="\033[1;37m"
	COL_YELLOW="\033[1;33m"
	COL_RED="\033[1;31m"
	COL_CYAN="\033[1;36m"
	COL_GREEN="\033[1;32m"
	COL_PINK="\033[1;35m"
	COL_BLUE="\033[1;34m"
	COL_BLACK="\033[1;30m"
	COL_MAGENTA="\033[1;35m"
	;;
esac

# Color functions
COL_INSTALLED="$COL_INVERT$COL_YELLOW" # show [installed] packages
COL_ARROW="$COL_YELLOW" # show ==>
COL_NUMBER="$COL_INVERT$COL_YELLOW" # show number) in listing
COL_CORE="$_colitalique$COL_RED"
COL_EXTRA="$_colitalique$COL_GREEN"
COL_LOCAL="$_colitalique$COL_YELLOW"
COL_COMMUNITY="$_colitalique$COL_PINK"
COL_TESTING="$_colitalique$COL_RED"
COL_AUR="$_colitalique$COL_MAGENTA"
COL_REPOS="$COL_MAGENTA"
COL_GROUP="$COL_BLUE"
}
list(){
	echo -e "${COL_ARROW}$1${NO_COLOR}" >&2
}
plain(){
	echo -e "${COL_BOLD}$*${NO_COLOR}" >&2
}
msg(){
	echo -e "${COL_GREEN}==> ${NO_COLOR}${COL_BOLD}$*${NO_COLOR}" >&2
}
warning(){
	echo -e "${COL_YELLOW}==> WARNING: ${NO_COLOR}${COL_BOLD}$*${NO_COLOR}" >&2
}
prompt(){
	echo -e "${COL_ARROW}==>  ${NO_COLOR}${COL_BOLD}$*${NO_COLOR}" >&2
	echo -e "${COL_ARROW}==>  ${NO_COLOR}${COL_BOLD} ----------------------------------------------${NO_COLOR}" >&2
	echo -ne "${COL_ARROW}==>${NO_COLOR} " >&2
}
promptlight(){
	echo -ne "${COL_ARROW}==>${NO_COLOR} " >&2
}
error(){
	echo -e "${COL_RED}""Error""${NO_COLOR}"": $*\n"
	return 1
}
colorizeoutputline(){		
	if [ "$COLORMODE" = "textonly" ]; then
		echo $*
	else
		local _line="$*"
		local repo="${_line%%/*}"
		[ "$repo" = "$_line" ] && echo $* && return
		local _line="${_line#*/}"
		case "$repo" in
			core) echo -n "$COL_CORE";;
			extra) echo -n "$COL_EXTRA";;
			community) echo -n "$COL_COMMUNITY";;
			testing) echo -n "$COL_TESTING";;
			community-testing) echo -n "$COL_TESTING";;
			aur) echo -n "$COL_AUR";;
			local) echo -n "$COL_LOCAL";;
			*) echo -n "$COL_REPOS";;
		esac
		echo "$repo/$NO_COLOR$_line"
	fi
	exit 0
}
cleanoutput(){
if [ $TERMINALTITLE -eq 0 -o -z "$DISPLAY"  ]; then
	return 0
fi
tput sgr0
}


