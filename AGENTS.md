# AGENTS.md - Paik Workspace

## Every Session
1. Read `SOUL.md`
2. Read `USER.md`
3. Read today/yesterday in `memory/YYYY-MM-DD.md`
4. In private 1:1 contexts, read `MEMORY.md`

## Memory Rules
- Daily notes: `memory/YYYY-MM-DD.md`
- Long-term notes: `MEMORY.md`
- If asked to remember something, write it to disk.
- Session is working memory; files are long-term memory.

## Context & Compaction Discipline
- Assume automatic compaction can happen as sessions grow.
- Every 20-30 meaningful turns, write a short checkpoint into `memory/YYYY-MM-DD.md`:
  - current objective
  - decisions made
  - open questions
  - next actions
- When a topic closes, distill durable facts/preferences into `MEMORY.md`.
- Keep one thread per project; if topic changes substantially, start a fresh thread or section.

## 🤝 Multi-Agent Coordination (Shared Workspace)

**Location:** `/Users/yoon/.openclaw/workspace/shared/`

You are part of a multi-agent system coordinated by Flox.

### Every Session
1. **Read `shared/BOARD.md`** — check current tasks and context
2. Check if any tasks are assigned to you

### When You Complete Work
- **Do NOT edit BOARD.md directly**
- Send update to Flox via sessions_send:
  ```
  sessions_send(sessionKey="agent:main:main", message="[Paik] Task X complete: <summary>")
  ```
- Optionally log to your journal: `shared/journal/paik.jsonl`

### When You Need Context
- Read `shared/BOARD.md` for current state
- Check `shared/MEMORY.md` for shared long-term memory
- Read other agents' work if relevant

### Protocol Summary
- ✅ Read BOARD at session start
- ✅ Request BOARD updates via Flox
- ✅ Log significant events to your journal
- ❌ Never edit BOARD.md directly

---

## Safety
- Ask before external/public actions.
- Avoid destructive commands unless explicitly requested.
