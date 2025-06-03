#!/bin/bash
# Claude Code Parallel - Simplified Installer v2
# 
# Usage:
#   curl -fsSL https://raw.githubusercontent.com/hikarubw/claude-code-parallel/main/install.sh | bash
#   bash install.sh [--uninstall] [--help]

set -euo pipefail

# Configuration
readonly REPO="hikarubw/claude-code-parallel"
readonly VERSION="1.0.1"
readonly BASE_URL="https://raw.githubusercontent.com/$REPO/main"

# Tools and commands to install
readonly TOOLS=(task session github maintain setup-autonomous)
readonly COMMANDS=(setup work status manual maintain auto)

# Colors
readonly RED='\033[0;31m'
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Error handling
trap 'echo -e "${RED}Installation failed on line $LINENO${NC}" >&2' ERR

# Helper functions
log() {
    echo -e "${BLUE}[Claude Parallel]${NC} $*"
}

success() {
    echo -e "${GREEN}✓${NC} $*"
}

error() {
    echo -e "${RED}✗${NC} $*" >&2
}

warn() {
    echo -e "${YELLOW}⚠${NC} $*"
}

# Check if command exists
has_command() {
    command -v "$1" >/dev/null 2>&1
}

# Download with retry
download_file() {
    local url=$1
    local dest=$2
    local retries=3
    
    while [ $retries -gt 0 ]; do
        if curl -fsSL "$url" -o "$dest" 2>/dev/null; then
            return 0
        fi
        ((retries--))
        [ $retries -gt 0 ] && sleep 1
    done
    return 1
}

# Verify installation
verify_installation() {
    local errors=0
    
    log "Verifying installation..."
    
    # Check tools
    for tool in "${TOOLS[@]}"; do
        if [ -x ".claude/tools/$tool" ]; then
            success "Tool: $tool"
        else
            error "Missing tool: $tool"
            ((errors++))
        fi
    done
    
    # Check commands
    for cmd in "${COMMANDS[@]}"; do
        if [ -f ".claude/commands/$cmd.md" ]; then
            success "Command: /project:$cmd"
        else
            error "Missing command: $cmd"
            ((errors++))
        fi
    done
    
    # Check settings
    if [ -f ".claude/settings.local.json" ]; then
        success "Settings file"
    else
        error "Missing settings file"
        ((errors++))
    fi
    
    return $errors
}

# Uninstall function
uninstall() {
    log "Uninstalling Claude Code Parallel..."
    
    if [ -d ".claude" ]; then
        rm -rf .claude
        success "Removed .claude directory"
    fi
    
    if [ -f "claude-tools" ]; then
        rm -f claude-tools
        success "Removed launcher script"
    fi
    
    log "Uninstall complete"
}

# Show help
show_help() {
    cat << EOF
Claude Code Parallel Installer v$VERSION

Usage:
  install.sh              Install in current directory
  install.sh --uninstall  Remove installation
  install.sh --help       Show this help

Requirements:
  - Git repository (or will offer to create one)
  - Bash shell
  - curl

The installer will:
  1. Check/create git repository
  2. Download tools and commands
  3. Set up permissions
  4. Create launcher script
  5. Verify installation

Learn more: https://github.com/$REPO
EOF
}

# Main installation
install() {
    log "Claude Code Parallel Installer v$VERSION"
    echo ""
    
    # Check git repository
    if [ ! -d ".git" ]; then
        warn "Not in a git repository"
        echo ""
        read -p "Initialize git repository here? [y/N] " -n 1 -r
        echo
        if [[ $REPLY =~ ^[Yy]$ ]]; then
            git init
            success "Initialized git repository"
        else
            error "Claude Code Parallel requires a git repository"
            exit 1
        fi
    else
        success "Git repository detected"
    fi
    
    # Create directories
    log "Creating directories..."
    mkdir -p .claude/{tools,commands,tasks}
    success "Directory structure created"
    
    # Download tools
    log "Downloading tools..."
    local failed=0
    for tool in "${TOOLS[@]}"; do
        printf "  %-20s" "$tool"
        if download_file "$BASE_URL/tools/$tool" ".claude/tools/$tool"; then
            chmod +x ".claude/tools/$tool"
            success "downloaded"
        else
            error "failed"
            ((failed++))
        fi
    done
    
    # Download commands
    log "Downloading commands..."
    for cmd in "${COMMANDS[@]}"; do
        printf "  %-20s" "/project:$cmd"
        if download_file "$BASE_URL/commands/$cmd.md" ".claude/commands/$cmd.md"; then
            success "downloaded"
        else
            error "failed"
            ((failed++))
        fi
    done
    
    if [ $failed -gt 0 ]; then
        warn "$failed downloads failed - installation may be incomplete"
    fi
    
    # Create settings file
    log "Creating settings file..."
    cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(tmux:*)",
      "Bash(.claude/tools/*:*)"
    ],
    "deny": []
  }
}
EOF
    success "Settings configured"
    
    # Create launcher script
    log "Creating launcher script..."
    cat > claude-tools << 'EOF'
#!/bin/bash
# Claude Code Parallel - Tool Launcher

if [ -z "$1" ]; then
    echo "Claude Code Parallel - Available tools:"
    for tool in .claude/tools/*; do
        [ -f "$tool" ] && echo "  $(basename "$tool")"
    done
    echo ""
    echo "Usage: ./claude-tools <tool> [args]"
    echo "Example: ./claude-tools task add 123"
else
    tool=".claude/tools/$1"
    if [ -x "$tool" ]; then
        shift
        exec "$tool" "$@"
    else
        echo "Error: Unknown tool '$1'"
        echo "Run ./claude-tools to see available tools"
        exit 1
    fi
fi
EOF
    chmod +x claude-tools
    success "Launcher created"
    
    # Create version file
    echo "$VERSION" > .claude/VERSION
    
    # Verify installation
    echo ""
    if verify_installation; then
        echo ""
        log "${GREEN}Installation complete!${NC}"
        echo ""
        echo "Next steps:"
        echo "  1. Open this directory in Claude Code"
        echo "  2. Run: /project:setup"
        echo ""
        echo "Manual usage:"
        echo "  ./claude-tools task add 123"
        echo "  ./claude-tools session start 3"
    else
        echo ""
        error "Installation incomplete - some files are missing"
        echo "Try running the installer again or check your internet connection"
        exit 1
    fi
}

# Main entry point
main() {
    case "${1:-}" in
        --uninstall)
            uninstall
            ;;
        --help|-h)
            show_help
            ;;
        "")
            install
            ;;
        *)
            error "Unknown option: $1"
            show_help
            exit 1
            ;;
    esac
}

# Run main function
main "$@"