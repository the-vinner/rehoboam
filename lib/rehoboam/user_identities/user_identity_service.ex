defmodule Rehoboam.UserIdentities.UserIdentityService do
  use Potionx.Auth.IdentityService,
    repo: Rehoboam.Repo,
    identity_schema: Rehoboam.UserIdentities.UserIdentity
end
