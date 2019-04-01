{ stdenv, fetchFromGitHub, raspberrypifw }:
raspberrypifw.overrideAttrs (oldAttrs: {
  name = "raspberrypi-firmware-4508a68";
  version = "4508a68";

  src = fetchFromGitHub {
    owner = "raspberrypi";
    repo = "firmware";
    rev = "4508a68812b1e089d8e1de1d20aac79f5b93ed3a";
    sha256 = "0cmjpvy4sr145w9xrmjyfb0vblrqawzcy6lf64a36gzdzjg29fbw";
  };
})
