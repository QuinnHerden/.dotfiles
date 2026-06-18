{
  description = "My system configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixos-25.05";
    };

    # Private "last-mile" layer (real identifiers). Defaults to an in-repo
    # public stub so the public flake evaluates standalone (CI + forks). The
    # owner's rebuild scripts override this to the nix/private submodule.
    private = {
      url = "path:./private-stub";
      flake = false;
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
      # Module list for a NixOS host. Shared by mkHost and the VM boot test so
      # the test and the real config cannot drift. Includes the private overlay
      # (inputs.private), which defaults to the public stub and is overridden by
      # the rebuild scripts; the VM test thus exercises the seam against the stub.
      nixosSystemModules = hostPath: [
        home-manager.nixosModules.default
        hostPath
        ./modules/home/integrated
        ./modules/system/common
        ./modules/system/nixos
        (import inputs.private)
      ];

      nixDotsModules = nixosSystemModules ./hosts/nix-dots;

      # Build a host config from its spec. Each builder type folds in its
      # standard module list, so a host is data (an entry in `hosts` below),
      # not a copy-pasted builder block.
      mkHost =
        spec:
        if spec.builder == "nixos" then
          nixpkgs.lib.nixosSystem {
            specialArgs = { inherit inputs; };
            modules = nixosSystemModules spec.hostPath;
          }
        else if spec.builder == "darwin" then
          darwin.lib.darwinSystem {
            specialArgs = { inherit inputs; };
            modules = [
              home-manager.darwinModules.default
              spec.hostPath
              ./modules/home/integrated
              ./modules/system/common
              ./modules/system/darwin
            ];
          }
        else
          home-manager.lib.homeManagerConfiguration {
            pkgs = nixpkgs.legacyPackages.${spec.system};
            extraSpecialArgs = { inherit inputs; };
            modules = [
              spec.hostPath
              ./modules/home/standalone
            ];
          };

      # The host matrix. Adding a machine is an entry here plus its host dir.
      # The `template` entries are generic, forkable examples (see hosts/_template)
      # that CI builds to keep the public layer evaluatable without the private
      # overlay.
      hosts = {
        nixos = {
          nix-box = {
            builder = "nixos";
            hostPath = ./hosts/nix-box;
          };
          nix-dots = {
            builder = "nixos";
            hostPath = ./hosts/nix-dots;
          };
          template = {
            builder = "nixos";
            hostPath = ./hosts/_template/nixos;
          };
        };
        # Docs: https://daiderd.com/nix-darwin/manual/index.html
        darwin = {
          mac-papi = {
            builder = "darwin";
            hostPath = ./hosts/mac-papi;
          };
          template = {
            builder = "darwin";
            hostPath = ./hosts/_template/darwin;
          };
        };
        home = {
          "quinnherden@kali-bug" = {
            builder = "home";
            system = "aarch64-linux";
            hostPath = ./hosts/kali-bug;
          };
          "dev@dev-container" = {
            builder = "home";
            system = "aarch64-linux";
            hostPath = ./hosts/dev-container;
          };
          template = {
            builder = "home";
            system = "aarch64-linux";
            hostPath = ./hosts/_template/home;
          };
        };
      };
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

      darwinConfigurations = nixpkgs.lib.mapAttrs (_: mkHost) hosts.darwin;

      homeConfigurations = nixpkgs.lib.mapAttrs (_: mkHost) hosts.home;

      nixosConfigurations = nixpkgs.lib.mapAttrs (_: mkHost) hosts.nixos;

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
