{ config, lib, pkgs, ... }:

let
  linuxPackages = pkgs.linuxPackages_rpi_5_0;
in
{
  boot = {
    loader.grub.enable = false;
    # Avoid running out of space on /boot
    # E.g. to clean, first delete generations and then run something like
    # nixos-rebuild boot -I nixpkgs=/nix/store/....-nixos-18.09-18.09...../nixos-18.09/nixpkgs
    # or
    # /run/current-system/bin/switch-to-configuration boot to clean space before it fills up
    # boot.loader.generic-extlinux-compatible.configurationLimit = 5;

    kernelPackages = linuxPackages;
    # kernelPatches = [ bcm2835_audio ];
    kernelParams = [
      # "console=ttyS1,115200n8"
      # not necessary with fkvm?
      # "cma=256M" # 32M is possible, but 256M fixes graphical problems
      # "audio_pwm_mode=2"
    ];
  };

  # tag this patched version of the kernel for easy reference when booting
  system.nixos.tags = [ "rpi-5.0" ];

  boot.loader.raspberryPi = {
    enable = true;
    version = 3; # Raspberry Pi 3B+
    uboot.enable = true;
    # https://www.raspberrypi.org/documentation/configuration/config-txt/video.md
    # Use gpu_mem with regular linux kernel?
    # firmwareConfig = ''
    #   gpu_mem=256
    #   '';
    #   # device_tree=bcm2710-rpi-3-b-plus.dtb
    # dtoverlay=vc4-kms-v3d
    # start_x=1
    # ignore_lcd=0
    # display_default_lcd=1
    # "dtparam=audio=on"
    # "dtoverlay=rpi-ft5406"
    # "dtoverlay=vc4-kms-v3d"
  };

  nixpkgs.localSystem = lib.systems.examples.aarch64-multiplatform;
  fileSystems = {
    # "/boot" = {
    #   device = "/dev/disk/by-label/NIXOS_BOOT";
    #   fsType = "vfat";
    #   neededForBoot = true;
    # };
    "/" = {
      device = "/dev/disk/by-label/NIXOS_SD";
      fsType = "ext4";
    };
  };
  swapDevices = [ { device = "/swapfile"; size = 4096; } ];

  hardware.enableRedistributableFirmware = true;
  hardware.firmware = [
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
  };
}
