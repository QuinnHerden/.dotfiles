{
  lib,
  config,
  pkgs,
  inputs,
  ...
}:

let
  # Pinned home-manager from the flake input, so runtime switches use the same
  # version the image was built with and work without refetching nixpkgs.
  homeManager = inputs.home-manager.packages.${pkgs.system}.home-manager;

  # Re-apply the home-manager config inside a running container without an image
  # rebuild. Deliberately does NOT pull — update/review the dotfiles first:
  #   cd ~/.dotfiles && git fetch && git diff origin/<branch> && git merge --ff-only ...
  # then run hm-switch. -b backup so a pre-existing real file doesn't error.
  hm-switch = pkgs.writeShellScriptBin "hm-switch" ''
    exec ${homeManager}/bin/home-manager switch \
      --flake "$HOME/.dotfiles/nix#dev@dev-container" -b backup "$@"
  '';
in
{

  home.username = "dev";
  home.homeDirectory = "/home/dev";

  home.packages = [
    homeManager
    hm-switch
  ];

  devPackages.enable = true;
  opsPackages.enable = true;
  opsPackages.enableGui = false;
  opsPackages.enableHeavy = false;

}
