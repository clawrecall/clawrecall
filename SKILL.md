---
name: clawrecall
type: skill
description: Permanent memory for your agent
version: 1.1.0
---

# 🦞 ClawRecall - Never Forget Again

## Free version features
- Creates permanent MEMORY.md with dates and struck-through old facts
- Adds working-context.md for tasks in progress (no mid-task forgetting)
- Agent auto-summarizes chats and saves key facts
- Simple beautiful dashboard for phone/browser search/edit

## Rules your agent MUST follow (inspired by real user fixes)
1. Always check MEMORY.md + working-context.md before answering
2. When you say “remember this forever” → add to MEMORY.md with date
3. During any task → update working-context.md live
4. Every chat end → extract facts and append to MEMORY.md
5. Use this format:
   ## Important Facts [2026-03-04]
   - Your budget is ₹50,000
   ## Decisions [2026-03-04]
   ~~Old plan~~ → New plan [updated: 2026-03-04]

## How to use
In Telegram/WhatsApp say:
- “Enable ClawRecall”
- “Remember this forever: My wife’s birthday is 15th June”
- “Start task: Plan my trip” (it creates working-context.md)

## Dashboard
Run in Terminal: clawrecall dashboard
Or open: ~/.openclaw/skills/clawrecall/dashboard.html
