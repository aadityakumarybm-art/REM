# REM — free GitHub + ChatGPT MCP setup

This repository provides a **keyless, pinned setup** for [Reverse Engineer Marketing (REM)](https://github.com/dansugc/reverse-engineer-marketing). The upstream application runs separately, rather than copying and modifying its source here.

- Upstream source: `dansugc/reverse-engineer-marketing`
- Pinned commit: `5b78198b2578997412853ab0858b10670fa74984`
- Node.js: **22+**
- No Scrape Creators or Anthropic key is needed for the free evidence scan.
- ChatGPT connection requires an authorized **Secure MCP Tunnel**, running on your machine or a server (not a GitHub Actions runner).

## Run locally (Windows PowerShell)

```powershell
git clone https://github.com/aadityakumarybm-art/REM.git
cd REM
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/setup-rem.ps1
node .rem-upstream/dist/cli.js doctor
node .rem-upstream/dist/cli.js sorabyte.in --no-ai --max-credits 0
```

The command writes `rem-reports/<domain>-<date>/report.md` and `evidence.json`. To enforce **zero paid credits** for local scans too, first run `$env:REM_MAX_CREDITS="0"`, unset any marketing API keys, and use an empty `REM_CONFIG_DIR`. The free MCP launcher does all three.

## GitHub Actions

Open **Actions → REM free verification → Run workflow**. Enter a public website/domain. The workflow checks types, runs tests and builds upstream at the exact pinned commit, then scans with `--no-ai --max-credits 0`. Download the `rem-free-report` artifact.

Pushes and pull requests run the same build checks, but do not initiate scans.

## ChatGPT MCP

See [docs/CHATGPT_MCP_SETUP.md](docs/CHATGPT_MCP_SETUP.md). The MCP server uses stdio; ChatGPT cannot connect to the GitHub URL or a local stdio command directly. Run it behind an authorized Secure MCP Tunnel. The launcher `scripts/start-free-mcp.ps1` removes paid marketing API keys and sets a zero-credit budget.

## Safety and provenance

This repository **does not contain marketing API keys**. Do not commit `.env`, reports containing sensitive notes, tunnel credentials, or API keys. The upstream code is MIT licensed; see [ORIGIN.md](ORIGIN.md). Always review upstream changes before changing the commit pin. Public sites can rate-limit/block scans; an unknown result is not proof a channel is unused.

**Scope:** this repository is an installation/automation wrapper. It does not mirror all upstream source files, deploy a persistent MCP server, or create a tunnel on your behalf.

## Use REM from this ChatGPT conversation (no tunnel, no marketing API key)

The connected GitHub plugin can create a scan issue and read its results. This is
**GitHub automation**, not a direct MCP connection. It needs no OpenAI Platform
tunnel or separate Scrape Creators / Anthropic API key.

1. Ask ChatGPT: **"Run a free REM scan of sorabyte.in using my GitHub REM repository."**
2. ChatGPT creates a GitHub issue titled `REM scan: sorabyte.in`.
3. A GitHub Actions job on the default branch runs pinned REM with
   `--no-ai --max-credits 0`, then replies to that issue with `report.md`.
4. ChatGPT reads the issue comment using the connected GitHub plugin and builds
   an evidence-cited marketing report. A complete `evidence.json` is also
   retained as a short-lived Actions artifact.

For a quick test, use `REM scan: example.com`. Editing an existing scan issue
also triggers a new scan; only issues created by the repository owner are
eligible. Use **public company domains only**, without `http://`, paths or
query strings. Reports are public in this public repository. Do not scan
private/internal services. The workflow does not run paid ad/social collectors
and does not turn ChatGPT into a native REM MCP client.

The first ChatGPT-to-GitHub scan may require workspace confirmation for GitHub
write actions. After a scan starts, the comment appears only when GitHub Actions
finishes; ChatGPT cannot keep a job alive or deliver future results without a
new user turn. Read its status through GitHub Actions.
