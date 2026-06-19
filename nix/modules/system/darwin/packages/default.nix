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
      platform = "darwin";
    }
  ) categories;

  homebrew = {
    enable = true;
    onActivation.cleanup = "uninstall";
  };

}
