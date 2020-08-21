# vscode-remote-wsl-nixos

Now that WSL 2 has been released from Windows 2004 update, NixOS can be run in Windows machine :tada: Since NixOS differs from other Linux in some aspects, it has some difficulties working with Visual Studio Code Remote-WSL extension. This repository quickly fixes problems working with VSCode.

## Steps

1. Install NixOS as a WSL 2 distro. Currently there's a working repository [here](https://github.com/Trundle/NixOS-WSL).
2. Install Visual Studio Code and its Remote-WSL extension.
3. Make sure that `C:\WINDOWS\System32\wsl.exe -d %YOUR_NIXOS_DISTRO% sh -c "echo hello"` prints `hello`. If you used repository from step 1, it won't print. Follow instructions at below section to fix the issue.
4. Run `cp ./server-env-setup ~/.vscode-server/server-env-setup`. See [here](https://code.visualstudio.com/docs/remote/wsl#_advanced-environment-setup-script) for description.
5. Now VSCode can connect to your NixOS!


## Known issues
- Every time your vscode updates (including the very first run), connection will fail. Just click 'retry' and reconnect. See `server-env-setup` file for explanations.


## Remote-SSH case

"node not found" problem with Remote-SSH can also be fixed by step 4.



## Issue with [Trundle/NixOS-WSL](https://github.com/Trundle/NixOS-WSL) distro

The problem: if you run `wsl.exe` with additional arguments (which is `sh -c "echo hello"` in step 3), the root shell ignores additional arguments. In [syschdemd.sh](https://github.com/Trundle/NixOS-WSL/blob/master/syschdemd.sh), you should add `"$@"` at the end of this line:
```sh
exec $sw/nsenter -t $(< /run/systemd.pid) -p -m --wd="$PWD" -- @wrapperDir@/su -s $userShell @defaultUser@
```
like this:
```sh
exec $sw/nsenter -t $(< /run/systemd.pid) -p -m --wd="$PWD" -- @wrapperDir@/su -s $userShell @defaultUser@ "$@"
```
Don't forget to rebuild your OS!
