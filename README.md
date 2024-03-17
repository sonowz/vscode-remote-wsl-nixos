# vscode-remote-wsl-nixos

Now that WSL 2 has been released from Windows 2004 update, NixOS can be run in Windows machine :tada: Since NixOS differs from other Linux in some aspects, it has some difficulties working with Visual Studio Code Remote-WSL extension. This repository quickly fixes problems working with VSCode.

## Steps

1. Install NixOS as a WSL 2 distro. Currently there's a community supported repository here ([NixOS-WSL](https://github.com/nix-community/NixOS-WSL)).
2. Install Visual Studio Code and its [Remote-WSL](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-wsl) extension.
3. Make sure `wget` is installed in your NixOS as a [system package](https://nixos.org/manual/nixos/stable/options#opt-environment.systemPackages). If you have no idea on this, run `nix profile install nixpkgs#wget` command to install `wget`.
4. Run `cp ./server-env-setup ~/.vscode-server/server-env-setup`. See [here](https://code.visualstudio.com/docs/remote/wsl#_advanced-environment-setup-script) for description.
5. Now VSCode can connect to your NixOS!

## Known issue

Every time your vscode gets updated (including the very first run), the remote connection will fail. Just click 'retry' and reconnect.

This is a **wontfix** issue. See `server-env-setup` script for explanations.

## For non-flake users

Since [NixOS-WSL](https://github.com/nix-community/NixOS-WSL) includes flakes as default, non-flake is considered as legacy.
Please use [non-flakes/server-env-setup](non-flakes/server-env-setup) file instead of `server-env-setup`.

---

### Alternative Solution

Solution described in [this post](https://discourse.nixos.org/t/vscode-remote-wsl-extension-works-on-nixos-without-patching-thanks-to-nix-ld/14615) works by setting up `server-env-setup` file using [home-manager](https://github.com/nix-community/home-manager). (This also requires [nix-ld](https://github.com/Mic92/nix-ld))
