{
  description = "Nebula Shell — A cosmic Quickshell desktop shell for Hyprland";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { self, nixpkgs }:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
    in
    {
      packages = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.stdenv.mkDerivation {
            pname = "nebula-shell";
            version = "0.1.0";
            src = ./.;

            installPhase = ''
              mkdir -p $out/share/nebula-shell
              cp -r . $out/share/nebula-shell/
              # Remove flake files from the output
              rm -f $out/share/nebula-shell/flake.nix
              rm -f $out/share/nebula-shell/flake.lock
              rm -rf $out/share/nebula-shell/.git
              rm -f $out/share/nebula-shell/.gitignore
            '';
          };
        });

      # For nixos-config flake input usage:
      # Add to flake.nix inputs:
      #   nebula-shell = {
      #     url = "github:Linuxury/nebula-shell";
      #     inputs.nixpkgs.follows = "nixpkgs";
      #   };
      #
      # Then in hyprland.nix:
      #   environment.systemPackages = [ inputs.nebula-shell.packages.${pkgs.system}.default ];
      #   # Or symlink: home.file.".config/quickshell".source = "${inputs.nebula-shell}/.";
    };
