#!/usr/bin/env bash

# Script to reset tmux window names to their default values
# This will rename all windows in the current session to their default names
# based on the window index

# Check if we're in a tmux session
if [[ -z $TMUX ]]; then
    echo "Error: Not in a tmux session"
    echo "Please start or attach to a tmux session first"
    exit 1
fi

# Get the current session name
session_name=$(tmux display-message -p "#{session_name}")
echo "Resetting window names in session: $session_name"

# Get the list of windows in the current session
windows=$(tmux list-windows -t "$session_name" -F "#{window_index}")

# Loop through each window and rename it to its default name (the index number)
for window_index in $windows; do
    # Rename the window to its default name (just the index number)
    tmux rename-window -t "$session_name:$window_index" "$window_index"
    echo "Reset window $window_index to default name"
done

echo "All windows have been reset to their default names"
echo "Note: You can manually rename a window using: tmux rename-window [new-name]"