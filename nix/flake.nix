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
        modules = [
          home-manager.nixosModules.default
          ./hosts/nix-dots
          ./modules/home/integrated
          ./modules/system/common
          ./modules/system/nixos
        ];
      };

    };
  
  };
}
