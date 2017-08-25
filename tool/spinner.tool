# spinner for interactive use
# uses file descriptor 3 in nomd

NOMD_SPINNER=
NOMD_SPINNER_INDEX=0
declare -A NOMD_SPINNER_CHARS
NOMD_SPINNER_CHARS=( [0]='-' [1]='\\' [2]='|' [3]='/' )

# enable spinner (only if on interactive terminal)
spinner_start()
{
    [ -t 0 ] || return 0
    NOMD_SPINNER=1
    trap on_spinner DEBUG
}

# clean up spinner (only if on interactive terminal)
spinner_stop()
{
    [ "$NOMD_SPINNER" ] || return 0
    trap DEBUG
    echo -en "\b \b" >&3
}

on_spinner()
{
    echo -en "\b${NOMD_SPINNER_CHARS[$NOMD_SPINNER_INDEX]}" >&3
    if [ $NOMD_SPINNER_INDEX = 3 ]; then
	NOMD_SPINNER_INDEX=0
    else
	NOMD_SPINNER_INDEX=$(( NOMD_SPINNER_INDEX + 1 ))
    fi
}
