_:

let
  mkPackageModule = import ../../../packages/mkPackageModule.nix;
  categories = import ../../../packages/categories.nix;
in

{

  imports = map (
    category:
    mkPackageModule {
      inherit category;
      platform = "nixos";
    }
  ) categories;

}
