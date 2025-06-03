# Contributing to Claude Code Parallel

Thank you for your interest in contributing! This project follows a "Claude-first" philosophy where simplicity is key.

## 🎯 Core Principles

Before contributing, please understand:

1. **Keep Tools Simple** - Each tool should do ONE thing well
2. **Let Claude Be Smart** - Intelligence belongs in Claude, not scripts
3. **Maintain Clarity** - Code should be obvious, not clever
4. **Test in Isolation** - Each tool should work independently

## 🚀 Getting Started

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/amazing-feature`)
3. Make your changes
4. Test thoroughly
5. Submit a Pull Request

## 📝 What We're Looking For

### ✅ Good Contributions

- **Bug fixes** with clear reproduction steps
- **Documentation improvements**
- **Simple tool enhancements** that maintain single responsibility
- **New commands** that enable new workflows
- **Performance improvements** that don't add complexity

### ❌ What We'll Likely Decline

- **Complex logic in tools** - Keep intelligence in Claude
- **Features that break simplicity** - No 500+ line tools
- **Major architectural changes** without discussion
- **Dependencies on external libraries** - Stay dependency-free

## 🛠️ Development Guidelines

### Tool Development

Tools should be:
- **Under 200 lines** of bash
- **Single purpose** - do one thing well
- **Idempotent** - safe to run multiple times
- **Clear output** - easy for Claude to parse

Example structure:
```bash
#!/bin/bash
# tool-name - Brief description

# Configuration
SOME_VAR="value"

# Main logic
case "$1" in
    action1)
        # Do something
        ;;
    action2)
        # Do something else
        ;;
    *)
        echo "Usage: tool-name <action1|action2>"
        ;;
esac
```

### Command Development

Commands should:
- Be written in Markdown
- Describe workflow clearly
- Reference tools to use
- Include examples

### Testing

Before submitting:
1. Test the tool standalone
2. Test with Claude Code
3. Test with parallel sessions
4. Verify autonomous operation

## 🐛 Reporting Issues

Include:
- Clear description
- Steps to reproduce
- Expected behavior
- Actual behavior
- System information

## 💡 Suggesting Features

1. Open an issue first
2. Describe the problem it solves
3. Show how it maintains simplicity
4. Get feedback before implementing

## 📊 Pull Request Process

1. **Update documentation** for any changes
2. **Add tests** if applicable
3. **Update CHANGELOG.md** with your changes
4. **Ensure CI passes** (if applicable)
5. **Request review** from maintainers

## 🤝 Code of Conduct

- Be respectful
- Be constructive
- Be patient
- Remember: we're all learning

## 📜 License

By contributing, you agree that your contributions will be licensed under the MIT License.

## 🙏 Thank You!

Every contribution helps make Claude Code Parallel better. Whether it's fixing a typo, improving documentation, or adding a feature - we appreciate your help!

Remember: **Keep it simple, let Claude be smart!**