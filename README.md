# Distrobox Development Environment Bootstrap

This script helps you quickly set up a development environment inside a distrobox container. You can choose between Node.js, PHP, or .NET development setups. Optionally, you can provide a GitHub project URL to clone, or just create the project folder without cloning.

## Features

- Installs podman and distrobox if needed
- Creates a distrobox container with Ubuntu 22.04
- Supports Node.js, PHP, and .NET development environments
- Optional Git project cloning
- Adds a convenient alias to enter the container

## Usage

Run the script and follow the prompts:

```bash
./setup-dev-env.sh
```

### Prompts

- GitHub PAT (Personal Access Token) — required if cloning a private repo
- Container name
- Development environment choice:
  - Node.js
  - PHP
  - .NET
- Git project URL (optional)
- Relative path inside your home directory where the project will be cloned or created

If no Git URL is provided, only the folder structure is created inside the container.

## Example

```bash
./setup-dev-env.sh
```

## Alias

After setup, you can enter the container with the alias:

```bash
enter_<container_name>
```

## Script Source

https://github.com/madcoda9000/distrobox-nodejs-dev-bootstrap
