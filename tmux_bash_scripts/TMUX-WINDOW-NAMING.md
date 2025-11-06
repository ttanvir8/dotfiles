# Tmux Window Naming Guide

## Resetting Window Names

You have two options to reset your tmux window names:

### 1. Using the Script

I've created a script that gives you multiple options for resetting window names:

```bash
# Run the script while in a tmux session
./reset-tmux-windows.sh
```

The script will present you with these options:
- Reset all windows to default numbers (0, 1, 2, etc.)
- Reset all windows to directory names
- Rename a specific window

### 2. Manual Commands

You can also use these tmux commands directly:

#### Reset a specific window to default name
```bash
# While in tmux
tmux rename-window -t session_name:window_index window_index
```

#### Rename the current window
Press `prefix` + `,` (comma) and type the new name.

#### Rename a specific window
```bash
tmux rename-window -t session_name:window_index new_name
```

## Preventing Auto-Renaming in the Future

You've already added these lines to your `~/.tmux.conf` which will prevent automatic renaming:

```
set-option -g allow-rename off
set-option -g automatic-rename off
```

After making any changes to your tmux configuration, remember to reload it:
- Either run: `tmux source-file ~/.tmux.conf`
- Or use your configured shortcut: `prefix` + `r`

## Quick Reference

- **View all windows**: `tmux list-windows`
- **Rename current window**: `prefix` + `,` (comma)
- **Switch to window by number**: `prefix` + `window_number`
- **List all sessions**: `tmux list-sessions`