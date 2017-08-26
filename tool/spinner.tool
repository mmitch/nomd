#!/usr/bin/env bash
#
# Copyright (C) 2017  Christian Garbs <mitch@cgarbs.de>
# Licensed under GNU GPL v3 or later.
#
# This file is part of nomd.
#
# nomd is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# nomd is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with nomd.  If not, see <http://www.gnu.org/licenses/>.
#

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
