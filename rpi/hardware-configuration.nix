{ config, lib, pkgs, ... }:

let
  linuxPackages = pkgs.linuxPackages_rpi_5_0;
in
{
  boot = {
    loader.grub.enable = false;
    kernelPackages = linuxPackages;
    kernelParams = [
      # "console=ttyS1,115200n8"
      "cma=256M" # 32M is possible, but 256M fixes graphical problems
    ];
  };

  # tag this patched version of the kernel for easy reference when booting
  system.nixos.tags = [ "rpi-5.0" ];

  boot.loader.raspberryPi = {
    enable = true;
    version = 3; # Raspberry Pi 3B+
    uboot.enable = true;
  };

  nixpkgs.localSystem = lib.systems.examples.aarch64-multiplatform;
  fileSystems = {
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
  swapDevices = [ { device = "/swapfile"; size = 4096; } ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
}
