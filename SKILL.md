---
name: clawrecall
type: skill
description: Permanent memory for your agent
version: 1.4.0
---

# 🦞 ClawRecall - Never Forget Again

## Critical Requirement (new in v1.3.0)
This skill REQUIRES filesystem tools. If the agent says it cannot read/write, run:
`openclaw config set tools.profile "coding"` then restart.

## Tool Requirement (new in v1.3.0)
This skill REQUIRES filesystem tools (read, write, append). If they are missing, politely ask the user to switch to "coding" or "full" tool profile in openclaw.json or enable group:filesystem.

[Rest of your existing SKILL.md content remains exactly the same]

## Free version features
- Creates permanent MEMORY.md with dates and struck-through old facts
- Adds working-context.md for tasks in progress (no mid-task forgetting)
- Agent auto-summarizes chats and saves key facts
- Simple beautiful dashboard for phone/browser search/edit

## CRITICAL RULES (Agent MUST obey 100% — v1.4.0)
1. ALWAYS check MEMORY.md + working-context.md before answering any question.
2. Trigger phrases (accept ALL of these exactly):
   - “Remember this forever:”
   - “Remember this always:”
   - “Remember this permanently:”
   - “Add to permanent memory:”
   - “Save forever:”
   - Any similar variation the user uses.
3. When triggered: **APPEND ONLY** — never overwrite, replace, delete, or reset the entire file.
   - Always add a **new dated section at the VERY END** of MEMORY.md.
   - Use append mode (do not read+rewrite the whole file).
   - Preserve every previous fact and struck-through history.
4. Format (exactly):
   ## Important Facts [YYYY-MM-DD]
   - New fact here
   ## Decisions [YYYY-MM-DD]
   ~~Old plan~~ → New plan [updated: YYYY-MM-DD]
5. NEVER delete or strike through old facts unless the user explicitly says “update” or “correct previous fact”.
6. At the end of every chat: auto-summarize important points and **append** them (do not overwrite).
7. If filesystem tools are missing: politely ask user to set tools.profile to "coding".

## How to use
In Telegram/WhatsApp say:
- “Remember this always: I never like cardamom”
- “Remember this forever: My wife’s birthday is 15th June”
- “Start task: Plan my trip” (creates working-context.md)

## Dashboard (v2.1)
Auto-loads MEMORY.md + working-context.md with real-time search and highlighting.
Open: ~/.openclaw/skills/clawrecall/dashboard.html

## Installation note
Installed directly from https://github.com/clawrecall/clawrecall