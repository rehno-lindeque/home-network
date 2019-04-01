{ pkgs
, ...
}:

let
  lib = pkgs.lib;
in
{
  imports = [
    ./hardware-configuration.nix
  ];

  nixpkgs.overlays = [ (import ./overlays.nix) ];

  environment.systemPackages = with pkgs; [
    wget
    vim
  ];
  services = {
    openssh = {
      enable = true;
      extraConfig = ''
        MaxAuthTries 10
        Match Address 10.8.0.0/24
          PermitRootLogin yes
        Match Address 192.168.0.0/24
          PermitRootLogin yes
        Match Address 192.168.100.0/24
          PermitRootLogin yes
      '';
    };
    xserver = {
      enable = true;
      videoDrivers = [ "modesetting" ];
      layout = "us";
      displayManager = {
        lightdm = {
          enable = true;
        };
      };
    };
  };

  documentation.man.enable = false;
  documentation.nixos.enable = false;

  system.stateVersion = "19.09";
  networking.networkmanager.enable = true;
  boot.cleanTmpDir = true;
  nix = {
    # gc.automatic = true;
    # gc.options = "--delete-older-than 30d";
  };
}
