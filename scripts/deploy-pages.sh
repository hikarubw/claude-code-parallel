#!/bin/bash
# Deploy installer to GitHub Pages (public) while keeping repo private

set -e

echo "🌐 Creating GitHub Pages installer..."

# Create gh-pages branch if needed
if ! git show-ref --verify --quiet refs/heads/gh-pages; then
    echo "Creating gh-pages branch..."
    git checkout --orphan gh-pages
    git rm -rf . 2>/dev/null || true
    git clean -fdx
else
    git checkout gh-pages
fi

# Create index.html with installer
cat > index.html << 'EOF'
<!DOCTYPE html>
<html>
<head>
    <title>Claude Code Tools Installer</title>
    <meta charset="utf-8">
    <style>
        body { 
            font-family: -apple-system, BlinkMacSystemFont, "Segoe UI", Helvetica, Arial, sans-serif;
            max-width: 800px;
            margin: 50px auto;
            padding: 20px;
            line-height: 1.6;
        }
        pre {
            background: #f6f8fa;
            padding: 16px;
            border-radius: 6px;
            overflow-x: auto;
        }
        code {
            background: #f6f8fa;
            padding: 2px 4px;
            border-radius: 3px;
        }
        .install-box {
            background: #0969da;
            color: white;
            padding: 20px;
            border-radius: 8px;
            text-align: center;
            margin: 30px 0;
        }
        .install-box code {
            background: rgba(255,255,255,0.2);
            color: white;
            font-size: 18px;
        }
    </style>
</head>
<body>
    <h1>Claude Code Tools</h1>
    <p>Simple tools for Claude Code to manage parallel development workflows.</p>
    
    <div class="install-box">
        <h2>Quick Install</h2>
        <pre><code>curl -fsSL https://YOUR_USERNAME.github.io/claude-code-tools/install.sh | bash</code></pre>
    </div>
    
    <h2>What is this?</h2>
    <p>Claude Code Tools provides simple bash scripts that Claude Code uses to:</p>
    <ul>
        <li>Manage parallel development sessions</li>
        <li>Track work queues and dependencies</li>
        <li>Handle GitHub integration</li>
        <li>Coordinate multiple git worktrees</li>
    </ul>
    
    <h2>Installation</h2>
    <pre><code># In your project directory
curl -fsSL https://YOUR_USERNAME.github.io/claude-code-tools/install.sh | bash

# Then in Claude Code
/project:setup</code></pre>
    
    <h2>Requirements</h2>
    <ul>
        <li>Git repository</li>
        <li>Bash shell</li>
        <li>Claude Code</li>
    </ul>
    
    <p>Optional: GitHub CLI (gh), tmux</p>
</body>
</html>
EOF

# Create the installer script
cat > install.sh << 'EOF'
#!/bin/bash
# Claude Code Tools - GitHub Pages Installer

set -e

echo "⚡ Installing Claude Code Tools..."

# Base URL for GitHub Pages
BASE_URL="https://YOUR_USERNAME.github.io/claude-code-tools"

# Create directories
mkdir -p .claude/{tools,commands,tasks}

# Download function with retry
download() {
    local url=$1
    local dest=$2
    local retries=3
    
    while [ $retries -gt 0 ]; do
        if curl -fsSL "$url" -o "$dest" 2>/dev/null; then
            chmod +x "$dest" 2>/dev/null || true
            return 0
        fi
        ((retries--))
        [ $retries -gt 0 ] && sleep 1
    done
    return 1
}

# Download all files
echo "Downloading tools..."
for tool in task session github maintain oauth-setup; do
    download "$BASE_URL/tools/$tool" ".claude/tools/$tool" || echo "Warning: Failed to download $tool"
done

echo "Downloading commands..."
for cmd in setup work status manual maintain auto setup-oauth; do
    download "$BASE_URL/commands/$cmd.md" ".claude/commands/$cmd.md" || echo "Warning: Failed to download $cmd"
done

# Create settings
cat > .claude/settings.local.json << 'SETTINGS'
{
  "permissions": {
    "allow": ["Bash(*:*)"]
  }
}
SETTINGS

# Create launcher
cat > claude << 'LAUNCHER'
#!/bin/bash
exec "$(dirname "$0")/.claude/tools/${1?Usage: ./claude <tool> [args]}" "${@:2}"
LAUNCHER
chmod +x claude

echo "✅ Installation complete!"
echo ""
echo "Next: /project:setup in Claude Code"
EOF

# Copy tools and commands
mkdir -p tools commands
cp ../tools/* tools/ 2>/dev/null || true
cp ../commands/* commands/ 2>/dev/null || true

# Create .nojekyll to serve files with underscores
touch .nojekyll

# Commit and push
git add -A
git commit -m "Update Claude Code Tools installer" || true

echo ""
echo "📋 Next steps:"
echo ""
echo "1. Update USERNAME in index.html and install.sh"
echo "2. Push to GitHub:"
echo "   git push origin gh-pages"
echo ""
echo "3. Enable GitHub Pages:"
echo "   - Go to Settings → Pages"
echo "   - Source: Deploy from branch"
echo "   - Branch: gh-pages / root"
echo ""
echo "4. Share the install command:"
echo "   curl -fsSL https://YOUR_USERNAME.github.io/claude-code-tools/install.sh | bash"
echo ""

# Return to main branch
git checkout main