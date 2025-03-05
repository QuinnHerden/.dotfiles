{
  description = "My system configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin = {
        url = "github:LnL7/nix-darwin";
        inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nix-darwin, nixpkgs }:
  let
    configuration = {pkgs, ... }: {

        # Necessary for using flakes on this system.
        nix.settings.experimental-features = "nix-command flakes";

        system.configurationRevision = self.rev or self.dirtyRev or null;

        # Used for backwards compatibility. please read the changelog
        # before changing: `darwin-rebuild changelog`.
        system.stateVersion = 4;

        # The platform the configuration will be used on.
        # If you're on an Intel system, replace with "x86_64-darwin"
        nixpkgs.hostPlatform = "aarch64-darwin";

        # Set the configured group ID to match the actual value
        # Possible cause: trying a new Nix installation with a pre-existing installation
        ids.gids.nixbld = 350;

        # Declare the user that will be running `nix-darwin`.
        users.users.quinnherden = {
            name = "quinnherden";
            home = "/Users/quinnherden";
        };

        # Create /etc/zshrc that loads the nix-darwin environment.
        programs.zsh.enable = true;

        environment.systemPackages = [ ];
    };
  in
  {
    darwinConfigurations."mbp-papi" = nix-darwin.lib.darwinSystem {
      modules = [
         configuration
      ];
    };
  };
}
