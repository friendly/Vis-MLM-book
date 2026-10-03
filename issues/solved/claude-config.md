# Claude Memory Across Machines

**Problem:** Claude's memory files live under `C:\Users\friendly\.claude\projects\{encoded-path}\memory\`,
where the encoded path is derived from the absolute project path. Different machines (home desktop,
office desktop, laptop) may have different drive letters or usernames, so each gets a different
encoded directory — memory doesn't sync automatically.

## Options

### 1. Memory folder in the project repo
Move (or symlink) the `memory/` folder into the project repo itself, e.g., `issues/memory/` or
a top-level `memory/`. It then syncs via git like everything else. Add to `.gitignore` if you
don't want it public; or keep in `issues/` which is already tracked. **Least friction.**

### 2. OneDrive junction
Point the memory directory at a OneDrive-synced folder via a directory junction (`mklink /J`).
OneDrive handles sync automatically across machines. Best for true automatic sync without
manual git push/pull.

### 3. Private git dotfiles repo
Init a private GitHub repo, track `~/.claude/` in it, push/pull manually when switching
machines. More control than OneDrive; works with different usernames.

### 4. Symlink memory into project repo
On each machine, after cloning the project:
```
mklink /J "C:\Users\friendly\.claude\projects\{encoded}\memory" "C:\R\projects\Vis-MLM-book\memory"
```
The encoded path differs per machine, so you'd need to run this once per machine.
The `memory/` folder then lives in the repo and is git-synced.

## Recommendation

**Option 1** (memory folder in the repo) is the least friction. Add `memory/` to `.gitignore`
if you don't want these notes public, or keep them in `issues/` which is already tracked.

**Option 2** (OneDrive junction) is best if you want true automatic Claude memory across machines.

---

The key constraint is that Claude's memory path encodes the absolute project path, so machines
with different drive letters or usernames get different encoded directories. Option 1 (notes in
the repo) sidesteps this entirely.
