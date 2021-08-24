# vscode-remote-wsl-nixos

Now that WSL 2 has been released from Windows 2004 update, NixOS can be run in Windows machine :tada: Since NixOS differs from other Linux in some aspects, it has some difficulties working with Visual Studio Code Remote-WSL extension. This repository quickly fixes problems working with VSCode.

## Steps

1. Install NixOS as a WSL 2 distro. Currently there's a working repository [here](https://github.com/Trundle/NixOS-WSL).
2. Install Visual Studio Code and its Remote-WSL extension.
4. Run `cp ./server-env-setup ~/.vscode-server/server-env-setup`. See [here](https://code.visualstudio.com/docs/remote/wsl#_advanced-environment-setup-script) for description.
5. Now VSCode can connect to your NixOS!


## Known issues
- Every time your vscode updates (including the very first run), connection will fail. Just click 'retry' and reconnect. See `server-env-setup` file for explanations.


## Issue with [Trundle/NixOS-WSL](https://github.com/Trundle/NixOS-WSL) distro

You will likely run into this error:
```bash
Launching C:\WINDOWS\System32\wsl.exe -d NixOS sh -c '"$VSCODE_WSL_EXT_LOCATION/scripts/wslServer.sh" 2b9aebd5354a3629c3aba0a5f5df49f43d6689f8 stable .vscode-server 0  '}
sh: /scripts/wslServer.sh: No such file or directory
```

#### The problem
`VSCODE_WSL_EXT_LOCATION` environment variable is expected to be set inside NixOS `sh`, whereas [syschdemd.sh](https://github.com/Trundle/NixOS-WSL/blob/main/syschdemd.sh) abstraction layer isolates the environment variable.

#### Solution
Change this line in [syschdemd.sh](https://github.com/Trundle/NixOS-WSL/blob/main/syschdemd.sh)
```sh
exec $sw/nsenter -t $(< /run/systemd.pid) -p -m -- $sw/machinectl -q --uid=@defaultUser@ shell .host /bin/sh -c "cd \"$PWD\"; exec $cmd"
```
like this:
```sh
exportCmd="export VSCODE_WSL_EXT_LOCATION=\"$VSCODE_WSL_EXT_LOCATION\""
exec $sw/nsenter -t $(< /run/systemd.pid) -p -m -- $sw/machinectl -q --uid=@defaultUser@ shell .host /bin/sh -c "cd \"$PWD\"; $exportCmd; exec $cmd"
```
Don't forget to rebuild your OS!

---

## For flake users (or `nixUnstable` users)

Currently unstable version of nix, which introduces [Nix flakes](https://nixos.wiki/wiki/Flakes), also overhauls various nix commands.

This changed the behavior of `nix eval` command in the `server-env-setup` script.
Please use [flake/server-env-setup](flake/server-env-setup) file instead.

**WARNING**: You may want to modify `PKGS_EXPRESSION` variable in the script.

---

## Alternative Solution

Solution described in [this post](https://discourse.nixos.org/t/vscode-remote-wsl-extension-works-on-nixos-without-patching-thanks-to-nix-ld/14615) works by setting up `server-env-setup` file using [home-manager](https://github.com/nix-community/home-manager). (Also requires [nix-ld](https://github.com/Mic92/nix-ld))
