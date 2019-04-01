# Deployment instructions

# $ nixops create deploy.nix
#

let
  networkName = "home";
in
{
  network = {
    enableRollback = true;
    description = "${networkName}";
  };

  "rpi" = { resources, lib, pkgs, config, ... }: {
    imports = [
      ./rpi/configuration.nix
    ];
    deployment.targetHost = "rpi";


    # TODO Set NIX_PATH in such a way that nixos-rebuild can be run despite being deployed via nixops (helpful for cleaning up /boot via nixos-rebuild boot)
    # nix.nixPath = [ "nixpkgs=/nix/var/nix/profiles/per-user/root/channels/nixos" "nixos-config=/etc/nixos/configuration.nix" "/nix/var/nix/profiles/per-user/root/channels" ];
    # see also https://github.com/nix-community/aarch64-build-box/blob/86190f5d19fb8cde1e7e72ffc752f97d5d37c41f/configuration.nix#L253

    #### imports = [
    ####   # ./modules/wireless-router.nix
    ####   ./rpi3.nix
    ####   ./admin-users.nix
    #### ];


    #### networking.hostName = "access-point-1";
    #### # deployment.targetHost = "access-point-1";
    #### # deployment.targetHost = "192.168.0.11"; # at home
    #### # deployment.targetHost = "2601:186:827f:ea30:ba27:ebff:fec7:42ac";

    #### deployment.targetHost = "192.168.100.228"; # at work
    #### services.openssh = {
    ####   enable = true;
    ####   # forwardX11 = true;
    ####   permitRootLogin = "yes";
    ####   extraConfig = ''
    ####     MaxAuthTries 10
    ####   '';
    #### };


    #### # minimize the closure:
    #### documentation.man.enable = false;
    #### services.nixosManual.enable = false;

    #### # at home
    #### # networking.wireless.router.repeater.enable = true;
    #### # networking.wireless.networks = import ./secrets/wifi-networks.nix;

    #### # Temporary/experimental
    #### # nixpkgs.crossSystem.system = "aarch64-linux";
    #### # nixpkgs.localSystem = pkgs.localSystem;
    #### # nixpkgs.localSystem = {
    #### #   # system = "x86_64-linux";
    #### #   # platform = lib.systems.platforms.pc64;
    #### #   system = "x86_64-linux";
    #### # };
    #### nixpkgs.crossSystem = lib.systems.examples.aarch64-multiplatform;
    #### nixpkgs.localSystem = lib.systems.examples.aarch64-multiplatform;

    #### # nixpkgs.system = "aarch64-linux";
    #### users.extraUsers.root.openssh.authorizedKeys.keys = [
    ####   "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIBa8dvNG2B4CKdcNxbpRhc9SrkI6zhUBqxIk3i/wP9aq NixOps client key for access-point-1"
    #### ];

  };
}


