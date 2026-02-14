# ─────────────────────────────────────
# OpenClaw Windows インストーラー
# PowerShell → WSL2セットアップ → OpenClawインストール
# ─────────────────────────────────────

Write-Host ""
Write-Host "🐾 OpenClaw Windows インストーラー" -ForegroundColor Cyan
Write-Host "─────────────────────────────────" -ForegroundColor Gray
Write-Host ""

# ── 管理者権限チェック ──
$isAdmin = ([Security.Principal.WindowsPrincipal] [Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole]::Administrator)

# ── WSL チェック & インストール ──
Write-Host "🔍 WSL を確認中..." -ForegroundColor Yellow

$wslInstalled = $false
try {
    $wslOutput = wsl --status 2>&1
    if ($LASTEXITCODE -eq 0) {
        $wslInstalled = $true
    }
} catch {
    $wslInstalled = $false
}

if (-not $wslInstalled) {
    Write-Host "⚠️  WSL がインストールされていません" -ForegroundColor Yellow
    Write-Host ""

    if (-not $isAdmin) {
        Write-Host "❌ WSL のインストールには管理者権限が必要です。" -ForegroundColor Red
        Write-Host "   PowerShell を「管理者として実行」して、もう一度このスクリプトを実行してください。" -ForegroundColor Red
        Write-Host ""
        Read-Host "Enter キーで終了"
        exit 1
    }

    Write-Host "📥 WSL2 をインストールします..." -ForegroundColor Cyan
    wsl --install

    Write-Host ""
    Write-Host "✅ WSL2 のインストールが完了しました。" -ForegroundColor Green
    Write-Host "⚠️  PC を再起動してから、もう一度このスクリプトを実行してください。" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Enter キーで終了"
    exit 0
}

Write-Host "✅ WSL が見つかりました" -ForegroundColor Green

# ── Ubuntu チェック ──
Write-Host "🔍 Ubuntu を確認中..." -ForegroundColor Yellow

$distros = wsl --list --quiet 2>&1 | ForEach-Object { $_ -replace "`0", "" } | Where-Object { $_ -match "Ubuntu" }

if (-not $distros) {
    Write-Host "⚠️  Ubuntu がインストールされていません" -ForegroundColor Yellow
    Write-Host "📥 Ubuntu をインストールします..." -ForegroundColor Cyan
    wsl --install -d Ubuntu
    if ($LASTEXITCODE -ne 0) {
        Write-Host ""
        Write-Host "❌ Ubuntu のインストールに失敗しました。" -ForegroundColor Red
        Write-Host "   管理者権限で再実行するか、手動で Ubuntu をインストールしてください。" -ForegroundColor Yellow
        Write-Host ""
        Read-Host "Enter キーで終了"
        exit 1
    }

    Write-Host ""
    Write-Host "✅ Ubuntu のインストールが完了しました。" -ForegroundColor Green
    Write-Host "   Ubuntu を起動してユーザー名とパスワードを設定してから、" -ForegroundColor Yellow
    Write-Host "   もう一度このスクリプトを実行してください。" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Enter キーで終了"
    exit 0
}

Write-Host "✅ Ubuntu が見つかりました" -ForegroundColor Green
$ubuntuDistro = ($distros | Select-Object -First 1).Trim()

# ── WSL 上で OpenClaw インストーラーを実行 ──
Write-Host ""
Write-Host "🚀 WSL 上で OpenClaw インストーラーを実行します..." -ForegroundColor Cyan
Write-Host ""

wsl -d $ubuntuDistro bash -lc "curl -fsSL https://paisenog-3.github.io/openclaw-wiki-ja/scripts/install.sh | bash"

if ($LASTEXITCODE -ne 0) {
    Write-Host ""
    Write-Host "❌ WSL 上でのインストールに失敗しました（distro: $ubuntuDistro）。" -ForegroundColor Red
    Write-Host "   Ubuntu を起動して初期設定完了後、再実行してください。" -ForegroundColor Yellow
    Write-Host ""
    Read-Host "Enter キーで終了"
    exit 1
}

Write-Host ""
Write-Host "─────────────────────────────────" -ForegroundColor Gray
Write-Host "🎉 完了！" -ForegroundColor Green
Write-Host ""
Read-Host "Enter キーで終了"
