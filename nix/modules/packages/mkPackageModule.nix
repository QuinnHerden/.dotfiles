# Generates a package-category wrapper module for one platform, collapsing the
# previously parallel per-category x per-platform wrappers (#128). The category
# data lives in ./<category>.nix next to this helper.
#
#   platform = "home"   -> home.packages              (home-manager)
#   platform = "nixos"  -> environment.systemPackages (NixOS)
#   platform = "darwin" -> environment.systemPackages (pkg.common) + homebrew
#
# The home and nixos modules of the same category share an option name but write
# to different sinks; they never coexist on one host (a host is one platform), so
# the generated options do not collide.
#
# Usage (in a tree's default.nix):
#   imports = map (category: mkPackageModule { inherit category; platform = "home"; }) categories;
{
  category,
  platform,
}:

{
  lib,
  config,
  pkgs,
  ...
}:

let
  name = "${category}Packages";
  pkg = import (./. + "/${category}.nix");
  opt = config.${name};

  # A category gets GUI/heavy toggles when its data declares those attrs (only
  # ops today), and only on the linux platforms (home, nixos); darwin installs
  # the common set with no split. Keyed off the data shape, not the name, so the
  # helper holds no category-specific knowledge.
  hasToggles = (pkg ? heavy || pkg ? linuxGui) && (platform == "home" || platform == "nixos");

  # Linux package selection. Referenced only by the home/nixos branches below;
  # must stay out of the darwin branch, since it touches linux-only data
  # (pkg.linux/linuxGui/heavy) and the ops-only toggle options.
  linuxSelection =
    (pkg.common pkgs)
    ++ (pkg.linux pkgs)
    ++ (lib.optionals pkgs.stdenv.isx86_64 (pkg.linuxX86 pkgs))
    ++ (lib.optionals (hasToggles && opt.enableHeavy) (pkg.heavy pkgs))
    ++ (lib.optionals (hasToggles && opt.enableGui) (pkg.linuxGui pkgs));
in
{
  options.${name} = {
    enable = lib.mkEnableOption "enables ${name}";
  }
  // lib.optionalAttrs hasToggles {
    enableGui = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include GUI/desktop packages (disable for headless/container environments)";
    };
    enableHeavy = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = "Include heavy tools like ffmpeg, ollama, pandoc (disable for lightweight/container environments)";
    };
  };

  config = lib.mkIf opt.enable (
    if platform == "home" then
      { home.packages = linuxSelection; }
    else if platform == "nixos" then
      { environment.systemPackages = linuxSelection; }
    else
      {
        environment.systemPackages = pkg.common pkgs;
        homebrew = {
          inherit (pkg.darwin) brews casks masApps;
        };
      }
  );
}
