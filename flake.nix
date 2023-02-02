{
  description = "Ruby on Rails development environment";

  inputs = {
    nixpkgs.url = "nixpkgs";
    flake-utils.url = "github:numtide/flake-utils";
    nix-filter.url = "github:numtide/nix-filter";
  };

  outputs = { self, nixpkgs, flake-utils, nix-filter }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        overlays = [
          (self: super: {
            ruby = pkgs.ruby_3_1;
          })
        ];
        pkgs = import nixpkgs { inherit overlays system; };

        rubyEnv = pkgs.bundlerEnv {
          # The full app environment with dependencies
          name = "arkive-env";
          inherit (pkgs) ruby;
          # Make sure to run: `bundler config set --local force_ruby_platform true`
          # in each project to avoid platform-specific-package hash mismatch problems.
          gemdir = ./.; # Points to Gemfile.lock and gemset.nix
        };

        updateDeps = pkgs.writeScriptBin "update-deps" (builtins.readFile
          (pkgs.substituteAll {
            src = ./scripts/update.sh;
            bundix = "${pkgs.bundix}/bin/bundix";
            bundler = "${rubyEnv.bundler}/bin/bundler";
          }));
      in
      {
        apps.default = {
          type = "app";
          program = "${rubyEnv}/bin/rails";
        };

        devShells = rec {
          default = run;

          run = pkgs.mkShell {
            buildInputs = [ rubyEnv rubyEnv.wrappedRuby updateDeps
                            pkgs.nodejs pkgs.chromedriver pkgs.mailcatcher
                            pkgs.rubyPackages_3_1.solargraph
            ];

            shellHook = ''
              ${rubyEnv}/bin/rails --version
            '';
          };
        };

        packages = {
          default = rubyEnv;

          docker = pkgs.dockerTools.buildImage {
            name = "arkive-app";
            tag = "latest";
            fromImage = pkgs.dockerTools.pullImage {
              imageName = "ubuntu";
              finalImageTag = "20.04";
              imageDigest = "sha256:a06ae92523384c2cd182dcfe7f8b2bf09075062e937d5653d7d0db0375ad2221";
              sha256 = "sha256-d249m1ZqcV72jfEcHDUn+KuOCs8WPaBJRcZotJjVW0o=";
            };
            config.Cmd = [ "${rubyEnv}/bin/bundler" ];
          };
        };
      });
}
