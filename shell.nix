{ pkgs ? import <nixpkgs> {}
, rpiPkgs ? import ./nix/rpipkgs.nix {}
, buildersStateFilePath ? (builtins.getEnv "PWD" + "/../remotebuilders-network/secrets/localstate.nixops")
, buildersSecretsEnvPath ? (builtins.getEnv "PWD" + "/../remotebuilders-network/secrets/.ec2-env")
, stateFilePath ? (builtins.getEnv "PWD" + "/secrets/localstate.nixops")
}:

let
  remoteBuildersNetwork = pkgs.callPackage ../remotebuilders-network { stateFilePath = buildersStateFilePath; secretsEnvPath = buildersSecretsEnvPath; };
  homeNetwork = pkgs.callPackage ./. { inherit rpiPkgs stateFilePath; };
in
pkgs.stdenv.mkDerivation
  {
    name = "home-network-provisioning-environment";
    version = "0.0.0";
    buildInputs =
      with pkgs;
      [
        git-crypt
        nixops
        homeNetwork
        remoteBuildersNetwork
      ];
    shellHook =
      let
        nc="\\e[0m"; # No Color
        white="\\e[1;37m";
        black="\\e[0;30m";
        blue="\\e[0;34m";
        light_blue="\\e[1;34m";
        green="\\e[0;32m";
        light_green="\\e[1;32m";
        cyan="\\e[0;36m";
        light_cyan="\\e[1;36m";
        red="\\e[0;31m";
        light_red="\\e[1;31m";
        purple="\\e[0;35m";
        light_purple="\\e[1;35m";
        brown="\\e[0;33m";
        yellow="\\e[1;33m";
        grey="\\e[0;30m";
        light_grey="\\e[0;37m";
      in
        ''
        echo
        printf "${white}"
        echo "-------------------------------------"
        echo "Home network provisioning environment"
        echo "-------------------------------------"
        printf "${nc}"
        echo
        echo "Home network"
        echo
        ${homeNetwork}/bin/home-help
        echo
        echo "Remote builders network"
        echo
        ${remoteBuildersNetwork}/bin/remotebuilders-help

        export NIXOPS_STATE=${stateFilePath}
        export NIXOPS_DEPLOYMENT=home
        '';
  }
