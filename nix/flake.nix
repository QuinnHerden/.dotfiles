{
  description = "My system configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin/nix-darwin-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Not following nixpkgs: git-hooks pins its own tested nixpkgs so hook tools
    # (statix, deadnix, nixfmt, shellcheck) resolve reliably.
    git-hooks = {
      url = "github:cachix/git-hooks.nix";
    };
  };

  outputs =
    {
      nixpkgs,
      darwin,
      home-manager,
      ...
    }@inputs:
    let
      systems = [
        "x86_64-linux"
        "aarch64-linux"
        "aarch64-darwin"
      ];
      forAllSystems = nixpkgs.lib.genAttrs systems;
      preCommitCheck =
        system:
        inputs.git-hooks.lib.${system}.run {
          src = ./.;
          hooks = {
            nixfmt-rfc-style.enable = true;
            deadnix = {
              enable = true;
              settings.edit = true;
            };
            statix.enable = true;
            shellcheck.enable = true;
          };
        };
      # Shared so the VM boot test and the real config cannot drift.
      nixDotsModules = [
        home-manager.nixosModules.default
        ./hosts/nix-dots
        ./modules/home/integrated
        ./modules/system/common
        ./modules/system/nixos
      ];
    in
    {

      devShells = forAllSystems (
        system:
        let
          pkgs = nixpkgs.legacyPackages.${system};
          hooks = preCommitCheck system;
        in
        {
          default = pkgs.mkShell {
            inherit (hooks) shellHook;
            buildInputs = hooks.enabledPackages;
          };
        }
      );

      darwinConfigurations = {
        # Docs: https://daiderd.com/nix-darwin/manual/index.html

        "mac-papi" = darwin.lib.darwinSystem {
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.darwinModules.default
            ./hosts/mac-papi
            ./modules/home/integrated
            ./modules/system/common
            ./modules/system/darwin
          ];
        };

      };

      homeConfigurations = {

        "quinnherden@kali-bug" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./hosts/kali-bug
            ./modules/home/standalone
          ];
        };

        "dev@dev-container" = home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.aarch64-linux;
          extraSpecialArgs = { inherit inputs; };
          modules = [
            ./hosts/dev-container
            ./modules/home/standalone
          ];
        };

      };

      nixosConfigurations = {

        "nix-box" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = [
            home-manager.nixosModules.default
            ./hosts/nix-box
            ./modules/home/integrated
            ./modules/system/common
            ./modules/system/nixos
          ];
        };

        "nix-dots" = nixpkgs.lib.nixosSystem {
          specialArgs = { inherit inputs; };
          modules = nixDotsModules;
        };

      };

      # Boot nix-dots in a QEMU VM and assert it actually comes up (building the
      # toplevel only proves it compiles). Run by the nixos-vm-test CI job on a
      # KVM runner; not part of the fast `flake check` gate.
      checks.x86_64-linux.nix-dots-boot = nixpkgs.legacyPackages.x86_64-linux.testers.runNixOSTest {
        name = "nix-dots-boot";
        # Let the node evaluate its own nixpkgs from the host modules (which
        # set nixpkgs.config.allowUnfree); the default read-only hostPkgs makes
        # nixpkgs.config a unique option and conflicts with that.
        node.pkgsReadOnly = false;
        node.specialArgs = { inherit inputs; };
        nodes.machine = {
          imports = nixDotsModules;
        };
        testScript = ''
          machine.wait_for_unit("multi-user.target")
          machine.succeed("getent passwd quinnherden")
          machine.succeed("test -d /home/quinnherden")
        '';
      };

    };
}
