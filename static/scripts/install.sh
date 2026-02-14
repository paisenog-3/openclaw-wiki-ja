#!/bin/bash
set -e

# ─────────────────────────────────────
# OpenClaw インストーラー
# Mac / Linux / Windows (WSL2) 対応
# ─────────────────────────────────────

REQUIRED_NODE_MAJOR=18
NVM_VERSION="0.40.1"

echo ""
echo "🐾 OpenClaw インストーラー"
echo "─────────────────────────────────"
echo ""

# ── OS検出 ──
detect_os() {
  case "$(uname -s)" in
    Linux*)
      if grep -qi microsoft /proc/version 2>/dev/null; then
        echo "wsl"
      else
        echo "linux"
      fi
      ;;
    Darwin*) echo "mac" ;;
    *) echo "unknown" ;;
  esac
}

OS=$(detect_os)
echo "📦 検出されたOS: $OS"

if [ "$OS" = "unknown" ]; then
  echo "❌ サポートされていないOSです。Mac, Linux, または Windows (WSL2) で実行してください。"
  exit 1
fi

# ── 依存パッケージのインストール ──
install_dependencies() {
  echo ""
  echo "🔧 依存パッケージを確認中..."

  # curlの存在チェック
  if ! command -v curl &>/dev/null; then
    echo "📥 curl をインストール中..."
    
    # sudo の有無を確認
    SUDO=""
    if command -v sudo &>/dev/null && [ "$EUID" -ne 0 ]; then
      SUDO="sudo"
    fi
    
    # パッケージマネージャーの検出とインストール
    if command -v apt-get &>/dev/null; then
      # Debian/Ubuntu
      echo "   パッケージリストを更新中..."
      $SUDO apt-get update >/dev/null 2>&1
      $SUDO apt-get install -y curl >/dev/null 2>&1
    elif command -v yum &>/dev/null; then
      # CentOS/RHEL
      $SUDO yum install -y curl
    elif command -v dnf &>/dev/null; then
      # Fedora
      $SUDO dnf install -y curl
    elif command -v brew &>/dev/null; then
      # macOS
      brew install curl
    else
      echo "❌ パッケージマネージャーが見つかりません。手動で curl をインストールしてください。"
      exit 1
    fi
    
    echo "✅ curl をインストールしました"
  else
    echo "✅ curl が見つかりました"
  fi
}

# ── Node.js チェック & インストール ──
install_node() {
  echo ""
  echo "🔍 Node.js を確認中..."

  if command -v node &>/dev/null; then
    NODE_VERSION=$(node -v | sed 's/v//' | cut -d. -f1)
    if [ "$NODE_VERSION" -ge "$REQUIRED_NODE_MAJOR" ]; then
      echo "✅ Node.js $(node -v) が見つかりました"
      return 0
    else
      echo "⚠️  Node.js $(node -v) は古いバージョンです（v${REQUIRED_NODE_MAJOR}以上が必要）"
    fi
  else
    echo "⚠️  Node.js が見つかりません"
  fi

  echo "📥 nvm 経由で Node.js をインストールします..."

  # nvm がなければインストール
  if [ ! -d "$HOME/.nvm" ]; then
    curl -o- "https://raw.githubusercontent.com/nvm-sh/nvm/v${NVM_VERSION}/install.sh" | bash
  fi

  export NVM_DIR="$HOME/.nvm"
  # shellcheck disable=SC1091
  [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
  if ! command -v nvm &>/dev/null; then
    echo "❌ nvm の読み込みに失敗しました。新しいシェルを開いて再実行してください。"
    exit 1
  fi

  nvm install 22
  nvm use 22

  echo "✅ Node.js $(node -v) をインストールしました"
}

# ── OpenClaw インストール ──
install_openclaw() {
  echo ""
  echo "📥 OpenClaw をインストール中..."

  if command -v openclaw &>/dev/null; then
    CURRENT_VERSION=$(openclaw --version 2>/dev/null || echo "不明")
    echo "⚠️  OpenClaw がすでにインストールされています (${CURRENT_VERSION})"
    read -rp "   上書きインストールしますか？ (y/N): " OVERWRITE < /dev/tty
    if [[ ! "$OVERWRITE" =~ ^[yY] ]]; then
      echo "⏭️  スキップしました"
      return 0
    fi
  fi

  if ! command -v npm &>/dev/null; then
    echo "❌ npm が見つかりません。Node.js のインストールを確認してください。"
    exit 1
  fi

  npm install -g openclaw
  export PATH="$(npm config get prefix)/bin:$PATH"

  if ! command -v openclaw &>/dev/null; then
    echo "❌ openclaw コマンドが見つかりません。PATH 設定を確認してください。"
    exit 1
  fi

  echo "✅ OpenClaw $(openclaw --version) をインストールしました"
}

# ── OpenClaw セットアップ ──
run_onboard() {
  echo ""
  echo "═══════════════════════════════════"
  echo "🔧 OpenClaw セットアップウィザード"
  echo "═══════════════════════════════════"
  echo ""
  echo "認証設定、モデル選択、ワークスペース設定を行います。"
  echo "画面の指示に従って進めてください。"
  echo ""

  # openclaw onboard を実行
  openclaw onboard

  if [ $? -ne 0 ]; then
    echo ""
    echo "⚠️  セットアップウィザードが中断されました。"
    echo "   あとで以下のコマンドで再実行できます："
    echo "   openclaw onboard"
    echo ""
  fi
}

# ── メイン ──
main() {
  install_dependencies
  install_node
  install_openclaw
  run_onboard

  echo ""
  echo "═══════════════════════════════════"
  echo "🎉 セットアップ完了！"
  echo "═══════════════════════════════════"
  echo ""
  echo "OpenClawの使い方："
  echo "  openclaw gateway start    # Gatewayを起動"
  echo "  openclaw help             # ヘルプを表示"
  echo ""
  echo "📖 ドキュメント: https://paisenog-3.github.io/openclaw-wiki-ja/"
  echo "💬 本家コミュニティ: https://discord.com/invite/clawd"
  echo ""
}

main
