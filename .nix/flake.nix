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
  };

  outputs = {
    self,
    darwin,
    nixpkgs,
    ...
  }@inputs:
  let
    inherit (self.lib) # from https://github.com/malob/nixpkgs/blob/master/darwin/bootstrap.nix
      attrValues
      makeOverridable
      mkForce
      optionalAttrs
      singleton
    ;
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