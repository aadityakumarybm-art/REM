$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$cli = Join-Path $root '.rem-upstream/dist/cli.js'
if (-not (Test-Path $cli)) {
  throw 'Build REM first using scripts/setup-rem.ps1'
}
# Force the free mode even if this machine has marketing keys or a saved REM config.
'ANTHROPIC_API_KEY','ANTHROPIC_AUTH_TOKEN','SCRAPECREATORS_API_KEY','SCRAPE_CREATORS_API_KEY' | ForEach-Object {
  Remove-Item "Env:\$_" -ErrorAction SilentlyContinue
}
$env:REM_MAX_CREDITS = '0'
$env:REM_CONFIG_DIR = Join-Path $root '.rem-empty-config'
# MCP over stdio: stdout belongs exclusively to the MCP protocol.
node $cli mcp
if ($LASTEXITCODE -ne 0) { exit $LASTEXITCODE }
