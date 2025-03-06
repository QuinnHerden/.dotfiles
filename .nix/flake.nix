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
      
      "mbp-papi" = darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          ./hosts/mbp-papi/configuration.nix
        ];
      };
      
    };
  
  };
}