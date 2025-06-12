#!/bin/bash

set -e

read -rsp "🔐 Enter your GitHub PAT (personal access token): " GITHUB_TOKEN
echo
read -rp "📦 Enter a name for your container: " CONTAINER_NAME
echo
read -rp "🌐 Please enter Git project URL (e.g. https://github.com/user/repo.git): " GIT_URL
echo
read -rp "📁 Relative path (inside your home) to clone project (e.g. Projects/MyApp): " TARGET_FOLDER_REL
echo

# 🔄 Absolute Zielpfad bauen
TARGET_FOLDER="$HOME/$TARGET_FOLDER_REL"

# 📁 Projektverzeichnisname extrahieren
REPO_NAME=$(basename -s .git "$GIT_URL")

# 1. Voraussetzungen installieren
echo "🔧 Installing dependencies (podman, distrobox)..."
sudo apt update
sudo apt install -y podman curl git

# 2. distrobox installieren
if ! command -v distrobox &>/dev/null; then
  curl -s https://raw.githubusercontent.com/89luca89/distrobox/main/install | sudo bash
fi

# 3. Container erstellen
IMAGE="ubuntu:22.04"

if distrobox list | awk '{print $1}' | grep -qx "$CONTAINER_NAME"; then
  echo "⚠️  Container '$CONTAINER_NAME' already exists. Aborting."
  exit 1
else
  echo "📦 Creating distrobox container '$CONTAINER_NAME'..."
  distrobox create --name "$CONTAINER_NAME" --image "$IMAGE" --yes
fi

# 4. Setup-Skript für Container schreiben
cat << EOF > setup_inside_container.sh
#!/bin/bash
set -e

echo "📁 Ensuring project folder exists..."
mkdir -p "\$HOME/\$TARGET_FOLDER_REL"
cd "\$HOME/\$TARGET_FOLDER_REL"

echo "🌐 [1/6] Updating package index..."
sudo apt update -y

echo "📦 [2/6] Installing base packages (curl, git, gnupg)..."
sudo apt install -y curl git gnupg

echo "🟢 [3/6] Setting up Node.js repository..."
curl -fsSL https://deb.nodesource.com/setup_lts.x | sudo -E bash -

echo "⬇️ [4/6] Installing Node.js LTS..."
sudo apt install -y nodejs

echo "📁 [5/6] Cloning project..."
git clone https://\${GITHUB_PAT}@${GIT_URL#https://} "\$HOME/\$TARGET_FOLDER_REL/$REPO_NAME"

echo "📂 [6/6] Entering project directory..."
cd "\$HOME/\$TARGET_FOLDER_REL/$REPO_NAME"

echo "🔒 Resetting git remote to remove PAT from config..."
git remote set-url origin "$GIT_URL"

echo "✅ Project is ready in ~/$(basename "$TARGET_FOLDER_REL")/$REPO_NAME"
EOF

chmod +x setup_inside_container.sh

# 5. Script im Container ausführen
echo "🚀 Running setup inside container..."
distrobox enter "$CONTAINER_NAME" -- env GITHUB_PAT="$GITHUB_TOKEN" GIT_URL="$GIT_URL" TARGET_FOLDER="$TARGET_FOLDER" ./setup_inside_container.sh

# 6. Aufräumen
rm -f setup_inside_container.sh || true

echo "✅ Entwicklungsumgebung ist fertig!"

# 7. Alias eintragen
ALIAS_CMD="alias enter_$CONTAINER_NAME='distrobox enter $CONTAINER_NAME --additional-flags \"--env DISTROBOX_NAME=$CONTAINER_NAME\"'"

if ! grep -Fxq "$ALIAS_CMD" ~/.bashrc; then
  echo "$ALIAS_CMD" >> ~/.bashrc
  echo "✅ Alias 'enter_$CONTAINER_NAME' wurde zu ~/.bashrc hinzugefügt."
else
  echo "ℹ️ Alias 'enter_$CONTAINER_NAME' existiert bereits in ~/.bashrc."
fi
source ~/.bashrc

echo "👉 Mit folgendem Befehl betrittst du den Container:"
echo "   enter_$CONTAINER_NAME"

