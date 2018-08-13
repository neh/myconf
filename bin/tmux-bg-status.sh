#!/bin/bash

declare -a sessions
declare -a windows
declare -a active_windows

sessions=($(tmux list-sessions -F '#S' | grep '^main.*'))
windows=($(tmux list-windows -t main -F '#I'))
active_windows=($(for sess in ${sessions[@]}; do tmux list-windows -t $sess -F '#{?window_active,#I,}'; done))
unique_active_windows=($(printf "%s\n" "${active_windows[@]}" | sort -u))
echo ${sessions[*]}
echo ${windows[*]}
echo ${active_windows[*]}
echo ${unique_active_windows[*]}

if [[ ${#unique_active_windows[@]} -lt ${#windows[@]} ]]; then
    status_status='on'
else
    status_status='off'
fi
for sess in ${sessions[@]}; do
    tmux set-window-option window-status-format "#{?#{m:* #I *, ${unique_active_windows[*]} },,#I (#W)}"
    # tmux set-window-option window-status-format "#I (#W)"
    tmux set-option -t $sess status ${status_status}
done
# if [[ ${#unique_active_windows[@]} -lt ${#windows[@]} ]]; then
# else
    # tmux set-option status off
# fi
