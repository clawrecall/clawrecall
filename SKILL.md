---
name: clawrecall
type: skill
description: Permanent memory for your agent
version: 1.3.0
---

# 🦞 ClawRecall - Never Forget Again

## Critical Requirement (new in v1.3.0)
This skill REQUIRES filesystem tools. If the agent says it cannot read/write, run:
`openclaw config set tools.profile "coding"` then restart.

## Tool Requirement (new in v1.3.0)
This skill REQUIRES filesystem tools (read, write, append). If they are missing, politely ask the user to switch to "coding" or "full" tool profile in openclaw.json or enable group:filesystem.

[Rest of your existing SKILL.md content remains exactly the same]

## Free version features
- Creates permanent **MEMORY.md** with dates and struck-through old facts
- Adds **working-context.md** for tasks in progress (no mid-task forgetting)
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

## How to use
In Telegram/WhatsApp say:
- “Remember this forever: My wife’s birthday is 15th June”
- “Start task: Plan my trip” (creates working-context.md)

## Dashboard
Run in Terminal: `clawrecall dashboard`  
Or open: `~/.openclaw/skills/clawrecall/dashboard.html`

## Installation note (Git version)
Installed directly from https://github.com/clawrecall/clawrecall  
All files are in `~/.openclaw/skills/clawrecall/`  
No further setup needed after enable.