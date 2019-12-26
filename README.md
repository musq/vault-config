# vault-config

Script and configurations to spin up Vault


## Table of Contents

- [Features](#features)
- [Requirements](#requirements)
- [Install](#install)
- [License](#license)


## Features

- Nginx config
- Vault server


## Requirements

| Dependencies | Purpose |
|:---|:---|
| [`dotfiles-system`][dotfiles-system] | Provides utility functions |
| [`www-config`][www-config] | Provides base nginx config |


## Install

The setup process will:

- Clone [`dotfiles-system`][dotfiles-system] in
`/home/ashish/projects/dotfiles-system`
- Create necessary users and groups
- Harden necessary directories
- Install [Vault][vault]
- Symlink [`tug.ro.vault.conf`](tug.ro.vault.conf) to `/etc/nginx/conf.d/partials/tug.ro.vault.conf`
- Symlink [`vault.service`](vault.service) to
`/lib/systemd/system/vault.service`
- Reload Vault and Nginx

```bash
# Create projects directory and go inside
mkdir -p /home/ashish/projects && cd /home/ashish/projects

# Clone this repo
git clone https://github.com/musq/vault-config.git

# Go inside
cd vault-config

# Run installer
./setup.sh
```


## License

The code is available under [GNU GPL v3, or later](LICENSE) license.


<!-- Link labels: -->

[dotfiles-system]: https://github.com/musq/dotfiles-system
[vault]: https://www.vaultproject.io/
[www-config]: https://github.com/musq/www-config
