$ErrorActionPreference = 'Stop'
$root = (Resolve-Path (Join-Path $PSScriptRoot '..')).Path
$upstream = Join-Path $root '.rem-upstream'
$revision = '5b78198b2578997412853ab0858b10670fa74984'
if (-not (Test-Path $upstream)) {
  git clone https://github.com/dansugc/reverse-engineer-marketing.git $upstream
  if ($LASTEXITCODE -ne 0) { throw 'Git clone failed' }
}
git -C $upstream fetch origin $revision
if ($LASTEXITCODE -ne 0) { throw 'Git fetch failed' }
git -C $upstream checkout --detach $revision
if ($LASTEXITCODE -ne 0) { throw 'Git checkout failed' }
Push-Location $upstream
try {
  npm ci
  if ($LASTEXITCODE -ne 0) { throw 'npm ci failed' }
  npm run typecheck
  if ($LASTEXITCODE -ne 0) { throw 'Typecheck failed' }
  npm test
  if ($LASTEXITCODE -ne 0) { throw 'Tests failed' }
  npm run build
  if ($LASTEXITCODE -ne 0) { throw 'Build failed' }
} finally {
  Pop-Location
}
Write-Host 'REM checked, tested, and built. For free MCP use scripts/start-free-mcp.ps1.'
