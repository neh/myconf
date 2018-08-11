#!/bin/bash

declare -a windows
declare -a active_windows

windows=($(tmux list-windows -t main -F '#I'))
active_windows=($(for sess in $(tmux list-sessions -F '#S' | grep '^main-.*'); do tmux list-windows -t $sess -F '#{?window_active,#I,}'; done))
unique_active_windows=($(printf "%s\n" "${active_windows[@]}" | sort -u))

tmux set-window-option -g -t main window-status-format "#{?#{m:* #I *, ${active_windows[*]} },,#I (#W)}"
if [[ ${#unique_active_windows[@]} -lt ${#windows[@]} ]]; then
    tmux set-option -t main -g status on
else
    tmux set-option -t main -g status off
fi
