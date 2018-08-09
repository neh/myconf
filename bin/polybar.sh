#!/usr/bin/env sh

laptop_display='eDP-1'

# Terminate already running bar instances
killall -q polybar

# Wait until the processes have been shut down
while pgrep -x polybar >/dev/null; do sleep 1; done

# Get network interface names
export INTERFACE_WIRED=$(ip link show | cut -d' ' -f2 | tr -d ':' | grep '^en')
export INTERFACE_WIRELESS=$(ip link show | cut -d' ' -f2 | tr -d ':' | grep '^wl')

primary=$(xrandr | grep ' connected primary' | cut -d' ' -f1)

for m in $(polybar --list-monitors | cut -d":" -f1); do
    if [[ "$m" == "$primary" ]]; then
        # the --reload option doesn't seem to work under i3, but
        # doesn't hurt either
        if [[ "$m" == "$laptop_display" ]]; then
            MONITOR=$m polybar --reload primary-laptop &
        else
            MONITOR=$m polybar --reload default &
        fi
    else
        MONITOR=$m polybar --reload secondary &
    fi
done
