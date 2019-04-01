self: super:
{
  linux_rpi_5_0 = self.callPackage ./linux-rpi-5.0.nix {};
  linuxPackages_rpi_5_0 = self.recurseIntoAttrs (self.linuxPackagesFor self.linux_rpi_5_0);

  raspberrypifw = self.callPackage ./raspberrypifw.nix { raspberrypifw = super.raspberrypifw; };
}
