# Connecting REM to ChatGPT without marketing API keys

REM currently exposes an MCP server over **stdio** (`rem mcp`). ChatGPT's custom MCP plugin cannot directly launch a local stdio process or connect to a GitHub repository. Use [OpenAI Secure MCP Tunnel](https://developers.openai.com/api/docs/guides/secure-mcp-tunnels) to bridge the local REM process privately.

## 1. Prepare the free REM launcher

Run from the repository root on Windows:

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/setup-rem.ps1
powershell -NoProfile -ExecutionPolicy Bypass -File scripts/start-free-mcp.ps1
```

The second command is a **stdio process**; no interactive output is expected. Stop it with Ctrl+C. When using a tunnel, the tunnel starts the launcher itself instead.

The launcher removes Anthropic/Scrape Creators environment keys, isolates REM's saved user config, and sets `REM_MAX_CREDITS=0`. Its MCP tools can collect public website/SEO/Wayback evidence. `write_report` falls back to the deterministic evidence report without an Anthropic key.

## 2. Obtain tunnel access

You need permission to create/use custom MCP plugins in the ChatGPT workspace and a tunnel associated with that workspace. Open [OpenAI Platform Tunnels](https://platform.openai.com/settings/organization/tunnels) to create/locate your `tunnel_id`, and obtain a **runtime** control-plane API key (with Tunnels Read + Use). This credential is **not** a Scrape Creators or Anthropic key, but platform usage may have its own billing/limits. Do not commit it or paste it into this chat.

Download the appropriate official [tunnel-client release](https://github.com/openai/tunnel-client/releases), add the executable to PATH, and follow [its onboarding guide](https://github.com/openai/tunnel-client/blob/master/docs/onboarding.md).

## 3. Bind the local REM launcher (PowerShell)

Use absolute paths, replacing `C:\path\to\REM` with your checkout's real location:

```powershell
$env:CONTROL_PLANE_API_KEY = '<runtime-key-from-your-platform-settings>'
tunnel-client init --sample sample_mcp_stdio_local --profile rem-free --tunnel-id tunnel_0123456789abcdef0123456789abcdef --mcp-command "powershell -NoProfile -ExecutionPolicy Bypass -File C:\path\to\REM\scripts\start-free-mcp.ps1"
tunnel-client doctor --profile rem-free --explain
tunnel-client run --profile rem-free
```

Replace the example tunnel ID with **your actual** ID; do not share credentials. Keep this process running. In another terminal, test `http://127.0.0.1:8080/readyz` if using the default health listener.

## 4. Install the ChatGPT plugin

In ChatGPT **Plugins → + → Add custom MCP server**, choose **Tunnel**, select your tunnel ID, complete connection settings, acknowledge the risk warning, and create the plugin. Install/select it in this chat.

Test in ChatGPT:

> Use REM to reverse engineer the public marketing evidence for sorabyte.in. Do not use paid sources. Call get_playbook and get_evidence, then validate the cited report.

Expected REM tools include `reverse_engineer_marketing`, `get_evidence`, `get_playbook`, `get_content`, `compare_runs`, `validate_report`, and `write_report`.

**Limitations:** GitHub Actions cannot act as a persistent tunnel server. The tunnel must remain online while you use REM in ChatGPT. A free evidence scan is not the same as full paid ad/social intelligence. ChatGPT workspace/plugin privileges and OpenAI Platform tunnel access are separate. Never expose the unauthenticated MCP process through a public open proxy.

Sources: [ChatGPT custom MCP setup](https://help.openai.com/en/articles/12584461-connecting-custom-mcp-servers-in-chatgpt), [Secure MCP Tunnel](https://developers.openai.com/api/docs/guides/secure-mcp-tunnels), [tunnel-client onboarding](https://github.com/openai/tunnel-client/blob/master/docs/onboarding.md).
