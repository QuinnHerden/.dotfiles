# Single source of truth for the package categories. Each name maps to a data
# file <name>.nix in this directory and is turned into a per-platform module by
# mkPackageModule.nix. Adding a category = add its data file here + this list.
[
  "comms"
  "dev"
  "experimental"
  "extra"
  "infra"
  "ops"
  "sec"
]
