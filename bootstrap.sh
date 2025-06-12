#!/bin/bash

set -e

read -rsp "🔐 Enter your GitHub PAT (press Enter to skip): " GITHUB_TOKEN
echo
read -rp "📦 Enter a name for your container: " CONTAINER_NAME
echo

echo "🛠️ Choose your development environment:"
echo "1) Node.js"
echo "2) PHP"
echo "3) .NET"
read -rp "Your choice (1/2/3): " ENVIRONMENT_CHOICE
echo

read -rp "🌐 Git project URL (optional, e.g. https://github.com/user/repo.git): " GIT_URL
echo
read -rp "📁 Relative path (inside your home) to create project (e.g. Projects/MyApp): " TARGET_FOLDER_REL
echo

# 🔄 Absolute Zielpfad bauen
TARGET_FOLDER="$HOME/$TARGET_FOLDER_REL"

# 📁 Projektverzeichnisname extrahieren
REPO_NAME=""
if [[ -n "$GIT_URL" ]]; then
  REPO_NAME=$(basename -s .git "$GIT_URL")
fi

# Vorbereitungen...
sudo apt update
sudo apt install -y podman curl git

if ! command -v distrobox &>/dev/null; then
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo bash
fi

IMAGE="ubuntu:22.04"
if distrobox list | awk '{print $1}' | grep -qx "$CONTAINER_NAME"; then
  echo "⚠️  Container '$CONTAINER_NAME' already exists. Aborting."
  exit 1
else
  echo "📦 Creating distrobox container '$CONTAINER_NAME'..."
  distrobox create --name "$CONTAINER_NAME" --image "$IMAGE" --yes
fi

# Setup-Skript erzeugen
cat << 'EOF' > setup_inside_container.sh
#!/bin/bash
set -e

echo "📁 Creating project folder..."
mkdir -p "$HOME/$TARGET_FOLDER_REL"
cd "$HOME/$TARGET_FOLDER_REL"

echo "🌐 [1/5] Updating package index..."
sudo apt update -y

echo "📦 [2/5] Installing common tools..."
sudo apt install -y curl git gnupg software-properties-common

case "$ENVIRONMENT_CHOICE" in
  1)
    echo "🟢 Installing Node.js..."
    curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -
    sudo apt install -y nodejs
    ;;
  2)
    echo "🟠 Installing PHP..."
    sudo apt install -y php php-cli php-mbstring php-xml unzip
    ;;
  3)
    echo "🔵 Installing .NET SDK..."
    wget https://packages.microsoft.com/config/ubuntu/22.04/packages-microsoft-prod.deb -O packages-microsoft-prod.deb
    sudo dpkg -i packages-microsoft-prod.deb
    rm packages-microsoft-prod.deb
    sudo apt update -y
    sudo apt install -y dotnet-sdk-6.0
    ;;
  *)
    echo "❌ Invalid environment choice."
    exit 1
    ;;
esac

if [[ -n "$GIT_URL" ]]; then
  echo "📁 Cloning Git repository..."
  git clone "https://${GITHUB_PAT}@${GIT_URL#https://}" "$HOME/$TARGET_FOLDER_REL/$REPO_NAME"
  cd "$HOME/$TARGET_FOLDER_REL/$REPO_NAME"
  echo "🔒 Resetting git remote to remove PAT from config..."
  git remote set-url origin "$GIT_URL"
fi

echo "✅ Setup complete."
EOF

chmod +x setup_inside_container.sh

# Skript im Container ausführen
distrobox enter "$CONTAINER_NAME" -- env \
  GITHUB_PAT="$GITHUB_TOKEN" \
  GIT_URL="$GIT_URL" \
  TARGET_FOLDER_REL="$TARGET_FOLDER_REL" \
  ENVIRONMENT_CHOICE="$ENVIRONMENT_CHOICE" \
  ./setup_inside_container.sh

rm setup_inside_container.sh

echo "✅ Entwicklungsumgebung ist fertig."

# Alias hinzufügen
ALIAS_CMD="alias enter_$CONTAINER_NAME='distrobox enter $CONTAINER_NAME'"
if ! grep -Fxq "$ALIAS_CMD" ~/.bashrc; then
  echo "$ALIAS_CMD" >> ~/.bashrc
  echo "✅ Alias 'enter_$CONTAINER_NAME' added to ~/.bashrc"
fi

source ~/.bashrc

echo "👉 Use 'enter_$CONTAINER_NAME' to access your container."
