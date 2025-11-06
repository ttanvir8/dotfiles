#!/bin/bash

# CLI tool to manage nsurlsessiond killer
# Usage: ./nsurlsessiond_manager.sh [--start|--stop|--logs|--status]

LAUNCHD_PLIST="/Library/LaunchDaemons/com.example.killnsurlsessiond.plist"

case "$1" in
    --start)
        # Create and start the service
        cat <<EOF >"$LAUNCHD_PLIST"
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>com.example.killnsurlsessiond</string>
    <key>ProgramArguments</key>
    <array>
        <string>/bin/bash</string>
        <string>-c</string>
        <string>pkill -9 nsurlsessiond</string>
    </array>
    <key>WatchPaths</key>
    <array>
        <string>/Applications</string>
    </array>
    <key>QueueDirectories</key>
    <array>
        <string>/tmp</string>
    </array>
    <key>StartCalendarInterval</key>
        <dict>
            <key>Minute</key>
            <integer>0</integer>
            <key>Hour</key>
            <integer>0</integer>
        </dict>
    <key>StandardErrorPath</key>
    <string>/tmp/kill_nsurlsessiond.err</string>
    <key>StandardOutPath</key>
    <string>/tmp/kill_nsurlsessiond.out</string>
    <key>AbandonProcessGroup</key>
    <true/>
</dict>
</plist>
EOF
        sudo chown root:wheel "$LAUNCHD_PLIST"
        sudo chmod 644 "$LAUNCHD_PLIST"
        sudo launchctl load "$LAUNCHD_PLIST"
        echo "Service started successfully"
        ;;
    --stop)
        # Stop the service
        sudo launchctl unload "$LAUNCHD_PLIST"
        sudo rm -f "$LAUNCHD_PLIST"
        echo "Service stopped successfully"
        ;;
    --logs)
        # Show logs
        echo "=== Standard Output ==="
        cat /tmp/kill_nsurlsessiond.out 2>/dev/null || echo "No output log found"
        echo "\n=== Standard Error ==="
        cat /tmp/kill_nsurlsessiond.err 2>/dev/null || echo "No error log found"
        ;;
    --status)
        # Check service status
        if launchctl print system/com.example.killnsurlsessiond &>/dev/null; then
            echo "Service is running"
        else
            echo "Service is not running"
        fi
        ;;
    --id)
        # Get process ID of nsurlsessiond
        PID=$(pgrep nsurlsessiond)
        if [ -z "$PID" ]; then
            echo "nsurlsessiond is not running"
        else
            echo "nsurlsessiond PID: $PID"
        fi
        ;;
    *)
        echo "Usage: $0 [--start|--stop|--logs|--status|--id]"
        echo "Options:"
        echo "  --start   Start the nsurlsessiond killer service"
        echo "  --stop    Stop the service"
        echo "  --logs    View service logs"
        echo "  --status  Check service status"
        echo "  --id      Get process ID of nsurlsessiond"
        exit 1
        ;;
esac