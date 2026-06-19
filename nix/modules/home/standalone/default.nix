_:

let
  mkPackageModule = import ../../packages/mkPackageModule.nix;
  categories = import ../../packages/categories.nix;
in

{

  nixpkgs.config.allowUnfree = true;

  imports = [
    ../content/base.nix
  ]
  ++ map (
    category:
    mkPackageModule {
      inherit category;
      platform = "home";
    }
  ) categories;

}
