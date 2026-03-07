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

# === 4. SETUP CLI ===
CLAWRECALL_CMD="$SKILL_PATH/clawrecall/clawrecall"
cat <<EOF > "$CLAWRECALL_CMD"
#!/bin/bash
case "\$1" in
  dashboard)
    if [[ "\$OSTYPE" == "darwin"* ]]; then
      open "$SKILL_PATH/clawrecall/dashboard.html"
    elif [[ "\$OSTYPE" == "linux-gnu"* ]]; then
      xdg-open "$SKILL_PATH/clawrecall/dashboard.html"
    elif [[ "\$OSTYPE" == "msys" || "\$OSTYPE" == "cygwin" ]]; then
      # Convert to Windows path for explorer
      WIN_PATH=\$(cygpath -w "$SKILL_PATH/clawrecall/dashboard.html")
      explorer "\$WIN_PATH"
    else
      echo "Please open $SKILL_PATH/clawrecall/dashboard.html manually."
    fi
    ;;
  *)
    echo "Usage: clawrecall dashboard"
    ;;
esac
EOF
chmod +x "$CLAWRECALL_CMD"

# Windows: Create .cmd for CMD/PowerShell support
if [ "$IS_WINDOWS" = true ]; then
  NPM_GLOBAL_BIN=$(npm config get prefix 2>/dev/null)
  if [ -n "$NPM_GLOBAL_BIN" ]; then
    echo "@echo off" > "$NPM_GLOBAL_BIN/clawrecall.cmd"
    echo "if \"%1\"==\"dashboard\" (" >> "$NPM_GLOBAL_BIN/clawrecall.cmd"
    echo "    explorer \"\$(cygpath -w "$SKILL_PATH/clawrecall/dashboard.html")\"" >> "$NPM_GLOBAL_BIN/clawrecall.cmd"
    echo ") else (" >> "$NPM_GLOBAL_BIN/clawrecall.cmd"
    echo "    echo Usage: clawrecall dashboard" >> "$NPM_GLOBAL_BIN/clawrecall.cmd"
    echo ")" >> "$NPM_GLOBAL_BIN/clawrecall.cmd"
  fi
fi

# Add alias if not exists
ADD_ALIAS_SUCCEEDED=false
CONFIG_FILES=("$HOME/.bashrc" "$HOME/.zshrc" "$HOME/.bash_profile")
FOUND_CONFIG=false

for config in "${CONFIG_FILES[@]}"; do
  if [ -f "$config" ]; then
    FOUND_CONFIG=true
    if ! grep -q "alias clawrecall=" "$config"; then
      echo "" >> "$config"
      echo "# ClawRecall Alias" >> "$config"
      echo "alias clawrecall='$CLAWRECALL_CMD'" >> "$config"
      ADD_ALIAS_SUCCEEDED=true
    fi
  fi
done

# If no config file found, create .bashrc (safest default)
if [ "$FOUND_CONFIG" = false ]; then
  config="$HOME/.bashrc"
  echo "# ClawRecall Alias" > "$config"
  echo "alias clawrecall='$CLAWRECALL_CMD'" >> "$config"
  ADD_ALIAS_SUCCEEDED=true
fi

# === 5. SUCCESS ===
echo ""
echo "🎉 ClawRecall Free installed successfully!"
echo "Skills path: $SKILL_PATH/clawrecall"

if [ "$ADD_ALIAS_SUCCEEDED" = true ]; then
  echo "🚀 Command enabled: Run 'source ~/.bashrc' (or restart terminal)"
  echo "Open dashboard: clawrecall dashboard"
else
  echo "Open dashboard: $CLAWRECALL_CMD dashboard"
fi

echo "Talk to agent: 'Enable ClawRecall'"
echo "For Pro upgrade: https://clawrecall.in"
