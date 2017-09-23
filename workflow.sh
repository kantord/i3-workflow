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

. settings.sh

run_custom_commands_of() {
    PROJECT=$1
    cd $PROJECTS/$PROJECT
    source .workflowrc
    start_workspace
    cd -
}

run_editor_in_directory_of() {
    PROJECT=$1
    urxvt -cd "$PROJECTS/$PROJECT" -hold -e zsh -c "source ~/.zshrc; nvim ." > /dev/null &
}

open_terminal_in_directory_of() {
    PROJECT=$1
    urxvt -cd "$PROJECTS/$PROJECT" > /dev/null &
}

rename_workspace_to_match() {
    PROJECT=$1
    WORKSPACE_NUMBER=`i3-msg -t get_workspaces | python -c "import sys;import json;doc = json.loads(sys.stdin.read());workspace = [w for w in doc if w['focused']][0];print(workspace['num'])"`
    i3-msg "rename workspace to \"$WORKSPACE_NUMBER: $PROJECT\"" > /dev/null &
}

list_projects() {
    ls $PROJECTS
}

launch_project_workspace() {
    PROJECT=$1
    open_terminal_in_directory_of $PROJECT
    run_editor_in_directory_of $PROJECT
    run_custom_commands_of $PROJECT
    rename_workspace_to_match $PROJECT
}

rofi_options() {
    list_projects
}

rofi_action() {
    PROJECT=$1
    launch_project_workspace $PROJECT
}

load_custom_settings() {
    USER_WORKFLOWRC=$HOME/.workflowrc
    if [ -f $USER_WORKFLOWRC ];
    then
        source $USER_WORKFLOWRC
    else
        echo $USER_WORKFLOWRC
    fi
}

load_custom_settings
if [ -z $@ ]
then
    rofi_options
else
    PROJECT=$@
    rofi_action $PROJECT
fi
