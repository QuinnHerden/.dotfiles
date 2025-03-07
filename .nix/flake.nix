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
      # Docs: https://daiderd.com/nix-darwin/manual/index.html
      
      "mac-agi" = darwin.lib.darwinSystem {
        modules = [
          # ./hosts/mac-agi/configuration.nix
          ./modules/darwin
          # ./modules/nixos
        ];
      };
      
      "mac-papi" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mac-papi/configuration.nix
          ./modules/darwin
          ./modules/nixos
        ];
      };
      
    };

    nixosConfigurations = {
    
      "nix-robin" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          ./hosts/nix-robin/configuration.nix
          ./modules/nixos
        ];
      };

    };
  
  };
}