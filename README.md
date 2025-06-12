# 🚀 distrobox-nodejs-dev-bootstrap

Automatisiere die Einrichtung einer isolierten Entwicklungsumgebung mit [distrobox](https://github.com/89luca89/distrobox), [podman](https://podman.io/) und deinem Git-Projekt. Ideal für Linux-Setups, schnelle Projektstarts oder portable Umgebungen.

## 🔧 Features

- Automatische Installation von `podman`, `distrobox`, `nodejs`
- Git-Projekt via Personal Access Token (PAT) klonen
- Isolierte Containerumgebung auf Basis von `ubuntu:22.04`
- Alias zum späteren Betreten des Containers
- Sicheres Handling des PAT (nicht im Git gespeichert)

## 🛠️ Anforderungen

- Linux
- Bash
- sudo-Rechte für Paketinstallation
- GitHub Personal Access Token (PAT)

## 🚀 Installation & Nutzung

```bash
git clone https://github.com/YOUR_USERNAME/distrobox-dev-bootstrap.git
cd distrobox-dev-bootstrap
chmod +x bootstrap.sh
./bootstrap.sh
```

Danach kannst du jederzeit mit folgendem Alias in deinen Container einsteigen:

```bash
enter_DEINCONTAINERNAME
```

## 🔐 Sicherheitshinweis

Das GitHub-PAT wird nur temporär für den `git clone` verwendet und **sofort wieder entfernt**. Es wird **nicht gespeichert**.

## 📄 Lizenz

MIT License – siehe [LICENSE](./LICENSE)
