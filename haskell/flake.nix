{
  description = "Advent of Code in Haskell";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/haskell-updates";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = nixpkgs.legacyPackages.${system};

        haskellPackages = pkgs.haskell.packages.ghc9101;

        aoc-script = pkgs.writeShellScriptBin "aoc" ''
          cmd=$(basename $0)
          usage() {
              echo -e "Usage:\n" \
                      "  $cmd run [DAY]\t [01-25]\n" \
                      "  $cmd watch [DAY]\t [01]-25]\n"
          }

          if [ -z "$1" ]; then
              usage
              exit
          fi

          case "$1" in
              "run")
                  if [ -z "$2" ]; then
                      usage
                      exit
                  fi

                  ./jpm_tree/bin/judge "$2".janet
                  ;;

              "watch")
                  if [ -z "$2" ]; then
                      usage
                      exit
                  fi

                  find ./"$2".janet | ${pkgs.entr}/bin/entr -s "clear; ./jpm_tree/bin/judge $2.janet"
                  ;;

              "deps")
                  ${pkgs.jpm}/bin/jpm deps -l
                  ;;

              "repl")
                  ${pkgs.janet}/bin/janet -e "(import spork/netrepl) (netrepl/server)"
                  ;;
          esac
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = [
            haskellPackages.ghc
            haskellPackages.haskell-language-server
            haskellPackages.ghcid
            haskellPackages.cabal-install
            aoc-script
          ];
        };
      }
    );
}
