#!/bin/bash
echo "🚀 ClawRecall Free Installer"

# === 1. Ensure OpenClaw is installed + onboard is done ===
if ! command -v openclaw >/dev/null 2>&1; then
  echo "Installing OpenClaw..."
  curl -fsSL https://openclaw.ai/install.sh | bash
  openclaw onboard --install-daemon
else
  echo "✅ OpenClaw detected. Running onboard to set workspace..."
  openclaw onboard --install-daemon
fi

echo ""
echo "🦞 Where should ClawRecall skills be installed?"
echo "Default is ~/.openclaw/skills (recommended)"
read -p "Skills path [~/.openclaw/skills]: " SKILL_PATH
SKILL_PATH=${SKILL_PATH:-~/.openclaw/skills}

mkdir -p "$SKILL_PATH/clawrecall"
cd "$SKILL_PATH/clawrecall"

# Download free files
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/SKILL.md -o SKILL.md
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/dashboard.html -o dashboard.html

# Safe skill load (no extra arguments)
openclaw skills load

echo ""
echo "🎉 ClawRecall Free installed successfully!"
echo "Skills path: $SKILL_PATH/clawrecall"
echo "Open dashboard: openclaw dashboard --memory"
echo "Talk to your agent: 'Enable ClawRecall'"
echo ""
echo "For Pro upgrade: https://clawrecall.in"
