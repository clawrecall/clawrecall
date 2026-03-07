#!/bin/bash
echo "🚀 ClawRecall Free Installer - Intelligent Mode"

# === DETECT WINDOWS / GIT BASH EARLY ===
IS_WINDOWS=false
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -n "$MSYSTEM" ]]; then
  IS_WINDOWS=true
  echo "🪟 Detected Windows (Git Bash)"
fi

# === 1. Check if OpenClaw is already installed ===
if command -v openclaw >/dev/null 2>&1; then
  echo "✅ OpenClaw is already installed."
  read -p "Do you want to update OpenClaw? (y/N): " update_choice
  if [[ "$update_choice" =~ ^[Yy]$ ]]; then
    echo "Updating OpenClaw..."
    if [ "$IS_WINDOWS" = true ]; then
      powershell -Command "iwr -useb https://openclaw.ai/install.ps1 | iex"
    else
      curl -fsSL https://openclaw.ai/install.sh | bash
    fi
  else
    echo "Skipping update."
  fi
else
  echo "Installing OpenClaw..."
  if [ "$IS_WINDOWS" = true ]; then
    powershell -Command "iwr -useb https://openclaw.ai/install.ps1 | iex"
  else
    curl -fsSL https://openclaw.ai/install.sh | bash
  fi
fi

# === 2. Run onboard (always after install/update) ===
echo "Running OpenClaw onboard..."
openclaw onboard --install-daemon

# === 3. Ask for skills path ===
echo ""
echo "🦞 Where should ClawRecall skills be installed?"
echo "Default is ~/.openclaw/skills (recommended)"
read -p "Skills path [~/.openclaw/skills]: " SKILL_PATH
SKILL_PATH=${SKILL_PATH:-~/.openclaw/skills}

mkdir -p "$SKILL_PATH/clawrecall"
cd "$SKILL_PATH/clawrecall"

# Install free skill
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/SKILL.md -o SKILL.md
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/dashboard.html -o dashboard.html

openclaw skills load

echo ""
echo "🎉 ClawRecall Free installed successfully!"
echo "Skills path: $SKILL_PATH/clawrecall"
echo "Open dashboard: openclaw dashboard --memory"
echo "Talk to agent: 'Enable ClawRecall'"
echo "For Pro upgrade: https://clawrecall.in"
