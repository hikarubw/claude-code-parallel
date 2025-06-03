#!/bin/bash
# Deploy to free CDN services (jsdelivr, unpkg, etc.)

set -e

echo "🚀 Creating CDN deployment package..."

# Create release directory
RELEASE_DIR="release"
rm -rf "$RELEASE_DIR"
mkdir -p "$RELEASE_DIR"

# Create package.json for npm (enables CDN access)
cat > package.json << EOF
{
  "name": "@hikarubw/claude-code-tools",
  "version": "1.0.0",
  "description": "Simple tools for Claude Code parallel development",
  "main": "install.js",
  "files": [
    "install.sh",
    "tools/",
    "commands/"
  ],
  "scripts": {
    "postinstall": "bash install.sh"
  },
  "keywords": ["claude", "ai", "tools", "development"],
  "author": "hikarubw",
  "license": "MIT",
  "repository": {
    "type": "git",
    "url": "https://github.com/hikarubw/claude-code-tools.git"
  }
}
EOF

# Create CDN-friendly installer
cat > install.sh << 'EOF'
#!/bin/bash
# Claude Code Tools - CDN Installer
# Works with: jsdelivr, unpkg, cdnjs

set -e

echo "⚡ Installing Claude Code Tools..."

# Detect CDN URL
if [ -n "$1" ]; then
    CDN_URL="$1"
elif command -v npm >/dev/null 2>&1; then
    # Use npm's CDN
    CDN_URL="https://unpkg.com/@hikarubw/claude-code-tools@latest"
else
    # Default to jsdelivr
    CDN_URL="https://cdn.jsdelivr.net/npm/@hikarubw/claude-code-tools@latest"
fi

# Create directories
mkdir -p .claude/{tools,commands,tasks}

# Download files
echo "Downloading from CDN..."
BASE_URL="$CDN_URL"

# Tools
for tool in task session github maintain oauth-setup; do
    curl -fsSL "$BASE_URL/tools/$tool" -o ".claude/tools/$tool" 2>/dev/null && \
    chmod +x ".claude/tools/$tool" && \
    echo "  ✓ $tool" || echo "  ✗ $tool"
done

# Commands
for cmd in setup work status manual maintain auto setup-oauth; do
    curl -fsSL "$BASE_URL/commands/$cmd.md" -o ".claude/commands/$cmd.md" 2>/dev/null && \
    echo "  ✓ $cmd" || echo "  ✗ $cmd"
done

# Settings
cat > .claude/settings.local.json << 'SETTINGS'
{"permissions":{"allow":["Bash(*:*)"]}}
SETTINGS

# Launcher
cat > claude << 'LAUNCHER'
#!/bin/bash
exec "$(dirname "$0")/.claude/tools/${1:?Usage: ./claude <tool> [args]}" "${@:2}"
LAUNCHER
chmod +x claude

echo "✅ Ready! Use /project:setup in Claude Code"
EOF

# Copy files
cp -r tools commands "$RELEASE_DIR/"
cp install.sh "$RELEASE_DIR/"

# Create README for npm
cat > "$RELEASE_DIR/README.md" << EOF
# Claude Code Tools

Install via CDN:

\`\`\`bash
# Via curl
curl -fsSL https://cdn.jsdelivr.net/npm/@hikarubw/claude-code-tools/install.sh | bash

# Or via unpkg
curl -fsSL https://unpkg.com/@hikarubw/claude-code-tools/install.sh | bash
\`\`\`

Then use \`/project:setup\` in Claude Code.
EOF

echo ""
echo "📦 CDN package prepared!"
echo ""
echo "To publish:"
echo "1. npm login"
echo "2. npm publish --access public"
echo ""
echo "Then users can install via:"
echo ""
echo "  curl -fsSL https://cdn.jsdelivr.net/npm/@hikarubw/claude-code-tools/install.sh | bash"
echo ""
echo "Or:"
echo ""
echo "  curl -fsSL https://unpkg.com/@hikarubw/claude-code-tools/install.sh | bash"