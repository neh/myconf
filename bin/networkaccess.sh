#!/usr/bin/env sh

IP=$(/usr/bin/curl -s https://api.ipify.org)

if [[ $? -gt 0 ]]; then
    SYMBOL="%{F#fb4934}%{F}"
    echo $SYMBOL
    exit
else
    SYMBOL="%{F#8d7f75}%{F}"
    # echo $SYMBOL
    echo "$SYMBOL  $IP"
fi

show_ip() {
    echo "$SYMBOL  $IP"
}

trap "show_ip" USR1
