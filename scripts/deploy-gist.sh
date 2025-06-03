#!/bin/bash
# Deploy installation files to GitHub Gist (public) while keeping repo private

set -e

echo "🚀 Deploying Claude Code Tools to public gist..."

# Create temporary directory for gist files
TEMP_DIR=$(mktemp -d)
trap "rm -rf $TEMP_DIR" EXIT

# Create the main installer
cat > "$TEMP_DIR/install.sh" << 'EOF'
#!/bin/bash
# Claude Code Tools - Public Installer
# Installs from GitHub Gist (works with private repos)

set -e

echo "⚡ Installing Claude Code Tools..."

# Configuration
GIST_ID="${CLAUDE_TOOLS_GIST_ID:-YOUR_GIST_ID_HERE}"
GIST_URL="https://gist.githubusercontent.com/hikarubw/$GIST_ID/raw"

# Create directories
mkdir -p .claude/{tools,commands,tasks}

# Download files from gist
download_file() {
    local file=$1
    local dest=$2
    echo "  📥 $file"
    curl -fsSL "$GIST_URL/$file" -o "$dest" 2>/dev/null || {
        echo "Failed to download $file"
        return 1
    }
    [ -x "$dest" ] || chmod +x "$dest" 2>/dev/null || true
}

# Download all tools
for tool in task session github maintain oauth-setup; do
    download_file "tool-$tool.sh" ".claude/tools/$tool" &
done

# Download all commands
for cmd in setup work status manual maintain auto setup-oauth; do
    download_file "cmd-$cmd.md" ".claude/commands/$cmd.md" &
done

# Wait for downloads
wait

# Create settings
cat > .claude/settings.local.json << 'SETTINGS'
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
SETTINGS

# Create launcher
cat > claude << 'LAUNCHER'
#!/bin/bash
if [ -z "$1" ]; then
    ls .claude/tools | sed 's/^/  /'
else
    exec "$(dirname "$0")/.claude/tools/$@"
fi
LAUNCHER
chmod +x claude

echo "✅ Installation complete!"
echo ""
echo "In Claude Code: /project:setup"
echo "In terminal: ./claude task add 123"
EOF

# Copy all tools with gist-friendly names
for tool in tools/*; do
    if [ -f "$tool" ]; then
        name=$(basename "$tool")
        cp "$tool" "$TEMP_DIR/tool-$name.sh"
    fi
done

# Copy all commands with gist-friendly names
for cmd in commands/*.md; do
    if [ -f "$cmd" ]; then
        name=$(basename "$cmd")
        cp "$cmd" "$TEMP_DIR/cmd-$name"
    fi
done

# Create a README for the gist
cat > "$TEMP_DIR/README.md" << 'EOF'
# Claude Code Tools - Installation Files

This gist contains the installation files for Claude Code Tools.

## Quick Install

```bash
curl -fsSL https://gist.githubusercontent.com/hikarubw/GIST_ID_HERE/raw/install.sh | bash
```

## What is this?

These are the tools and commands for Claude Code Tools, a suite of simple bash scripts that help Claude Code manage parallel development workflows.

## Files

- `install.sh` - The installer script
- `tool-*.sh` - Individual tools (task, session, github, etc.)
- `cmd-*.md` - Slash command documentation

## More Info

See the main project for documentation (private repo).
EOF

echo ""
echo "📦 Files prepared in: $TEMP_DIR"
echo ""
echo "Next steps:"
echo "1. Create a new public gist at: https://gist.github.com"
echo "2. Upload all files from $TEMP_DIR"
echo "3. Copy the gist ID from the URL"
echo "4. Update install.sh with your gist ID"
echo "5. Share the install command:"
echo ""
echo "   curl -fsSL https://gist.githubusercontent.com/YOUR_USERNAME/GIST_ID/raw/install.sh | bash"
echo ""
echo "Opening directory..."
open "$TEMP_DIR" 2>/dev/null || echo "Files at: $TEMP_DIR"