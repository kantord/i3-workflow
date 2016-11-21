#!/bin/bash

# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.

# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.

# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.

PROJECTS=~/repos

get_workspace_name() {
    i3-msg -t get_workspaces | python -c "import sys;import json;doc = json.loads(sys.stdin.read());workspace = [w for w in doc if w['focused']][0];print(workspace['name'])"
}

get_active_project_name() {
    get_workspace_name | sed "s/^.*\: //"
}

build_active_project() {
    ACTIVE_PROJECT=`get_active_project_name`
    #zenity --info --text $ACTIVE_PROJECT
    i3-sensible-terminal -cd "$PROJECTS/$ACTIVE_PROJECT" -hold -e "make"
}

build_active_project
