{
  description = "My system configuration";

  inputs = {
    nixpkgs = {
      url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    };
    
    darwin = {
      url = "github:LnL7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    ...
  }
  @inputs:
  let
    
    # …
    # …
    
  in {
    
    darwinConfigurations = {
      
      "mbp-agi" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mbp-agi/configuration.nix
          ./modules/darwin
          ./modules/nixos
        ];
      };
      
      "mbp-papi" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mbp-papi/configuration.nix
          ./modules/darwin
          ./modules/nixos
        ];
      };
      
    };

    nixosConfigurations = {
    
      "nix-robin" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nix-robin/configuration.nix
          ./modules/nixos
        ];
      };

    };
  
  };
}