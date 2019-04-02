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
      # Use for initial login with nixops
      # permitRootLogin = "yes";

      # Larger MaxAuthTries helps to avoid ssh 'Too many authentication failures' issue
      # See https://github.com/NixOS/nixops/issues/593#issue-203407250
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
      # videoDrivers = [ "modesetting" ]; # use with regular linux kernel
      videoDrivers = [ "fbdev" "vc4" ]; # use with vc4-fkvm-v3d ?
      layout = "us";
      displayManager = {
        # sessionCommands = ''
        #   firefox &
        # '';

        lightdm = {
          enable = true;
          greeter.enable = false;
          autoLogin = {
            enable = true;
            user = "guest";
          };
        };
      };
    };
  };


  # minimize the closure:
  documentation.man.enable = false;
  documentation.nixos.enable = false;

  users.users.root.openssh.authorizedKeys.keys = [
      # temporary: id_accesspoint
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4l3exfk44/NHAO2vDgtKuF9eDiSoWR+VOWhB6ZbLtR72MX05TTirQT11cXCEBdVl6/hS1Xca0DTuk9Zth/yfTvCiyWr9s+5MvHZp0pptqfz/Hzb3lnl/HA8ctfo3uZ6aiL8oL0xo8kHo79g8Z5nIhFGh/XEUpj7ARG/VSRBNVtlPSpHoBFoyDsPs58BhKyIRWR+A6SGbSGOuaxj6ynlcyv7FUG9Gq9HLVK32yUafBrthUVpX2BSUNoh2cDZlxbn0k2NKdfc2APYHa+V289OHKdfoMjA3xCacbpAMudv09NWT/X7RoRZ8yHuMJTqUi7OFTddY3XPKyRFm7GE9Pt35+pvuJfGKpP5GYXVhAUuohxMO0xD3gNdnGzzcMJGRtH14kFGE5rhQHkIiWQeEae9p81u5d3wn7CvGrjOPSJPeBq+CmdmyRGerIVG2QbYkTXvz5Bp7fRH/KTrjIrZAMCgqcZhezaDjke4s4AFEnm017U1FBolAEyiN5BrHX/cfI1RLWUW7hX5QZi4zDuZoCe8D4aMQv65Bie5Ymz/MVN/97CKvO2P3L1cCC9313BkeDAgSy3N2jwZO5Bo9symApOY+P0XvoKAMKooQjYP0mKYequsmys5Qrkgm4xffBmy/PmVQlJYiBU6EjrI+8ElVz89UvSD/kPvLnYEf70OOYs3X+3w=="
    ];

  # Define a guest user account. Remember to set a password with ‘passwd’.
  users.users.guest = {
    isNormalUser = true;
    uid = 1000;
    extraGroups = [ "video" "audio" "disk" "dialout" "wheel" "networkmanager" ];
    packages =
      with pkgs; [
        # firefox
      ];
  };

  # The NixOS release to be compatible with for stateful data such as databases.
  system.stateVersion = "19.09";
  networking.networkmanager.enable = true;
  boot.cleanTmpDir = true;
  nix = {
    # disable temporarily
    # gc.automatic = true;
    # gc.options = "--delete-older-than 30d";
  };
}
