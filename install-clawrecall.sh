#!/bin/bash
echo "🚀 ClawRecall Free Installer - Intelligent Mode"

# === DETECT WINDOWS / GIT BASH EARLY ===
IS_WINDOWS=false
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -n "$MSYSTEM" || "$OS" == "Windows_NT" || -n "$WINDIR" ]]; then
  IS_WINDOWS=true
  echo "🪟 Detected Windows environment"
fi

# Function to run openclaw with PATH fallback and wait loop
run_openclaw() {
  local cmd_found=false
  local timeout=30
  local count=0

  while [ "$cmd_found" = false ] && [ $count -lt $timeout ]; do
    if command -v openclaw >/dev/null 2>&1; then
      cmd_found=true
      openclaw "$@"
      return $?
    elif [ "$IS_WINDOWS" = true ]; then
      local NPM_GLOBAL_BIN
      NPM_GLOBAL_BIN=$(npm config get prefix 2>/dev/null)
      if [ -n "$NPM_GLOBAL_BIN" ] && [ -f "$NPM_GLOBAL_BIN/openclaw" ]; then
        cmd_found=true
        "$NPM_GLOBAL_BIN/openclaw" "$@"
        return $?
      elif [ -f "$APPDATA/npm/openclaw" ]; then
        cmd_found=true
        "$APPDATA/npm/openclaw" "$@"
        return $?
      fi
    fi
    
    if [ $count -eq 0 ]; then
      echo "⌛ Waiting for openclaw command to be available..."
    fi
    sleep 1
    ((count++))
  done

  echo "❌ openclaw command not found after $timeout seconds. Please restart your terminal."
  exit 1
}

# Helper for interactive read when piped
interactive_read() {
  local prompt="$1"
  local var_name="$2"
  local default_val="$3"
  
  if [ -c /dev/tty ]; then
    read -p "$prompt" "$var_name" < /dev/tty
  else
    # Fallback if no TTY (rare but possible in some CI/wrappers)
    read -p "$prompt" "$var_name"
  fi
  
  local val
  eval "val=\$$var_name"
  if [ -z "$val" ]; then
    eval "$var_name=\"$default_val\""
  fi
}

# === 1. Check if OpenClaw is already installed ===
if command -v openclaw >/dev/null 2>&1; then
  echo "✅ OpenClaw is already installed."
  interactive_read "Do you want to update OpenClaw? (y/N): " update_choice "n"
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
    powershell -Command "iwr -useb https://openclaw.ai/install.ps1 | iex"
    # The installer might spawn background processes, so we let the wait loop handle it
  else
    curl -fsSL https://openclaw.ai/install.sh | bash
  fi
fi

# === 2. Run onboard (always after install/update) ===
echo "Starting setup..."
if [ -c /dev/tty ]; then
  run_openclaw onboard --install-daemon < /dev/tty
else
  run_openclaw onboard --install-daemon
fi

# === 3. Ask for skills path ===
echo ""
echo "🦞 Where should ClawRecall skills be installed?"
echo "Default is ~/.openclaw/skills (recommended)"
DEFAULT_SKILL_PATH="$HOME/.openclaw/skills"
interactive_read "Skills path [$DEFAULT_SKILL_PATH]: " SKILL_PATH "$DEFAULT_SKILL_PATH"

# Expand tilde
SKILL_PATH="${SKILL_PATH/#\~/$HOME}"

mkdir -p "$SKILL_PATH/clawrecall"
cd "$SKILL_PATH/clawrecall" || exit 1

# Install free skill
echo "📥 Downloading ClawRecall skills..."
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/SKILL.md -o SKILL.md
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/dashboard.html -o dashboard.html

run_openclaw skills load

# === 4. SUCCESS ===
echo ""
echo "🎉 ClawRecall Free installed successfully!"
echo "Skills path: $SKILL_PATH/clawrecall"

# Detective work to open dashboard
OPEN_CMD=""
if [[ "$OSTYPE" == "darwin"* ]]; then
  OPEN_CMD="open"
elif [[ "$OSTYPE" == "linux-gnu"* ]]; then
  OPEN_CMD="xdg-open"
elif [ "$IS_WINDOWS" = true ]; then
  OPEN_CMD="explorer"
fi

if [ -n "$OPEN_CMD" ]; then
  echo "Open dashboard: $OPEN_CMD \"$SKILL_PATH/clawrecall/dashboard.html\""
else
  echo "Open dashboard: Open $SKILL_PATH/clawrecall/dashboard.html in your browser"
fi

echo "Talk to agent: 'Enable ClawRecall'"
echo "For Pro upgrade: https://clawrecall.in"
