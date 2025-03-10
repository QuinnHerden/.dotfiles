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
    nixpkgs,
    darwin,
    home-manager,
    ...
  }@inputs: {
    
    darwinConfigurations = {
      # Docs: https://daiderd.com/nix-darwin/manual/index.html
      
      "mac-agi" = darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.darwinModules.default
          ./hosts/mac-agi
          ./system/darwin
          ./system/common
        ];
      };
      
      "mac-papi" = darwin.lib.darwinSystem {
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.darwinModules.default
          ./home
          ./hosts/mac-papi
          ./system/common
          ./system/darwin
        ];
      };
      
    };

    nixosConfigurations = {
    
      "nix-robin" = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; };
        modules = [
          home-manager.nixosModules.default
          ./hosts/nix-robin
          ./system/common
          ./system/nixos
        ];
      };

    };
  
  };
}