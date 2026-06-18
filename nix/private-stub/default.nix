# Public stub for the private "last-mile" layer (issue #148). A fork (and CI)
# evaluates against this; the owner overrides inputs.private to a private repo.
_: {
  # No real authorized keys in the public tree. The owner's overlay supplies
  # the real key; this placeholder keeps the public flake evaluatable.
  users.users.quinnherden.openssh.authorizedKeys.keys = [ ];
}
