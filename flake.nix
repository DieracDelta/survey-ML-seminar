{
  description = "Typst";

  inputs.nixpkgs.url = "nixpkgs/master";
  inputs.typst-lsp.url = "github:nvarner/typst-lsp";
  inputs.typst-lsp.inputs.nixpkgs.follows = "nixpkgs";
  inputs.typst-fmt.url = "github:astrale-sharp/typstfmt";
  inputs.typst.url = "github:typst/typst/v0.7.0";

  inputs.vscoq = {
    url = "github:coq-community/vscoq";
    flake = true;
  };

  outputs = { self, nixpkgs, typst-lsp, typst, typst-fmt, vscoq}:
    let
      allSystems = [ "x86_64-linux" "aarch64-darwin" ];
      forAllSystems = f: nixpkgs.lib.genAttrs allSystems (system: f {
        pkgs = import nixpkgs {
          inherit system;
          overlays = [
            (_: _:
            {

                vscoqlsp = vscoq.packages.${system}.vscoq-language-server;

            }
            )
          ];
          # overlays = [(_: _: {
          #   typst-eyy = typst.packages.${system}.default;
          #   typst-fmt-eyy = typst-fmt.packages.${system}.default;
          #   typst-lsp-eyy = typst-lsp.packages.${system}.default.overrideAttrs (
          #   old: {
          #           preBuild = ''
          #             mkdir -p ../cargo-vendor-dir
          #             cp -r ${typst}/assets ../cargo-vendor-dir/assets
          #             cp -r ${typst-fmt}/README.md ../cargo-vendor-dir
          #           '';
          #         }
          #       );
          # })];
        };
      });
    in {
      devShells = forAllSystems ({pkgs}:
        {
          default = pkgs.mkShell {
            # shellHook = ''
            #   pre-commit install
            #   pre-commit autoupdate
            # '';
            nativeBuildInputs = [
                pkgs.pre-commit
                pkgs.typst
                pkgs.typstfmt
                pkgs.typst-lsp
                pkgs.dafny
                pkgs.coqPackages.coq-lsp
                pkgs.vscoqlsp
                pkgs.coq
            ];
          };
        }
      );
    };
}
