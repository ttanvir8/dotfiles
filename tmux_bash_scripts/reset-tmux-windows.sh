#!/usr/bin/env bash

# Script to reset tmux window names
# This script provides options to reset window names to:
# 1. Default numbers (0, 1, 2, etc.)
# 2. Directory names (based on current path)
# 3. Custom names

# Check if we're in a tmux session
if [[ -z $TMUX ]]; then
    echo "Error: Not in a tmux session"
    echo "Please start or attach to a tmux session first"
    exit 1
fi

# Get the current session name
session_name=$(tmux display-message -p "#{session_name}")
echo "Current session: $session_name"

# Function to reset windows to default numbers
reset_to_numbers() {
    # Get the list of windows in the current session
    windows=$(tmux list-windows -t "$session_name" -F "#{window_index}")
    
    # Loop through each window and rename it to its default name (the index number)
    for window_index in $windows; do
        tmux rename-window -t "$session_name:$window_index" "$window_index"
        echo "Reset window $window_index to default name: $window_index"
    done
    
    echo "All windows have been reset to their default numbers"
}

# Function to reset windows to directory names
reset_to_directories() {
    # Get the list of windows with their indices and current paths
    window_info=$(tmux list-windows -t "$session_name" -F "#{window_index}|#{pane_current_path}")
    
    # Loop through each window and rename it to the basename of its current path
    while IFS='|' read -r window_index path; do
        dir_name=$(basename "$path")
        tmux rename-window -t "$session_name:$window_index" "$dir_name"
        echo "Reset window $window_index to directory name: $dir_name"
    done <<< "$window_info"
    
    echo "All windows have been reset to their directory names"
}

# Function to rename a specific window
rename_specific_window() {
    read -p "Enter window index to rename: " window_index
    read -p "Enter new name for window $window_index: " new_name
    
    if tmux list-windows -t "$session_name" -F "#{window_index}" | grep -q "^$window_index$"; then
        tmux rename-window -t "$session_name:$window_index" "$new_name"
        echo "Window $window_index renamed to: $new_name"
    else
        echo "Error: Window index $window_index does not exist"
    fi
}

# Display current windows
echo "\nCurrent windows:"
tmux list-windows -t "$session_name"

# Menu
echo "\nReset window names options:"
echo "1. Reset all windows to default numbers (0, 1, 2, etc.)"
echo "2. Reset all windows to directory names"
echo "3. Rename a specific window"
echo "4. Exit"

read -p "Select an option (1-4): " option

case $option in
    1) reset_to_numbers ;;
    2) reset_to_directories ;;
    3) rename_specific_window ;;
    4) echo "Exiting without changes" ;;
    *) echo "Invalid option" ;;
esac

echo "\nNote: You can manually rename a window at any time using: tmux rename-window [new-name]"
echo "Or press prefix + , (comma) to rename the current window"