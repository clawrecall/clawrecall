#!/bin/bash
echo "🚀 ClawRecall Free Installer - Intelligent Mode"

# === DETECT WINDOWS / GIT BASH EARLY ===
IS_WINDOWS=false
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -n "$MSYSTEM" || "$OS" == "Windows_NT" ]]; then
  IS_WINDOWS=true
  echo "🪟 Detected Windows environment"
fi

# Function to run openclaw with PATH fallback
run_openclaw() {
  if command -v openclaw >/dev/null 2>&1; then
    openclaw "$@"
  elif [ "$IS_WINDOWS" = true ]; then
    # On Windows, attempt to find it in common npm global paths if not in PATH
    local NPM_GLOBAL_BIN
    NPM_GLOBAL_BIN=$(npm config get prefix 2>/dev/null)
    if [ -n "$NPM_GLOBAL_BIN" ] && [ -f "$NPM_GLOBAL_BIN/openclaw" ]; then
      "$NPM_GLOBAL_BIN/openclaw" "$@"
    elif [ -f "$APPDATA/npm/openclaw" ]; then
      "$APPDATA/npm/openclaw" "$@"
    else
      echo "❌ openclaw command not found. Please restart your terminal or add npm global bin to your PATH."
      exit 1
    fi
  else
    echo "❌ openclaw command not found."
    exit 1
  fi
}

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
  echo "OpenClaw not found. Installing now..."
  if [ "$IS_WINDOWS" = true ]; then
    # We use powershell for the official installer which handles Windows native setup
    powershell -Command "iwr -useb https://openclaw.ai/install.ps1 | iex"
    # Small wait to ensure filesystem sync
    sleep 2
  else
    curl -fsSL https://openclaw.ai/install.sh | bash
  fi
fi

# === 2. Run onboard (always after install/update) ===
echo "Starting setup..."
run_openclaw onboard --install-daemon

# === 3. Ask for skills path ===
echo ""
echo "🦞 Where should ClawRecall skills be installed?"
echo "Default is ~/.openclaw/skills (recommended)"
# Ensure we handle home directory correctly on Windows bash
DEFAULT_SKILL_PATH="$HOME/.openclaw/skills"
read -p "Skills path [$DEFAULT_SKILL_PATH]: " SKILL_PATH
SKILL_PATH=${SKILL_PATH:-$DEFAULT_SKILL_PATH}

# Expand tilde if present
SKILL_PATH="${SKILL_PATH/#\~/$HOME}"

mkdir -p "$SKILL_PATH/clawrecall"
cd "$SKILL_PATH/clawrecall" || exit 1

# Install free skill
echo "📥 Downloading ClawRecall skills..."
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/SKILL.md -o SKILL.md
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/dashboard.html -o dashboard.html

run_openclaw skills load

echo ""
echo "🎉 ClawRecall Free installed successfully!"
echo "Skills path: $SKILL_PATH/clawrecall"
echo "Open dashboard: openclaw dashboard --memory"
echo "Talk to agent: 'Enable ClawRecall'"
echo "For Pro upgrade: https://clawrecall.in"
