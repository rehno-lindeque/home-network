{ lib, linux_rpi, buildLinux, fetchFromGitHub, ... } @args:

linux_rpi.override (old: args // {
  buildLinux = a: buildLinux (a // rec {
    version = "${modDirVersion}";
    modDirVersion = "5.0.3";

    src = fetchFromGitHub {
      owner = "raspberrypi";
      repo = "linux";
      rev = "1bcd1a4940d3a4c4a793086ebe1b6b0afb4fff97";
      sha256 = "0ij6ciy6qd28d635qjfr3bwjlbaxky9r87rwxa5wdj48vavww6rh";
    };
  });
})
