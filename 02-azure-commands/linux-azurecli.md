# Azure CLI on Linux — Install, Check, Upgrade, Remove

Covers the most common Linux flavors: **Debian/Ubuntu** (and derivatives like
**Kali**), **RHEL/CentOS/Fedora/Oracle Linux**, and **openSUSE/SLES**. Also covers
**WSL2** (Windows Subsystem for Linux) — since WSL2 runs a real Linux distro
(usually Ubuntu), the same Debian/Ubuntu instructions apply there.

> For **Windows-native** install (winget, MSI) + `az login`, see
> [01-getting-started/README.md](../01-getting-started/README.md) instead.

Official docs: https://learn.microsoft.com/cli/azure/install-azure-cli-linux

## Check if Azure CLI is already installed

Works the same across all distros and WSL2:

```bash
az --version
```

- If you get a version number (e.g. `azure-cli 2.65.0`), it's installed — see
  [Upgrade](#upgrade-apt) below to make sure it's current.
- If you get `az: command not found`, jump to the install section for your distro.

Find just the CLI version (no extensions/dependencies):
```bash
az version --output table
```

## 🟦 Debian / Ubuntu / Kali (and other Debian-based distros)

> WSL2 users: if your WSL distro is Ubuntu (the default), use this section.
> Kali is Debian-based and uses the same `apt` flow — the one-line script below
> works, but if it fails (Kali sometimes ships an older `curl`/`gnupg`), fall back
> to the manual steps.

### Install with the one-line script (recommended)
```bash
curl -sL https://aka.ms/InstallAzureCLIDeb | sudo bash
```

### Manual install (step-by-step)
1. Install prerequisite packages:
```bash
sudo apt-get update
sudo apt-get install -y ca-certificates curl apt-transport-https lsb-release gnupg
```
2. Download and install the Microsoft signing key:
```bash
curl -sL https://packages.microsoft.com/keys/microsoft.asc |
  gpg --dearmor |
  sudo tee /etc/apt/trusted.gpg.d/microsoft.asc.gpg > /dev/null
```
3. Add the Azure CLI software repository (uses your distro's codename, e.g. `jammy`, `noble`, `kali-rolling`):
```bash
AZ_REPO=$(lsb_release -cs)
echo "deb [arch=amd64] https://packages.microsoft.com/repos/azure-cli/ $AZ_REPO main" |
  sudo tee /etc/apt/sources.list.d/azure-cli.list
```
> If your distro's codename isn't in the Microsoft repo (common on Kali or very
> new Ubuntu releases), replace `$AZ_REPO` with the closest supported Ubuntu/Debian
> codename (e.g. `bookworm` or `jammy`) instead.
4. Update and install:
```bash
sudo apt-get update
sudo apt-get install -y azure-cli
```

### Upgrade (apt)
```bash
sudo apt-get update
sudo apt-get install --only-upgrade -y azure-cli
```

### Uninstall (apt)
```bash
sudo apt-get remove -y azure-cli
sudo rm /etc/apt/sources.list.d/azure-cli.list
```

## 🟥 RHEL / CentOS / Fedora / Oracle Linux (dnf/yum)

### Install
```bash
sudo dnf install -y https://packages.microsoft.com/config/rhel/9.0/packages-microsoft-prod.rpm
sudo dnf install azure-cli -y
```
> Replace `9.0` with your RHEL major version (e.g. `8`) if different. On older
> systems without `dnf`, substitute `yum` for `dnf` in both commands.

### Upgrade (dnf/yum)
```bash
sudo dnf update azure-cli -y
# or, on older systems:
sudo yum update azure-cli -y
```

### Uninstall (dnf/yum)
```bash
sudo dnf remove azure-cli -y
```

## 🟩 openSUSE / SLES (zypper)

### Install
```bash
sudo rpm --import https://packages.microsoft.com/keys/microsoft.asc
sudo zypper addrepo --name 'Azure CLI' --check https://packages.microsoft.com/yumrepos/azure-cli azure-cli
sudo zypper install --from azure-cli azure-cli
```

### Upgrade (zypper)
```bash
sudo zypper update azure-cli
```

### Uninstall (zypper)
```bash
sudo zypper remove azure-cli
```

## Sign in after install

```bash
az login

# If the CLI can't open a browser (headless server, WSL2 without a configured
# browser launcher, SSH session), use a device code instead:
az login --use-device-code
```

If the CLI can open your default browser, it loads an Azure sign-in page.
Otherwise, open https://aka.ms/devicelogin in any browser and enter the code
shown in your terminal.

Test the connection:
```bash
az account list --output table
```

## Troubleshooting

| Symptom | Likely cause | Fix |
|---|---|---|
| `az: command not found` after install | Shell session predates the install, or `/usr/bin` isn't on `PATH` | Open a new terminal, or `hash -r` |
| `apt-get update` fails with a GPG/signature error | Stale or missing Microsoft signing key | Re-run the signing key step above |
| `az login` never opens a browser (WSL2) | No browser launcher configured in WSL | Use `az login --use-device-code`, or install `wslu`/set `BROWSER` env var to a Windows browser |
| Installed via script but `az --version` shows an old version | A second `az` binary earlier in `PATH` (e.g. from `pip install azure-cli`) | `which -a az` to find duplicates; remove the old one or reorder `PATH` |

## Additional Resources
- [Install Azure CLI on Linux (official docs)](https://learn.microsoft.com/cli/azure/install-azure-cli-linux)
- [az login reference](https://learn.microsoft.com/cli/azure/reference-index?view=azure-cli-latest#az-login)
- [01-getting-started/README.md](../01-getting-started/README.md) — Windows install, sign-in, subscription selection, resource provider registration