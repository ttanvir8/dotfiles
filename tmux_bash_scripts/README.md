# Tmux Productivity Toolkit

A comprehensive collection of scripts and configurations to supercharge your tmux workflow. This toolkit provides intelligent session management, directory-based navigation, and enhanced window/pane operations to make terminal multiplexing more efficient and intuitive.

## Features

- **Smart Session Management**: Create and switch between sessions based on project directories
- **Recent Session Access**: Quickly access your most recently used tmux sessions
- **Session Queue System**: Maintain a queue of favorite sessions for instant switching
- **Directory-Based Navigation**: Open directories directly in new windows and panes
- **Intelligent Window Naming**: Automatic and manual window name management
- **Fuzzy Finding Integration**: Uses fzf for interactive selection interfaces

## Scripts Overview

### Core Scripts

| Script | Purpose | Key Features |
|--------|---------|--------------|
| `tmux-sessionizer` | Project-based session management | Creates sessions from directories, switches between them |
| `tmux-recent` | Access recent sessions | Shows last 30 sessions with timestamps, fuzzy search |
| `tmux-queue` | Session queue management | Add/remove/switch sessions via keyboard shortcuts |
| `tmux-window` | Open directories in windows | Creates new windows with specific directory context |
| `tmux-pane` | Create directory-aware panes | Splits windows with horizontal/vertical layout options |
| `reset-tmux-windows.sh` | Window naming management | Reset names to numbers, directories, or custom names |

### Utility Scripts

- `finder-opener` - Integration with system finder
- `reset-window-names.sh` - Quick window name reset
- `disable-auto-rename.conf` - Configuration to disable automatic renaming

## Installation

1. **Clone or copy the scripts** to a directory in your PATH:
   ```bash
   # Option 1: Copy to ~/bin or /usr/local/bin
   cp tmux-* ~/bin/

   # Option 2: Create a directory and add to PATH
   mkdir -p ~/.local/bin
   cp tmux-* ~/.local/bin/
   echo 'export PATH="$HOME/.local/bin:$PATH"' >> ~/.zshrc
   ```

2. **Make scripts executable**:
   ```bash
   chmod +x ~/bin/tmux-*
   ```

3. **Install dependencies**:
   ```bash
   # macOS
   brew install fzf tmux

   # Ubuntu/Debian
   sudo apt install fzf tmux

   # Or using your preferred package manager
   ```

## Configuration

### Basic Tmux Configuration

Add to your `~/.tmux.conf`:

```bash
# Disable automatic renaming
set-option -g allow-rename off
set-option -g automatic-rename off

# Optional: Enable automatic directory-based naming
# set-option -g automatic-rename on
# set-option -g automatic-rename-format '#{b:pane_current_path}'
```

### Recommended Keybindings

Add these to your shell configuration (`~/.zshrc` or `~/.bashrc`):

```bash
# Session Management
bindkey -s '^f' 'tmux-sessionizer\n'  # Ctrl+f - Create/switch session
bindkey -s '^e' 'tmux-recent\n'      # Ctrl+e - Recent sessions

# Window/Pane Operations
bindkey -s '^n' 'tmux-window\n'      # Ctrl+n - New window with directory
bindkey -s '^p' 'tmux-pane\n'        # Ctrl+p - New pane with directory
bindkey -s '^h' 'tmux-pane h\n'      # Ctrl+h - Horizontal split
bindkey -s '^v' 'tmux-pane v\n'      # Ctrl+v - Vertical split
```

## Usage

### Session Management

#### tmux-sessionizer
Create or switch to tmux sessions based on directories:

```bash
# Interactive mode (shows fzf picker)
tmux-sessionizer

# Direct usage (if not in tmux, creates new session)
tmux-sessionizer ~/projects/my-project
```

**What it does:**
- Searches `~/code`, `~/fun`, and `~` for directories
- Creates a new session if one doesn't exist for the selected directory
- Switches to the session (or attaches if not in tmux)
- Uses the directory basename as session name (replacing dots with underscores)

#### tmux-recent
Access your most recently used sessions:

```bash
tmux-recent
```

**Features:**
- Shows last 30 sessions with last-attached timestamps
- Interactive fuzzy search with fzf
- Works both inside and outside tmux
- Automatically attaches or switches to selected session

#### tmux-queue
Manage a queue of favorite sessions for quick access:

```bash
# Add current session to queue
tmux-queue add

# Remove current session from queue
tmux-queue delete

# Switch to queued session by key (a, s, d, f)
tmux-queue switch a  # Switch to first queued session
tmux-queue switch s  # Switch to second queued session
```

### Window and Pane Operations

#### tmux-window
Open directories in new tmux windows:

```bash
# Interactive directory selection
tmux-window

# Open specific directory
tmux-window ~/projects/api-server
```

**Features:**
- Creates new window after the current highest window number
- Opens with the selected directory as working directory
- Must be run from within a tmux session

#### tmux-pane
Create new panes with directory context:

```bash
# Interactive directory selection (horizontal split)
tmux-pane

# Vertical split
tmux-pane ~/config v

# Horizontal split (default)
tmux-pane ~/projects h
```

### Window Name Management

#### reset-tmux-windows.sh
Interactive script to manage window names:

```bash
./reset-tmux-windows.sh
```

**Options:**
1. Reset all windows to default numbers (0, 1, 2, etc.)
2. Reset all windows to directory names
3. Rename a specific window
4. Exit

#### Manual Window Naming
```bash
# Rename current window
tmux rename-window "new-name"

# Rename specific window
tmux rename-window -t session_name:window_index "new-name"

# Using tmux prefix key + comma (,)
<prefix> + ,
```

## Configuration Files

### TMUX-WINDOW-NAMING.md
Comprehensive guide for tmux window naming strategies and best practices.

### tmux.conf
Configuration for automatic directory-based window naming:

```bash
# Enable automatic directory naming
set-option -g automatic-rename on
set-option -g automatic-rename-format '#{b:pane_current_path}'
```

### disable-auto-rename.conf
Configuration to prevent automatic window renaming:

```bash
set-option -g allow-rename off
set-option -g automatic-rename off
```

## Advanced Usage

### Custom Directory Search Paths

Edit the scripts to customize which directories are searched:

**tmux-sessionizer:**
```bash
session=$(find ~ ~/code ~/fun ~/work -mindepth 1 -maxdepth 1 -type d | fzf)
```

**tmux-window & tmux-pane:**
```bash
selected=$(find ~/.config ~/code ~/fun ~/personal ~/work ~/research -mindepth 0 -maxdepth 5 -type d | fzf)
```

### Integration with Shell

Add these functions to your shell configuration for enhanced functionality:

```bash
# Quick session switching
function ts() {
    if [ -z "$1" ]; then
        tmux-sessionizer
    else
        tmux new-session -s "$1" -c "$1" 2>/dev/null || tmux switch-client -t "$1"
    fi
}

# Enhanced pane creation with layout
function tp() {
    if [ -z "$1" ]; then
        tmux-pane
    else
        tmux-pane "$1" "${2:-h}"
    fi
}
```

### Workflow Optimization

#### Development Workflow
```bash
# 1. Start new session for project
tmux-sessionizer

# 2. Open editor in main pane
# 3. Create horizontal split for terminal
tmux-pane h

# 4. Create vertical split for logs/testing
tmux-pane v
```

#### Multi-Project Management
```bash
# Add frequently used projects to queue
cd ~/projects/api-server && tmux-sessionizer
tmux-queue add

cd ~/projects/frontend && tmux-sessionizer
tmux-queue add

# Quick switching with single keypress
tmux-queue switch a  # Switch to API server
tmux-queue switch s  # Switch to frontend
```

## Dependencies

- **tmux** - Terminal multiplexer
- **fzf** - Fuzzy finder for interactive selection
- **bash** - Shell environment
- **coreutils** - Basic Unix utilities (basename, dirname, etc.)

## Troubleshooting

### Common Issues

1. **"Not in a tmux session" error**
   - Ensure you're running the command from within tmux
   - Use `tmux` to start a new session if needed

2. **Scripts not found**
   - Verify scripts are in your PATH
   - Check file permissions with `ls -la tmux-*`
   - Make sure scripts are executable

3. **fzf not working**
   - Install fzf: `brew install fzf` (macOS) or `sudo apt install fzf` (Ubuntu)
   - Ensure fzf is accessible in your PATH

4. **Directory not found**
   - Check if the directory exists and has proper permissions
   - Modify search paths in scripts for your directory structure

### Debug Mode

Enable verbose output for debugging:

```bash
# Add to scripts for debugging
set -x  # Enable debug mode
# ... script content ...
set +x  # Disable debug mode
```

## Contributing

Feel free to submit issues, feature requests, or pull requests to improve this toolkit.

## License

This toolkit is provided as-is for personal use. Feel free to modify and adapt the scripts to your needs.
