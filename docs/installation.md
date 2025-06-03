# Installation Guide

## Prerequisites

Required:
- Git repository (or willing to `git init`)
- Bash shell
- Claude Code

Recommended:
- GitHub CLI (`gh`) - for GitHub integration
- tmux - for parallel sessions

## Installation Methods

### 1. Quick Install (Recommended)

```bash
# In your project directory
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/install.sh | bash
```

### 2. Offline/Private Install

If your repository is private or you need offline installation:

```bash
# Generate self-contained installer
git clone https://github.com/hikarubw/claude-code-tools.git
cd claude-code-tools
./scripts/bundle.sh

# Copy dist/install.sh to your project
cp dist/install.sh /path/to/your/project/
cd /path/to/your/project
bash install.sh
```

### 3. Manual Install

```bash
# Clone repository
git clone https://github.com/hikarubw/claude-code-tools.git
cd claude-code-tools

# Run installer
./install.sh
```

### 4. Global Install

Install once for all projects:

```bash
# Run installer with global option
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/install.sh | bash

# Choose option 2 when prompted
```

Then add to your shell profile:
```bash
export PATH="$PATH:$HOME/.claude-code-tools/tools"
```

## What Gets Installed

```
your-project/
├── .claude/
│   ├── tools/          # Executable tools
│   │   ├── task        # Task queue management
│   │   ├── session     # tmux session control
│   │   ├── github      # GitHub integration
│   │   ├── maintain    # Cleanup utilities
│   │   └── oauth-setup # OAuth configuration
│   ├── commands/       # Slash command documentation
│   │   ├── setup.md
│   │   ├── work.md
│   │   ├── status.md
│   │   └── ...
│   ├── tasks/          # Runtime data
│   └── settings.local.json
└── claude-tools        # Local launcher script
```

## Permissions

The installer creates `.claude/settings.local.json` with:

```json
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(tmux:*)",
      "Bash(npm:*)",
      "Bash(node:*)",
      "Bash(.claude/tools/*:*)"
    ],
    "deny": []
  }
}
```

Adjust as needed for your security requirements.

## Verification

After installation:

```bash
# Check tools are accessible
./claude-tools

# Should list available tools:
#   task
#   session
#   github
#   maintain
#   oauth-setup
```

## Troubleshooting

### "Permission denied"
```bash
chmod +x .claude/tools/*
chmod +x claude-tools
```

### "Not in a git repository"
```bash
git init
# Then run installer again
```

### "Command not found: gh"
GitHub CLI is optional but recommended:
```bash
# macOS
brew install gh

# Linux/WSL
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null
sudo apt update
sudo apt install gh
```

### "Command not found: tmux"
tmux is optional but recommended:
```bash
# macOS
brew install tmux

# Linux/WSL  
sudo apt install tmux
```

## Uninstallation

```bash
# Remove from project
rm -rf .claude claude-tools

# Remove global installation
rm -rf ~/.claude-code-tools
```

## Updating

To update to the latest version:

```bash
# Just run the installer again
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-tools/main/install.sh | bash
```

The installer will overwrite existing files with the latest versions.