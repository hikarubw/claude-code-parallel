#!/bin/bash
# Create a self-contained installer bundle for private repos

set -e

echo "Creating installer bundle..."

# Create bundle directory
BUNDLE_DIR="dist"
rm -rf "$BUNDLE_DIR"
mkdir -p "$BUNDLE_DIR"

# Create the installer script with embedded files
cat > "$BUNDLE_DIR/install.sh" << 'INSTALLER_HEADER'
#!/bin/bash
# Claude Code Tools - Self-Contained Installer
# This file includes all tools and commands

set -e

echo "⚡ Installing Claude Code Tools..."

# Create directories
mkdir -p .claude/{tools,commands,tasks}

# Extract embedded files
extract_file() {
    local marker=$1
    local output=$2
    awk "/^#===BEGIN:$marker===/{flag=1;next}/^#===END:$marker===/{flag=0}flag" "$0" > "$output"
    [ -f "$output" ] && chmod +x "$output" 2>/dev/null || true
}

# Extract all tools
INSTALLER_HEADER

# Embed each tool
for tool in tools/*; do
    if [ -f "$tool" ]; then
        name=$(basename "$tool")
        echo "extract_file \"TOOL:$name\" \".claude/tools/$name\"" >> "$BUNDLE_DIR/install.sh"
    fi
done

# Embed each command
for cmd in commands/*.md; do
    if [ -f "$cmd" ]; then
        name=$(basename "$cmd")
        echo "extract_file \"CMD:$name\" \".claude/commands/$name\"" >> "$BUNDLE_DIR/install.sh"
    fi
done

# Continue installer script
cat >> "$BUNDLE_DIR/install.sh" << 'INSTALLER_MIDDLE'

# Create settings file
cat > .claude/settings.local.json << 'EOF'
{
  "permissions": {
    "allow": [
      "Bash(git:*)",
      "Bash(gh:*)",
      "Bash(tmux:*)",
      "Bash(npm:*)",
      "Bash(.claude/tools/*:*)"
    ],
    "deny": []
  }
}
EOF

# Create launcher
cat > claude << 'EOF'
#!/bin/bash
if [ -z "$1" ]; then
    echo "Claude Code Tools - Usage:"
    echo "  ./claude task add 123"
    echo "  ./claude session start 3"
    echo ""
    echo "Or in Claude Code:"
    echo "  /project:setup"
else
    exec "$(dirname "$0")/.claude/tools/$@"
fi
EOF
chmod +x claude

echo "✅ Installation complete!"
echo ""
echo "Next steps:"
echo "1. Open this folder in Claude Code"
echo "2. Run: /project:setup"

exit 0

# Embedded files below
INSTALLER_MIDDLE

# Now embed all the files
for tool in tools/*; do
    if [ -f "$tool" ]; then
        name=$(basename "$tool")
        echo "#===BEGIN:TOOL:$name===" >> "$BUNDLE_DIR/install.sh"
        cat "$tool" >> "$BUNDLE_DIR/install.sh"
        echo "#===END:TOOL:$name===" >> "$BUNDLE_DIR/install.sh"
    fi
done

for cmd in commands/*.md; do
    if [ -f "$cmd" ]; then
        name=$(basename "$cmd")
        echo "#===BEGIN:CMD:$name===" >> "$BUNDLE_DIR/install.sh"
        cat "$cmd" >> "$BUNDLE_DIR/install.sh"
        echo "#===END:CMD:$name===" >> "$BUNDLE_DIR/install.sh"
    fi
done

chmod +x "$BUNDLE_DIR/install.sh"

echo "✅ Bundle created at: $BUNDLE_DIR/install.sh"
echo ""
echo "To use:"
echo "1. Copy $BUNDLE_DIR/install.sh to your project"
echo "2. Run: bash install.sh"
echo ""
echo "Or distribute via:"
echo "- Email attachment"
echo "- Private file sharing"
echo "- Internal package registry"