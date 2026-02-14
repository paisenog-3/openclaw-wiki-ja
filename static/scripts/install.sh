#!/bin/bash
set -e

# ─────────────────────────────────────
# OpenClaw インストーラー
# Mac / Linux / Windows (WSL2) 対応
# ─────────────────────────────────────

REQUIRED_NODE_MAJOR=18
NVM_VERSION="0.40.1"
SELECTED_PROVIDER=""
MODEL=""

CREDENTIALS_FILE="$HOME/.openclaw/credentials"

save_credential() {
  local key="$1"
  local value="$2"
  local tmp_file
  local escaped_value

  # ディレクトリ作成
  mkdir -p "$HOME/.openclaw"
  chmod 700 "$HOME/.openclaw"

  # credentialsファイルの作成/更新
  touch "$CREDENTIALS_FILE"
  chmod 600 "$CREDENTIALS_FILE"

  # 既存のキーを削除して追記（冪等）
  tmp_file=$(mktemp)
  grep -vE "^[[:space:]]*export[[:space:]]+${key}=" "$CREDENTIALS_FILE" > "$tmp_file" || true
  escaped_value=${value//\'/\'\"\'\"\'}
  printf "export %s='%s'\n" "$key" "$escaped_value" >> "$tmp_file"
  mv "$tmp_file" "$CREDENTIALS_FILE"
  chmod 600 "$CREDENTIALS_FILE"

  # .bashrcからsourceする設定を追加（まだなければ）
  if ! grep -q "source.*\.openclaw/credentials" "$HOME/.bashrc" 2>/dev/null; then
    echo "" >> "$HOME/.bashrc"
    echo "# OpenClaw credentials" >> "$HOME/.bashrc"
    echo '[ -f "$HOME/.openclaw/credentials" ] && source "$HOME/.openclaw/credentials"' >> "$HOME/.bashrc"
  fi

  # 現在のシェルにもexport
  export "${key}=${value}"
}

mask_credential() {
  local value="$1"
  local len=${#value}
  if [ "$len" -le 4 ]; then
    echo "****"
  else
    local masked_len=$((len - 4))
    printf '%*s' "$masked_len" '' | tr ' ' '*'
    echo "${value: -4}"
  fi
}

validate_credential() {
  local key="$1"
  local value="$2"
  local min_len=10

  # 最低文字数チェック
  if [ ${#value} -lt $min_len ]; then
    echo "⚠️  入力が短すぎます（${#value}文字）。正しい値か確認してください。"
    return 1
  fi

  # プロバイダー固有のフォーマットチェック
  case "$key" in
    ANTHROPIC_API_KEY)
      if [[ ! "$value" =~ ^sk-ant- ]]; then
        echo "⚠️  Anthropic APIキーは通常「sk-ant-」で始まります。正しい値か確認してください。"
        read -rp "   このまま続行しますか？ (y/N): " CONFIRM
        [[ "$CONFIRM" =~ ^[yY] ]] || return 1
      fi
      ;;
    OPENAI_API_KEY)
      if [[ ! "$value" =~ ^sk- ]]; then
        echo "⚠️  OpenAI APIキーは通常「sk-」で始まります。正しい値か確認してください。"
        read -rp "   このまま続行しますか？ (y/N): " CONFIRM
        [[ "$CONFIRM" =~ ^[yY] ]] || return 1
      fi
      ;;
  esac

  return 0
}

default_model_for_provider() {
  case "$1" in
    anthropic) echo "anthropic/claude-sonnet-4-5" ;;
    openai) echo "openai/gpt-5" ;;
    google) echo "google/gemini-2.5-pro" ;;
    groq) echo "groq/llama-3.3-70b-versatile" ;;
    openrouter) echo "openrouter/openai/gpt-5" ;;
    local) echo "llama3" ;;
    *) echo "" ;;
  esac
}

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
    read -rp "   上書きインストールしますか？ (y/N): " OVERWRITE
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

# ── APIキー / トークン設定 ──
setup_credentials() {
  while true; do
    echo ""
    echo "═══════════════════════════════════"
    echo "🔑 認証設定"
    echo "═══════════════════════════════════"
    echo ""
    echo "OpenClawを利用するには、AIプロバイダーへの認証が必要です。"
    echo "以下の3つの方法から選べます："
    echo ""
    echo "  1) サブスクリプション（認証トークン）"
    echo "     → ChatGPT Plus/Pro や Claude Pro/Max を契約中の方"
    echo "     → 追加料金なし、サブスク枠内で利用可能"
    echo ""
    echo "  2) APIキー（従量課金）"
    echo "     → サブスク不要、使った分だけ課金"
    echo "     → 大量利用やプログラムからの利用に最適"
    echo ""
    echo "  3) ローカルモデル（Ollama等）"
    echo "     → 完全無料、インターネット不要"
    echo "     → ただしGPU搭載PCが必要（VRAM 8GB以上推奨）"
    echo ""
    read -rp "利用方法を選択してください [1/2/3]: " AUTH_METHOD

    case "$AUTH_METHOD" in
      1) setup_subscription; break ;;
      2) setup_apikey; break ;;
      3) SELECTED_PROVIDER="local"; setup_local; break ;;
      *)
        echo "❌ 1〜3のいずれかを選択してください"
        ;;
    esac
  done
}

# ── サブスクリプション（認証トークン）設定 ──
setup_subscription() {
  echo ""
  echo "───────────────────────────────────"
  echo "📋 サブスクリプション（認証トークン）"
  echo "───────────────────────────────────"
  echo ""
  echo "どのサービスのサブスクリプションをお持ちですか？"
  echo ""
  echo "  1) Anthropic（Claude Pro / Max）"
  echo "  2) OpenAI（ChatGPT Plus / Pro）"
  echo "  3) Google（Gemini Advanced）"
  echo ""
  read -rp "番号: " SUB_PROVIDER

  case "$SUB_PROVIDER" in
    1)
      SELECTED_PROVIDER="anthropic"
      echo ""
      echo "📖 Claude の認証トークン取得手順："
      echo "───────────────────────────────────"
      echo "  1. ブラウザで https://claude.ai にログイン"
      echo "  2. F12キーでデベロッパーツールを開く"
      echo "  3. 「Application」→「Cookies」→「https://claude.ai」を選択"
      echo "  4. 「sessionKey」の値をコピー"
      echo "───────────────────────────────────"
      echo ""
      while true; do
        read -rsp "認証トークンを貼り付けてください（入力は非表示）: " TOKEN; echo
        if [ -n "$TOKEN" ]; then
          echo "   入力値: $(mask_credential "$TOKEN")"
          save_credential "ANTHROPIC_SESSION_TOKEN" "$TOKEN"
          echo "✅ 認証トークンを ~/.openclaw/credentials に保存しました（chmod 600）"
          break
        else
          echo "⚠️  認証トークンが必要です。上の手順に従って取得してください。"
        fi
      done
      ;;
    2)
      SELECTED_PROVIDER="openai"
      echo ""
      echo "📖 ChatGPT の認証トークン取得手順："
      echo "───────────────────────────────────"
      echo "  1. ブラウザで https://chatgpt.com にログイン"
      echo "  2. F12キーでデベロッパーツールを開く"
      echo "  3. 「Application」→「Cookies」→「https://chatgpt.com」を選択"
      echo "  4. 「__Secure-next-auth.session-token」の値をコピー"
      echo "───────────────────────────────────"
      echo ""
      while true; do
        read -rsp "認証トークンを貼り付けてください（入力は非表示）: " TOKEN; echo
        if [ -n "$TOKEN" ]; then
          echo "   入力値: $(mask_credential "$TOKEN")"
          save_credential "OPENAI_SESSION_TOKEN" "$TOKEN"
          echo "✅ 認証トークンを ~/.openclaw/credentials に保存しました（chmod 600）"
          break
        else
          echo "⚠️  認証トークンが必要です。上の手順に従って取得してください。"
        fi
      done
      ;;
    3)
      SELECTED_PROVIDER="google"
      echo ""
      echo "📖 Gemini の認証トークン取得手順："
      echo "───────────────────────────────────"
      echo "  1. ブラウザで https://gemini.google.com にログイン"
      echo "  2. F12キーでデベロッパーツールを開く"
      echo "  3. 「Application」→「Cookies」→「https://gemini.google.com」を選択"
      echo "  4. 「__Secure-1PSID」の値をコピー"
      echo "───────────────────────────────────"
      echo ""
      while true; do
        read -rsp "認証トークンを貼り付けてください（入力は非表示）: " TOKEN; echo
        if [ -n "$TOKEN" ]; then
          echo "   入力値: $(mask_credential "$TOKEN")"
          save_credential "GOOGLE_SESSION_TOKEN" "$TOKEN"
          echo "✅ 認証トークンを ~/.openclaw/credentials に保存しました（chmod 600）"
          break
        else
          echo "⚠️  認証トークンが必要です。上の手順に従って取得してください。"
        fi
      done
      ;;
    *)
      echo "❌ 1〜3のいずれかを選択してください"
      setup_subscription
      return
      ;;
  esac
}

# ── APIキー設定 ──
setup_apikey() {
  echo ""
  echo "───────────────────────────────────"
  echo "📋 APIキー（従量課金）"
  echo "───────────────────────────────────"
  echo ""
  echo "どのプロバイダーを利用しますか？"
  echo ""
  echo "  1) Anthropic（推奨）  → Claude モデル"
  echo "  2) OpenAI            → GPTモデル、Codex"
  echo "  3) Google            → Gemini モデル"
  echo "  4) Groq              → 高速推論"
  echo "  5) OpenRouter        → 複数プロバイダーを1つのキーで"
  echo ""
  read -rp "番号: " PROVIDER

  case "$PROVIDER" in
    1)
      SELECTED_PROVIDER="anthropic"
      KEY_NAME="ANTHROPIC_API_KEY"
      echo ""
      echo "📖 Anthropic APIキーの取得手順："
      echo "───────────────────────────────────"
      echo "  1. https://console.anthropic.com/ にアクセス"
      echo "  2. アカウントを作成またはログイン"
      echo "  3. 「API Keys」→「Create Key」をクリック"
      echo "  4. 生成されたキー（sk-ant-...）をコピー"
      echo "───────────────────────────────────"
      ;;
    2)
      SELECTED_PROVIDER="openai"
      KEY_NAME="OPENAI_API_KEY"
      echo ""
      echo "📖 OpenAI APIキーの取得手順："
      echo "───────────────────────────────────"
      echo "  1. https://platform.openai.com/ にアクセス"
      echo "  2. アカウントを作成またはログイン"
      echo "  3. 「API Keys」→「Create new secret key」をクリック"
      echo "  4. 生成されたキー（sk-...）をコピー"
      echo "───────────────────────────────────"
      ;;
    3)
      SELECTED_PROVIDER="google"
      KEY_NAME="GOOGLE_API_KEY"
      echo ""
      echo "📖 Google APIキーの取得手順："
      echo "───────────────────────────────────"
      echo "  1. https://aistudio.google.com/ にアクセス"
      echo "  2. Googleアカウントでログイン"
      echo "  3. 「Get API Key」→「Create API key」をクリック"
      echo "  4. 生成されたキーをコピー"
      echo "───────────────────────────────────"
      ;;
    4)
      SELECTED_PROVIDER="groq"
      KEY_NAME="GROQ_API_KEY"
      echo ""
      echo "📖 Groq APIキーの取得手順："
      echo "───────────────────────────────────"
      echo "  1. https://console.groq.com/ にアクセス"
      echo "  2. アカウントを作成またはログイン"
      echo "  3. 「API Keys」→「Create API Key」をクリック"
      echo "  4. 生成されたキーをコピー"
      echo "───────────────────────────────────"
      ;;
    5)
      SELECTED_PROVIDER="openrouter"
      KEY_NAME="OPENROUTER_API_KEY"
      echo ""
      echo "📖 OpenRouter APIキーの取得手順："
      echo "───────────────────────────────────"
      echo "  1. https://openrouter.ai/ にアクセス"
      echo "  2. アカウントを作成またはログイン"
      echo "  3. 「Keys」→「Create Key」をクリック"
      echo "  4. 生成されたキーをコピー"
      echo "───────────────────────────────────"
      ;;
    *)
      echo "❌ 無効な選択です"
      setup_apikey
      return
      ;;
  esac

  echo ""
  while true; do
    read -rsp "${KEY_NAME} を貼り付けてください（入力は非表示）: " API_KEY; echo
    if [ -n "$API_KEY" ]; then
      if ! validate_credential "$KEY_NAME" "$API_KEY"; then
        continue
      fi
      echo "   入力値: $(mask_credential "$API_KEY")"
      save_credential "${KEY_NAME}" "${API_KEY}"
      echo "✅ ${KEY_NAME} を ~/.openclaw/credentials に保存しました"
      break
    else
      echo "⚠️  APIキーが必要です。上の手順に従って取得してください。"
    fi
  done
}

# ── ローカルモデル設定 ──
setup_local() {
  echo ""
  echo "───────────────────────────────────"
  echo "📋 ローカルモデル"
  echo "───────────────────────────────────"
  echo ""
  echo "⚠️  ローカルモデルの実行には GPU（VRAM 8GB以上推奨）と"
  echo "   大容量のストレージが必要です。"
  echo ""
  echo "どのツールを使いますか？"
  echo ""
  echo "  1) Ollama（推奨・最も手軽）"
  echo "  2) LM Studio（GUI管理）"
  echo "  3) llama.cpp（上級者向け）"
  echo ""
  read -rp "番号: " LOCAL_TOOL

  case "$LOCAL_TOOL" in
    1)
      echo ""
      if command -v ollama &>/dev/null; then
        echo "✅ Ollama が見つかりました"
        echo ""
        echo "モデルをダウンロードしますか？（例: llama3, gemma2, phi3）"
        read -rp "モデル名を入力（スキップは Enter）: " MODEL_NAME
        if [ -n "$MODEL_NAME" ]; then
          echo "📥 ${MODEL_NAME} をダウンロード中..."
          ollama pull "$MODEL_NAME"
          echo "✅ ${MODEL_NAME} のダウンロードが完了しました"
        fi
      else
        echo "📖 Ollama のインストール手順："
        echo "───────────────────────────────────"
        echo "  1. https://ollama.com/ にアクセス"
        echo "  2. お使いのOS用のインストーラーをダウンロード"
        echo "  3. インストール後、ターミナルで以下を実行："
        echo "     ollama pull llama3"
        echo "───────────────────────────────────"
      fi
      ;;
    2)
      echo ""
      echo "📖 LM Studio のインストール手順："
      echo "───────────────────────────────────"
      echo "  1. https://lmstudio.ai/ にアクセス"
      echo "  2. お使いのOS用のインストーラーをダウンロード"
      echo "  3. 起動してモデルを検索・ダウンロード"
      echo "  4. 「Local Server」タブからAPIサーバーを起動"
      echo "───────────────────────────────────"
      ;;
    3)
      echo ""
      echo "📖 llama.cpp のインストール手順："
      echo "───────────────────────────────────"
      echo "  1. https://github.com/ggml-org/llama.cpp を参照"
      echo "  2. ビルド手順に従ってインストール"
      echo "  3. GGUF形式のモデルをダウンロードして実行"
      echo "───────────────────────────────────"
      ;;
    *)
      echo "❌ 無効な選択です"
      setup_local
      return
      ;;
  esac
}

# ── モデル選択 ──
select_model() {
  echo ""
  echo "═══════════════════════════════════"
  echo "🤖 デフォルトモデルの選択"
  echo "═══════════════════════════════════"
  echo ""
  
  # SELECTED_PROVIDER が未設定の場合のフォールバック
  if [ -z "$SELECTED_PROVIDER" ]; then
    echo "⚠️  プロバイダーが設定されていません。スキップします。"
    return 0
  fi
  
  echo "OpenClawで使用するデフォルトモデルを選択してください："
  echo ""

  # OpenClawから対応モデルを動的取得
  echo "利用可能なモデルを取得中..."
  echo ""

  case "$SELECTED_PROVIDER" in
    local)
      if command -v ollama &>/dev/null; then
        echo "Ollamaにインストール済みのモデル："
        ollama list 2>/dev/null || echo "  （モデルがまだありません）"
        echo ""
      fi
      read -rp "モデル名を入力（例: llama3）: " MODEL
      if [ -z "$MODEL" ]; then
        MODEL="llama3"
      fi
      ;;
    *)
      # プロバイダー名でフィルタしてモデル一覧を取得
      MODELS=$(openclaw models --all 2>/dev/null | grep "^${SELECTED_PROVIDER}/" | awk '{print $1}' | head -20)

      if [ -z "$MODELS" ]; then
        echo "⚠️  モデル一覧を取得できませんでした"
        read -rp "モデル名を手動入力してください: " MODEL
        if [ -z "$MODEL" ]; then
          MODEL="$(default_model_for_provider "$SELECTED_PROVIDER")"
        fi
      else
        # 番号付きで表示
        echo "  ${SELECTED_PROVIDER} の対応モデル："
        echo "  ─────────────────────────────────"
        i=1
        while IFS= read -r m; do
          echo "  ${i}) ${m}"
          i=$((i + 1))
        done <<< "$MODELS"
        echo ""
        echo "  番号を入力するか、モデル名を直接入力してください"
        read -rp "選択: " MODEL_CHOICE

        # 番号で選択された場合、モデル名に変換
        if [[ "$MODEL_CHOICE" =~ ^[0-9]+$ ]]; then
          MODEL=$(echo "$MODELS" | sed -n "${MODEL_CHOICE}p")
        else
          MODEL="$MODEL_CHOICE"
        fi

        if [ -z "$MODEL" ]; then
          # デフォルト：一覧の最初のモデル
          MODEL=$(echo "$MODELS" | head -1)
        fi
      fi
      ;;
  esac

  echo "✅ デフォルトモデル: ${MODEL}"
  echo "   （Gateway起動後に設定画面から変更することもできます）"
}

# ── Gateway 起動 ──
start_gateway() {
  echo ""
  echo "═══════════════════════════════════"
  echo "🚀 Gateway の起動"
  echo "═══════════════════════════════════"
  echo ""
  read -rp "OpenClaw Gateway を起動しますか？ (Y/n): " START
  if [[ "$START" =~ ^[nN] ]]; then
    echo ""
    echo "あとで以下のコマンドで起動できます："
    echo "  openclaw gateway start"
    return 0
  fi

  openclaw gateway start

  echo ""
  echo "✅ Gateway が起動しました"
  echo "   上記に表示されたURLをブラウザで開いてください"
  echo ""
}

# ── メイン ──
main() {
  install_dependencies
  install_node
  install_openclaw
  setup_credentials
  select_model
  start_gateway

  echo ""
  echo "═══════════════════════════════════"
  echo "🎉 セットアップ完了！"
  echo "═══════════════════════════════════"
  echo ""
  echo "📖 ドキュメント: https://docs.openclaw.ai"
  echo "💬 コミュニティ: https://discord.com/invite/clawd"
  echo ""
}

main
