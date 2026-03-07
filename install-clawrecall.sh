#!/bin/bash
echo "🚀 ClawRecall Free Installer - Intelligent Mode"

# === 1. Check if OpenClaw is already installed ===
if command -v openclaw >/dev/null 2>&1; then
  echo "✅ OpenClaw is already installed."
  read -p "Do you want to update OpenClaw? (y/N): " update_choice
  
  if [[ "$update_choice" =~ ^[Yy]$ ]]; then
    echo "Updating OpenClaw..."
    curl -fsSL https://openclaw.ai/install.sh | bash
  else
    echo "Skipping update. Using existing installation."
  fi
  
  # Always run onboard after update or skip
  echo "Running onboard to ensure workspace is set..."
  openclaw onboard --install-daemon
else
  echo "OpenClaw not found. Installing now..."
  curl -fsSL https://openclaw.ai/install.sh | bash
  echo "Running onboard..."
  openclaw onboard --install-daemon
fi

# === 2. Always ask for skills path (after onboard) ===
echo ""
echo "🦞 Where should ClawRecall skills be installed?"
echo "Default is ~/.openclaw/skills (recommended)"
read -p "Skills path [~/.openclaw/skills]: " SKILL_PATH
SKILL_PATH=${SKILL_PATH:-~/.openclaw/skills}

mkdir -p "$SKILL_PATH/clawrecall"
cd "$SKILL_PATH/clawrecall"

# Download and install free skill
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/SKILL.md -o SKILL.md
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/dashboard.html -o dashboard.html

openclaw skills load

echo ""
echo "🎉 ClawRecall Free installed successfully!"
echo "Skills path: $SKILL_PATH/clawrecall"
echo "Open dashboard: openclaw dashboard --memory"
echo "Talk to agent: 'Enable ClawRecall'"
echo "For Pro upgrade → https://clawrecall.in"
