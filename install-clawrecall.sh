#!/bin/bash
set -e

if ! command -v openclaw >/dev/null 2>&1; then
  echo "❌ Error: OpenClaw gateway is not installed."
  echo "Please install it first: npm install -g @openclaw/gateway"
  exit 1
fi

echo "🚀 ClawRecall Git Installer v2.0 (auto-fixes broken folders)"

mkdir -p ~/.openclaw/skills
cd ~/.openclaw/skills

if [ -d "clawrecall" ]; then
  if [ -d "clawrecall/.git" ]; then
    echo "📥 Updating existing Git repo..."
    cd clawrecall
    git pull --ff-only || (git reset --hard HEAD && git pull)
  else
    echo "⚠️ Folder exists but not Git repo → cleaning and recloning..."
    rm -rf clawrecall
    git clone https://github.com/clawrecall/clawrecall.git clawrecall
    cd clawrecall
  fi
else
  echo "📥 Fresh cloning ClawRecall..."
  git clone https://github.com/clawrecall/clawrecall.git clawrecall
  cd clawrecall
fi

echo "✅ Files ready!"

openclaw config set tools.profile "coding"
openclaw gateway restart

cat << 'ENABLE_BLOCK'
I just installed/updated ClawRecall from Git (v2 installer).

Here is the COMPLETE SKILL.md content:

---
name: clawrecall
type: skill
description: Permanent memory for your agent
version: 1.3.0
---

# 🦞 ClawRecall - Never Forget Again

## Free version features
- Creates permanent MEMORY.md with dates and struck-through old facts
- Adds working-context.md for tasks in progress (no mid-task forgetting)
- Agent auto-summarizes chats and saves key facts
- Simple beautiful dashboard for phone/browser search/edit

## Rules your agent MUST follow
1. Always check MEMORY.md + working-context.md before answering
2. When you say “remember this forever” → add to MEMORY.md with date
3. During any task → update working-context.md live
4. Every chat end → extract facts and append to MEMORY.md
5. Use this exact format:
   ## Important Facts [2026-03-07]
   - Your budget is ₹50,000
   ## Decisions [2026-03-07]
   ~~Old plan~~ → New plan [updated: 2026-03-07]

Please parse this and ENABLE the ClawRecall skill immediately.  
Reply exactly: "✅ ClawRecall enabled successfully from Git direct install (version 1.3.0). Ready to remember everything."
ENABLE_BLOCK

echo ""
echo "🎉 Paste the block above into your OpenClaw chat now."
echo "Test: Remember this forever: Test from Git install"
echo "Future updates: just run this script again."