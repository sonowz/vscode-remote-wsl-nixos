# This script finds all versions of vscode-server instances from provided user,
# and patches nodejs binaries. Note that if the required nodejs version changes,
# you should manually update nodejs package version below.
#
# Note that this script can also be used to patch binaries for Remote-SSH extension.
with import <nixpkgs> {};

let
  pname = "fix-vscode-remote";
  script = pkgs.writeShellScriptBin pname ''
    if [ -z "$1" ]; then
      echo "Please specify username."
      exit 1
    fi

    VSCODE_DIR="/home/$1/.vscode-server/bin"
    SCRIPT_DIR="$(dirname $0)"

    if [ $1 = "root" ]; then
      VSCODE_DIR="/root/.vscode-server/bin"
    fi

    for versiondir in $VSCODE_DIR/*/; do
      rm "$versiondir/node"
      ln -s "$SCRIPT_DIR/node" "$versiondir/node"
    done
  '';
in
{}:
stdenv.mkDerivation rec {
  name = pname;
  nodePackage = pkgs.nodejs-12_x; # This is vscode runtime
  src = ./.;
  installPhase = ''
    mkdir -p $out/bin
    cp ${script}/bin/${pname} $out/bin/${pname}
    cp ${nodePackage}/bin/node $out/bin/node
    chmod +x $out/bin/${pname}
  '';
  buildInputs = [ script nodePackage ];
}
