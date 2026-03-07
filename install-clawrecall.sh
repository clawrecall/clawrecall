#!/bin/bash
set -e

echo "🚀 Installing/Updating ClawRecall directly from Git (free version)..."

mkdir -p ~/.openclaw/skills
cd ~/.openclaw/skills

if [ -d "clawrecall" ]; then
  echo "📥 Updating existing ClawRecall..."
  cd clawrecall && git pull --ff-only || (git reset --hard HEAD && git pull)
else
  echo "📥 Cloning fresh ClawRecall..."
  git clone https://github.com/clawrecall/clawrecall.git clawrecall
  cd clawrecall
fi

echo "✅ Files placed. Now paste the block below into your agent:"

cat << 'ENABLE_BLOCK'
[PASTE THE EXACT SAME LONG BLOCK I GAVE YOU ABOVE HERE — I kept it short in this message to avoid duplication]
ENABLE_BLOCK

echo ""
echo "🎉 After pasting and enabling, test with: Remember this forever: Test"
echo "Future updates: just run this script again."