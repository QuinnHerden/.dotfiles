# Public stub for the private "last-mile" layer (issue #148). A fork (and CI)
# evaluates against this; the owner overrides inputs.private to a private repo.
# No real identifiers in the public tree: the generic user (modules/system/
# common/user.nix) sets no authorized keys, so the public flake evaluates with
# none. The owner's overlay (inputs.private) supplies the real key.
_: { }
