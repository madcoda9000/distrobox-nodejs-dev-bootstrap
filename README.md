![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)
![Shell Script](https://img.shields.io/badge/script-bash-blue)
![Platform](https://img.shields.io/badge/platform-linux-green)


# 📦 Distrobox Node.js Dev Bootstrap

Ein automatisiertes Setup-Skript, das eine vollständige Node.js-Entwicklungsumgebung in einem isolierten [Distrobox](https://github.com/89luca89/distrobox)-Container auf Basis von `ubuntu:22.04` einrichtet.

---

## ✨ Features

- 🐧 Erstellt automatisch eine isolierte Entwicklungsumgebung mit `distrobox`
- 🔐 Klont ein privates GitHub-Repository mit deinem persönlichen Zugriffstoken (PAT)
- 🚀 Installiert Node.js (LTS), Git, curl, gnupg u.v.m.
- ⚙️ Fügt automatisch einen Alias zum einfachen Container-Zugriff hinzu
- 🧼 Bereinigt temporäre Dateien nach dem Setup

---

## ⚙️ Voraussetzungen

- Betriebssystem: Linux mit `bash`
- Paketmanager: `apt` (z.B. Ubuntu, Debian)
- [Podman](https://podman.io/) (wird automatisch installiert)
- Optional: GitHub PAT (Personal Access Token) mit **Repo-Zugriff**

---

## 🚀 Schnellstart

```bash
curl -s https://raw.githubusercontent.com/madcoda9000/distrobox-nodejs-dev-bootstrap/main/bootstrap.sh | bash
```

> 💡 Alternativ kannst du das Skript manuell herunterladen und ausführen:
>
> ```bash
> git clone https://github.com/madcoda9000/distrobox-nodejs-dev-bootstrap.git
> cd distrobox-nodejs-dev-bootstrap
> chmod +x bootstrap.sh
> ./bootstrap.sh
> ```

---

## 🖥️ Was passiert im Skript?

1. 🔧 Installiert `podman`, `git`, `curl` (falls noch nicht vorhanden)
2. 🐳 Installiert `distrobox`, falls nicht vorhanden
3. 📦 Erstellt einen Container auf Basis von `ubuntu:22.04`
4. 📂 Klont dein GitHub-Projekt (öffentlich oder privat mit PAT)
5. 🟢 Installiert Node.js LTS und Tools im Container
6. 🔗 Legt einen praktischen Alias an, z. B.:

```bash
alias enter_meinprojekt='distrobox enter meinprojekt --additional-flags "--env DISTROBOX_NAME=meinprojekt"'
```

---

## 🛠 Beispiel

```bash
🔐 Enter your GitHub PAT: •••••••••
📦 Enter a name for your container: meinprojekt
🌐 Please enter Git project URL: https://github.com/username/my-app.git
📁 Relative path (inside your home) to clone project: Projekte/WebApps
```

Danach kannst du einfach mit folgendem Befehl in deine Umgebung einsteigen:

```bash
enter_meinprojekt
```

---

## 📁 Struktur im Home-Verzeichnis

Nach dem Setup befindet sich dein Projekt unter:

```
~/Projekte/WebApps/my-app
```

---

## 🧯 Container entfernen (optional)

```bash
distrobox rm meinprojekt
```

---

## 📜 Lizenz

MIT License – © [madcoda9000](https://github.com/madcoda9000)
