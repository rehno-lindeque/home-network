{ lib, linkFarm, writeShellScriptBin, nixops
, rpiPkgs ? import ./nix/rpipkgs.nix {}
, stateFilePath  # Path to a .nixops file that contains nix state
}:

let
  networkScripts = lib.fix (self:
    lib.mapAttrs writeShellScriptBin {
      home-help = ''
        echo 'USAGE:'
        echo
        echo 'home-help'
        echo 'home-ops'
        echo 'rpi-up'
        echo 'rpi-down'
        echo 'rpi-ssh'
        echo 'rpi-reboot'
        # echo 'rpi-build-livedisk'
        echo 'rpi-crossbuild-minimal-livedisk'
        '';
      home-ops = ''
        echo '${nixops}/bin/nixops $1 -s ${stateFilePath} -d home ''${@:2}'
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
      # rpi-build-livedisk = ''
      #   nix-build '${rpiPkgs.path}/nixos' -I 'nixpkgs=${rpiPkgs.path}' -I 'nixos-config=rpi/sd-image.nix' -A config.system.build.sdImage --pure $@
      #   '';
      rpi-crossbuild-minimal-livedisk =
      let
        nixpkgsCross =
          builtins.fetchTarball {
            url = https://github.com/ElvishJerricco/nixpkgs/archive/cross-nixos-aarch64-2018-08-05.tar.gz;
            sha256 = "1ywkxc5x0b0chkddxxir09xr7zkn3l3dwakwvhrd1n743z0gp8gy";
          };
        # nix-build '<nixpkgs/nixos>' -I nixos-config=rpi/sd-image-cross.nix -I nixpkgs=https://github.com/ElvishJerricco/nixpkgs/archive/cross-nixos-aarch64-2018-08-05.tar.gz -A config.system.build.sdImage -o sdImage $@ || exit -1
      in ''
        nix-build '${nixpkgsCross}/nixos' -I nixos-config=rpi/sd-image-cross.nix -I nixpkgs=${nixpkgsCross} -A config.system.build.sdImage -o sdImage $@ || exit -1
        echo
        echo 'use dd to copy the image to an sdcard'
        echo 'sudo dd bs=4M if=sdImage/sd-image/nixos-sd-image-18.09pre-git-x86_64-linux.img of=/dev/YOUR_SD_CARD conv=fsync'
        echo 'sudo umount /dev/sdX?'
        echo 'echo ", +" | sudo sfdisk -N 2 /dev/YOUR_SD_CARD'
        '';
      rpi-reboot = ''
        ${self.home-ops}/bin/home-ops reboot --include rpi $@
        '';
    });
in
  linkFarm "home-network"
    (lib.attrValues
      (lib.mapAttrs (name: path: { name = "bin/${name}"; path = "${path}/bin/${name}"; }) networkScripts))
