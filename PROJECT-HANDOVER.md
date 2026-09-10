# BRDC Employee Intranet — Project Handover

**Last updated:** September 9, 2026
**Live site:** https://itbahama.github.io/BRDC-INTRANET/employee-portal.html
**Repo:** https://github.com/ITBAHAMA/BRDC-INTRANET
**Local folder:** `C:\Users\BRDC OFFICE\Desktop\CMMS\CMMS NEW`

---

## 1. How it's built

Single-file app. Everything — HTML, CSS, JavaScript — lives in **`employee-portal.html`** (~810 KB). No build step, no framework, no npm. Edit the file, run `push-now.bat`, done.

| Layer | What it uses |
|---|---|
| Frontend | One HTML file · Tailwind CDN · Phosphor Icons |
| Backend | Supabase (PostgreSQL + Storage) |
| Hosting | GitHub Pages |
| Deploy | `push-now.bat` (clears git locks → commit → force push) |

### Deploying

1. Double-click **`push-now.bat`**
2. Wait for "Done!"
3. In the browser: **Ctrl+Shift+R** (or F12 → right-click refresh → *Empty Cache and Hard Reload*)

GitHub Pages takes ~1 minute to rebuild. Large files (videos) take longer.

---

## 2. Supabase

**Active project:** `ryzucipineonaytxotuu`
**Old project:** `mtrrslztrjcxwatdossu` — **paused, do not use.** Data was migrated out in July 2026.

Anon/publishable key is in the HTML source (line ~1200). This is normal for Supabase — the key is public by design.

### Tables (14)

| Table | Purpose |
|---|---|
| `profiles` | 34 employee accounts · login, dept, position, `avatar_url` |
| `directory_entries` | Company Directory contacts (supplements hard-coded cards) |
| `birthdays` | Birthdays + `start_date` for tenure |
| `admin_memos` | PDF memos uploaded via Admin Panel · `storage_path` |
| `dept_announcements` | Team updates per department |
| `announcements` | Company-wide announcements |
| `announcement_acknowledgements` | Read receipts · `memo_slug` for memos, `announcement_id` for announcements |
| `raci_matrix` | Who Does What — per-department responsibilities |
| `performance_evaluations` | 25-question evaluations · `q1`–`q25` + `overall_rating` |
| `it_systems` | IT system status board |
| `login_logs` | Login history |
| `quick_links` | Department quick links |
| `support_requests` | Help & Feedback tickets |
| `broadcast_alert` | Site-wide alert banner |

### Storage buckets (all public)

| Bucket | Contents |
|---|---|
| `MEMOS` | Uploaded memo PDFs → `uploads/<dept>/<timestamp>-<file>.pdf` |
| `AVATARS` | Profile photos → `<username>.jpg` (512×512, cropped) |
| `VIDEOS` | Reserved. Currently unused — videos ship with the repo instead. |

> There is also a stray **`MEMO`** bucket (singular) created by accident. Nothing uses it; safe to delete.

### RLS

All tables have Row Level Security **disabled**, with `GRANT ALL ... TO anon`. This is required because the portal authenticates with its own `profiles` table, not Supabase Auth — the anon key must be able to read and write.

Supabase shows an **"Unrestricted"** badge on these tables. That is expected, not a fault.

---

## 3. Login

Not Supabase Auth. The portal checks `profiles` directly:

```js
SUPA.from('profiles').select('*').eq('username', username).single()
// then: data.password === btoa(plaintext)
```

Passwords are **base64-encoded, not hashed**. Default for all accounts is `123456` (`MTIzNDU2`).

**This is the weakest part of the system.** Anyone who opens the page source can read the anon key and query `profiles` directly, including passwords. Acceptable for an internal tool on a trusted network; not acceptable if the portal ever holds sensitive personal data. Moving to Supabase Auth with hashed passwords is the fix.

### Admin accounts (9)

`admin` · `evelyn` · `eden` · `milan` · `johson` · `dianne` · `cheza` · `toni` · `mark`

---

## 4. Access control

Three independent mechanisms. Know which one you're editing.

### a) Department gating — Essential Tools

```html
data-tool-dept="purchasing"
data-tool-dept="hr,accounting"        <!-- either dept -->
```

### b) Position gating — Essential Tools

```html
data-tool-position="Gross Leasable Area - GLA"
data-tool-position="Accounting Supervisor,Accounting Assistant Supervisor"
```

A tile with **both** shows if *either* matches. Admins always see everything.
Handled by `applyToolVisibility()`.

### c) Section gating — Training & Tutorials

Add the `acct-block` class to a section; `applyAcctApVisibility()` shows it to **Accounting, HR, and admins**, and unloads any videos inside when the user doesn't qualify.

### Current restrictions

| Item | Visible to |
|---|---|
| Trello (Essential Tools) | Purchasing |
| Importation Docs | GLA |
| Working Paper 2026 | GLA · Accounting Supervisor · Accounting Assistant Supervisor |
| Accounting AP Guides / GLA / AP Videos | Accounting · HR · admins |
| RACI "Who Does What" | Own department only · HR and admins see all |

---

## 5. Bundled media

Videos and documents ship **inside the repo**, not Supabase Storage. This was a deliberate change after repeated Storage upload failures — if the HTML deploys, the media deploys with it.

```
videos/
  orientation.mp4          9.7 MB   Welcome orientation (was 43 MB)
  ap-playbook.mp4          8.3 MB   Ang Playbook ng AP (was 40 MB)
  ap-tagapagbantay.mp4     9.5 MB   Tagapagbantay ng Bahama (was 47 MB)
docs/
  ap-aging.pdf / .docx              AP Aging step-by-step
  ap-assistant-onboarding.pdf       22 pages
  ap-assistant-entries.pdf          6 pages · VAT & EWT
```

**Always compress video before adding it.** Command used:

```bash
ffmpeg -i input.mp4 -c:v libx264 -preset veryfast -crf 30 \
  -vf "scale=1280:-2" -movflags +faststart -c:a aac -b:a 96k output.mp4
```

This gave ~80% reduction with no visible quality loss on slide-based content. It matters: Supabase free tier allows 5 GB egress/month, and GitHub Pages has its own soft limits.

Videos use `preload="none"` and only get a `src` when their accordion opens — nobody downloads 17 MB unless they choose to watch.

---

## 6. Performance Evaluation

- 25 questions, Tagalog, scored 1–4
- **Overall = sum of all 25, out of 100** (changed from average in Sept 2026)
- Colour bands: 88+ emerald · 63+ blue · 38+ amber · below red
- Minimum possible score is 25, not 0 — all questions are required
- Who can evaluate: `EVAL_ALLOWED_POSITIONS` (supervisors, managers, admins)
- HR Records tab: `_isHrUser()` — admins and HR only
- Employee list merges `profiles` + `directory_entries`, deduplicated by name

---

## 7. Known limitations

**Two parallel systems for the same content.** Both the Company Directory and Memos & Policies mix hard-coded HTML cards with database-driven ones. Changing one does not affect the other. This has caused several "it's not showing up" bugs. Worth consolidating.

**Name matching is by string.** Performance evaluations, directory photos, and RACI all match people by `full_name` text. A spelling difference between `profiles` and `directory_entries` silently breaks the link. No foreign keys.

**Onboarding checklists incomplete.** 19 positions have them. Missing for ~12 employees: Admin Assistant, Admin Officer, Operations Manager, Pump Technician, Sales and Operation Manager, Transport Manager, Purchasing Supervisor, Purchasing Assistant.

**12 legacy memo links are broken.** The hard-coded HR/IT/Accounting memo entries point at `MEMOS/HUMAN RESOURCE/…` paths that were never uploaded to the new project. The 14 SmartFuels PDFs in `SMARTFUELS MEMOS/` are also still waiting to be uploaded.

**No SmartFuels accounts exist** — though 14 SmartFuels memos are configured.

**Google Drive / Sheets links must be shared manually.** Several links point at Drive folders and Sheets. If sharing is "Restricted", employees see the tile but hit "Request access". This has bitten us twice.

---

## 8. Working on this file

Before every deploy, run these checks:

```bash
# JavaScript syntax
python3 -c "
import re,subprocess
html=open('employee-portal.html',encoding='utf-8').read()
for s in re.findall(r'<script(?![^>]*\bsrc=)[^>]*>(.*?)</script>', html, re.S):
    if len(s.strip())<20: continue
    open('/tmp/s.js','w',encoding='utf-8').write(s)
    r=subprocess.run(['node','--check','/tmp/s.js'],capture_output=True,text=True)
    if r.returncode: print(r.stderr[:300])
"
```

Also check that every `onclick="foo()"` has a matching `function foo`, and every `getElementById('x')` has a matching `id="x"`. Several features have shipped broken because the JS existed but the HTML never did — Global Search sat dead for weeks that way.

### Where things live

| Feature | Search for |
|---|---|
| Login | `window.doLogin` |
| Department data | `DEPT_DATA` |
| Positions per dept | `DEPT_POSITIONS` |
| Admin tabs | `ADMIN_TABS` · `MGMT_ALLOWED_TABS` |
| Tool visibility | `applyToolVisibility` |
| Training gating | `applyAcctApVisibility` · `.acct-block` |
| RACI | `loadRaci` · `_raciCanViewAll` |
| Memos | `loadDeptMemos` · `loadUploadedMemos` |
| Avatars | `previewAvatar` · `applyDirectoryPhotos` |
| Evaluation | `submitEvaluation` · `EVAL_MAX_SCORE` |

---

## 9. Suggested next steps

1. **Upload the 14 SmartFuels memo PDFs** — they're prepared in `SMARTFUELS MEMOS/`, just need to go into the `MEMOS` bucket
2. **Restore the 12 broken legacy memo links** — or remove the entries if the files are gone
3. **Add the 8 missing onboarding checklists** — this is the portal's core purpose
4. **Create SmartFuels accounts**
5. **Consolidate the hard-coded vs database duplication** in Directory and Memos
6. **Move to hashed passwords** if the portal will ever hold sensitive data
