![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Shell Script](https://img.shields.io/badge/script-bash-blue)
![Platform](https://img.shields.io/badge/platform-linux-green)

# 📦 Distrobox Dev Bootstrap

Ein interaktives Setup-Skript, das eine vollständige Entwicklungsumgebung in einem isolierten [Distrobox](https://github.com/89luca89/distrobox)-Container auf Basis von `ubuntu:22.04` einrichtet – für Node.js, PHP oder .NET.

---

## ✨ Features

- 🐧 Erstellt eine isolierte Linux-Entwicklungsumgebung mit `distrobox`
- 🔐 Optionaler Klon eines öffentlichen oder privaten GitHub-Repos (PAT wird unterstützt)
- 🔧 Auswahl der Entwicklungsumgebung: Node.js, PHP oder .NET SDK
- ⚙️ Automatisierte Installation aller Tools und Abhängigkeiten
- 🚀 Alias für einfachen Zugang zum Container
- 🧼 Temporäre Dateien werden nach Setup entfernt

---

## ⚙️ Voraussetzungen

- Linux-System mit Bash
- `apt`-Paketmanager (Ubuntu, Debian)
- Internetverbindung
- Optional: GitHub Personal Access Token (PAT), wenn du ein privates Repo klonen willst

---

## 🚀 Schnellstart

```bash
curl -s https://raw.githubusercontent.com/madcoda9000/distrobox-nodejs-dev-bootstrap/main/bootstrap.sh | bash
```

## 💡 Alternativ lokal ausführen:

```bash
git clone https://github.com/madcoda9000/distrobox-nodejs-dev-bootstrap.git
cd distrobox-nodejs-dev-bootstrap
chmod +x bootstrap.sh
./bootstrap.sh
```

## 🖥️ Was passiert im Skript?

1. 🔧 Installiert podman, git, curl, distrobox (sofern nicht vorhanden)

2. 🐳 Erstellt einen Container auf Basis von ubuntu:22.04

3. 📂 Erstellt den gewünschten Projektordner und klont optional ein Git-Repository

4. 🧰 Installiert je nach Wahl:

    Node.js (LTS) + npm

    PHP (CLI, mbstring, xml)

    .NET SDK (6.0)

5. 🔗 Legt einen Alias an wie z. B.:

```bash
alias enter_meinprojekt='distrobox enter meinprojekt'
```

## 📋 Beispiel-Dialog

```bash
🔐 Enter your GitHub PAT (press Enter to skip): •••••••••
📦 Enter a name for your container: meinprojekt
🛠️ Choose your development environment:
1) Node.js
2) PHP
3) .NET
Your choice (1/2/3): 1
🌐 Git project URL (optional): https://github.com/username/my-app.git
📁 Relative path (inside your home) to create project: Projekte/WebApps
```
Danach kannst du deinen Container mit folgendem Befehl betreten:

```bash
enter_meinprojekt
```

## 📁 Ordnerstruktur
Dein Projekt befindet sich nach der Installation z. B. hier:
```bash
~/Projekte/WebApps/my-app
```

## 🧯 Container löschen

```bash
distrobox rm meinprojekt
```

## 📜 Lizenz
MIT License – © madcoda9000
