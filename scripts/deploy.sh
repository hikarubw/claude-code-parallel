#!/bin/bash
# Claude Code Parallel - Unified Deployment Script
#
# Usage:
#   ./scripts/deploy.sh bundle    Create self-contained installer
#   ./scripts/deploy.sh release   Create GitHub release
#   ./scripts/deploy.sh test      Test installation

set -euo pipefail

# Configuration
readonly REPO="hikarubw/claude-code-parallel"
readonly VERSION=$(cat .claude/VERSION 2>/dev/null || echo "1.0.0")

# Colors
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly YELLOW='\033[1;33m'
readonly NC='\033[0m'

# Create self-contained bundle
create_bundle() {
    echo -e "${BLUE}Creating self-contained installer...${NC}"
    
    local bundle_file="dist/claude-parallel-installer.sh"
    mkdir -p dist
    
    # Start with shebang and header
    cat > "$bundle_file" << 'HEADER'
#!/bin/bash
# Claude Code Parallel - Self-Contained Installer
# This file includes all tools and commands

set -euo pipefail

readonly VERSION="1.0.1"
readonly TOOLS=(task session github maintain)
readonly COMMANDS=(setup work status manual maintain auto)

# Colors
readonly GREEN='\033[0;32m'
readonly BLUE='\033[0;34m'
readonly NC='\033[0m'

echo -e "${BLUE}Claude Code Parallel - Offline Installer${NC}"

# Check git repo
if [ ! -d ".git" ]; then
    echo "Error: Not in a git repository"
    echo "Run: git init"
    exit 1
fi

# Create structure
mkdir -p .claude/{tools,commands,tasks}

# Extract embedded files
extract_file() {
    local marker=$1
    local output=$2
    sed -n "/^#===$marker:START===$/,/^#===$marker:END===$/p" "$0" | sed '1d;$d' > "$output"
    [ -f "$output" ] && chmod +x "$output" 2>/dev/null || true
}

echo "Installing tools..."
HEADER

    # Add extraction commands
    for tool in tools/*; do
        [ -f "$tool" ] || continue
        name=$(basename "$tool")
        echo "extract_file \"TOOL:$name\" \".claude/tools/$name\"" >> "$bundle_file"
        echo "echo \"  ✓ $name\"" >> "$bundle_file"
    done
    
    echo "" >> "$bundle_file"
    echo "echo \"Installing commands...\"" >> "$bundle_file"
    
    for cmd in commands/*.md; do
        [ -f "$cmd" ] || continue
        name=$(basename "$cmd" .md)
        echo "extract_file \"CMD:$name\" \".claude/commands/$name.md\"" >> "$bundle_file"
        echo "echo \"  ✓ /project:$name\"" >> "$bundle_file"
    done
    
    # Add footer
    cat >> "$bundle_file" << 'FOOTER'

# Create settings
cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(tmux:*)",
      "Bash(.claude/tools/*:*)"
    ]
  }
}
EOF

# Create launcher
cat > claude-tools << 'EOF'
#!/bin/bash
exec "$(dirname "$0")/.claude/tools/${1:?Usage: ./claude-tools <tool> [args]}" "${@:2}"
EOF
chmod +x claude-tools

# Create version file
echo "$VERSION" > .claude/VERSION

echo ""
echo -e "${GREEN}✅ Installation complete!${NC}"
echo "Run /project:setup in Claude Code"

exit 0

# Embedded files below
FOOTER

    # Embed all files
    for tool in tools/*; do
        [ -f "$tool" ] || continue
        name=$(basename "$tool")
        echo "#===TOOL:$name:START===" >> "$bundle_file"
        cat "$tool" >> "$bundle_file"
        echo "#===TOOL:$name:END===" >> "$bundle_file"
    done
    
    for cmd in commands/*.md; do
        [ -f "$cmd" ] || continue
        name=$(basename "$cmd" .md)
        echo "#===CMD:$name:START===" >> "$bundle_file"
        cat "$cmd" >> "$bundle_file"
        echo "#===CMD:$name:END===" >> "$bundle_file"
    done
    
    chmod +x "$bundle_file"
    
    echo -e "${GREEN}✓ Bundle created: $bundle_file${NC}"
    echo "  Size: $(wc -c < "$bundle_file" | xargs) bytes"
    echo "  Share this file for offline installation"
}

# Create GitHub release
create_release() {
    echo -e "${BLUE}Creating GitHub release v$VERSION...${NC}"
    
    # Check if gh is installed
    if ! command -v gh >/dev/null; then
        echo -e "${YELLOW}GitHub CLI (gh) not installed${NC}"
        echo "Install: brew install gh"
        exit 1
    fi
    
    # Create bundle first
    create_bundle
    
    # Create release notes
    local notes="Claude Code Parallel v$VERSION

Parallel development automation for Claude Code.

## Installation

\`\`\`bash
curl -fsSL https://github.com/$REPO/releases/download/v$VERSION/install.sh | bash
\`\`\`

Or download the self-contained installer for offline use.

## What's New
- Simplified installation process
- Improved error handling
- Version management
"
    
    # Create release
    gh release create "v$VERSION" \
        install.sh \
        dist/claude-parallel-installer.sh \
        --title "Claude Code Parallel v$VERSION" \
        --notes "$notes" \
        --repo "$REPO"
    
    echo -e "${GREEN}✓ Release created${NC}"
}

# Test installation
test_install() {
    echo -e "${BLUE}Testing installation...${NC}"
    
    # Create test directory
    local test_dir="test-install-$$"
    mkdir "$test_dir"
    cd "$test_dir"
    git init --quiet
    
    # Test online install
    echo "Testing online installation..."
    if bash ../install.sh; then
        echo -e "${GREEN}✓ Online installation successful${NC}"
        
        # Verify files
        if [ -x ".claude/tools/task" ] && [ -f ".claude/commands/setup.md" ]; then
            echo -e "${GREEN}✓ Files verified${NC}"
        else
            echo -e "${YELLOW}⚠ Some files missing${NC}"
        fi
    else
        echo -e "${YELLOW}✗ Online installation failed${NC}"
    fi
    
    # Cleanup
    cd ..
    rm -rf "$test_dir"
    
    # Test bundle if exists
    if [ -f "dist/claude-parallel-installer.sh" ]; then
        echo ""
        echo "Testing bundled installation..."
        test_dir="test-bundle-$$"
        mkdir "$test_dir"
        cd "$test_dir"
        git init --quiet
        
        if bash ../dist/claude-parallel-installer.sh; then
            echo -e "${GREEN}✓ Bundle installation successful${NC}"
        else
            echo -e "${YELLOW}✗ Bundle installation failed${NC}"
        fi
        
        cd ..
        rm -rf "$test_dir"
    fi
}

# Show usage
usage() {
    cat << EOF
Claude Code Parallel - Deployment Tool

Usage:
  ./scripts/deploy.sh bundle    Create self-contained installer
  ./scripts/deploy.sh release   Create GitHub release  
  ./scripts/deploy.sh test      Test installation
  ./scripts/deploy.sh help      Show this help

Examples:
  # Create offline installer
  ./scripts/deploy.sh bundle
  
  # Publish new release
  ./scripts/deploy.sh release
  
  # Test both online and offline installation
  ./scripts/deploy.sh test
EOF
}

# Main
case "${1:-help}" in
    bundle)
        create_bundle
        ;;
    release)
        create_release
        ;;
    test)
        test_install
        ;;
    help|--help|-h)
        usage
        ;;
    *)
        echo "Unknown command: $1"
        usage
        exit 1
        ;;
esac