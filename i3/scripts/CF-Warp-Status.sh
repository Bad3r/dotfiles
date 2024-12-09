#!/bin/sh

log_file="/var/log/cloudflare-warp/cfwarp_service_log.txt"
last_status=""

# Function to extract the status from a line
extract_status() {
    case "$1" in
    *ResponseStatus:*)
        printf "%s" "$1" | awk -F'ResponseStatus: ' '{split($2, a, " "); print a[1]}'
        ;;
    *"INFO warp_svc: Service stopped"*)
        printf "Service Not Running"
        ;;
    *)
        printf ""
        ;;
    esac
}

send_notification() {
    status="$1"
    if [ "$status" = "Warp service stopped" ]; then
        notify-send -u critical -t 10000 "Warp Status" "$status"
    elif [ "$status" = "Connected" ] || [ "$status" = "Connecting" ]; then
        notify-send -u normal "Warp Status" "$status"
    else
        notify-send -u critical -t 10000 "Warp Status" "$status"
    fi
}

Process_log_entry() {
    entry="$1"
    current_status=$(extract_status "$entry")
    if [ -n "$current_status" ] && [ "$current_status" != "$last_status" ]; then
        send_notification "$current_status"
        last_status="$current_status"
    fi
}

# Initial status processing: find the most recent relevant log line
initial_status=$(grep -E 'ResponseStatus:|INFO warp_svc: Service stopped' "$log_file" | tail -n 1)
if [ -n "$initial_status" ]; then
    current_status=$(extract_status "$initial_status")
    if [ -n "$current_status" ]; then
        send_notification "$current_status"
        last_status="$current_status"
    fi
fi

# Monitor the log file for changes
tail -F "$log_file" | {
    while IFS= read -r entry; do
        Process_log_entry "$entry"
    done
}
