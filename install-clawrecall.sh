#!/bin/bash
echo "🚀 Installing OpenClaw + ClawRecall Free..."

curl -fsSL https://openclaw.ai/install.sh | bash
openclaw onboard --install-daemon

mkdir -p ~/.openclaw/skills/clawrecall
cd ~/.openclaw/skills/clawrecall
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/SKILL.md -o SKILL.md
curl -fsSL https://raw.githubusercontent.com/clawrecall/clawrecall/main/dashboard.html -o dashboard.html

openclaw skills load .

echo "✅ ClawRecall Free installed!"
echo "Open dashboard: openclaw dashboard --memory"
echo "Talk to agent: 'Enable ClawRecall'"
