#!/bin/bash
# Claude Code Parallel - Installer
# 
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-parallel/main/install.sh | bash
#   bash install.sh [--help]

set -e

# Configuration
REPO="hikarubw/claude-code-parallel"
BASE_URL="https://raw.githubusercontent.com/$REPO/main"
VERSION="1.0.0"

# Colors
BLUE='\033[0;34m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

# Parse arguments
for arg in "$@"; do
    case $arg in
        --help|-h)
            echo "Claude Code Parallel Installer v$VERSION"
            echo ""
            echo "Usage:"
            echo "  install.sh          Install in current project"
            echo "  install.sh --help   Show this help"
            echo ""
            echo "The installer automatically detects whether to install"
            echo "for the current project (if in git repo) or globally."
            exit 0
            ;;
    esac
done

echo -e "${BLUE}Claude Code Parallel - Installer${NC}"
echo ""

# Smart detection
if [ -d ".git" ] || [ -f ".claude/settings.local.json" ]; then
    echo -e "${GREEN}✓ Git repository detected${NC}"
    echo "Installing for this project..."
    INSTALL_DIR=".claude"
    INSTALL_TYPE="project"
else
    echo "No git repository found."
    echo ""
    echo "1) Initialize git and install here"
    echo "2) Install globally (for all projects)"
    echo "3) Cancel"
    echo ""
    read -p "Choice [1-3]: " choice
    
    case $choice in
        1)
            git init
            INSTALL_DIR=".claude"
            INSTALL_TYPE="project"
            ;;
        2)
            INSTALL_DIR="$HOME/.claude-code-tools"
            INSTALL_TYPE="global"
            ;;
        *)
            echo "Installation cancelled."
            exit 0
            ;;
    esac
fi

# Create directories
mkdir -p "$INSTALL_DIR"/{tools,commands,tasks}

# Function to download with retry
download_file() {
    local url=$1
    local dest=$2
    local retries=3
    
    while [ $retries -gt 0 ]; do
        if curl -fsSL "$url" -o "$dest" 2>/dev/null; then
            [ -x "$dest" ] || chmod +x "$dest" 2>/dev/null
            return 0
        fi
        ((retries--))
        [ $retries -gt 0 ] && sleep 1
    done
    return 1
}

# Download tools
echo "Downloading tools..."
for tool in task session github maintain; do
    if download_file "$BASE_URL/tools/$tool" "$INSTALL_DIR/tools/$tool"; then
        echo -e "  ${GREEN}✓${NC} $tool"
    else
        echo -e "  ${RED}✗${NC} $tool (failed)"
    fi
done

# Download commands
echo "Downloading commands..."
for cmd in setup work status manual maintain auto; do
    if download_file "$BASE_URL/commands/$cmd.md" "$INSTALL_DIR/commands/$cmd.md"; then
        echo -e "  ${GREEN}✓${NC} /project:$cmd"
    else
        echo -e "  ${RED}✗${NC} /project:$cmd (failed)"
    fi
done

# Create settings file
cat > "$INSTALL_DIR/settings.local.json" << 'EOF'
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
EOF

# Project-specific setup
if [ "$INSTALL_TYPE" = "project" ]; then
    # Create launcher script
    cat > claude-tools << 'EOF'
#!/bin/bash
# Claude Code Tools Launcher
if [ -z "$1" ]; then
    echo "Claude Code Tools - Available tools:"
    ls .claude/tools 2>/dev/null | sed 's/^/  /'
else
    exec ".claude/tools/$@"
fi
EOF
    chmod +x claude-tools
    
    echo ""
    echo -e "${GREEN}✅ Installation complete!${NC}"
    echo ""
    echo "Usage in Claude Code:"
    echo "  /project:setup    - Initialize project"
    echo "  /project:work 5   - Start parallel development"
    echo "  /project:status   - View progress"
    echo ""
    echo "Usage in terminal:"
    echo "  ./claude-tools task add 123"
    echo "  ./claude-tools session start"
else
    # Global installation
    echo ""
    echo -e "${GREEN}✅ Global installation complete!${NC}"
    echo ""
    echo "Add to your shell profile:"
    echo "  export PATH=\"\$PATH:$INSTALL_DIR/tools\""
    echo ""
    echo "Then in any project:"
    echo "  cd your-project"
    echo "  claude-parallel-install"
    
    # Create installer symlink
    cat > "$INSTALL_DIR/claude-parallel-install" << 'EOF'
#!/bin/bash
curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-parallel/main/install.sh | bash
EOF
    chmod +x "$INSTALL_DIR/claude-parallel-install"
fi

echo ""
echo -e "${BLUE}Happy coding with Claude! 🚀${NC}"