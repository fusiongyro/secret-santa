{
  description = "Secret Santa Project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/25.05";
  };

  outputs = inputs@{ flake-parts, ... }:
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
      ];
      systems = [ "x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin" ];
      perSystem = { config, self', inputs', pkgs, system, ... }: {
        packages.default = pkgs.hello;

        # Custom overlay for clingo with Python
        packages.clingo = pkgs.clingo.overrideAttrs (oldAttrs: {
          cmakeFlags = (oldAttrs.cmakeFlags or []) ++ [
            "-DCLINGO_BUILD_WITH_PYTHON=ON"
          ];

          # We want to make sure that the Python from Clingo is the one we get in our app
          # The CFFI dependency somehow doesn't survive the copy; I'm not sure why
          propagatedBuildInputs = (oldAttrs.propagatedBuildInputs or []) ++ [pkgs.python3 pkgs.python3Packages.cffi];
        });
      
        devShells.default = pkgs.mkShell {
          buildInputs = [ self'.packages.clingo ];
        };
      };
      flake = {
      };
    };
}
