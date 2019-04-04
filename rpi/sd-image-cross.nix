{ config, pkgs, lib, ... }:
let
  sdImageAarch64 = builtins.fetchurl {
    url = https://raw.githubusercontent.com/ElvishJerricco/cross-nixos-aarch64/master/sd-image-aarch64.nix;
    sha256 = "02y9xwh86ji50n2va58xw840s4p7vyb09xvny6nc9w4ip1a9pbjm";
  };
in
{
  # imports = [ <nixpkgs/nixos/modules/installer/cd-dvd/sd-image-aarch64.nix> ];
  imports = [ sdImageAarch64 ];

  boot.kernelPackages = pkgs.linuxPackages_testing;

  security.polkit.enable = false;
  services.udisks2.enable = false;

  programs.command-not-found.enable = false;

  system.boot.loader.kernelFile = lib.mkForce "Image";

  # installation-device.nix forces this on. But it currently won't
  # cross build due to w3m
  # services.nixosManual.showManual = lib.mkForce false;
  # documentation.nixos.enable = lib.mkOverride 0 false;
  services.nixosManual.enable = lib.mkOverride 0 false;

  # installation-device.nix turns this off.
  systemd.services.sshd.wantedBy = lib.mkOverride 0 ["multi-user.target"];

  nixpkgs.localSystem = { system = "x86_64-linux"; };
  nixpkgs.crossSystem = { config = "aarch64-unknown-linux-gnu"; system = "aarch64-linux"; };
  # nixpkgs.crossSystem = lib.systems.examples.aarch64-multiplatform;

  nix.checkConfig = false;
  networking.wireless.enable = lib.mkForce false;

  system.stateVersion = "18.03";

  # put your own configuration here, for example ssh keys:

  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQC4l3exfk44/NHAO2vDgtKuF9eDiSoWR+VOWhB6ZbLtR72MX05TTirQT11cXCEBdVl6/hS1Xca0DTuk9Zth/yfTvCiyWr9s+5MvHZp0pptqfz/Hzb3lnl/HA8ctfo3uZ6aiL8oL0xo8kHo79g8Z5nIhFGh/XEUpj7ARG/VSRBNVtlPSpHoBFoyDsPs58BhKyIRWR+A6SGbSGOuaxj6ynlcyv7FUG9Gq9HLVK32yUafBrthUVpX2BSUNoh2cDZlxbn0k2NKdfc2APYHa+V289OHKdfoMjA3xCacbpAMudv09NWT/X7RoRZ8yHuMJTqUi7OFTddY3XPKyRFm7GE9Pt35+pvuJfGKpP5GYXVhAUuohxMO0xD3gNdnGzzcMJGRtH14kFGE5rhQHkIiWQeEae9p81u5d3wn7CvGrjOPSJPeBq+CmdmyRGerIVG2QbYkTXvz5Bp7fRH/KTrjIrZAMCgqcZhezaDjke4s4AFEnm017U1FBolAEyiN5BrHX/cfI1RLWUW7hX5QZi4zDuZoCe8D4aMQv65Bie5Ymz/MVN/97CKvO2P3L1cCC9313BkeDAgSy3N2jwZO5Bo9symApOY+P0XvoKAMKooQjYP0mKYequsmys5Qrkgm4xffBmy/PmVQlJYiBU6EjrI+8ElVz89UvSD/kPvLnYEf70OOYs3X+3w=="
  ];
  sdImage.bootSize = 480;
  networking.hostName = "rpi";
  services.openssh = {
    enable = true;
    permitRootLogin = lib.mkForce "yes";
    extraConfig = ''
      MaxAuthTries 20
      '';
  };
}

