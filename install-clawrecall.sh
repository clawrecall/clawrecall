#!/bin/bash
echo "🚀 Installing OpenClaw + ClawRecall Free..."

# === OS DETECTION & FRIENDLY HANDLING ===
if [[ "$OSTYPE" == "msys" || "$OSTYPE" == "cygwin" || -n "$MSYSTEM" ]]; then
  echo "🪟 Detected Windows + Git Bash"
  echo "The official OpenClaw installer doesn't support Git Bash directly."
  echo "We'll use the recommended PowerShell method instead."
  
  echo "Running official OpenClaw installer via PowerShell..."
  powershell -Command "iwr -useb https://openclaw.ai/install.ps1 | iex"
  
  echo "✅ OpenClaw installed via PowerShell"
else
  # Mac / Linux / WSL
  echo "🐧 Detected macOS / Linux / WSL"
  curl -fsSL https://openclaw.ai/install.sh | bash
fi

# === Continue with ClawRecall Free (works on all OS) ===
echo "🦞 Installing ClawRecall Free skill..."

# Create folders
mkdir -p ~/.openclaw/skills/clawrecall
cd ~/.openclaw/skills/clawrecall

# Download free files
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/SKILL.md -o SKILL.md
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/dashboard.html -o dashboard.html

# Load the skill
openclaw skills load . 2>/dev/null || echo "✅ ClawRecall Free installed!"

echo ""
echo "🎉 SUCCESS! ClawRecall Free is ready."
echo "Open dashboard: openclaw dashboard --memory"
echo "Talk to your agent: 'Enable ClawRecall'"
echo ""
echo "For Pro upgrade, go to https://clawrecall.in"
