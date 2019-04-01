{ lib, linkFarm, writeShellScriptBin, nixops
, rpiPkgs ? import ./nix/rpipkgs.nix {}
, stateFilePath  # Path to a .nixops file that contains nix state
}:

let
  networkScripts = lib.fix (self:
    lib.mapAttrs writeShellScriptBin {
      home-help = ''
        echo "USAGE:"
        echo
        echo "home-help"
        echo "home-ops"
        echo "rpi-up"
        echo "rpi-down"
        echo "rpi-ssh"
        '';
      home-ops = ''
        echo "${nixops}/bin/nixops $1 -s ${stateFilePath} -d home ''${@:2}"
        ${nixops}/bin/nixops $1 -s ${stateFilePath} -d home ''${@:2}
      '';
      rpi-up = ''
        ${self.home-ops}/bin/home-ops deploy -Inixpkgs=${rpiPkgs.path} --include rpi $@
        '';
      rpi-down = ''
        ${self.home-ops}/bin/home-ops destroy --include rpi $@
        '';
      rpi-ssh = ''
        ${self.home-ops}/bin/home-ops ssh rpi $@
        '';
    });
in
  linkFarm "home-network"
    (lib.attrValues
      (lib.mapAttrs (name: path: { name = "bin/${name}"; path = "${path}/bin/${name}"; }) networkScripts))
